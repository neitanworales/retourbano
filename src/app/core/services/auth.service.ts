import { BehaviorSubject, catchError, firstValueFrom, map, Observable, of } from 'rxjs';
import { inject, Injectable } from '@angular/core';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { Session } from '../models/login/Session';
import { Router } from '@angular/router';
import { SessionResponse } from '../models/login/SessionResponse';

@Injectable()
export class AuthService {
  constructor(private loginDao: LoginDao) { }

  private _currentUser = new BehaviorSubject<Session | null>(this.getSession());
  currentUser$ = this._currentUser.asObservable();
  authorized: Session | null = null;
  router = inject(Router);

  getSession(): Session | null {
    const session = JSON.parse(localStorage.getItem('session')!);
    console.log(session);
    if (session) {
      this.loginDao.getSession().subscribe(
        result => {
          console.log("SE OBTIENE SESSIÓN DESDE EL BACKEND");
          localStorage.setItem('session', JSON.stringify(result.session));
        }, error => {
          console.log("ERROR AL HACER REQUEST: " + error);
          this.setSession(null);
          localStorage.clear();
        }
      );
      console.log('se devuelve la sesión ' + JSON.parse(localStorage.getItem('session')!))
      return JSON.parse(localStorage.getItem('session')!);
    } else {
      return null;
    }
  }

  getSessionValida(): Session {
    return JSON.parse(localStorage.getItem('session')!);
  }

  setSession(session: Session | null) {
    this._currentUser.next(session);
  }
}