import { Component } from '@angular/core';
import { HorarioDao } from 'src/app/core/api/dao/HorarioDao';
import { HorarioActividades } from 'src/app/core/models/horario/HorarioActividades';

@Component({
    selector: 'app-horario',
    templateUrl: './horario.component.html',
    styleUrls: ['./horario.component.css'],
    standalone: false
})
export class HorarioComponent {

  todayDate : Date = new Date();
  datos? : HorarioActividades;

  constructor(
    public horarioDao : HorarioDao
  ) {
    this.getRegistroAvance();
   }

  ngOnInit(): void {
  }

  private getRegistroAvance(){
    this.horarioDao.getData().subscribe(
      result => {
        this.datos = result;
        console.log(this.datos);
      }
    );
  }

}
