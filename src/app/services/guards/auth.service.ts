import { lastValueFrom } from 'rxjs';
import { Injectable } from '@angular/core';
import { LoginDao } from "../../api/dao/LoginDao";

@Injectable()
export class AuthService {
  constructor(private loginDao: LoginDao) { }

  public async isAuthenticated(): Promise<boolean> {
    const result = this.loginDao.validarSession();
    return lastValueFrom(result);
  }

}