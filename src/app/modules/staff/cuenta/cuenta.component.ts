import { Component, inject, OnInit } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { Session } from 'src/app/core/models/login/Session';
import { Usuario } from 'src/app/core/models/usuario/Usuario';
import { AuthService } from 'src/app/core/services/auth.service';

interface AccountMovement {
  title: string;
  detail: string;
  dateLabel: string;
}

interface AccountMovementApi {
  action?: string;
  old_value?: string;
  new_value?: string;
  created_at?: string;
}

@Component({
  selector: 'app-cuenta',
  templateUrl: './cuenta.component.html',
  styleUrls: ['./cuenta.component.css'],
  standalone: false
})
export class CuentaComponent implements OnInit {

  private readonly authService = inject(AuthService);
  private readonly registroDao = inject(RegistroDao);

  session!: Session;
  loadingProfile = false;
  profileErrorMessage = '';
  loadingMovements = false;
  movementErrorMessage = '';
  hasPassword = false;
  newPassword = '';
  confirmPassword = '';
  passwordMessage = '';
  passwordErrorMessage = '';
  isSavingPassword = false;
  movements: AccountMovement[] = [];

  constructor() {
    this.session = this.authService.getSession()!;
  }

  ngOnInit(): void {
    this.loadProfile();
    this.loadMovements();
  }

  loadProfile(): void {
    if (!this.session?.token) {
      return;
    }

    this.loadingProfile = true;
    this.profileErrorMessage = '';

    this.registroDao.obtenerPerfilCuenta().subscribe({
      next: (response) => {
        this.applyProfileToSession(response?.user, response?.roles || []);
        this.hasPassword = !!response?.has_password;
        this.loadingProfile = false;
      },
      error: () => {
        this.loadingProfile = false;
        this.profileErrorMessage = 'No se pudo actualizar la informacion de la cuenta.';
      }
    });
  }

  savePassword(): void {
    this.passwordMessage = '';
    this.passwordErrorMessage = '';

    if (this.newPassword.trim().length < 8) {
      this.passwordErrorMessage = 'La nueva contrasena debe tener al menos 8 caracteres.';
      return;
    }

    if (this.newPassword !== this.confirmPassword) {
      this.passwordErrorMessage = 'La confirmacion de la contrasena no coincide.';
      return;
    }

    this.isSavingPassword = true;

    this.registroDao.actualizarPasswordPropia(this.newPassword).subscribe({
      next: () => {
        this.passwordMessage = 'Contrasena actualizada correctamente.';
        this.passwordErrorMessage = '';
        this.newPassword = '';
        this.confirmPassword = '';
        this.isSavingPassword = false;
        this.hasPassword = true;
        this.loadMovements();
      },
      error: () => {
        this.isSavingPassword = false;
        this.passwordErrorMessage = 'No se pudo actualizar la contrasena.';
      }
    });
  }

