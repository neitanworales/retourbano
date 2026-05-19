import { Component, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
  selector: 'app-campamentos',
  templateUrl: './campamentos.component.html',
  styleUrl: './campamentos.component.css',
  standalone: false
})
export class CampamentosComponent implements OnInit {

  constructor(
    public eventDao: EventDao,
    private formBuilder: FormBuilder) { }

  columnsToDisplay = [
    'acciones',
    'id_event',
    'titulo',
    'fecha_inicio',
    'fecha_termino',
    'activo',
    'maximo_inscr',
    'umbral',
    'fecha_apertura',
    'fecha_maxima',
    'costo'
  ];

  dataSource: Event[] = [];
  eventoActivo = new Event();
  eventoForm!: FormGroup;
  selectedEventId?: number;
  isCreating = false;
  isSaving = false;
  feedbackMessage = '';
  feedbackType: 'success' | 'error' | '' = '';

  ngOnInit(): void {
    this.inicializarForm();
    this.cargarDatos();
  }

  inicializarForm() {
    this.eventoForm = this.formBuilder.group({
      id: [null],
      legacy_event_id: [null],
      organization_id: [null, Validators.required],
      city_id: [null, Validators.required],
      event_year: [new Date().getFullYear(), Validators.required],
      titulo: ["", Validators.required],
      fecha_inicio: ["", Validators.required],
      fecha_termino: ["", Validators.required],
      activo: [1],
      maximo_inscr: ["", Validators.required],
      umbral: ["", Validators.required],
      fecha_maxima: ["", Validators.required],
      fecha_apertura: ["", Validators.required],
      costoMX: ["", Validators.required],
      costoUSD: [""],
      pago_minimoMX: ["", Validators.required],
      banco: ["", Validators.required],
      cuenta: ["", Validators.required],
      clabe: [""],
      titularCuenta: ["", Validators.required],
      contacto1: ["", Validators.required],
      contacto2: ["", Validators.required],
      email_contacto: ["", Validators.required],
      llegada_lugar: ["", Validators.required],
      llegada_coordenadas: ["", Validators.required],
      llegada_nota: [""],
      salida_lugar: ["", Validators.required],
      salida_coordenadas: ["", Validators.required],
      salida_nota: [""],
      notas_costos: [""],
      costos: this.formBuilder.array([])
    });
  }

  get costosFormArray(): FormArray {
    return this.eventoForm.get('costos') as FormArray;
  }

  private createCostoForm(costo?: any): FormGroup {
    const incluyeText = Array.isArray(costo?.incluye)
      ? costo.incluye.join('\n')
      : (typeof costo?.incluye === 'string' ? costo.incluye : '');

    return this.formBuilder.group({
      id: [costo?.id || null],
      descripcion: [costo?.descripcion || '', Validators.required],
      divisa: [costo?.divisa || 'MXN', Validators.required],
      cantidad: [costo?.cantidad ?? 0, Validators.required],
      incluyeText: [incluyeText]
    });
  }

  private setCostos(costos?: any[]): void {
    this.costosFormArray.clear();
    const costosSafe = Array.isArray(costos) ? costos : [];

    if (costosSafe.length === 0) {
      this.costosFormArray.push(this.createCostoForm());
      return;
    }

    costosSafe.forEach((costo) => this.costosFormArray.push(this.createCostoForm(costo)));
  }

  agregarCosto(): void {
    this.costosFormArray.push(this.createCostoForm());
  }

  eliminarCosto(index: number): void {
    if (this.costosFormArray.length <= 1) {
      this.costosFormArray.at(0).patchValue({ descripcion: '', divisa: 'MXN', cantidad: 0, incluyeText: '' });
      return;
    }
    this.costosFormArray.removeAt(index);
  }

  cargarDatos() {
    this.eventDao.getEvents().subscribe(
      response => {
        this.dataSource = response.data?.events || [];

        if (this.dataSource.length > 0) {
          const preferred = this.dataSource.find((evt) => this.getActivo(evt) === 1) || this.dataSource[0];
          this.seleccionarEvento(preferred);
        } else {
          this.nuevoEvento();
        }
      }
    );
  }

