import { Component, OnInit } from '@angular/core';
import { CampamentoDao } from 'src/app/core/api/dao/CampamentoDao';
import { Campamento } from 'src/app/core/models/registro/Campamento';

@Component({
    selector: 'app-campamentos',
    templateUrl: './campamentos.component.html',
    //styleUrl: './campamentos.component.css',
    standalone: false
})
export class CampamentosComponent implements OnInit {

  constructor(public campaDao: CampamentoDao){}

  columnsToDisplay = [
    'botonera',
    'id_campamento',
    'titulo',
    'activo',
    'maximo_inscr',
    'umbral',
    'fecha_apertura',
    'fecha_maxima',
    'costo'
  ];

  dataSource?: Campamento[];

  ngOnInit(): void {
    this.cargarDatos();
  }

  cargarDatos(){
    this.campaDao.getCampamentos().subscribe(
      response => {
        this.dataSource = response.resultado;
      }
    );
  }
}
