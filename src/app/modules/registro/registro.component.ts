import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { combineLatest, of } from 'rxjs';
import { map, switchMap } from 'rxjs/operators';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
  selector: 'app-registro',
  templateUrl: './registro.component.html',
  styleUrls: ['./registro.component.css'],
  standalone: false
})
export class RegistroComponent implements OnInit {

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private eventDao: EventDao
  ) { }

  events?: Event[];
  id_event?: number;
  event?: Event;

  ngOnInit(): void {
    this.loadEvents();
    this.subscribeToRouteChanges();
  }

  private subscribeToRouteChanges() {
    combineLatest([this.route.queryParamMap, this.route.paramMap])
      .pipe(
        map(([queryParams, pathParams]: [ParamMap, ParamMap]) => {
          const queryId = Number(queryParams.get('id_event'));
          const pathId = Number(pathParams.get('id_event'));
          return !isNaN(queryId) && queryId > 0 ? queryId : pathId;
        }),
        switchMap((id) => {
          if (!isNaN(id) && id > 0) {
            this.id_event = id;
            return this.eventDao.getEventInfo(id);
          }
          this.id_event = undefined;
          return of({ data: { events: [] } });
        })
      )
      .subscribe({
        next: (result: any) => {
          if (result.data?.events?.length > 0) {
            this.event = result.data.events[0];
            console.log('Evento cargado:', this.event);
          } else {
            this.event = undefined;
          }
        },
        error: (error) => {
          console.error('Error al cargar evento:', error);
          this.event = undefined;
        }
      });
  }

  private loadEvents() {
    this.eventDao.getEventActivo().subscribe({
      next: (result) => {
        this.events = result.data?.events || [];
        // Si hay solo un evento y no hay query params, seleccionarlo automáticamente
        if (this.events.length === 1 && !this.event) {
          this.selectEvent(this.events[0]);
        }
      },
      error: (error) => {
        console.error('Error al cargar eventos:', error);
        this.events = [];
      }
    });
  }

  getEventId(event: Event | undefined): number | undefined {
    if (!event) {
      return undefined;
    }

    const anyEvent = event as any;
    const candidates = [event.id, anyEvent.id_event, anyEvent.id_campamento, event.legacy_event_id];

    for (const candidate of candidates) {
      const parsed = Number(candidate);
      if (!isNaN(parsed) && parsed > 0) {
        return parsed;
      }
    }

    return undefined;
  }

  selectEvent(selectedEvent: Event | undefined) {
    const eventId = this.getEventId(selectedEvent);
    if (!eventId) {
      return;
    }

    this.id_event = eventId;
    this.eventDao.getEventInfo(eventId).subscribe({
      next: (result) => {
        const loadedEvent = result.data?.events?.[0];
        this.event = loadedEvent || selectedEvent;
      },
      error: () => {
        this.event = selectedEvent;
      }
    });

    this.router.navigate(['/registro'], { queryParams: { id_event: eventId } });
  }

}
