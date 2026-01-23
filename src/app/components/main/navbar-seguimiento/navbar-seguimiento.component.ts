import { Component, inject, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { UserRole } from 'src/app/core/api/Utils';
import { Session } from 'src/app/core/models/login/Session';
import { AuthService } from 'src/app/core/services/auth.service';
import { CampamentoDao } from 'src/app/core/api/dao/CampamentoDao';
import { Campamento } from 'src/app/core/models/registro/Campamento';

@Component({
  selector: 'app-navbar-seguimiento',
  templateUrl: './navbar-seguimiento.component.html',
  styleUrls: ['./navbar-seguimiento.component.css'],
  standalone: false
})
export class NavbarSeguimientoComponent implements OnInit {

  currentUser?: Session;
  campamentos: Campamento[] = [];
  selectedCampamentoId?: number;
  compareIds = (a: number | null, b: number | null) => a === b;

  constructor(
    private loginDao: LoginDao,
    private router: Router,
    private autho: AuthService,
    private campamentoDao: CampamentoDao
  ) {
    this.currentUser = inject(AuthService).getSessionValida();
  }

  ngOnInit(): void {
    // Initialize selected campamento from localStorage before options load
    const stored = localStorage.getItem('campamentoSeleccionado');
    const parsed = stored != null ? Number(stored) : null;
    this.selectedCampamentoId = parsed != null && !isNaN(parsed) && parsed > 0 ? parsed : undefined;
    console.log('Campamento seleccionado cargado:', this.selectedCampamentoId);
    this.campamentoDao.getCampamentoActivo().subscribe({
      next: (resp) => {
        this.campamentos = resp.resultado ?? [];
      },
      error: (err) => {
        console.error('Error al cargar campamentos:', err);
      }
    });
  }

  cerrarSesion() {
    const session = this.autho.getSession();
    if (session) {
      this.loginDao.logout().subscribe(
        result => {
          console.log(result);
          this.autho.setSession(null);
          this.router.navigate(['login']);
          localStorage.clear();
        });
    } else {
      this.router.navigate(['login']);
    }
  }

  hasRole(roles: UserRole[]) {
    return this.currentUser?.roles.some((role) => roles.includes(role));
  }

  onCampamentoChange(id: number) {
    this.selectedCampamentoId = id;
    if (id != null) {
      localStorage.setItem('campamentoSeleccionado', String(id));
    }
  }

}
