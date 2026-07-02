import { Component, inject, OnInit } from '@angular/core';
import { Session } from 'src/app/core/models/login/Session';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { AuthService } from 'src/app/core/services/auth.service';
import { Event } from 'src/app/core/models/registro/Event';
import { Usuario } from 'src/app/core/models/usuario/Usuario';

interface DashboardPayment {
  amount?: number;
  description?: string;
  paid_at?: string | Date;
  created_at?: string | Date;
  payment_method?: string;
}

interface DashboardRegistration {
  id?: number;
  registration_id?: number;
  event_id?: number;
  title?: string;
  event_year?: number;
  city_label?: string;
  start_at?: string | Date;
  is_active?: boolean;
  registration_status?: string;
  price_mxn?: number;
  pagado?: number;
  pagos?: DashboardPayment[];
}

interface EditableDashboardProfile {
  full_name: string;
  display_name: string;
  email: string;
  phone: string;
  whatsapp: string;
  gender: string;
  birth_date: string;
  age: string;
  shirt_size: string;
  coming_from: string;
  church: string;
  guardian_name: string;
  guardian_phone: string;
  guardian_email: string;
  allergies: string;
  medications: string;
}

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
  standalone: false
})
export class DashboardComponent implements OnInit {

  events?: Event[];
  upcomingEvents: Event[] = [];
  activeRegistrationsByEventId: Record<number, DashboardRegistration> = {};
  historicalRegistrations: DashboardRegistration[] = [];
  session!: Session;
  loadingProfile = false;
  profileErrorMessage = '';
  isEditingProfile = false;
  isSavingProfile = false;
  saveProfileMessage = '';
  saveProfileErrorMessage = '';
  editableProfile: EditableDashboardProfile = this.createEmptyEditableProfile();

  private readonly authService = inject(AuthService);

  constructor(private registroDao: RegistroDao) {
    this.session = this.authService.getSession()!;
  }

  ngOnInit(): void {
    this.syncEditableProfileFromSession();
    this.loadDashboardProfile();
    this.validarInscricion();
  }

  loadDashboardProfile(): void {
    if (!this.session?.token) {
      return;
    }

    this.loadingProfile = true;
    this.profileErrorMessage = '';

    this.registroDao.obtenerPerfilCuenta(true).subscribe({
      next: (response) => {
        this.applyProfileToSession(response?.user, response?.roles || []);
        this.activeRegistrationsByEventId = (response?.active_registrations || []).reduce((accumulator: Record<number, DashboardRegistration>, item: any) => {
          const eventId = Number(item?.event_id || item?.id || 0);
          if (eventId > 0) {
            accumulator[eventId] = item as DashboardRegistration;
          }
          return accumulator;
        }, {});
        this.historicalRegistrations = (response?.historical_registrations || []) as DashboardRegistration[];
        this.loadingProfile = false;
      },
      error: () => {
        this.loadingProfile = false;
        this.profileErrorMessage = 'No se pudo cargar la informacion del dashboard.';
        this.activeRegistrationsByEventId = {};
        this.historicalRegistrations = [];
      }
    });
  }

  private validarInscricion() {
    this.registroDao.validarInscripcion(0).subscribe({
      next: result => {
        this.events = result.events;
        this.upcomingEvents = result.events! || [];
      },
      error: () => {
        this.upcomingEvents = [];
      }
    });
  }

  getCurrentRegistration(eventId?: number): DashboardRegistration | null {
    if (!eventId) {
      return null;
    }

    return this.activeRegistrationsByEventId[eventId] || null;
  }

  isRegisteredForEvent(event: Event): boolean {
    return !!event?.id && !!this.getCurrentRegistration(event.id);
  }

  getCurrentEventStatus(event: Event): string {
    return this.isRegisteredForEvent(event) ? 'Ya estas inscrito' : 'Inscripciones abiertas';
  }

  getCurrentEventStatusClass(event: Event): string {
    return this.isRegisteredForEvent(event)
      ? 'dashboard-status-pill dashboard-status-pill-success'
      : 'dashboard-status-pill dashboard-status-pill-info';
  }

