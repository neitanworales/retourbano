import { Component, inject, OnInit } from '@angular/core';
import { RetoDao } from 'src/app/core/api/dao/RetoDao';
import { Seguimiento } from 'src/app/core/models/reto/Seguimiento';
import { Session } from 'src/app/core/models/login/Session';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { AuthService } from 'src/app/core/services/auth.service';
import { Indicador } from 'src/app/core/models/registro/Indicador';
import { Paquete } from 'src/app/core/models/registro/Paquete';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
  standalone: false
})
export class DashboardComponent implements OnInit {

  event?: Event;
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
  paquetes: Paquete[] = [];

  constructor(private retoDao: RetoDao, private loginDao: LoginDao, private registroDao: RegistroDao) {
    this.session = inject(AuthService).getSession()!;
  }

  ngOnInit(): void {
    this.validarInscricion();
    this.cargarHistorialEventos();
    this.cargarIndicadores();
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

  private cargarIndicadores() {
    this.registroDao.getIndicadores(this.event?.id!).subscribe(
      result => {
        const maxPaquetes = Math.max(...result.reporte!.map(item => item.paquete!));
        console.log("Max paquetotes: " + maxPaquetes);
        for (let i = 0; i < maxPaquetes; i++) {
          let pa = i + 1;
          if (!this.paquetes[i]) {
            this.paquetes[i] = new Paquete;
          }
          this.paquetes[i].indicadores = result!.reporte!.filter(p => p.paquete == pa)!;
        }
      }
    );
  }

  public presentarFormInscripcion() {
    this.showFormInscripcion = true;
  }

  inscribirEvento(event_id: number) {
  }

}
