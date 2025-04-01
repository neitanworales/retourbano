import { Component, inject, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { AuthService } from 'src/app/core/services/auth.service';

@Component({
  selector: 'app-navbar-seguimiento',
  templateUrl: './navbar-seguimiento.component.html',
  styleUrls: ['./navbar-seguimiento.component.css'],
  standalone: false
})
export class NavbarSeguimientoComponent implements OnInit {

  constructor(
    private loginDao: LoginDao,
    private router: Router,
    private autho: AuthService
  ) { }

  ngOnInit(): void {
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

}
