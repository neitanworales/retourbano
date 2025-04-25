import { Component, OnInit } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { MtoLogin } from 'src/app/core/models/login/MtoLogin';

@Component({
  selector: 'app-usuarios',
  templateUrl: './usuarios.component.html',
  styleUrl: './usuarios.component.css',
  standalone: false
})
export class UsuariosComponent implements OnInit{

  users?: MtoLogin[] = new Array();
  columnsToDisplay = [
    'id',
    'nick',
    'email',
    'roles'
  ];

  constructor(
    private registroDao: RegistroDao,
  ){

  }

  ngOnInit(): void {
    this.loadData();
  }

  cargarTodos(){
    this.loadData();
  }

  loadData(){
    this.registroDao.obtenerUsuarios().subscribe(
      resultado => {
        this.users = resultado.users;
      }
    );
  }

}
