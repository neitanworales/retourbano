import { Component, inject, OnInit } from '@angular/core';
import { RetoDao } from 'src/app/core/api/dao/RetoDao';
import { Seguimiento } from 'src/app/core/models/reto/Seguimiento';
import { Session } from 'src/app/core/models/login/Session';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { AuthService } from 'src/app/core/services/auth.service';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
  standalone: false
})
export class DashboardComponent implements OnInit {

  events?: Event[];
  upcomingEvents: Event[] = [];
  registeredEvents: Event[] = [];
  session!: Session;
  seguimientos?: Seguimiento[];
  diaSelected = "";
  horarios?: string[];
  showHorario?: boolean;
  horaSelected?: string
  showFormInscripcion?: boolean = false;

  constructor(private retoDao: RetoDao, private loginDao: LoginDao, private registroDao: RegistroDao) {
    this.session = inject(AuthService).getSession()!;
  }

  ngOnInit(): void {
    this.validarInscricion();
    this.cargarHistorialEventos();
  }

  private validarInscricion() {
    this.registroDao.validarInscripcion(0).subscribe(
      result => {
        this.events = result.events;
        this.upcomingEvents = result.events?.filter(e => !e.is_registered) || [];
      }
    );
  }

  private cargarHistorialEventos() {
    this.registroDao.getUserRegistrations().subscribe(
      result => {
        const registrations = result.data?.events || [];
        this.registeredEvents = registrations.map((item) => {
          const event = new Event();
          event.id = item.id;
          event.title = item.title || 'Evento sin nombre';
          event.start_at = item.start_at;
          event.city_label = item.city_label || 'Sin ciudad';
          event.is_registered = true;
          event.registration_id = item.registration_id;
          event.registration_status = item.registration_status || 'active';
          return event;
        });
      },
      error => {
        console.error('Error loading registration history:', error);
        this.registeredEvents = [];
      }
    );
  }

  public presentarFormInscripcion() {
    this.showFormInscripcion = true;
  }

  inscribirEvento(event_id: number) {
  }

}
