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

}
