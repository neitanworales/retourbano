import { Component, OnInit } from '@angular/core';

@Component({
    selector: 'app-footer-seguimiento',
    templateUrl: './footer-seguimiento.component.html',
    styleUrls: ['./footer-seguimiento.component.css'],
    standalone: false
})
export class FooterSeguimientoComponent implements OnInit {

  currentYear = new Date().getFullYear();

  constructor() { }

  ngOnInit(): void {
  }

}
