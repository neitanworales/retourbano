import { Component, OnInit } from '@angular/core';
import { RetoDao } from 'src/app/core/api/dao/RetoDao';
import { Asistencia } from 'src/app/core/models/reto/Asistencia';

@Component({
    selector: 'app-asistencia',
    templateUrl: './asistencia.component.html',
    styleUrls: ['./asistencia.component.css'],
    standalone: false
})
export class AsistenciaComponent implements OnInit {

  dataSource?: Asistencia[];
  displayedColumns = [
    //'id_campamento',
    //'cg',
    //'id',
    'nombre',
    //'id_seguimiento',
    //'seguimiento_id',
    //'estudiante_id',
    
    'dia_llegada',
    //'registro',
    'hora_llegada',
    'confirmacion',
  ];

  constructor(public retoDao: RetoDao) { }

  ngOnInit(): void {
    this.cargarDatos();
  }

  cargarDatos() {
    this.retoDao.getAsistencia().subscribe(
      respuesta => {
        this.dataSource = respuesta.resultado;
        console.log(this.dataSource);
      }
    );
  }

  asistir(guerrero: Asistencia, asiste: boolean){
    
  }

}
