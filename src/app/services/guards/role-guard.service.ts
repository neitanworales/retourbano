import { Injectable } from '@angular/core';
import { LoginDao } from '../../api/dao/LoginDao';
import { AuthService } from './auth.service';
import { lastValueFrom } from 'rxjs';
import { ActivatedRouteSnapshot, Router } from '@angular/router';

@Injectable()
export class RoleGuardService  {
  constructor(
    public loginDao: LoginDao,
    public auth: AuthService,
    public router: Router) { }

  async canActivate(route: ActivatedRouteSnapshot): Promise<boolean> {
    // this will be passed from the route config
    // on the data property
    const expectedAdmin = route.data['isAdmin'];
    // decode the token to get its payload

    if (! await this.auth.isAuthenticated()) {
      this.router.navigate(['login']);
      return false;
    }

    if (await this.validateRol(expectedAdmin)) {
      this.router.navigate(['inscripciones']);
      return false;
    }
    return true;
  }

  private async validateRol(expectedAdmin: boolean): Promise<boolean> {
    if (expectedAdmin) {
      const result = this.loginDao.isAdmin()
      return lastValueFrom(result);
    }
    return true;
  }
}