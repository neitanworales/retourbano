import { inject } from '@angular/core';
import { CanMatchFn, GuardResult, MaybeAsync, Router } from '@angular/router';
import { map } from 'rxjs';
import { AuthService } from '../services/auth.service';

export const authGuard: CanMatchFn = (
  route,
  segments,
): MaybeAsync<GuardResult> => {
  const router = inject(Router);

  return inject(AuthService).currentUser$.pipe(
    map((session) => {
      if (session) {
        return true;
      }

      return router.createUrlTree(['/auth/login']);
    }),
  );
};