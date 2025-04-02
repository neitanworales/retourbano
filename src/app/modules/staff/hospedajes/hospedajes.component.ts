import { Component, OnInit } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { Hospedaje } from 'src/app/core/models/hospedaje/Hospedaje';

@Component({
  selector: 'app-hospedajes',
  templateUrl: './hospedajes.component.html',
  styleUrl: './hospedajes.component.css',
  standalone: false
})
export class HospedajesComponent implements OnInit {
  
  hospedajes!: Hospedaje[];
  columnsToDisplay = [
    'id',
    'id_guerrero',
    'nombre',
    'confirmado',
    'asistencia',
    'hospedaje',
    'sexo',
    'habitacion'
  ];

  constructor(
    private registroDao: RegistroDao
  ){

  }

  ngOnInit(): void {
    this.cargarDatos();
  }

  private cargarDatos() {
    this.registroDao.obtenerHospedajes().subscribe(
      result => {
        this.hospedajes = result.resultado;
      }
    );
  }

}
