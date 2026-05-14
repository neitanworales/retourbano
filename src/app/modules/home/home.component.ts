import { Component, OnInit, Inject } from '@angular/core';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
  standalone: false
})
export class HomeComponent implements OnInit {

  events?: Event[];
  isLoading: boolean = true;

  constructor(
    private eventDao: EventDao
  ) { 
    this.loadEvents();
  }

  ngOnInit(): void {
    
  }

  private loadEvents() {
    this.eventDao.getEventActivo().subscribe({
      next: (result) => {
        console.log("Eventos cargados: ", result.resultado);
        this.events = result.resultado!;
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
