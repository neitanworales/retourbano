import { Component, Input, OnInit } from '@angular/core';
import { Campamento } from 'src/app/models/registro/Campamento';

@Component({
    selector: 'app-tabla-costos',
    templateUrl: './tabla-costos.component.html',
    styleUrls: ['./tabla-costos.component.css'],
    standalone: false
})
export class TablaCostosComponent implements OnInit {

  @Input()
  campamento!: Campamento;

  constructor() { }

  ngOnInit(): void {
  }

}
