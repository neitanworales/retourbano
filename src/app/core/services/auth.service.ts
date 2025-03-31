import { BehaviorSubject, lastValueFrom } from 'rxjs';
import { Injectable } from '@angular/core';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { Session } from '../models/login/Session';

@Injectable()
export class AuthService {
  constructor(private loginDao: LoginDao) { }

  public async isAuthenticated(): Promise<boolean> {
    const result = this.loginDao.validarSession();
    return lastValueFrom(result);
  }

  private _currentUser = new BehaviorSubject<Session | null>(this.getSession());
  currentUser$ = this._currentUser.asObservable();

  getSession(): Session {
    return JSON.parse(localStorage.getItem('session')!);
  }
}