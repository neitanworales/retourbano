import { Component, Input } from '@angular/core';
import { PagoDao } from 'src/app/core/api/dao/PagoDao';
import { Indicador } from 'src/app/core/models/registro/Indicador';
import { Pago } from 'src/app/core/models/registro/Pago';
import { DatePipe } from '@angular/common';
import * as XLSX from 'xlsx';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
    selector: 'app-contabilidad',
    templateUrl: './contabilidad.component.html',
    styleUrls: ['./contabilidad.component.css'],
    providers: [DatePipe],
    standalone: false
})
export class ContabilidadComponent {

  constructor(public pagoDao: PagoDao, private datePipe: DatePipe) { }

  @Input() selectedEvento?: Event;

  indicadores? : Indicador[]

  pageResumenActive = true;
  pageEntradasActive = false;
  pagePrCamperoActive = false;
  pageMetodosActive = false;
  pagePendientesActive = false;
  pageFlujoActive = false;
  
  displayStyle: string = "none";
  displayStylePorGuerrero: string = "none";
  chartsDisplayStyle = "";
  searchByName?: string = "";

  dataSource?: any[];
  dataSourcePorGuerrero?: any[];
  dataSourceMetodos?: any[];
  dataSourcePendientes?: any[];
  dataSourceFlujo?: any[];

  columnsToDisplay = [
    'ID',
    'nombre',
    'descripcion',
    'cantidad',
    'divisa',
    'no_ticket'
  ];

  columnsToDisplayPorGuerrero = [
    'nombre',
    'descripcion',
    'cantidad',
    'pagos'
  ];

  columnsToDisplayMetodos = [
    'metodo',
    'cantidad',
    'total'
  ];

  columnsToDisplayPendientes = [
    'nombre',
    'tipo',
    'pagado',
    'esperado',
    'pendiente',
    'pagos',
    'ultimo_pago'
  ];

  columnsToDisplayFlujo = [
    'fecha',
    'pagos',
    'total'
  ];

  ngOnInit(): void {
    this.cargarDatos();
  }

  activarPageResumen(){
    this.pageResumenActive = true;
    this.pageEntradasActive = false;
    this.pagePrCamperoActive = false;
    this.pageMetodosActive = false;
    this.pagePendientesActive = false;
    this.pageFlujoActive = false;
    this.cargarDatos();
  }

  activarPageEntradas(){
    this.pageResumenActive = false;
    this.pageEntradasActive = true;
    this.pagePrCamperoActive = false;
    this.pageMetodosActive = false;
    this.pagePendientesActive = false;
    this.pageFlujoActive = false;
    this.cargarDatos();
  }

  activarPagePorGuerrero(){
    this.pageResumenActive = false;
    this.pageEntradasActive = false;
    this.pagePrCamperoActive = true;
    this.pageMetodosActive = false;
    this.pagePendientesActive = false;
    this.pageFlujoActive = false;
    this.cargarDatos();
  }

  activarPageMetodos(){
    this.pageResumenActive = false;
    this.pageEntradasActive = false;
    this.pagePrCamperoActive = false;
    this.pageMetodosActive = true;
    this.pagePendientesActive = false;
    this.pageFlujoActive = false;
    this.cargarDatos();
  }

  activarPagePendientes(){
    this.pageResumenActive = false;
    this.pageEntradasActive = false;
    this.pagePrCamperoActive = false;
    this.pageMetodosActive = false;
    this.pagePendientesActive = true;
    this.pageFlujoActive = false;
    this.cargarDatos();
  }

  activarPageFlujo(){
    this.pageResumenActive = false;
    this.pageEntradasActive = false;
    this.pagePrCamperoActive = false;
    this.pageMetodosActive = false;
    this.pagePendientesActive = false;
    this.pageFlujoActive = true;
    this.cargarDatos();
  }