  getEventDateLabel(event: Event): string {
    if (!event?.start_at) {
      return 'Fecha por definir';
    }

    const date = new Date(String(event.start_at));
    if (Number.isNaN(date.getTime())) {
      return String(event.start_at);
    }

    return new Intl.DateTimeFormat('es-MX', {
      day: '2-digit',
      month: 'long',
      year: 'numeric'
    }).format(date);
  }

  getCurrentEventPaidAmount(event: Event): number {
    const registration = this.getCurrentRegistration(event?.id);
    if (!registration) {
      return 0;
    }

    if (typeof registration.pagado === 'number') {
      return registration.pagado;
    }

    return (registration.pagos || []).reduce((total, payment) => total + Number(payment?.amount || 0), 0);
  }

  getCurrentEventPendingAmount(event: Event): number {
    const registration = this.getCurrentRegistration(event?.id);
    if (!registration) {
      return 0;
    }

    const targetAmount = Number(registration.price_mxn || event.price_mxn || 0);
    if (!targetAmount) {
      return 0;
    }

    return Math.max(targetAmount - this.getCurrentEventPaidAmount(event), 0);
  }

  getCurrentEventPayments(event: Event): DashboardPayment[] {
    return this.getCurrentRegistration(event?.id)?.pagos || [];
  }

  getPaymentDateLabel(payment: DashboardPayment): string {
    const rawDate = payment?.paid_at || payment?.created_at;
    if (!rawDate) {
      return 'Sin fecha';
    }

    const date = new Date(String(rawDate));
    if (Number.isNaN(date.getTime())) {
      return String(rawDate);
    }

    return new Intl.DateTimeFormat('es-MX', {
      day: '2-digit',
      month: 'short',
      year: 'numeric'
    }).format(date);
  }

  inscribirEvento(event_id: number) {
  }

  startEditingProfile(): void {
    this.isEditingProfile = true;
    this.saveProfileMessage = '';
    this.saveProfileErrorMessage = '';
    this.syncEditableProfileFromSession();
  }

  cancelEditingProfile(): void {
    this.isEditingProfile = false;
    this.saveProfileErrorMessage = '';
    this.syncEditableProfileFromSession();
  }

  saveProfile(): void {
    this.isSavingProfile = true;
    this.saveProfileMessage = '';
    this.saveProfileErrorMessage = '';

    this.registroDao.actualizarPerfilCuenta({
      full_name: this.normalizeEditableValue(this.editableProfile.full_name),
      display_name: this.normalizeEditableValue(this.editableProfile.display_name),
      email: this.normalizeEditableValue(this.editableProfile.email),
      phone: this.normalizeEditableValue(this.editableProfile.phone),
      whatsapp: this.normalizeEditableValue(this.editableProfile.whatsapp),
      gender: this.normalizeEditableValue(this.editableProfile.gender),
      birth_date: this.normalizeEditableValue(this.editableProfile.birth_date),
      age: this.normalizeEditableNumber(this.editableProfile.age),
      shirt_size: this.normalizeEditableValue(this.editableProfile.shirt_size),
      coming_from: this.normalizeEditableValue(this.editableProfile.coming_from),
      church: this.normalizeEditableValue(this.editableProfile.church),
      guardian_name: this.normalizeEditableValue(this.editableProfile.guardian_name),
      guardian_phone: this.normalizeEditableValue(this.editableProfile.guardian_phone),
      guardian_email: this.normalizeEditableValue(this.editableProfile.guardian_email),
      allergies: this.normalizeEditableValue(this.editableProfile.allergies),
      medications: this.normalizeEditableValue(this.editableProfile.medications),
    }).subscribe({
      next: (response) => {
        this.applyProfileToSession(response?.user, response?.roles || []);
        this.isEditingProfile = false;
        this.isSavingProfile = false;
        this.saveProfileMessage = 'Perfil actualizado correctamente.';
      },
      error: () => {
        this.isSavingProfile = false;
        this.saveProfileErrorMessage = 'No se pudo guardar la informacion del perfil.';
      }
    });
  }

  getProfileName(): string {
    return String(
      this.session.guerrero?.display_name
      || this.session.guerrero?.full_name
      || this.session.guerrero?.nombre
      || this.session.usuario?.display_name
      || this.session.usuario?.full_name
      || this.session.usuario?.nombre
      || 'Mi dashboard'
    );
  }

  getPrimaryEmail(): string {
    return String(this.session.guerrero?.email || this.session.usuario?.email || 'Sin correo registrado');
  }

