import { Component, OnInit, Inject } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { filter, map, switchMap, tap } from 'rxjs/operators';
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
    private eventDao: EventDao
  ) { }

  events?: Event[];
  id_event?: number;
  event?: Event;

  ngOnInit(): void {
    this.loadEvent();
    this.loadEvents();
  }

  private loadEvent() {
    this.route.queryParamMap
      .pipe(
        map((params: ParamMap) => {
          const idEvent = Number(params.get('id_event'));
          const idCampamento = Number(params.get('id_campamento'));
          return !isNaN(idEvent) && idEvent > 0 ? idEvent : idCampamento;
        }),
        filter((id) => !isNaN(id) && id > 0),
        tap((id) => {
          this.id_event = id;
        }),
        switchMap((id) => this.eventDao.getEventInfo(id))
      )
      .subscribe({
        next: (result) => {
          this.event = result.data?.events?.[0];
        },
        error: (error) => {
          console.error('Error al cargar evento:', error);
        }
      });
    console.log('Evento', this.event);
  }

  private loadEvents() {
    this.eventDao.getEventActivo().subscribe({
      next: (result) => {
        this.events = result.data?.events!;
        if (!this.event && this.events?.length === 1) {
          this.event = this.events[0];
          this.id_event = this.events[0]?.id;
        }
      },
      error: (error) => {
        console.error('Error al cargar eventos    :', error);
      }
    });
  }

}
