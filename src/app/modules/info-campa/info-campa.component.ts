import { Component, OnInit } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { combineLatest, of } from 'rxjs';
import { map, switchMap, tap } from 'rxjs/operators';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
    selector: 'app-info-campa',
    templateUrl: './info-campa.component.html',
    styleUrls: ['./info-campa.component.css'],
    standalone: false
})
export class InfoCampaComponent implements OnInit {

  constructor(
    private route: ActivatedRoute,
    private eventDao: EventDao,
    private sanitizer: DomSanitizer
  ) { }

  id_event?: number;
  event: Event = new Event();
  isLoading = false;

  ngOnInit(): void {
    combineLatest([
      this.route.queryParamMap,
      this.eventDao.getEventActivo('BASIC')
    ])
      .pipe(
        map(([params, result]: [ParamMap, any]) => {
          const queryId = Number(params.get('id_event'));
          if (!isNaN(queryId) && queryId > 0) {
            return queryId;
          }

          const activeEvents = result?.data?.events || [];
          if (activeEvents.length === 1) {
            return this.getEventId(activeEvents[0]);
          }

          return undefined;
        }),
        tap((id) => {
          if (id) {
            this.isLoading = true;
            this.id_event = id;
          } else {
            this.event = new Event();
            this.id_event = undefined;
          }
        }),
        switchMap((id) => {
          if (!id) {
            return of({ data: { events: [] } });
          }
          return this.eventDao.getEventInfo(id);
        })
      )
      .subscribe({
        next: (result) => {
          this.event = result.data?.events?.[0] || new Event();
          this.isLoading = false;
        },
        error: (error) => {
          console.error('Error al cargar evento:', error);
          this.isLoading = false;
        }
      });
  }

  private getEventId(event: Event | undefined): number | undefined {
    if (!event) {
      return undefined;
    }

    const anyEvent = event as any;
    const candidates = [event.id, anyEvent.id_event, anyEvent.id_campamento];

    for (const candidate of candidates) {
      const parsed = Number(candidate);
      if (!isNaN(parsed) && parsed > 0) {
        return parsed;
      }
    }

    return undefined;
  }

  private loadEvent(id_event  : number): void {
    console.log('Id evento recibida:', id_event);
    this.isLoading = true;
    this.eventDao.getEventInfo(id_event).subscribe({
      next: (result) => {
        this.event = result.data?.events?.[0]!;
        this.isLoading = false;
      },
      error: (error) => {
        console.error('Error al cargar evento :', error);
        this.isLoading = false;
      }
    });
  }

  getSafeUrl(url?: string | null): SafeResourceUrl | null {
    if (!url) {
      return null;
    }

    const normalizedUrl = url.replace(/&amp;/g, '&');
    if (normalizedUrl !== url) {
      console.warn('Mapa URL normalizada desde HTML escapado.');
    }
    return this.sanitizer.bypassSecurityTrustResourceUrl(normalizedUrl);
  }

  getEventDurationDays(): number {
    if (!this.event?.start_at || !this.event?.end_at) {
      return 0;
    }

    const startDate = new Date(this.event.start_at);
    const endDate = new Date(this.event.end_at);
    const millisecondsPerDay = 1000 * 60 * 60 * 24;
    const durationInDays = Math.ceil((endDate.getTime() - startDate.getTime()) / millisecondsPerDay);

    return durationInDays > 0 ? durationInDays : 0;
  }

  formatLobbyTime(value?: Date | string): string {
    if (!value) {
      return '';
    }

    if (typeof value === 'string') {
      const timeMatch = value.match(/^(\d{2}:\d{2})(?::\d{2})?$/);
      if (timeMatch) {
        return timeMatch[1];
      }
    }

    return this.formatearHoraInput(value);
  }

  formatNoteText(value?: string | null): string {
    if (!value) {
      return '';
    }

    return value.replace(/\s*\*\*\s*/g, '\n').trim();
  }

  private formatearHoraInput(value?: Date | string): string {
    if (!value) {
      return '';
    }

    if (typeof value === 'string') {
      const timeMatch = value.match(/^(\d{2}:\d{2})(?::\d{2})?$/);
      if (timeMatch) {
        return timeMatch[1];
      }
    }

    const date = new Date(value);
    if (Number.isNaN(date.getTime())) {
      return '';
    }

    const localDate = new Date(date.getTime() - (date.getTimezoneOffset() * 60000));
    return localDate.toISOString().slice(11, 16);
  }

}