  getPhone(): string {
    return String(this.session.guerrero?.phone || this.session.guerrero?.telefono || this.session.usuario?.phone || this.session.usuario?.telefono || 'Sin telefono');
  }

  getBirthDate(): string {
    const rawDate = this.session.guerrero?.birth_date || this.session.guerrero?.fechaNac || this.session.usuario?.birth_date || this.session.usuario?.fechaNac;

    if (!rawDate) {
      return 'No registrada';
    }

    const date = new Date(rawDate as string | Date);
    if (Number.isNaN(date.getTime())) {
      return String(rawDate);
    }

    return new Intl.DateTimeFormat('es-MX', {
      day: '2-digit',
      month: 'long',
      year: 'numeric'
    }).format(date);
  }

  getAge(): string {
    const age = this.session.guerrero?.age || this.session.guerrero?.edad || this.session.usuario?.age || this.session.usuario?.edad;
    return age ? `${age} anios` : 'Sin dato';
  }

  getGender(): string {
    return String(this.session.guerrero?.gender || this.session.guerrero?.sexo || this.session.usuario?.gender || this.session.usuario?.sexo || 'Sin especificar');
  }

  getShirtSize(): string {
    return String(this.session.guerrero?.shirt_size || this.session.guerrero?.talla || this.session.usuario?.shirt_size || this.session.usuario?.talla || 'Sin dato');
  }

  getChurch(): string {
    return String(this.session.guerrero?.church || this.session.guerrero?.iglesia || this.session.usuario?.church || this.session.usuario?.iglesia || 'Sin dato');
  }

  getOrigin(): string {
    return String(this.session.guerrero?.coming_from || this.session.guerrero?.vienesDe || this.session.usuario?.coming_from || this.session.usuario?.vienesDe || 'Sin dato');
  }

  getGuardianName(): string {
    return String(this.session.guerrero?.guardian_name || this.session.guerrero?.tutorNombre || this.session.usuario?.guardian_name || this.session.usuario?.tutorNombre || 'Sin dato');
  }

  getGuardianPhone(): string {
    return String(this.session.guerrero?.guardian_phone || this.session.guerrero?.tutorTelefono || this.session.usuario?.guardian_phone || this.session.usuario?.tutorTelefono || 'Sin dato');
  }

  getGuardianEmail(): string {
    return String(this.session.guerrero?.guardian_email || this.session.guerrero?.emailTutor || this.session.usuario?.guardian_email || this.session.usuario?.emailTutor || 'Sin dato');
  }

  getMedicalNotes(): string {
    return String(this.session.guerrero?.medications || this.session.guerrero?.medicamentos || this.session.usuario?.medications || this.session.usuario?.medicamentos || 'Sin observaciones registradas');
  }

  getAllergies(): string {
    return String(this.session.guerrero?.allergies || this.session.guerrero?.alergias || this.session.usuario?.allergies || this.session.usuario?.alergias || 'Sin alergias registradas');
  }

  getAcceptedPoliciesLabel(): string {
    const acceptedPolicies = this.session.guerrero?.accepted_policies || this.session.guerrero?.aceptaPoliticas || this.session.usuario?.accepted_policies || this.session.usuario?.aceptaPoliticas;
    return acceptedPolicies ? 'Politicas aceptadas' : 'Politicas pendientes';
  }

  getRegisteredAt(): string {
    const rawDate = this.session.guerrero?.registered_at || this.session.usuario?.registered_at;

    if (!rawDate) {
      return 'Sin fecha de registro';
    }

    const date = new Date(String(rawDate));
    if (Number.isNaN(date.getTime())) {
      return String(rawDate);
    }

    return new Intl.DateTimeFormat('es-MX', {
      day: '2-digit',
      month: 'short',
      year: 'numeric'
    }).format(date);
  }

  getRoles(): string[] {
    return (this.session.roles || [])
      .map((role) => String(role || '').trim())
      .filter((role) => role.length > 0);
  }

  getHistoricalRegistrationCount(): number {
    return this.historicalRegistrations.length;
  }

  getActiveRegistrationCount(): number {
    return Object.keys(this.activeRegistrationsByEventId).length;
  }

  getHistoricalRegistrations(): DashboardRegistration[] {
    return this.historicalRegistrations;
  }