  loadMovements(): void {
    this.loadingMovements = true;
    this.movementErrorMessage = '';

    this.registroDao.obtenerActividadCuenta(10).subscribe({
      next: (response) => {
        const rawItems = (response?.movements || []) as AccountMovementApi[];
        this.movements = rawItems.length > 0
          ? rawItems.map((item) => this.mapMovement(item))
          : this.buildFallbackMovements();
        this.loadingMovements = false;
      },
      error: () => {
        this.loadingMovements = false;
        this.movementErrorMessage = 'No se pudo cargar la bitacora de la cuenta.';
        this.movements = this.buildFallbackMovements();
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
      || 'Mi cuenta'
    );
  }

  getPrimaryEmail(): string {
    return String(this.session.guerrero?.email || this.session.usuario?.email || 'Sin correo registrado');
  }

  getPhone(): string {
    return String(this.session.guerrero?.phone || this.session.guerrero?.telefono || this.session.usuario?.phone || this.session.usuario?.telefono || 'Sin telefono');
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
  }

  private buildFallbackMovements(): AccountMovement[] {
    return [{
      title: 'Sesion activa',
      detail: `Acceso activo para ${this.getPrimaryEmail()}`,
      dateLabel: 'Ahora'
    }, {
      title: 'Politicas de cuenta',
      detail: this.getAcceptedPoliciesLabel(),
      dateLabel: this.getRegisteredAt()
    }];
  }

  private mapMovement(item: AccountMovementApi): AccountMovement {
    const action = String(item?.action || '').trim();
    const payload = this.parseMovementPayload(item?.new_value);

    if (action === 'auth.login') {
      return {
        title: 'Inicio de sesion',
        detail: 'Acceso exitoso a tu cuenta.',
        dateLabel: this.formatMovementDate(item?.created_at)
      };
    }

    if (action === 'auth.logout') {
      return {
        title: 'Cierre de sesion',
        detail: 'Se cerro una sesion autenticada.',
        dateLabel: this.formatMovementDate(item?.created_at)
      };
    }

    if (action === 'users.profile.update' || action === 'users.registration_profile_update') {
      return {
        title: 'Perfil actualizado',
        detail: 'Se actualizaron tus datos de perfil y contacto.',
        dateLabel: this.formatMovementDate(item?.created_at)
      };
    }

    if (action === 'users.password.update' || action === 'users.password.reset_access' || action === 'users.password_reset' || action === 'auth.password_reset') {
      return {
        title: 'Seguridad',
        detail: String(item?.new_value || 'Se realizaron cambios en tu contrasena.'),
        dateLabel: this.formatMovementDate(item?.created_at)
      };
    }

    if (action === 'users.roles.update' || action === 'users.event_roles.update') {
      return {
        title: 'Roles actualizados',
        detail: 'Se modificaron tus permisos o roles asociados.',
        dateLabel: this.formatMovementDate(item?.created_at)
      };
    }

    if (action === 'registrations.create' || action === 'registrations.reenrollment.create') {
      return {
        title: 'Inscripcion registrada',
        detail: 'Se genero una nueva inscripcion para un evento.',
        dateLabel: this.formatMovementDate(item?.created_at)
      };
    }

    if (action === 'registrations.update') {
      return {
        title: 'Inscripcion actualizada',
        detail: 'Se modificaron datos de tu inscripcion.',
        dateLabel: this.formatMovementDate(item?.created_at)
      };
    }

    if (action === 'registrations.status_update') {
      return {
        title: 'Estatus de inscripcion',
        detail: 'Se actualizo el estatus o seguimiento de una inscripcion.',
        dateLabel: this.formatMovementDate(item?.created_at)
      };
    }

    if (action === 'registrations.delete') {
      return {
        title: 'Inscripcion eliminada',
        detail: 'Se elimino una inscripcion existente.',
        dateLabel: this.formatMovementDate(item?.created_at)
      };
    }

    if (action === 'payments.create' || action === 'payments.update' || action === 'payments.delete') {
      const amount = payload?.amount ? Number(payload.amount) : 0;
      const currency = payload?.currency || 'MXN';
      const description = payload?.description || (action === 'payments.delete' ? 'Pago eliminado' : 'Pago registrado');
      return {
        title: action === 'payments.update' ? 'Pago actualizado' : (action === 'payments.delete' ? 'Pago eliminado' : 'Pago aplicado'),
        detail: `${description}${amount > 0 ? ` por ${new Intl.NumberFormat('es-MX', { style: 'currency', currency }).format(amount)}` : ''}`,
        dateLabel: this.formatMovementDate(item?.created_at)
      };
    }

    return {
      title: 'Movimiento',
      detail: String(item?.new_value || item?.old_value || 'Se registro actividad en tu cuenta.'),
      dateLabel: this.formatMovementDate(item?.created_at)
    };
  }

  private parseMovementPayload(value?: string): any {
    if (!value) {
      return null;
    }

    try {
      return JSON.parse(value);
    } catch {
      return null;
    }
  }

  private formatMovementDate(value?: string): string {
    if (!value) {
      return 'Reciente';
    }

    const date = new Date(String(value));
    if (Number.isNaN(date.getTime())) {
      return String(value);
    }

    return new Intl.DateTimeFormat('es-MX', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    }).format(date);
  }
}
