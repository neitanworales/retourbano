import { Component, OnInit } from '@angular/core';
import { DatePipe } from '@angular/common';
import { animate, state, style, transition, trigger } from '@angular/animations';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { EventRegistration } from 'src/app/core/models/registro/EventRegistration';
import { Pago } from 'src/app/core/models/registro/Pago';
import * as XLSX from 'xlsx';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { Event } from 'src/app/core/models/registro/Event';
import { AuthService } from 'src/app/core/services/auth.service';

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

  readonly legacyFullPaymentAmount = 1950;
  
  readonly sortOptions = [
    { value: '', label: 'Ordenar por' },
    { value: 'nombre', label: 'Nombre' },
    { value: 'edad', label: 'Edad' },
    { value: 'sexo', label: 'Sexo' },
    { value: 'talla', label: 'Talla' },
    { value: 'pagado', label: 'Pagado' },
  ];

  tabsCampas?: boolean[] = [false, false];
  events?: Event[]
  selectedEventoId?: number;
  selectedEvento?: Event;

  pageResumenActive = true;
  pageInscritosActive = false;
  pageStaffActive = false;
  pageAdminsActive = false;
  pageBajasActive = false;
  pageSeguimientoActive = false;
  pageHospedajeActive = false;
  pageContabilidadActive = false;

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
  appliedSearchByName = '';
  selectedGender = '';
  shirtSizeFilter = '';
  ageMin?: number | null = null;
  ageMax?: number | null = null;
  confirmedFilter = '';
  attendanceFilter = '';
  followupFilter = '';
  lodgingFilter = '';
  paidFilter = '';
  sortBy = '';
  sortDirection: 'asc' | 'desc' = 'asc';
  private loadedRegistrations: EventRegistration[] = [];
  years = [
    2015, 2016, 2017, 2018, 2019, 2021, 2022, 2023
  ];

  constructor(
    public registroDao: RegistroDao,
    private datePipe: DatePipe,
    private eventDao: EventDao,
    private authService: AuthService) { }

  ngOnInit(): void {
    this.cargarDatos();
    this.loadCampamentos();
  }

  loadCampamentos() {
    this.eventDao.getEventActivo('FULL').subscribe({
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
    this.pageHospedajeActive = false;
    this.pageContabilidadActive = false;
    this.cargarDatos();
  }

  activarPageInscritos() {
    this.pageResumenActive = false;
    this.pageInscritosActive = true;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = false;
    this.pageHospedajeActive = false;
    this.pageContabilidadActive = false;
    this.cargarDatos();
  }

  activarPageStaff() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = true;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = false;
    this.pageHospedajeActive = false;
    this.pageContabilidadActive = false;
    this.cargarDatos();
  }

  activarPageBajas() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = true;
    this.pageSeguimientoActive = false;
    this.pageHospedajeActive = false;
    this.pageContabilidadActive = false;
    this.cargarDatos();
  }

  activarPageSeguimiento() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = true;
    this.pageHospedajeActive = false;
    this.pageContabilidadActive = false;
    this.cargarDatos();
  }

  activarPageHistorico() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = false;
    this.pageHospedajeActive = false;
    this.pageContabilidadActive = false;
    this.cargarDatos();
  }

  activarPageHospedaje() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = false;
    this.pageHospedajeActive = true;
    this.pageContabilidadActive = false;
    this.cargarDatos();
  }

  activarPageContabilidad() {
    this.pageResumenActive = false;
    this.pageInscritosActive = false;
    this.pageStaffActive = false;
    this.pageAdminsActive = false;
    this.pageBajasActive = false;
    this.pageSeguimientoActive = false;
    this.pageHospedajeActive = false;
    this.pageContabilidadActive = true;
    this.cargarDatos();
  }

  cargarDatos() {

    let opcion: number = 0;
    let activo: boolean = false;
    let staff: boolean = false;
    let seg: boolean = false;

    if (this.pageResumenActive) {
      this.loadedRegistrations = [];
      this.dataSource = [];
      this.displayStyle = "none";
      this.chartsDisplayStyle = "";
    } else if (this.pageHospedajeActive) {
      this.loadedRegistrations = [];
      this.displayStyle = "none";
      this.chartsDisplayStyle = "none";
    } else if (this.pageContabilidadActive) {
      this.loadedRegistrations = [];
      this.displayStyle = "none";
      this.chartsDisplayStyle = "none";
    } else {
      this.chartsDisplayStyle = "none";
      this.displayStyle = "";

      if (this.pageInscritosActive) {
        opcion = 1;
        activo = true;
        staff = false;
        seg = false;
      }

      if (this.pageStaffActive) {
        opcion = 1;
        activo = true;
        staff = true;
        seg = false;
      }

      if (this.pageAdminsActive) {
        opcion = 1;
        activo = true;
        staff = true;
        seg = false;
      }

      if (this.pageBajasActive) {
        opcion = 1;
        activo = false;
        staff = false;
        seg = false;
      }

      if (this.pageSeguimientoActive) {
        opcion = 1;
        activo = true;
        seg = true;
      }

      this.registroDao.consultarInscritos(
        opcion,
        activo,
        staff,
        this.searchByName!,
        seg,
        this.selectedEventoId,
        {
          gender: this.selectedGender,
          shirtSize: this.shirtSizeFilter,
          ageMin: this.ageMin,
          ageMax: this.ageMax,
          isConfirmed: this.confirmedFilter,
          attendanceConfirmed: this.attendanceFilter,
          isFollowup: this.followupFilter,
          requiresLodging: this.lodgingFilter,
        }
      ).subscribe(
        respuesta => {
          this.loadedRegistrations = respuesta.data?.registrations || [];
          this.applyLoadedData();
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

  actualizarStatus(isActive: boolean, registrationId: number, eventRegistration: EventRegistration) {
    this.registroDao.actualizarStatus(isActive, registrationId).subscribe(
      result => {
        if (!result.error) {

          if(!isActive){
            this.registroDao.actualizarEventRol(eventRegistration.user!.id!, this.selectedEventoId!, false, false).subscribe(
              result => {
                if (!result.error) {
                  this.cargarDatos();
                }
              }
            );
          } else {
            this.cargarDatos();
          }
        }
      }
    );
  }

  agregarPago(element: EventRegistration) {
    if (element.pagos == null) {
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
          reg.is_confirmed = confirma;
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
          reg.attendance_confirmed = asiste;
        }
      }
    );
  }

  enviarConfirmarEmail(reg: EventRegistration) {
    this.registroDao.enviarConfirmarEmail(reg.id!).subscribe(
      result => {
        if (result.error) {
          console.log("erro al guardar el pago");
        } else {
          reg.email_confirmed = this.extractConfirmationEmailCount(reg, result);
        }
      }
    );
  }

  search() {
    this.appliedSearchByName = (this.searchByName || '').trim();
    this.cargarDatos();
  }

  applySorting() {
    this.applyLoadedData();
  }

  cargarTodos() {
    this.searchByName = "";
    this.appliedSearchByName = '';
    this.selectedGender = '';
    this.shirtSizeFilter = '';
    this.ageMin = null;
    this.ageMax = null;
    this.confirmedFilter = '';
    this.attendanceFilter = '';
    this.followupFilter = '';
    this.lodgingFilter = '';
    this.paidFilter = '';
    this.sortBy = '';
    this.sortDirection = 'asc';
    this.cargarDatos();
  }

  getHighlightedName(name?: string | null): string {
    const displayName = name || '';
    const searchTerm = this.appliedSearchByName;

    if (!displayName) {
      return '';
    }

    if (!searchTerm) {
      return this.escapeHtml(displayName);
    }

    const escapedName = this.escapeHtml(displayName);
    const matcher = new RegExp(`(${this.escapeRegExp(searchTerm)})`, 'ig');

    return escapedName.replace(matcher, '<span class="search-highlight">$1</span>');
  }

  private escapeHtml(value: string): string {
    return value
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  private escapeRegExp(value: string): string {
    return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  private applyLoadedData() {
    const filtered = this.applyPaidFilter(this.loadedRegistrations);
    this.dataSource = this.sortRegistrations(filtered);
  }

  isRegistrationPaid(registration: EventRegistration): boolean {
    return Number(registration.pagado || 0) >= this.getRequiredPaymentAmount(registration);
  }

  getRequiredPaymentAmount(registration: EventRegistration): number {
    const eventCosts = (this.selectedEvento?.costos || [])
      .filter((costo) => this.isMxnCost(costo))
      .map((costo) => ({ ...costo, cantidad: Number(costo.cantidad || 0) }))
      .filter((costo) => Number.isFinite(costo.cantidad) && costo.cantidad > 0);

    if (eventCosts.length === 0) {
      const fallbackPrice = Number(this.selectedEvento?.price_mxn);
      if (Number.isFinite(fallbackPrice) && fallbackPrice > 0) {
        return fallbackPrice;
      }

      return this.legacyFullPaymentAmount;
    }

    if (eventCosts.length === 1) {
      return eventCosts[0].cantidad;
    }

    const requiresLodging = registration.requires_lodging === true;
    const matchedCost = requiresLodging
      ? eventCosts.find((costo) => this.isLodgingIncludedCost(costo))
      : eventCosts.find((costo) => this.isNoLodgingCost(costo));

    if (matchedCost) {
      return matchedCost.cantidad;
    }

    const sortedAmounts = eventCosts
      .map((costo) => costo.cantidad)
      .sort((left, right) => left - right);

    return requiresLodging
      ? sortedAmounts[sortedAmounts.length - 1]
      : sortedAmounts[0];
  }

  private applyPaidFilter(registrations: EventRegistration[]): EventRegistration[] {
    if (!this.paidFilter) {
      return [...registrations];
    }

    return registrations.filter((registration) => {
      const totalPaid = Number(registration.pagado || 0);
      const requiredAmount = this.getRequiredPaymentAmount(registration);

      if (this.paidFilter === 'paid') {
        return totalPaid >= requiredAmount;
      }

      if (this.paidFilter === 'pending') {
        return totalPaid < requiredAmount;
      }

      return true;
    });
  }

  private isMxnCost(costo: { divisa?: string }): boolean {
    const currency = String(costo.divisa || 'MXN').trim().toUpperCase();
    return currency === 'MXN';
  }

  private isLodgingIncludedCost(costo: { descripcion?: string; incluye?: string[] }): boolean {
    const normalizedDescription = this.normalizeCostText(costo.descripcion);
    const includesHospedaje = (costo.incluye || []).some((item) => this.normalizeCostText(item).includes('hospedaje'));

    return normalizedDescription.includes('con hospedaje')
      || normalizedDescription.includes('todo incluido')
      || includesHospedaje;
  }

  private isNoLodgingCost(costo: { descripcion?: string; incluye?: string[] }): boolean {
    const normalizedDescription = this.normalizeCostText(costo.descripcion);
    const includesHospedaje = (costo.incluye || []).some((item) => this.normalizeCostText(item).includes('hospedaje'));

    return normalizedDescription.includes('sin hospedaje')
      || normalizedDescription.includes('hospedaje aparte')
      || normalizedDescription.includes('sin alojamiento')
      || !includesHospedaje;
  }

  private normalizeCostText(value?: string): string {
    return String(value || '')
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .toLowerCase()
      .trim();
  }

  private sortRegistrations(registrations: EventRegistration[]): EventRegistration[] {
    if (!this.sortBy) {
      return [...registrations];
    }

    const direction = this.sortDirection === 'desc' ? -1 : 1;

    return [...registrations].sort((left, right) => {
      const leftValue = this.getSortableValue(left, this.sortBy);
      const rightValue = this.getSortableValue(right, this.sortBy);

      if (leftValue < rightValue) {
        return -1 * direction;
      }

      if (leftValue > rightValue) {
        return 1 * direction;
      }

      return 0;
    });
  }

  private getSortableValue(registration: EventRegistration, field: string): number | string {
    switch (field) {
      case 'edad':
        return Number(registration.user?.edad || 0);
      case 'pagado':
        return Number(registration.pagado || 0);
      case 'sexo':
        return String(registration.user?.sexo || '').toLowerCase();
      case 'talla':
        return String(registration.user?.talla || '').toLowerCase();
      case 'nombre':
      default:
        return String(registration.user?.nombre || '').toLowerCase();
    }
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

  exportToExcel() {
    let myDate = new Date();
    let dateString = this.datePipe.transform(myDate, 'YYYY_MM_dd_HHmmss');
    let fileName = 'INSCRIPCIONES-RETO-URBANO-' + this.year + '_' + dateString + '.xlsx';
    /* pass here the table id */
    //let element = document.getElementById('excel-table');
    //const ws: XLSX.WorkSheet =XLSX.utils.table_to_sheet(element);

    const excelData = (this.dataSource || []).map((registro) => ({
      id: registro.id,
      numero: registro.numero,
      event_id: registro.event_id,
      user_id: registro.user_id,
      nombre: registro.user?.nombre || registro.user?.full_name,
      nick: registro.user?.nick || registro.user?.display_name,
      edad: registro.user?.edad || registro.user?.age,
      sexo: registro.user?.sexo || registro.user?.gender,
      talla: registro.user?.talla || registro.user?.shirt_size,
      email: registro.user?.email,
      telefono: registro.user?.telefono || registro.user?.phone,
      iglesia: registro.user?.iglesia || registro.user?.church,
      vienesDe: registro.user?.vienesDe || registro.user?.coming_from,
      alergias: registro.user?.alergias || registro.user?.allergies,
      medicamentos: registro.user?.medicamentos || registro.user?.medications,
      tutorNombre: registro.user?.tutorNombre || registro.user?.guardian_name,
      tutorTelefono: registro.user?.tutorTelefono || registro.user?.guardian_phone,
      confirmado: registro.is_confirmed ?? registro.is_confirmed,
      asistencia: registro.attendance_confirmed ?? registro.attendance_confirmed,
      staff: registro.is_staff ?? registro.is_staff,
      admin: registro.is_admin ?? registro.is_admin,
      seguimiento: registro.is_followup ?? registro.is_followup,
      emailEnviado: registro.welcome_email_sent ?? registro.welcome_email_sent,
      emailConfirmado: registro.email_confirmed ?? 0,
      hospedaje: registro.requires_lodging ?? registro.requires_lodging,
      habitacion: registro.room_code,
      statusRegistro: registro.registration_status,
      razones: registro.reasons || registro.razones,
      pagado: registro.pagado,
    }));

    const ws: XLSX.WorkSheet = XLSX.utils.json_to_sheet(excelData);

    /* generate workbook and add the worksheet */
    const wb: XLSX.WorkBook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Guerreros');

    const actorUserId = this.authService.getSessionValida()?.id;
    this.registroDao.registrarActividadStaff({
      action: 'exports.inscriptions_excel',
      summary: 'Exportacion de inscripciones a Excel',
      affected_user_id: actorUserId,
      entity_type: 'report',
      related_event_id: this.selectedEventoId,
      metadata: {
        file_name: fileName,
        rows: excelData.length,
        year: this.year,
        event_title: this.selectedEvento?.titulo || this.selectedEvento?.title || null,
      }
    }).subscribe({ error: () => undefined });

    /* save to file */
    XLSX.writeFile(wb, fileName);
  }

  isAdminRegistration(registration: EventRegistration): boolean {
    return registration.is_admin === true || registration.roles?.includes('admin') === true;
  }

  tabCampamentos(arg0: number) {
    this.tabsCampas = [false, false];
    this.tabsCampas[arg0] = true;
    this.selectedEventoId = this.events![arg0].id;
    this.selectedEvento = this.events![arg0];
    console.log("Evento seleccionado: ", this.events![arg0]);
    console.log("ID evento seleccionado: ", this.selectedEventoId);
    this.cargarDatos();
  }

  confirmarAsistencia(reg: EventRegistration) {
    this.confirmar(reg, !reg.is_confirmed);
  }

  enviarWelcomeEmail(reg: EventRegistration) {
    this.registroDao.reenviarWelcomeEmail(reg.id!).subscribe(
      result => {
        if (result.error) {
          console.log('error al enviar el welcome email');
        } else {
          reg.welcome_email_sent = this.extractSentEmailCount(reg, result);
        }
      }
    );
  }

  getSentEmailCount(reg?: EventRegistration): number {
    const parsed = Number(reg?.welcome_email_sent ?? 0);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
  }

  getSentEmailCountConfirmacion(reg?: EventRegistration): number {
    const parsed = Number(reg?.email_confirmed ?? 0);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
  }

  hasSentEmails(reg?: EventRegistration): boolean {
    return this.getSentEmailCount(reg) > 0;
  }

  getEmailButtonClass(reg?: EventRegistration): string {
    return this.hasSentEmails(reg) ? 'primary' : 'purple';
  }

  hasSentEmailsConfirmacion(reg?: EventRegistration): boolean {
    return this.getSentEmailCountConfirmacion(reg) > 0;
  }

  getEmailButtonClassConfirmacion(reg?: EventRegistration): string {
    return this.hasSentEmailsConfirmacion(reg) ? 'primary' : 'purple';
  }

  private extractSentEmailCount(reg: EventRegistration, result: any): number {
    const sentCount = Number(result?.data?.welcome_email_sent);
    if (Number.isFinite(sentCount) && sentCount >= 0) {
      return sentCount;
    }

    return this.getSentEmailCount(reg) + 1;
  }

  private extractConfirmationEmailCount(reg: EventRegistration, result: any): number {
    const sentCount = Number(result?.data?.email_confirmed ?? result?.data?.confirmation_email_sent);
    if (Number.isFinite(sentCount) && sentCount >= 0) {
      return sentCount;
    }

    return this.getSentEmailCountConfirmacion(reg) + 1;
  }

  private registrarImpresion(action: 'prints.registration_sheet' | 'prints.name_badge', summary: string, reg: EventRegistration): void {
    const actorUserId = this.authService.getSessionValida()?.id;
    this.registroDao.registrarActividadStaff({
      action,
      summary,
      affected_user_id: actorUserId,
      entity_type: 'report',
      entity_id: reg.id,
      related_event_id: this.selectedEventoId,
      related_registration_id: reg.id,
      metadata: {
        registration_id: reg.id,
        user_id: reg.user?.id || reg.user_id || null,
        full_name: reg.user?.nombre || reg.user?.full_name || null,
        nick: reg.user?.nick || reg.user?.display_name || null,
        room_code: reg.room_code || null,
      }
    }).subscribe({ error: () => undefined });
  }

  imprimirPDF(reg: EventRegistration) {
    const printWindow = window.open('', '_blank', 'width=900,height=1200');
    if (!printWindow) {
      return;
    }

    this.registrarImpresion('prints.registration_sheet', 'Impresion de ficha de inscripcion', reg);

    const fullName = reg.user?.nombre || reg.user?.full_name || 'Sin nombre';
    const nick = reg.user?.nick || reg.user?.display_name || '';
    const rows = [
      ['Nombre', fullName],
      ['Gafete', nick],
      ['Edad', reg.user?.edad || reg.user?.age || ''],
      ['Sexo', reg.user?.sexo || reg.user?.gender || ''],
      ['Talla', reg.user?.talla || reg.user?.shirt_size || ''],
      ['Email', reg.user?.email || ''],
      ['Teléfono', reg.user?.telefono || reg.user?.phone || ''],
      ['Iglesia', reg.user?.iglesia || reg.user?.church || ''],
      ['Procedencia', reg.user?.vienesDe || reg.user?.coming_from || ''],
      ['Alergias', reg.user?.alergias || reg.user?.allergies || ''],
      ['Medicamentos', reg.user?.medicamentos || reg.user?.medications || ''],
      ['Tutor', reg.user?.tutorNombre || reg.user?.guardian_name || ''],
      ['Teléfono tutor', reg.user?.tutorTelefono || reg.user?.guardian_phone || ''],
      ['Hospedaje', reg.requires_lodging ? 'Sí' : 'No'],
      ['Habitación', reg.room_code || ''],
      ['Razones', reg.reasons || reg.razones || ''],
      ['Pagado', `$${reg.pagado || 0}`],
    ];

    const tableRows = rows.map(([label, value]) => `<tr><th>${label}</th><td>${value ?? ''}</td></tr>`).join('');
    printWindow.document.write(`
      <html>
        <head>
          <title>Ficha de inscripción</title>
          <style>
            body { font-family: Arial, sans-serif; padding: 24px; color: #222; }
            h1, h2 { margin: 0 0 12px; }
            table { width: 100%; border-collapse: collapse; margin-top: 20px; }
            th, td { border: 1px solid #d0d0d0; padding: 10px; text-align: left; vertical-align: top; }
            th { width: 220px; background: #f3f3f3; }
          </style>
        </head>
        <body>
          <h1>Reto Urbano ${this.year}</h1>
          <h2>${fullName}</h2>
          <table>${tableRows}</table>
        </body>
      </html>
    `);
    printWindow.document.close();
    printWindow.focus();
    printWindow.print();
  }

  imprimirGafete(reg: EventRegistration) {
    const printWindow = window.open('', '_blank', 'width=600,height=400');
    if (!printWindow) {
      return;
    }

    this.registrarImpresion('prints.name_badge', 'Impresion de gafete', reg);

    const fullName = reg.user?.nombre || reg.user?.full_name || 'Sin nombre';
    const nick = reg.user?.nick || reg.user?.display_name || '';
    const room = reg.room_code || '';

    printWindow.document.write(`
      <html>
        <head>
          <title>Gafete</title>
          <style>
            body { font-family: Arial, sans-serif; margin: 0; padding: 24px; }
            .badge { width: 320px; border: 3px solid #222; border-radius: 16px; padding: 24px; text-align: center; }
            .event { font-size: 18px; font-weight: 700; margin-bottom: 16px; }
            .nick { font-size: 36px; font-weight: 700; margin-bottom: 8px; }
            .name { font-size: 20px; margin-bottom: 10px; }
            .room { font-size: 16px; color: #555; }
          </style>
        </head>
        <body>
          <div class="badge">
            <div class="event">Reto Urbano ${this.year}</div>
            <div class="nick">${nick}</div>
            <div class="name">${fullName}</div>
            <div class="room">${room ? `Habitación: ${room}` : ''}</div>
          </div>
        </body>
      </html>
    `);
    printWindow.document.close();
    printWindow.focus();
    printWindow.print();
  }

  borrarDefinitivamente(reg: EventRegistration) {
    if (!reg.id || !window.confirm('Esta acción borrará definitivamente la inscripción y sus pagos. ¿Deseas continuar?')) {
      return;
    }

    this.registroDao.borrarRegistro(reg.id).subscribe(
      result => {
        if (result.error) {
          console.log('error al borrar la inscripción');
        } else {
          this.expandedGuerrero = undefined;
          this.dataSource = (this.dataSource || []).filter((item) => item.id !== reg.id);
        }
      }
    );
  }

}