  getEventLabel(registration: DashboardRegistration): string {
    const title = registration?.title || 'Evento sin nombre';
    const year = registration?.event_year ? ` ${registration.event_year}` : '';
    return `${title}${year}`.trim();
  }

  getEventMeta(registration: DashboardRegistration): string {
    const chunks: string[] = [];

    if (registration?.start_at) {
      const date = new Date(String(registration.start_at));
      if (!Number.isNaN(date.getTime())) {
        chunks.push(new Intl.DateTimeFormat('es-MX', {
          day: '2-digit',
          month: 'short',
          year: 'numeric'
        }).format(date));
      }
    }

    if (registration?.city_label) {
      chunks.push(registration.city_label);
    }

    return chunks.join(' · ') || 'Sin detalles';
  }

  getRegistrationStatusLabel(status?: string): string {
    switch ((status || '').toUpperCase()) {
      case 'A':
        return 'Activo';
      case 'B':
        return 'Baja';
      case 'C':
        return 'Cancelado';
      case 'P':
        return 'Pendiente';
      default:
        return status || 'Sin estado';
    }
  }

  getRegistrationStatusClass(registration: DashboardRegistration): string {
    if (registration?.is_active) {
      return 'status-badge status-badge-active';
    }

    if ((registration?.registration_status || '').toUpperCase() === 'B') {
      return 'status-badge status-badge-inactive';
    }

    return 'status-badge status-badge-neutral';
  }

  trackRegistration(index: number, registration: DashboardRegistration): number | string {
    return registration?.registration_id || registration?.id || index;
  }

  getInitials(): string {
    const parts = this.getProfileName()
      .split(' ')
      .map((part) => part.trim())
      .filter((part) => part.length > 0)
      .slice(0, 2);

    return parts.map((part) => part.charAt(0).toUpperCase()).join('') || 'RU';
  }

  private applyProfileToSession(rawProfile: Usuario | undefined, roles: Session['roles']): void {
    const profile = Object.assign(new Usuario(), rawProfile || {});
    const updatedSession: Session = {
      ...this.session,
      id: profile.id || this.session.id,
      usuario: profile,
      guerrero: profile,
      roles: roles.length ? roles : (this.session.roles || []),
    };

    this.session = updatedSession;
    this.authService.setSession(updatedSession);
    this.syncEditableProfileFromSession();
  }

  private syncEditableProfileFromSession(): void {
    const current = (this.session?.guerrero || this.session?.usuario || {}) as Usuario;

    this.editableProfile = {
      full_name: String(current.full_name || current.nombre || ''),
      display_name: String(current.display_name || current.nick || ''),
      email: String(current.email || ''),
      phone: String(current.phone || current.telefono || ''),
      whatsapp: String(current.whatsapp || ''),
      gender: String(current.gender || current.sexo || ''),
      birth_date: String(current.birth_date || current.fechaNac || ''),
      age: current.age !== undefined && current.age !== null ? String(current.age) : String(current.edad || ''),
      shirt_size: String(current.shirt_size || current.talla || ''),
      coming_from: String(current.coming_from || current.vienesDe || ''),
      church: String(current.church || current.iglesia || ''),
      guardian_name: String(current.guardian_name || current.tutorNombre || ''),
      guardian_phone: String(current.guardian_phone || current.tutorTelefono || ''),
      guardian_email: String(current.guardian_email || current.emailTutor || ''),
      allergies: String(current.allergies || current.alergias || ''),
      medications: String(current.medications || current.medicamentos || ''),
    };
  }

  private createEmptyEditableProfile(): EditableDashboardProfile {
    return {
      full_name: '',
      display_name: '',
      email: '',
      phone: '',
      whatsapp: '',
      gender: '',
      birth_date: '',
      age: '',
      shirt_size: '',
      coming_from: '',
      church: '',
      guardian_name: '',
      guardian_phone: '',
      guardian_email: '',
      allergies: '',
      medications: '',
    };
  }

  private normalizeEditableValue(value: string): string {
    return String(value || '').trim();
  }

  private normalizeEditableNumber(value: string): number | null {
    const normalized = String(value || '').trim();
    if (!normalized) {
      return null;
    }

    const parsed = Number(normalized);
    return Number.isFinite(parsed) ? parsed : null;
  }

}
