import { BehaviorSubject, lastValueFrom } from 'rxjs';
import { Injectable } from '@angular/core';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { Session } from '../models/login/Session';

@Injectable()
export class AuthService {
  constructor(private loginDao: LoginDao) { }

  private _currentUser = new BehaviorSubject<Session | null>(this.getSession());
  currentUser$ = this._currentUser.asObservable();

  getSession(): Session | null {
    const session = JSON.parse(localStorage.getItem('session')!);
    console.log('Se validará : '+session);
    if (session) {
      console.log('no es nula, se consultará');
      this.loginDao.getSession().subscribe(
        result => {
          if (result.session === undefined) {
            console.log('se lamacenará la nueva session actualizada')
            localStorage.setItem('session', JSON.stringify(result.session));
          }
        }
      );
      console.log('se devuelve la sesión '+JSON.parse(localStorage.getItem('session')!))
      return JSON.parse(localStorage.getItem('session')!);
    } else {
      return null;
    }
  }

  setSession(session: Session | null){
    this._currentUser.next(session);
  }
}