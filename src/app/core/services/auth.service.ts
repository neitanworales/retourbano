import { BehaviorSubject, catchError, firstValueFrom, map, Observable, of } from 'rxjs';
import { inject, Injectable } from '@angular/core';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { Session } from '../models/login/Session';
import { Router } from '@angular/router';
import { SessionResponse } from '../models/login/SessionResponse';

@Injectable()
export class AuthService {
  constructor(private loginDao: LoginDao) {
    this.validateStoredSession();
  }

  private _currentUser = new BehaviorSubject<Session | null>(this.readStoredSession());
  currentUser$ = this._currentUser.asObservable();
  authorized: Session | null = null;
  router = inject(Router);

  getSession(): Session | null {
    return this.readStoredSession();
  }

  getSessionValida(): Session {
    return JSON.parse(localStorage.getItem('session')!);
  }

  setSession(session: Session | null) {
    if (session) {
      localStorage.setItem('session', JSON.stringify(session));
    } else {
      localStorage.removeItem('session');
    }
    this._currentUser.next(session);
  }

  clearSession() {
    this.setSession(null);
  }

  private readStoredSession(): Session | null {
    const raw = localStorage.getItem('session');
    if (!raw) {
      return null;
    }

    try {
      return JSON.parse(raw) as Session;
    } catch {
      localStorage.removeItem('session');
      return null;
    }
  }

  private validateStoredSession() {
    const session = this.readStoredSession();
    if (!session?.token) {
      return;
    }

    this.loginDao.getSession().subscribe({
      next: (result) => {
        this.setSession(result.session || null);
      },
      error: () => {
        this.clearSession();
      }
    });
  }
}