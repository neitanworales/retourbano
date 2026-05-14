import { Component, inject, OnInit } from '@angular/core';
import { RetoDao } from 'src/app/core/api/dao/RetoDao';
import { Seguimiento } from 'src/app/core/models/reto/Seguimiento';
import { Session } from 'src/app/core/models/login/Session';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { AuthService } from 'src/app/core/services/auth.service';
import { Indicador } from 'src/app/core/models/registro/Indicador';
import { Paquete } from 'src/app/core/models/registro/Paquete';
import { arrow } from '@popperjs/core';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
  standalone: false
})
export class DashboardComponent implements OnInit {

  event?: Event;
  session!: Session;
  seguimientos?: Seguimiento[];
  diaSelected = "";
  horarios?: string[];
  showHorario?: boolean;
  horaSelected?: string
  mensajeInscritoCampamento?: string;
  inscrtoCampamento?: boolean;
  classInscritoCampamento?: string;
  showFormInscripcion?: boolean = false;
  paquetes: Paquete[] = [];

  constructor(private retoDao: RetoDao, private loginDao: LoginDao, private registroDao: RegistroDao) {
    this.session = inject(AuthService).getSession()!;
  }

  ngOnInit(): void {
    this.validarInscricion();
    this.cargarIndicadores();
  }

  private validarInscricion() {
    this.registroDao.validarInscripcion().subscribe(
      result => {
        this.mensajeInscritoCampamento = result.mensaje;
        this.inscrtoCampamento = result.inscrito;
        this.classInscritoCampamento = result.inscrito ? "alert alert-success" : "alert alert-warning";
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

}
