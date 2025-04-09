import { Component, inject, OnInit } from '@angular/core';
import { RetoDao } from 'src/app/core/api/dao/RetoDao';
import { Seguimiento } from 'src/app/core/models/reto/Seguimiento';
import { Session } from 'src/app/core/models/login/Session';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { AuthService } from 'src/app/core/services/auth.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
  standalone: false
})
export class DashboardComponent implements OnInit {

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

  constructor(private retoDao: RetoDao, private loginDao: LoginDao, private registroDao: RegistroDao) { 
    this.session = inject(AuthService).getSession()!;
  }

  ngOnInit(): void {
    this.validarInscricion();
  }

  private validarInscricion() {
    this.registroDao.validarInscripcion().subscribe(
      result => {
        this.mensajeInscritoCampamento = result.mensaje;
        this.inscrtoCampamento = result.inscrito;
        this.classInscritoCampamento = result.inscrito?"alert alert-success":"alert alert-warning";
      }
    );
  }

  public presentarFormInscripcion(){
    this.showFormInscripcion = true;
  }

  private cargarDatos() {
    this.retoDao.getSeguimientosByGuerror().subscribe(
      resultado => {
        this.seguimientos = resultado.resultado;

        let first = this.seguimientos?.find((obj) => {
          return obj.activo == true;
        });

        if (first?.dia_llegada !== undefined) {
          this.diaSelected = first?.dia_llegada;
          this.horaSelected = first?.hora_llegada;
          if (this.diaSelected === 'v') {
            this.showHorario = true;
            this.horarios = this.horariosViernes;
          } else if (this.diaSelected === 's') {
            this.showHorario = true;
            this.horarios = this.horariosSabado;
          } else {
            this.showHorario = false;
            this.horarios = [];
          }
        }
      }
    );
  }

  diaLlegada(dia: string) {
    this.retoDao.confirmaAsistencia(dia).subscribe(
      resultado => {
        if (!resultado.error) {
          this.diaSelected = dia;
          this.horaSelected = "";
          this.horaLlegada();
          if (this.diaSelected === 'v') {
            this.showHorario = true;
            this.horarios = this.horariosViernes;
          } else if (this.diaSelected === 's') {
            this.showHorario = true;
            this.horarios = this.horariosSabado;
          } else {
            this.showHorario = false;
            this.horarios = [];
          }
        }
      }
    );
  }

  horaLlegada() {
    this.retoDao.confirmaAsistenciaHora(this.horaSelected!).subscribe(
      resultado => {
        console.log(resultado);
      }
    );
  }

  horariosViernes = [
    "15:00",
    "15:30",
    "16:00",
    "16:30",
    "17:00",
    "17:30",
    "18:00",
    "18:30",
    "19:00",
    "19:30",
    "20:00",
    "20:30",
    "21:00",
    "21:30",
    "22:00",
    "22:30",
  ]

  horariosSabado = [
    "06:00",
    "06:30",
    "07:00",
    "07:30",
    "08:00",
    "08:30",
    "09:00",
    "09:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
  ]

}
