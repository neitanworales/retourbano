import { Component, OnInit, ViewChild } from '@angular/core';
import { DatePipe } from '@angular/common';
import { animate, state, style, transition, trigger } from '@angular/animations';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { EventRegistration } from 'src/app/core/models/registro/EventRegistration';
import { Pago } from 'src/app/core/models/registro/Pago';
import * as XLSX from 'xlsx';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { Event } from 'src/app/core/models/registro/Event';
import { PieChartComponent } from 'src/app/components/pie-chart/pie-chart.component';

@Component({
    selector: 'app-inscripciones',
    templateUrl: './inscripciones.component.html',
    styleUrls: ['./inscripciones.component.css'],
    animations: [
        trigger('detailExpand', [
            state('collapsed', style({ height: '0px', minHeight: '0' })),
            state('expanded', style({ height: '*' })),
            transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
        ]),
    ],
    providers: [DatePipe],
    standalone: false
})
export class InscripcionesComponent implements OnInit {

  @ViewChild(PieChartComponent)
  child!: PieChartComponent;

  tabsCampas? : boolean[] = [false, false];
  events?: Event[]
  selectedEventoId?: number;
  selectedEvento?: Event;

  pageResumenActive = true;
  pageInscritosActive = false;
  pageStaffActive = false;
  pageAdminsActive = false;
  pageBajasActive = false;
  pageSeguimientoActive = false;
  pageHistoricoActive = false;

  displayStyle: string = "none";
  chartsDisplayStyle = "";

  dataSource?: EventRegistration[];
  columnsToDisplay = [
    'ID',
    'numero',
    'nombre',
    'nick',
    'edad',
    'sexo',
    'talla',
    'confirmado',
    'asistencia',
    'pagado', 
    'emailenviado'
  ];

  year: number = 2023;
  historicoColumnsToDisplay = [
    'ID',
    'nombre',
    'email'
  ];

  expandedGuerrero?: EventRegistration;
  searchByName?: string = "";
  years = [
    2015,2016,2017,2018,2019,2021,2022,2023
  ];

  constructor(
    public registroDao: RegistroDao, 
    private datePipe: DatePipe,
    private eventDao: EventDao) { }

  ngOnInit(): void {
    this.cargarDatos();
    this.loadCampamentos();
  }

  loadCampamentos() {
    this.eventDao.getEventActivo().subscribe({
      next: (result) => {
        console.log("Eventos cargados: ", result.data?.events);
        this.events = result.data?.events;
        console.log("Tabs eventos asignados: ", this.tabsCampas);

        if (this.events?.length === 1) {
          this.tabCampamentos(0);
        }
      },
      error: (error) => {
        console.error('Error al cargar eventos:', error);
      }
    });
  }

  activarPageResumen() {
    this.pageResumenActive = true;
    this.pageInscritosActive = false;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = false;
    this.pageHistoricoActive = false;
    this.cargarDatos();
  }

  activarPageInscritos() {
    this.pageResumenActive = false;
    this.pageInscritosActive = true;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = false;
    this.pageHistoricoActive = false;
    this.cargarDatos();
  }

