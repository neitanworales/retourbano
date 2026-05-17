import { DatePipe } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { Habitacion } from 'src/app/core/models/hospedaje/Habitacion';
import { HospedajeTable } from 'src/app/core/models/hospedaje/HospedajeTable';
import { EventRegistration } from 'src/app/core/models/registro/EventRegistration';
import { User } from 'src/app/core/models/registro/User';
import * as XLSX from 'xlsx';

@Component({
  selector: 'app-hospedajes',
  templateUrl: './hospedajes.component.html',
  styleUrl: './hospedajes.component.css',
  standalone: false,
  providers: [DatePipe],
})
export class HospedajesComponent implements OnInit {

  eventSeleccionadoId?: number;

  pageHabitaciones : boolean = true;
  pageHospedajes! : boolean;
  pageNoHospedajes! : boolean;

  pageHabitacionesDisplayStyle = 'block';
  pageHospedajesDisplayStyle = 'none';

  hospedajes: HospedajeTable[] = new Array();
  habitaciones: Habitacion[] = new Array();
  personasSinHabitacion: EventRegistration[] = new Array();

  // Loading states
  cargandoHabitaciones = false;
  cargandoHospedajes = false;
  guardando = false;

  // Error messages
  errorHabitaciones: string | null = null;
  errorHospedajes: string | null = null;

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
    this.cargandoHospedajes = true;
    this.errorHospedajes = null;
    
    this.registroDao.obtenerHospedajes(this.pageHospedajes, this.eventSeleccionadoId!).subscribe(
      result => {
        if (result.error) {
          this.errorHospedajes = result.message || 'Error al cargar hospedajes';
          console.error('Error loading hospedajes:', result.message);
        } else {
          this.hospedajes = result.resultado;
          this.hospedajes.map((p) => {
            p.editar = false;
            return p;
          });
          this.errorHospedajes = null;
        }
        this.cargandoHospedajes = false;
      },
      error => {
        this.errorHospedajes = 'Error al conectar con el servidor';
        console.error('HTTP Error loading hospedajes:', error);
        this.cargandoHospedajes = false;
      }
    );
  }

  cargarHabitaciones(){
    this.cargarDatosHabitaciones();
  }

  private cargarDatosHabitaciones(){
    this.cargandoHabitaciones = true;
    this.errorHabitaciones = null;

    this.registroDao.obtenerHabitaciones(this.eventSeleccionadoId!).subscribe(
      result => {
        if (result.error) {
          this.errorHabitaciones = result.message || 'Error al cargar habitaciones';
          console.error('Error loading habitaciones:', result.message);
          this.habitaciones = [];
        } else {
          this.habitaciones = result.resultado;
          this.errorHabitaciones = null;
        }
        this.cargandoHabitaciones = false;
      },
      error => {
        this.errorHabitaciones = 'Error al conectar con el servidor';
        console.error('HTTP Error loading habitaciones:', error);
        this.habitaciones = [];
        this.cargandoHabitaciones = false;
      }
    );

    this.registroDao.obtenerPersonasSinHabitacion(this.eventSeleccionadoId!).subscribe(
      result => {
        if (result.error) {
          console.error('Error loading unassigned people:', result.message);
          this.personasSinHabitacion = [];
        } else {
          this.personasSinHabitacion = result.personas || [];
        }
      },
      error => {
        console.error('HTTP Error loading unassigned people:', error);
        this.personasSinHabitacion = [];
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
    if (!hosp.id || !hosp.habitacion) {
      alert('ID o habitación no válidos');
      return;
    }

    this.guardando = true;
    this.registroDao.actualizarHabitacion(hosp.id, hosp.habitacion, this.eventSeleccionadoId!).subscribe(
      result => {
        if (result.error) {
          alert('Error: ' + (result.message || 'No se pudo actualizar la habitación'));
          hosp.habitacion = hosp.habitacionOldValue;
        } else {
          alert('Habitación actualizada correctamente');
        }
        hosp.editar = false;
        this.guardando = false;
      },
      error => {
        console.error('Error updating room assignment:', error);
        alert('Error al conectar con el servidor');
        hosp.habitacion = hosp.habitacionOldValue;
        hosp.editar = false;
        this.guardando = false;
      }
    );
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
    if (!hosp.id || hosp.hospedaje === undefined || hosp.hospedaje === null) {
      alert('ID o valor de hospedaje no válidos');
      return;
    }

    this.guardando = true;
    this.registroDao.actualizarHospedaje(hosp.id, hosp.hospedaje, this.eventSeleccionadoId!).subscribe(
      result => {
        if (result.error) {
          alert('Error: ' + (result.message || 'No se pudo actualizar el hospedaje'));
          hosp.hospedaje = hosp.hospedajeOldValue;
        } else {
          alert('Hospedaje actualizado correctamente');
        }
        hosp.editarHospedaje = false;
        this.guardando = false;
      },
      error => {
        console.error('Error updating lodging requirement:', error);
        alert('Error al conectar con el servidor');
        hosp.hospedaje = hosp.hospedajeOldValue;
        hosp.editarHospedaje = false;
        this.guardando = false;
      }
    );
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
