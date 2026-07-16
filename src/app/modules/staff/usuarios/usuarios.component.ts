import { Component, OnInit } from '@angular/core';
import { animate, state, style, transition, trigger } from '@angular/animations';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { UserRole } from 'src/app/core/api/Utils';
import { MtoLogin } from 'src/app/core/models/login/MtoLogin';
import { AsistenciaCampamentos, CampamentoGuerreros } from 'src/app/core/models/registro/CampamentoGuerreros';

@Component({
  selector: 'app-usuarios',
  templateUrl: './usuarios.component.html',
  styleUrl: './usuarios.component.css',
  animations: [
    trigger('detailExpand', [
      state('collapsed', style({ height: '0px', minHeight: '0' })),
      state('expanded', style({ height: '*' })),
      transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    ]),
  ],
  standalone: false
})
export class UsuariosComponent implements OnInit {

  readonly availableRoles: UserRole[] = ['staff', 'admin'];

  users?: MtoLogin[] = [];
  allUsers?: MtoLogin[] = [];
  repetidos?: CampamentoGuerreros[] = [];
  expandedCampamentoGuerrero?: CampamentoGuerreros;
  expandedUsers?: MtoLogin;

  columnsToDisplay = [
    'id',
    'nick',
    'email',
    'campamentos',
    'passwordStatus',
    'roles',
  ];

  columnsToDisplayRepetidos = [
    'email',
    'count'
  ];

  pageUsuarios: boolean = true;
  pageRepetidos: boolean = false;
  pageUsauriosDisplayStyle: string = 'block';
  pageRepetidosDisplayStyle: string = 'none';
  searchUsers: string = '';
  onlyActiveCampUsers: boolean = false;

  constructor(
    private registroDao: RegistroDao,
    private loginDao: LoginDao
  ) {

  }

  activarPageUsuarios() {
    this.pageUsuarios = true;
    this.pageRepetidos = false;
    this.pageUsauriosDisplayStyle = 'block';
    this.pageRepetidosDisplayStyle = 'none';
    this.loadDataUsuarios();
  }

  activarPageRepetidos() {
    this.pageUsuarios = false;
    this.pageRepetidos = true;
    this.pageUsauriosDisplayStyle = 'none';
    this.pageRepetidosDisplayStyle = 'block';
    this.loadDataRepetidos();
  }

  ngOnInit(): void {
    this.loadDataUsuarios();
  }

  cargarTodos() {
    this.searchUsers = '';
    this.loadDataUsuarios();
  }

  cargarTodosRepetidos() {
    this.loadDataRepetidos();
  }

  loadDataUsuarios() {
    this.registroDao.obtenerUsuarios(0, this.searchUsers).subscribe(
      resultado => {
        this.allUsers = (resultado.users || []).map((user) => this.prepareUser(user));
        this.applyUsersFilter();
      }
    );
  }

  buscarUsuarios() {
    this.loadDataUsuarios();
  }

  toggleOnlyActiveCampUsers() {
    this.onlyActiveCampUsers = !this.onlyActiveCampUsers;
    this.applyUsersFilter();
  }

  loadDataRepetidos() {
    this.registroDao.obtenerRepetidos(0).subscribe(
      resultado => {
        this.repetidos = resultado.data?.duplicates || [];
      }
    );
  }

  esTutor(cg: AsistenciaCampamentos) {
    this.registroDao.updateEmailTutor(cg.guerreroID!, '', cg.email!,0).subscribe(
      resultado => {
        this.cargarTodosRepetidos();
      }
    );
  }

  noEsTutor(cg: AsistenciaCampamentos) {
    this.registroDao.updateEmailTutor(cg.guerreroID!, cg.email_tutor!, '',0).subscribe(
      resultado => {
        this.cargarTodosRepetidos();
      }
    );
  }

  editarPassword(hosp: MtoLogin) {
    hosp.editar = !hosp.editar;
    if (hosp.editar) {
      hosp.passwordOldValue = hosp.password;
      hosp.password = '';
      hosp.showPassword = false;
    } else {
      hosp.password = '';
      hosp.showPassword = false;
    }

    hosp.actionMessage = '';
    hosp.actionError = false;
  }

  guardarPassword(hosp: MtoLogin) {
    if (!hosp.id || !hosp.password?.trim()) {
      return;
    }

    this.registroDao.cambiarContrasena(hosp.password, hosp.id, 0).subscribe(
      result => {
        hosp.password = '';
        hosp.passwordOldValue = '';
        hosp.editar = false;
        hosp.showPassword = false;
        hosp.has_password = true;
        hosp.actionError = false;
        hosp.actionMessage = 'Password actualizada correctamente.';
      }
    );
  }

  resetearPassword(user: MtoLogin) {
    if (!user.id || user.isResettingPassword) {
      return;
    }

    const shouldReset = window.confirm('Esto quitara el acceso por password a este usuario. Deseas continuar?');
    if (!shouldReset) {
      return;
    }

    user.isResettingPassword = true;
    user.actionMessage = '';
    user.actionError = false;

    this.registroDao.resetearContrasena(user.id).subscribe({
      next: () => {
        user.isResettingPassword = false;
        user.has_password = false;
        user.password = '';
        user.passwordOldValue = '';
        user.editar = false;
        user.showPassword = false;
        user.actionError = false;

        if (this.getManagedRoles(user).length === 0) {
          this.allUsers = (this.allUsers || []).filter((item) => item.id !== user.id);
          this.applyUsersFilter();
          return;
        }

        user.actionMessage = 'Acceso por password reseteado correctamente.';
      },
      error: () => {
        user.isResettingPassword = false;
        user.actionError = true;
        user.actionMessage = 'No se pudo resetear la password.';
      }
    });
  }