  cargarDatos() {

    let opcion: number = 0;
    let activo: boolean = false;
    let staff: boolean = false;
    let admin: boolean = false;
    let seg: boolean = false;
    const eventId = this.selectedEvento?.id;

    if (this.pageResumenActive) {
      this.dataSource = [];
      this.dataSourceMetodos = [];
      this.dataSourcePendientes = [];
      this.dataSourceFlujo = [];
      this.displayStylePorGuerrero = "none";
      this.displayStyle = "none";
      this.chartsDisplayStyle = "";

      this.pagoDao.consultarResumen(eventId).subscribe(
        respuesta => {
          this.indicadores = respuesta.resultado;
          console.log(this.indicadores);
        }
      );

    } else if (this.pagePrCamperoActive) {
      this.chartsDisplayStyle = "none";
      this.displayStyle = "none";
      this.displayStylePorGuerrero = "";
      this.dataSourceMetodos = [];
      this.dataSourcePendientes = [];
      this.dataSourceFlujo = [];
      this.pagoDao.consultarPagosPorGuerrero(eventId).subscribe(
        respuesta => {
          console.log(respuesta.resultado);
          this.dataSourcePorGuerrero = respuesta.resultado;
        }
      );

    } else if (this.pageMetodosActive) {
      this.chartsDisplayStyle = "none";
      this.displayStyle = "none";
      this.displayStylePorGuerrero = "none";
      this.dataSourcePendientes = [];
      this.dataSourceFlujo = [];

      this.pagoDao.consultarMetodosPago(eventId).subscribe(
        respuesta => {
          this.dataSourceMetodos = respuesta.resultado;
        }
      );

    } else if (this.pagePendientesActive) {
      this.chartsDisplayStyle = "none";
      this.displayStyle = "none";
      this.displayStylePorGuerrero = "none";
      this.dataSourceMetodos = [];
      this.dataSourceFlujo = [];

      this.pagoDao.consultarPendientes(eventId).subscribe(
        respuesta => {
          this.dataSourcePendientes = respuesta.resultado;
        }
      );

    } else if (this.pageFlujoActive) {
      this.chartsDisplayStyle = "none";
      this.displayStyle = "none";
      this.displayStylePorGuerrero = "none";
      this.dataSourceMetodos = [];
      this.dataSourcePendientes = [];

      this.pagoDao.consultarFlujo(eventId).subscribe(
        respuesta => {
          this.dataSourceFlujo = respuesta.resultado;
        }
      );

    } else {
      this.chartsDisplayStyle = "none";
      this.displayStylePorGuerrero = "none";
      this.displayStyle = "";
      this.dataSourceMetodos = [];
      this.dataSourcePendientes = [];
      this.dataSourceFlujo = [];

      if (this.pageEntradasActive) {
        opcion = 1;
        activo = true;
        staff = false;
        admin = false;
        seg=false;
      }      

      this.pagoDao.consultarPagos(eventId).subscribe(
        respuesta => {
          console.log(respuesta.resultado);
          this.dataSource = respuesta.resultado;
        }
      );
    }
  }

  cargarTodos() {
    this.searchByName = "";
    this.cargarDatos();
  }

  exportToExcel(dataset: 'entradas' | 'porGuerrero' | 'metodos' | 'pendientes' | 'flujo'){
    let myDate = new Date();
    let dateString = this.datePipe.transform(myDate, 'YYYY_MM_dd_HHmmss');
    let fileName= 'PAGOS-RETO-URBANO-2024_'+dateString+'.xlsx';
    /* pass here the table id */
    //let element = document.getElementById('excel-table');
    //const ws: XLSX.WorkSheet =XLSX.utils.table_to_sheet(element);
 
    const dataMap: Record<string, any[] | undefined> = {
      entradas: this.dataSource,
      porGuerrero: this.dataSourcePorGuerrero,
      metodos: this.dataSourceMetodos,
      pendientes: this.dataSourcePendientes,
      flujo: this.dataSourceFlujo,
    };

    const rows = dataMap[dataset] || [];
    const ws: XLSX.WorkSheet =XLSX.utils.json_to_sheet(rows);

    /* generate workbook and add the worksheet */
    const wb: XLSX.WorkBook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Pagos');
 
    /* save to file */  
    XLSX.writeFile(wb, fileName);
  }

}