  seleccionarEvento(evento: Event): void {
    this.eventoActivo = evento;
    this.selectedEventId = this.getEventId(evento) || undefined;
    this.isCreating = false;
    this.feedbackMessage = '';
    this.feedbackType = '';

    const eventData = evento as any;

    this.eventoForm.patchValue({
      id: this.getEventId(evento),
      legacy_event_id: eventData.legacy_event_id || this.getEventId(evento) || null,
      organization_id: eventData.organization_id || null,
      city_id: eventData.city_id || null,
      event_year: eventData.event_year || this.obtenerYearDesdeFecha(eventData.fecha_inicio ?? eventData.start_at),
      titulo: eventData.titulo ?? eventData.title ?? '',
      fecha_inicio: this.formatearFechaInput(eventData.fecha_inicio ?? eventData.start_at),
      fecha_termino: this.formatearFechaInput(eventData.fecha_termino ?? eventData.end_at),
      activo: this.getActivo(evento),
      maximo_inscr: eventData.maximo_inscr ?? eventData.max_registrations ?? '',
      umbral: eventData.umbral ?? eventData.threshold ?? '',
      fecha_maxima: this.formatearFechaInput(eventData.fecha_maxima ?? eventData.registration_deadline),
      fecha_apertura: this.formatearFechaInput(eventData.fecha_apertura ?? eventData.registration_open_at),
      costoMX: eventData.costoMX ?? eventData.price_mxn ?? '',
      costoUSD: eventData.costoUSD ?? eventData.price_usd ?? '',
      pago_minimoMX: eventData.pago_minimoMX ?? eventData.minimum_payment_mxn ?? '',
      banco: eventData.banco ?? eventData.bank_name ?? '',
      cuenta: eventData.cuenta ?? eventData.bank_account ?? '',
      clabe: eventData.clabe ?? eventData.bank_clabe ?? '',
      titularCuenta: eventData.titularCuenta ?? eventData.account_holder ?? '',
      contacto1: eventData.contacto1 ?? eventData.contact_phone_1 ?? '',
      contacto2: eventData.contacto2 ?? eventData.contact_phone_2 ?? '',
      email_contacto: eventData.email_contacto ?? eventData.contact_email ?? '',
      llegada_lugar: eventData.llegada_lugar ?? eventData.arrival_place ?? '',
      llegada_coordenadas: eventData.llegada_coordenadas ?? eventData.arrival_coordinates ?? '',
      llegada_nota: eventData.llegada_nota ?? eventData.arrival_note ?? '',
      salida_lugar: eventData.salida_lugar ?? eventData.departure_place ?? '',
      salida_coordenadas: eventData.salida_coordenadas ?? eventData.departure_coordinates ?? '',
      salida_nota: eventData.salida_nota ?? eventData.departure_note ?? '',
      notas_costos: eventData.notas_costos ?? eventData.cost_notes ?? ''
    });

    this.setCostos(eventData.costos || []);
  }

  nuevoEvento(): void {
    this.isCreating = true;
    this.selectedEventId = undefined;
    this.feedbackMessage = '';
    this.feedbackType = '';

    const base = this.eventoActivo || new Event();
    const now = new Date();
    this.eventoForm.reset({
      id: null,
      legacy_event_id: null,
      organization_id: (base as any).organization_id || null,
      city_id: (base as any).city_id || null,
      event_year: now.getFullYear(),
      titulo: '',
      fecha_inicio: '',
      fecha_termino: '',
      activo: 1,
      maximo_inscr: base.maximo_inscr || 150,
      umbral: base.umbral || 80,
      fecha_maxima: '',
      fecha_apertura: '',
      costoMX: base.costoMX || '',
      costoUSD: base.costoUSD || '',
      pago_minimoMX: base.pago_minimoMX || '',
      banco: base.banco || '',
      cuenta: base.cuenta || '',
      clabe: (base as any).clabe || '',
      titularCuenta: base.titularCuenta || '',
      contacto1: base.contacto1 || '',
      contacto2: base.contacto2 || '',
      email_contacto: base.email_contacto || '',
      llegada_lugar: base.llegada_lugar || '',
      llegada_coordenadas: base.llegada_coordenadas || '',
      llegada_nota: base.llegada_nota || '',
      salida_lugar: base.salida_lugar || '',
      salida_coordenadas: base.salida_coordenadas || '',
      salida_nota: base.salida_nota || '',
      notas_costos: ''
    });

    this.setCostos([]);
  }

  cancelarEdicion(): void {
    if (this.eventoActivo && this.getEventId(this.eventoActivo)) {
      this.seleccionarEvento(this.eventoActivo);
      return;
    }
    this.nuevoEvento();
  }

  guardarEvento(): void {
    if (this.eventoForm.invalid) {
      this.eventoForm.markAllAsTouched();
      this.feedbackType = 'error';
      this.feedbackMessage = 'Revisa los campos requeridos antes de guardar.';
      return;
    }

    const payload = this.buildPayload();
    this.isSaving = true;
    this.feedbackMessage = '';

    const request$ = payload.id
      ? this.eventDao.updateEvent(payload)
      : this.eventDao.createEvent(payload);

    request$.subscribe({
      next: (response) => {
        this.isSaving = false;
        const eventResponse = response.data?.event;
        this.feedbackType = 'success';
        this.feedbackMessage = payload.id ? 'Campamento actualizado correctamente.' : 'Campamento creado correctamente.';

        if (eventResponse) {
          const eventId = this.getEventId(eventResponse as any);
          const index = this.dataSource.findIndex((item) => this.getEventId(item) === eventId);
          if (index >= 0) {
            this.dataSource[index] = eventResponse as Event;
          } else {
            this.dataSource = [eventResponse as Event, ...this.dataSource];
          }
          this.seleccionarEvento(eventResponse as Event);
        }

        this.cargarDatos();
      },
      error: () => {
        this.isSaving = false;
        this.feedbackType = 'error';
        this.feedbackMessage = 'No fue posible guardar el campamento. Intenta de nuevo.';
      }
    });
  }

