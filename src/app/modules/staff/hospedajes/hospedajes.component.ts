import { DatePipe } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { Habitacion } from 'src/app/core/models/hospedaje/Habitacion';
import { HospedajeTable } from 'src/app/core/models/hospedaje/HospedajeTable';
import { Guerrero } from 'src/app/core/models/registro/Guerrero';
import * as XLSX from 'xlsx';

@Component({
  selector: 'app-hospedajes',
  templateUrl: './hospedajes.component.html',
  styleUrl: './hospedajes.component.css',
  standalone: false,
  providers: [DatePipe],
})
export class HospedajesComponent implements OnInit {

  pageHabitaciones : boolean = true;
  pageHospedajes! : boolean;
  pageNoHospedajes! : boolean;

  pageHabitacionesDisplayStyle = 'block';
  pageHospedajesDisplayStyle = 'none';

  hospedajes: HospedajeTable[] = new Array();
  habitaciones: Habitacion[] = new Array();
  personasSinHabitacion: Guerrero[] = new Array();

  columnsToDisplay = [
    'nombre',
    'confirmado',
    'asistencia',
    'hospedaje',
    'sexo',
    'edad',
    'habitacion'
  ];

  constructor(
    private registroDao: RegistroDao,
    private datePipe: DatePipe
  ) {

  }

  ngOnInit(): void {
    this.cargarDatosHabitaciones();
  }

  private cargarDatosHospedajes() {
    this.registroDao.obtenerHospedajes(this.pageHospedajes).subscribe(
      result => {
        this.hospedajes = result.resultado;
        this.hospedajes.map((p, i) => {
          p.editar = false;
          return p;
        });
      }
    );
  }

  cargarHabitaciones(){
    this.cargarDatosHabitaciones();
  }

  private cargarDatosHabitaciones(){
    this.registroDao.obtenerHabitaciones().subscribe(
      result => {
        this.habitaciones = result.resultado;
      }
    );
    this.registroDao.obtenerPersonasSinHabitacion().subscribe(
      result => {
        this.personasSinHabitacion = result.personas!;
      }
    );
  }

  editar(hosp: HospedajeTable) {
    hosp.editar = !hosp.editar;
    if (hosp.editar) {
      hosp.habitacionOldValue = hosp.habitacion;
    } else {
      hosp.habitacion = hosp.habitacionOldValue;
    }
  }

  guardar(hosp: HospedajeTable) {
    this.registroDao.actualizarHabitacion(hosp.id!, hosp.habitacion!).subscribe(
      result => {

      }
    );
    hosp.editar = false;
  }

  editarHospedaje(hosp: HospedajeTable) {
    hosp.editarHospedaje = !hosp.editarHospedaje;
    if (hosp.editar) {
      hosp.hospedajeOldValue = hosp.hospedajeOldValue;
    } else {
      hosp.hospedaje = hosp.hospedajeOldValue;
    }
  }

  guardarHospedaje(hosp: HospedajeTable) { 
    this.registroDao.actualizarHospedaje(hosp.id!, hosp.hospedaje!).subscribe(
      result => {

      }
    );
    hosp.editarHospedaje = false;
  }

  exportToExcel() {
    let myDate = new Date();
    let dateString = this.datePipe.transform(myDate, 'YYYY_MM_dd_HHmmss');
    let fileName = 'HOSPEDAJE_RU_2025_' + dateString + '.xlsx';
    /* pass here the table id */
    //let element = document.getElementById('excel-table');
    //const ws: XLSX.WorkSheet =XLSX.utils.table_to_sheet(element);

    const ws: XLSX.WorkSheet = XLSX.utils.json_to_sheet(this.hospedajes!);

    /* generate workbook and add the worksheet */
    const wb: XLSX.WorkBook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Guerreros');

    /* save to file */
    XLSX.writeFile(wb, fileName);
  }

  cargarTodos() {
    this.cargarDatosHospedajes();
  }

  activarPageHabitaciones(){
    this.pageHospedajesDisplayStyle = 'none';
    this.pageHabitacionesDisplayStyle = 'block';
    this.pageHabitaciones = true;
    this.pageHospedajes = false;
    this.pageNoHospedajes = false;
    this.cargarDatosHabitaciones();
  }

  activarPageHospedajes(){
    this.pageHospedajesDisplayStyle = 'block';
    this.pageHabitacionesDisplayStyle = 'none';
    this.pageHabitaciones = false;
    this.pageHospedajes = true;
    this.pageNoHospedajes = false;
    this.cargarDatosHospedajes();
  }

  activarPageNoHospedajes(){
    this.pageHospedajesDisplayStyle = 'block';
    this.pageHabitacionesDisplayStyle = 'none';
    this.pageHabitaciones = false;
    this.pageHospedajes = false;
    this.pageNoHospedajes = true;
    this.cargarDatosHospedajes();
  }

}