  togglePasswordVisibility(user: MtoLogin) {
    user.showPassword = !user.showPassword;
  }

  enviarRecuperacion(user: MtoLogin) {
    const email = user.email?.toString().trim() || '';
    if (!email || user.isSendingRecoveryEmail) {
      return;
    }

    user.isSendingRecoveryEmail = true;
    user.actionMessage = '';
    user.actionError = false;

    this.loginDao.recoveryPassword(email).subscribe({
      next: () => {
        this.registroDao.registrarActividadStaff({
          action: 'emails.password_recovery.staff',
          summary: 'Correo de recuperacion enviado por staff',
          affected_user_id: user.id,
          entity_type: 'user',
          entity_id: user.id,
          metadata: {
            email,
            target_user_id: user.id,
            roles: user.roles || [],
          }
        }).subscribe({ error: () => undefined });

        user.isSendingRecoveryEmail = false;
        user.actionError = false;
        user.actionMessage = 'Se envió el correo de recuperación si la cuenta existe.';
      },
      error: () => {
        user.isSendingRecoveryEmail = false;
        user.actionError = true;
        user.actionMessage = 'No se pudo enviar el correo de recuperación.';
      }
    });
  }

  hasRole(user: MtoLogin, role: UserRole): boolean {
    return this.getManagedRoles(user).includes(role);
  }

  actualizarRol(user: MtoLogin, role: UserRole, enabled: boolean) {
    if (!user.id || user.isSavingRoles) {
      return;
    }

    user.isSavingRoles = true;
    this.registroDao.actualizarRolesGlobales(user.id, enabled ? { add_roles: [role] } : { remove_roles: [role] }).subscribe({
      next: (result: any) => {
        user.roles = (result?.data?.roles || user.roles || []) as UserRole[];
        user.isSavingRoles = false;
      },
      error: () => {
        user.isSavingRoles = false;
      }
    });
  }

  getManagedRoles(user: MtoLogin): UserRole[] {
    return (user.roles || []).filter((role): role is UserRole => role === 'staff' || role === 'admin');
  }

  getDisplayRoles(user: MtoLogin): string[] {
    const managedRoles = this.getManagedRoles(user);
    return managedRoles.length > 0 ? managedRoles : ['sin roles'];
  }

  getRoleBadgeClass(role: string): string {
    if (role === 'admin') {
      return 'role-badge role-badge-admin';
    }

    if (role === 'staff') {
      return 'role-badge role-badge-staff';
    }

    return 'role-badge role-badge-empty';
  }

  getPasswordBadgeClass(user: MtoLogin): string {
    return user.has_password ? 'role-badge role-badge-password' : 'role-badge role-badge-empty';
  }

  getPasswordBadgeLabel(user: MtoLogin): string {
    return user.has_password ? 'con password' : 'sin password';
  }

  getCurrentCampLabel(user: MtoLogin): string {
    const activeEvents = user.active_events || [];
    if (activeEvents.length > 0) {
      return activeEvents.length === 1
        ? `Activo: ${this.getEventLabel(activeEvents[0])}`
        : `Activo en ${activeEvents.length} campamentos`;
    }

    if (user.latest_event) {
      return `Ultimo: ${this.getEventLabel(user.latest_event)}`;
    }

    return 'Sin campamentos';
  }

  getCurrentCampBadgeClass(user: MtoLogin): string {
    if ((user.active_events || []).length > 0) {
      return 'role-badge role-badge-active-event';
    }

    if (user.latest_event) {
      return 'role-badge role-badge-last-event';
    }

    return 'role-badge role-badge-empty';
  }

  getRegistrationStatusLabel(status?: string | null): string {
    const normalizedStatus = (status || '').trim().toUpperCase();

    if (normalizedStatus === 'A' || normalizedStatus === '') {
      return 'Activa';
    }

    if (normalizedStatus === 'B' || normalizedStatus === 'INACTIVE') {
      return 'Baja';
    }

    if (normalizedStatus === 'P') {
      return 'Pendiente';
    }

    return normalizedStatus;
  }

  getRegistrationStatusBadgeClass(status?: string | null): string {
    const normalizedStatus = (status || '').trim().toUpperCase();

    if (normalizedStatus === 'A' || normalizedStatus === '') {
      return 'role-badge role-badge-status-active';
    }

    if (normalizedStatus === 'B' || normalizedStatus === 'INACTIVE') {
      return 'role-badge role-badge-status-inactive';
    }

    if (normalizedStatus === 'P') {
      return 'role-badge role-badge-status-pending';
    }

    return 'role-badge role-badge-empty';
  }

  getEventLabel(event?: { title?: string | null; event_year?: number | null }): string {
    if (!event) {
      return 'Sin campamento';
    }

    const title = event.title?.trim() || 'Campamento sin titulo';
    return event.event_year ? `${title} ${event.event_year}` : title;
  }

  private prepareUser(user: MtoLogin): MtoLogin {
    return {
      ...user,
      roles: user.roles || [],
      active_events: user.active_events || [],
      isSavingRoles: false,
      showPassword: false,
      isSendingRecoveryEmail: false,
      isResettingPassword: false,
      actionMessage: '',
      actionError: false,
    };
  }

  private applyUsersFilter() {
    const sourceUsers = this.allUsers || [];
    this.users = this.onlyActiveCampUsers
      ? sourceUsers.filter((user) => (user.active_events || []).length > 0)
      : sourceUsers;
  }

}