  eliminarEvento(evento?: Event): void {
    const target = evento || this.eventoActivo;
    const eventId = this.getEventId(target);
    if (!eventId) {
      return;
    }

    const ok = window.confirm('Esta accion eliminara el campamento y sus costos. Deseas continuar?');
    if (!ok) {
      return;
    }

    this.eventDao.deleteEvent(eventId).subscribe({
      next: () => {
        this.feedbackType = 'success';
        this.feedbackMessage = 'Campamento eliminado correctamente.';
        this.dataSource = this.dataSource.filter((item) => this.getEventId(item) !== eventId);
        if (this.dataSource.length > 0) {
          this.seleccionarEvento(this.dataSource[0]);
        } else {
          this.nuevoEvento();
        }
      },
      error: () => {
        this.feedbackType = 'error';
        this.feedbackMessage = 'No fue posible eliminar el campamento.';
      }
    });
  }

  getEventId(evento: any): number | null {
    const value = evento?.id ?? evento?.id_event ?? evento?.id_campamento;
    if (value === null || value === undefined || value === '') {
      return null;
    }
    return Number(value);
  }

  getActivo(evento: any): number {
    const value = evento?.activo ?? evento?.is_active;
    if (value === true || value === 1 || value === '1') {
      return 1;
    }
    return 0;
  }

  private buildPayload(): any {
    const raw = this.eventoForm.getRawValue();
    const fechaInicio = this.normalizeDateTime(raw.fecha_inicio);
    const fechaTermino = this.normalizeDateTime(raw.fecha_termino);

    return {
      id: raw.id || undefined,
      legacy_event_id: raw.legacy_event_id || undefined,
      organization_id: Number(raw.organization_id),
      city_id: Number(raw.city_id),
      event_year: Number(raw.event_year || this.obtenerYearDesdeDateString(fechaInicio)),
      title: raw.titulo,
      start_at: fechaInicio,
      end_at: fechaTermino,
      is_active: Number(raw.activo) === 1 ? 1 : 0,
      max_registrations: Number(raw.maximo_inscr),
      threshold: Number(raw.umbral),
      registration_open_at: this.normalizeDateTime(raw.fecha_apertura),
      registration_deadline: this.normalizeDateTime(raw.fecha_maxima),
      price_mxn: Number(raw.costoMX),
      price_usd: raw.costoUSD === '' || raw.costoUSD === null ? null : Number(raw.costoUSD),
      minimum_payment_mxn: Number(raw.pago_minimoMX),
      bank_name: raw.banco,
      bank_account: raw.cuenta,
      bank_clabe: raw.clabe,
      account_holder: raw.titularCuenta,
      contact_phone_1: raw.contacto1,
      contact_phone_2: raw.contacto2,
      contact_email: raw.email_contacto,
      arrival_place: raw.llegada_lugar,
      arrival_coordinates: raw.llegada_coordenadas,
      arrival_note: raw.llegada_nota,
      departure_place: raw.salida_lugar,
      departure_coordinates: raw.salida_coordenadas,
      departure_note: raw.salida_nota,
      cost_notes: raw.notas_costos,
      costos: this.costosFormArray.controls
        .map((control) => control.value)
        .filter((costo) => (costo.descripcion || '').trim() !== '')
        .map((costo) => ({
          id: costo.id || undefined,
          descripcion: (costo.descripcion || '').trim(),
          divisa: (costo.divisa || 'MXN').trim().toUpperCase(),
          cantidad: Number(costo.cantidad || 0),
          incluye: this.parseIncluye(costo.incluyeText)
        }))
    };
  }

  private parseIncluye(incluyeText: string): string[] {
    if (!incluyeText) {
      return [];
    }

    return incluyeText
      .split(/\n|,/g)
      .map((item: string) => item.trim())
      .filter((item: string) => item.length > 0);
  }

  private formatearFechaInput(value?: Date | string): string {
    if (!value) {
      return '';
    }

    const date = new Date(value);
    if (Number.isNaN(date.getTime())) {
      return '';
    }

    const localDate = new Date(date.getTime() - (date.getTimezoneOffset() * 60000));
    return localDate.toISOString().slice(0, 16);
  }

  private normalizeDateTime(value: string): string | null {
    if (!value) {
      return null;
    }

    const date = new Date(value);
    if (Number.isNaN(date.getTime())) {
      return null;
    }

    const localDate = new Date(date.getTime() - (date.getTimezoneOffset() * 60000));
    return localDate.toISOString().slice(0, 19).replace('T', ' ');
  }

  private obtenerYearDesdeFecha(value?: Date | string): number | null {
    if (!value) {
      return null;
    }
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) {
      return null;
    }
    return date.getFullYear();
  }

  private obtenerYearDesdeDateString(value?: string | null): number {
    if (!value) {
      return new Date().getFullYear();
    }
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) {
      return new Date().getFullYear();
    }
    return date.getFullYear();
  }
}