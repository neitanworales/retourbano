import { Component } from '@angular/core';
import { PagoDao } from 'src/app/core/api/dao/PagoDao';
import { Indicador } from 'src/app/core/models/registro/Indicador';
import { Pago } from 'src/app/core/models/registro/Pago';
import { DatePipe } from '@angular/common';
import * as XLSX from 'xlsx';

@Component({
    selector: 'app-contabilidad',
    templateUrl: './contabilidad.component.html',
    styleUrls: ['./contabilidad.component.css'],
    providers: [DatePipe],
    standalone: false
})
export class ContabilidadComponent {

  constructor(public pagoDao: PagoDao, private datePipe: DatePipe) { }

  indicadores? : Indicador[]

  pageResumenActive = true;
  pageEntradasActive = false;
  pagePrCamperoActive = false;
  
  displayStyle: string = "none";
  displayStylePorGuerrero: string = "none";
  chartsDisplayStyle = "";
  searchByName?: string = "";

  dataSource?: Pago[];
  dataSourcePorGuerrero?: Pago[];

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

  ngOnInit(): void {
    this.cargarDatos();
  }

  activarPageResumen(){
    this.pageResumenActive = true;
    this.pageEntradasActive = false;
    this.pagePrCamperoActive = false;
    this.cargarDatos();
  }

  activarPageEntradas(){
    this.pageResumenActive = false;
    this.pageEntradasActive = true;
    this.pagePrCamperoActive = false;
    this.cargarDatos();
  }

  activarPagePorGuerrero(){
    this.pageResumenActive = false;
    this.pageEntradasActive = false;
    this.pagePrCamperoActive = true;
    this.cargarDatos();
  }

  cargarDatos() {

    let opcion: number = 0;
    let activo: boolean = false;
    let staff: boolean = false;
    let admin: boolean = false;
    let seg: boolean = false;

    if (this.pageResumenActive) {
      this.dataSource = [];
      this.displayStylePorGuerrero = "none";
      this.displayStyle = "none";
      this.chartsDisplayStyle = "";

      this.pagoDao.consultarResumen().subscribe(
        respuesta => {
          this.indicadores = respuesta.resultado;
          console.log(this.indicadores);
        }
      );

    } else if (this.pagePrCamperoActive) {
      this.chartsDisplayStyle = "none";
      this.displayStyle = "none";
      this.displayStylePorGuerrero = "";
      this.pagoDao.consultarPagosPorGuerrero().subscribe(
        respuesta => {
          console.log(respuesta.resultado);
          this.dataSourcePorGuerrero = respuesta.resultado;
        }
      );

    } else {
      this.chartsDisplayStyle = "none";
      this.displayStylePorGuerrero = "none";
      this.displayStyle = "";

      if (this.pageEntradasActive) {
        opcion = 1;
        activo = true;
        staff = false;
        admin = false;
        seg=false;
      }      

      this.pagoDao.consultarPagos().subscribe(
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

  exportToExcel(isPorGuerrero: boolean){
    let myDate = new Date();
    let dateString = this.datePipe.transform(myDate, 'YYYY_MM_dd_HHmmss');
    let fileName= 'PAGOS-RETO-URBANO-2024_'+dateString+'.xlsx';
    /* pass here the table id */
    //let element = document.getElementById('excel-table');
    //const ws: XLSX.WorkSheet =XLSX.utils.table_to_sheet(element);
 
    const ws: XLSX.WorkSheet =XLSX.utils.json_to_sheet(isPorGuerrero?this.dataSourcePorGuerrero!:this.dataSource!);

    /* generate workbook and add the worksheet */
    const wb: XLSX.WorkBook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Pagos');
 
    /* save to file */  
    XLSX.writeFile(wb, fileName);
  }

}
