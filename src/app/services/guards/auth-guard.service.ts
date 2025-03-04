import { Injectable } from '@angular/core';
import { AuthService } from './auth.service';
import { Router } from '@angular/router';

@Injectable()
export class AuthGuardService  {
  
  constructor(
    public auth: AuthService, 
    public router: Router) {}

  async canActivate(): Promise<boolean> {
    if (!await this.auth.isAuthenticated()) {
      console.log("deslogeado");
      this.router.navigate(['login']);
      return false;
    }
    console.log("aun logeado");
    return true;
  }

}