  activarPageStaff() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = true;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = false;
    this.pageHistoricoActive = false;
    this.cargarDatos();
  }

  activarPageAdmins() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = false;
    this.pageAdminsActive = true;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = false;
    this.pageHistoricoActive = false;
    this.cargarDatos();
  }

  activarPageBajas() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = true;
    this.pageSeguimientoActive = false;
    this.pageHistoricoActive = false;
    this.cargarDatos();
  }

  activarPageSeguimiento() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = true;
    this.pageHistoricoActive = false;
    this.cargarDatos();
  }

  activarPageHistorico() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = false;
    this.pageHistoricoActive = true;
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
      this.displayStyle = "none";
      this.chartsDisplayStyle = "";
    }
    else if (this.pageHistoricoActive) {
      this.displayStyle = "";
      this.chartsDisplayStyle = "none";

      this.registroDao.consultarHistorico(this.year, this.selectedEventoId!).subscribe(
        respuesta => {
          this.dataSource = respuesta.data?.registrations || [];
        }
      );

    } else {
      this.chartsDisplayStyle = "none";
      this.displayStyle = "";

      if (this.pageInscritosActive) {
        opcion = 1;
        activo = true;
        staff = false;
        admin = false;
        seg = false;
      }

      if (this.pageStaffActive) {
        opcion = 1;
        activo = true;
        staff = true;
        admin = false;
        seg = false;
      }

      if (this.pageAdminsActive) {
        opcion = 1;
        activo = true;
        staff = true;
        admin = true;
        seg = false;
      }

      if (this.pageBajasActive) {
        opcion = 1;
        activo = false;
        staff = false;
        admin = false;
        seg = false;
      }

      if (this.pageSeguimientoActive) {
        opcion = 1;
        activo = true;
        seg = true;
      }

      this.registroDao.consultarInscritos(opcion, activo, staff, admin, this.searchByName!, seg, this.selectedEventoId).subscribe(
        respuesta => {
          this.dataSource = respuesta.data?.registrations || [];
        }
      );
    }
  }

  actualizarStaff(eventRegistration: EventRegistration) {
    this.registroDao.actualizarEventRol(eventRegistration.user!.id!, this.selectedEventoId!, !eventRegistration.is_staff!, eventRegistration.is_admin!).subscribe(
      result => {
        if (!result.error) {
          this.cargarDatos();
        }
      }
    );
  }

  actualizarAdmin(eventRegistration: EventRegistration) {
    this.registroDao.actualizarEventRol(eventRegistration.user!.id!, this.selectedEventoId!, true, !eventRegistration.is_admin!).subscribe(
      result => {
        if (!result.error) {
          this.cargarDatos();
        }
      }
    );
  }

  actualizarStatus(isActive: boolean, registrationId: number) {
    this.registroDao.actualizarStatus(isActive, registrationId).subscribe(
      result => {
        if (!result.error) {
          this.cargarDatos();
        }
      }
    );
  }

  agregarPago(element: EventRegistration) {
    if(element.pagos == null){
      element.pagos = [];
    }
    let nuevoPago = new Pago();
    nuevoPago.nuevo = true;
    nuevoPago.actualizar = false;
    nuevoPago.currency = "MXN"
    element.pagos.push(nuevoPago);
  }

  guardarPago(pago: Pago, reg: EventRegistration) {
    this.registroDao.guardarPago(pago, reg.id!).subscribe(
      result => {
        if (result.error) {
          console.log("erro al guardar el pago");
        } else {
          pago.actualizar = false;
          pago.nuevo = false;
          if (reg.pagado == null) {
            reg.pagado = 0;
          }
          reg.pagado = Number(reg.pagado) + Number(pago.amount!);
        }
      }
    );
  }

  confirmar(reg: EventRegistration, confirma: boolean) {
    this.registroDao.guardarConfirmacion(confirma, reg.id!).subscribe(
      result => {
        if (result.error) {
          console.log("erro al guardar la confirmacion");
        } else {
          reg.confirmado = confirma;
        }
      }
    );
  }

  asistir(reg: EventRegistration, asiste: boolean) {
    this.registroDao.guardarAsistencia(asiste, reg.id!).subscribe(
      result => {
        if (result.error) {
          console.log("erro al guardar el pago");
        } else {
          reg.asistencia = asiste;
        }
      }
    );
  }

  enviarConfirmarEmail(reg: EventRegistration, enviar: boolean, confirmar: boolean) {
    this.registroDao.enviarConfirmarEmail(enviar, confirmar, reg.id!).subscribe(
      result => {
        if (result.error) {
          console.log("erro al guardar el pago");
        } else {
          reg.emailEnviado = enviar;
          reg.emailConfirmado = confirmar;
        }
      }
    );
  }

  search() {
    this.cargarDatos();
  }

  cargarTodos() {
    this.searchByName = "";
    this.cargarDatos();
  }

  seguimiento(reg: EventRegistration, seg: boolean) {
    this.registroDao.guardarSeguimiento(seg, reg.id!).subscribe(
      result => {
        if (result.error) {
          console.log("erro al guardar el pago");
        } else {
          reg.seguimiento = seg;
        }
      }
    );
  }

  cambiarContrasena(reg: EventRegistration) {
    this.registroDao.cambiarContrasena(reg.user?.password!, reg.user?.id!, this.selectedEventoId!).subscribe(
      result => {
        if (result.error) {
          console.log("erro al guardar el cambio de contraseña");
        }
      }
    );
  }

  editarContrasena(reg: EventRegistration) {
    reg.user!.updatePassword = true;
  }

  cancelarContrasena(reg: EventRegistration) {
    reg.user!.updatePassword = false;
  }

  changeYear(y: number) {
    this.year = y;
    this.cargarTodos();
  }

  exportToExcel(){
    let myDate = new Date();
    let dateString = this.datePipe.transform(myDate, 'YYYY_MM_dd_HHmmss');
    let fileName= 'INSCRIPCIONES-RETO-URBANO-2025_'+dateString+'.xlsx';
    /* pass here the table id */
    //let element = document.getElementById('excel-table');
    //const ws: XLSX.WorkSheet =XLSX.utils.table_to_sheet(element);
 
    const ws: XLSX.WorkSheet =XLSX.utils.json_to_sheet(this.dataSource!);

    /* generate workbook and add the worksheet */
    const wb: XLSX.WorkBook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Guerreros');
 
    /* save to file */  
    XLSX.writeFile(wb, fileName);
  }

  tabCampamentos(arg0: number) {
    this.tabsCampas = [false, false];
    this.tabsCampas[arg0] = true;
    this.selectedEventoId = this.events![arg0].id;
    this.selectedEvento = this.events![arg0];
    console.log("Evento seleccionado: ", this.events![arg0]);
    console.log("ID evento seleccionado: ", this.selectedEventoId);
    this.actualizarGraficos();
    this.cargarDatos();
  }

  actualizarGraficos(){
    this.child.refrescar(4);
    this.child.refrescar(5);
    this.child.refrescar(6);
    this.child.refrescar(7);
    this.child.refrescar(8);
    this.child.refrescar(14);
  }

}
