import { Component, OnInit } from '@angular/core';
import { animate, state, style, transition, trigger } from '@angular/animations';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { MtoLogin } from 'src/app/core/models/login/MtoLogin';
import { AsistenciaCampamentos, CampamentoGuerreros } from 'src/app/core/models/registro/CampamentoGuerreros';

@Component({
  selector: 'app-usuarios',
  templateUrl: './usuarios.component.html',
  styleUrl: './usuarios.component.css',
  animations: [
    trigger('detailExpand', [
      state('collapsed', style({ height: '0px', minHeight: '0' })),
      state('expanded', style({ height: '*' })),
      transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    ]),
  ],
  standalone: false
})
export class UsuariosComponent implements OnInit {

  users?: MtoLogin[];
  repetidos?: CampamentoGuerreros[];
  expandedCampamentoGuerrero?: CampamentoGuerreros;

  columnsToDisplay = [
    'id',
    'nick',
    'email',
    'roles',
    'password'
  ];

  columnsToDisplayRepetidos = [
    'email',
    'count'
  ];

  pageUsuarios: boolean = true;
  pageRepetidos: boolean = false;
  pageUsauriosDisplayStyle: string = 'block';
  pageRepetidosDisplayStyle: string = 'none';

  constructor(
    private registroDao: RegistroDao,
  ) {

  }

  activarPageUsuarios() {
    this.pageUsuarios = true;
    this.pageRepetidos = false;
    this.pageUsauriosDisplayStyle = 'block';
    this.pageRepetidosDisplayStyle = 'none';
    this.loadDataUsuarios();
  }

  activarPageRepetidos() {
    this.pageUsuarios = false;
    this.pageRepetidos = true;
    this.pageUsauriosDisplayStyle = 'none';
    this.pageRepetidosDisplayStyle = 'block';
    this.loadDataRepetidos();
  }

  ngOnInit(): void {
    this.loadDataUsuarios();
  }

  cargarTodos() {
    this.loadDataUsuarios();
  }

  cargarTodosRepetidos() {
    this.loadDataRepetidos();
  }

  loadDataUsuarios() {
    this.registroDao.obtenerUsuarios().subscribe(
      resultado => {
        this.users = resultado.users;
      }
    );
  }

  loadDataRepetidos() {
    this.registroDao.obtenerRepetidos().subscribe(
      resultado => {
        this.repetidos = resultado.resultado;
      }
    );
  }

  esTutor(cg: AsistenciaCampamentos){
    this.registroDao.updateEmailTutor(cg.guerreroID!, '', cg.email!).subscribe(
      resultado => {
        this.cargarTodosRepetidos();
      }
    );
  }

  noEsTutor(cg: AsistenciaCampamentos){
    this.registroDao.updateEmailTutor(cg.guerreroID!, cg.email_tutor!, '').subscribe(
      resultado => {
        this.cargarTodosRepetidos();
      }
    );
  }

    editarPassword(hosp: MtoLogin) {
      hosp.editar = !hosp.editar;
      if (hosp.editar) {
        hosp.passwordOldValue = hosp.password;
      } else {
        hosp.password = hosp.passwordOldValue;
      }
    }
  
    guardarPassword(hosp: MtoLogin) {
      this.registroDao.actualizarPassword(hosp.email!, hosp.password!).subscribe(
        result => {
  
        }
      );
      hosp.editar = false;
    }

}
