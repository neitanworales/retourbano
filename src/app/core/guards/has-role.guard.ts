import { inject } from '@angular/core';
import { CanActivateFn } from '@angular/router';
import { map } from 'rxjs';
import { AuthService } from '../services/auth.service';
import { UserRole } from '../api/Utils';

export const hasRoleGuard = (roles: UserRole[]): CanActivateFn => {
  return () => {
    return inject(AuthService).currentUser$.pipe(
      map((session) => {
        if (!session) return false;

        return session.roles.some(role => roles.includes(role));
      }),
    );
  };
};