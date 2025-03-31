import { Component, OnInit } from '@angular/core';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { AuthGuardService } from 'src/app/core/services/guards/auth-guard.service';

@Component({
    selector: 'app-navbar-seguimiento',
    templateUrl: './navbar-seguimiento.component.html',
    styleUrls: ['./navbar-seguimiento.component.css'],
    standalone: false
})
export class NavbarSeguimientoComponent implements OnInit {

  constructor(private loginDao: LoginDao, private guard: AuthGuardService) { }

  ngOnInit(): void {
  }

  cerrarSesion() {
    this.loginDao.logout().subscribe(
      () => {
        this.guard.canActivate();
      });
      localStorage.clear();
  }

}
