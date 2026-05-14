import { Component, OnInit, Inject } from '@angular/core';
import { APP_BASE_HREF } from '@angular/common';
import { Event } from 'src/app/core/models/registro/Event';
import { EventDao } from 'src/app/core/api/dao/EventDao';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css'],
  standalone: false
})
export class NavbarComponent implements OnInit {

  events?: Event[];
  isLoading: boolean = true;

  constructor(
    private eventDao: EventDao
  ) {
    this.loadEvent();
  }

  ngOnInit(): void {
  }

  private loadEvent() {
    this.eventDao.getEventActivo().subscribe({
      next: (result) => {
        console.log("Eventos cargados: ", result.data?.events);
        this.events = result.data?.events!;
        console.log("Eventos asignados: ", this.events);
        this.isLoading = false;
      },
      error: (error) => {
        console.error('Error al cargar eventos:', error);
        this.isLoading = false;
      }
    });
  }

}
