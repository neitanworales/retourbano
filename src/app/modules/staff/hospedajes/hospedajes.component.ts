import { DatePipe } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { HospedajeTable } from 'src/app/core/models/hospedaje/HospedajeTable';
import * as XLSX from 'xlsx';

@Component({
  selector: 'app-hospedajes',
  templateUrl: './hospedajes.component.html',
  styleUrl: './hospedajes.component.css',
  standalone: false,
  providers: [DatePipe],
})
export class HospedajesComponent implements OnInit {

  hospedajes: HospedajeTable[] = new Array();
  columnsToDisplay = [
    'nombre',
    'confirmado',
    'asistencia',
    'hospedaje',
    'sexo',
    'habitacion'
  ];

  constructor(
    private registroDao: RegistroDao,
    private datePipe: DatePipe
  ) {

  }

  ngOnInit(): void {
    this.cargarDatos();
  }

  private cargarDatos() {
    this.registroDao.obtenerHospedajes().subscribe(
      result => {
        this.hospedajes = result.resultado;
        this.hospedajes.map((p, i) => {
          p.editar = false;
          return p;
        });
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
    this.cargarDatos();
  }

}
