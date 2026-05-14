import { Component, OnInit, Input } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { Avance } from 'src/app/core/models/registro/Avance';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
    selector: 'app-registro-avance',
    templateUrl: './registro-avance.component.html',
    styleUrls: ['./registro-avance.component.css'],
    standalone: false
})
export class RegistroAvanceComponent implements OnInit {

  avance? : Avance;
  avanceStyle = "width: 0%;";
  today = new Date();
  cerradas = true;
  abiertas = true;
  lugaresDisponibles? : Boolean;

  @Input()
  showForm?: boolean;

  @Input({ required: true })
  event!: Event;

  constructor(
    public registroDao : RegistroDao
  ) {
   }

  ngOnInit(): void {
    this.getRegistroAvance();
  }

  private getRegistroAvance(){
    /*this.registroDao.getAvanceRegistro().subscribe(
      result => {
        var avances = result.resultado;
        if(Array.isArray(avances)){
          this.avance = avances[0];
          this.avanceStyle = "width: "+this.avance.porcentaje+"%;";
          this.avance.fecha_maxima = new Date((this.avance.fecha_maxima+"").replace(/-/g, "/"));
          this.avance.fecha_apertura= new Date((this.avance.fecha_apertura+"").replace(/-/g, "/"));
          this.abiertas = this.today.getTime()>=this.avance?.fecha_apertura?.getTime();
          this.cerradas = this.today.getTime()>this.avance?.fecha_maxima?.getTime();
          this.lugaresDisponibles = this.avance?.disponibles>0;
        }
      }
    );*/

    console.log("Configuracion recibida: ", this.event.configuracion);
    this.avance = this.event.configuracion;
    this.avanceStyle = "width: "+this.avance!.porcentaje!+"%;";
    this.avance!.fecha_maxima = new Date((this.avance!.fecha_maxima+"").replace(/-/g, "/"));
    this.avance!.fecha_apertura= new Date((this.avance!.fecha_apertura+"").replace(/-/g, "/"));
    this.abiertas = this.today.getTime()>=this.avance!.fecha_apertura?.getTime();
    this.cerradas = this.today.getTime()>this.avance!.fecha_maxima?.getTime();
    this.lugaresDisponibles = this.avance!.disponibles>0;
    
  }

}
