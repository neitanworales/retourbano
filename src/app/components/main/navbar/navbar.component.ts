import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { Event } from 'src/app/core/models/registro/Event';
import { EventDao } from 'src/app/core/api/dao/EventDao';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css'],
  standalone: false
})
export class NavbarComponent implements OnInit {

  @ViewChild('navbarResponsive') navbarResponsive?: ElementRef<HTMLDivElement>;
  @ViewChild('navbarToggler') navbarToggler?: ElementRef<HTMLButtonElement>;

  events?: Event[];
  isLoading: boolean = true;

  constructor(
    private eventDao: EventDao
  ) {
    this.loadEvent();
  }

  ngOnInit(): void {
  }

  closeNavbar(): void {
    const collapse = this.navbarResponsive?.nativeElement;
    const toggler = this.navbarToggler?.nativeElement;

    if (!collapse?.classList.contains('show')) {
      return;
    }

    collapse.classList.remove('show');
    toggler?.classList.add('collapsed');
    toggler?.setAttribute('aria-expanded', 'false');
  }

  private loadEvent() {
    this.eventDao.getEventActivo('BASIC').subscribe({
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
