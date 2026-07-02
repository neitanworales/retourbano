import { Component, Input, OnInit } from '@angular/core';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
    selector: 'app-tabla-costos',
    templateUrl: './tabla-costos.component.html',
    styleUrls: ['./tabla-costos.component.css'],
    standalone: false
})
export class TablaCostosComponent implements OnInit {

  @Input()
  event!: Event;

  constructor() { }

  ngOnInit(): void {
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

}
