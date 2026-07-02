import { Component, inject, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { UserRole } from 'src/app/core/api/Utils';
import { Session } from 'src/app/core/models/login/Session';
import { AuthService } from 'src/app/core/services/auth.service';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { Event } from 'src/app/core/models/registro/Event';
import { take } from 'rxjs';

@Component({
  selector: 'app-navbar-seguimiento',
  templateUrl: './navbar-seguimiento.component.html',
  styleUrls: ['./navbar-seguimiento.component.css'],
  standalone: false
})
export class NavbarSeguimientoComponent implements OnInit {

  currentUser?: Session;
  eventos: Event[] = [];
  selectedEventoId?: number;
  compareIds = (a: number | null, b: number | null) => a === b;

  constructor(
    private loginDao: LoginDao,
    private router: Router,
    private autho: AuthService,
    private eventDao: EventDao
  ) {
    this.currentUser = inject(AuthService).getSession() || undefined;
  }

  ngOnInit(): void {
    this.autho.currentUser$.subscribe((session) => {
      this.currentUser = session || undefined;
    });

    // Initialize selected evento from localStorage before options load
    const stored = localStorage.getItem('eventoSeleccionado');
    const parsed = stored != null ? Number(stored) : null;
    this.selectedEventoId = parsed != null && !isNaN(parsed) && parsed > 0 ? parsed : undefined;
    console.log('Evento seleccionado cargado:', this.selectedEventoId);
    this.eventDao.getEventActivo('BASIC').subscribe({
      next: (resp) => {
        this.eventos = resp.data?.events ?? [];
      },
      error: (err) => {
        console.error('Error al cargar eventos:', err);
      }
    });
  }

  cerrarSesion() {
    const token = this.autho.getSession()?.token?.toString() || '';

    this.autho.clearSession();
    this.router.navigate(['login']);

    if (!token) {
      return;
    }

    this.loginDao.logout(token).pipe(take(1)).subscribe({
      error: (error) => {
        console.error('Error al cerrar sesión:', error);
      }
    });
  }

  hasRole(roles: UserRole[]) {
    return this.currentUser?.roles.some((role) => roles.includes(role));
  }

  onEventoChange(id: number) {
    this.selectedEventoId = id;
    if (id != null) {
      localStorage.setItem('eventoSeleccionado', String(id));
    }
  }

  getCurrentUserName(): string {
    return String(
      this.currentUser?.guerrero?.display_name
      || this.currentUser?.guerrero?.full_name
      || this.currentUser?.guerrero?.nombre
      || this.currentUser?.usuario?.display_name
      || this.currentUser?.usuario?.full_name
      || this.currentUser?.usuario?.nombre
      || 'Mi cuenta'
    );
  }

  getCurrentUserInitials(): string {
    const parts = this.getCurrentUserName()
      .split(' ')
      .map((part) => part.trim())
      .filter((part) => part.length > 0)
      .slice(0, 2);

    return parts.map((part) => part.charAt(0).toUpperCase()).join('') || 'RU';
  }

}
