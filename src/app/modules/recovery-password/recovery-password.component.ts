import { Component, OnInit } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { finalize } from 'rxjs';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';

@Component({
    selector: 'app-recovery-password',
    templateUrl: './recovery-password.component.html',
    styleUrls: ['./recovery-password.component.css'],
    standalone: false
})
export class RecoveryPasswordComponent implements OnInit {
    token = '';
    validatingToken = true;
    validToken = false;
    loadingSubmit = false;
    visibleAlert = false;
    alertType: 'success' | 'danger' = 'success';
    alertMessage = '';

    resetForm: FormGroup;

    constructor(
        private route: ActivatedRoute,
        private router: Router,
        private fb: FormBuilder,
        private loginDao: LoginDao,
    ) {
        this.resetForm = this.fb.group(
            {
                newPassword: ['', [Validators.required, this.passwordPolicyValidator()]],
                confirmPassword: ['', [Validators.required]],
            },
            { validators: this.passwordsMatchValidator() }
        );
    }

    ngOnInit(): void {
        this.token = (this.route.snapshot.queryParamMap.get('token') || '').trim();
        if (!this.token) {
            this.validatingToken = false;
            this.validToken = false;
            this.showAlert('danger', 'El enlace no contiene un token válido. Solicita uno nuevo.');
            return;
        }

        this.loginDao.validateResetToken(this.token).subscribe({
            next: (result) => {
                this.validToken = !!result.success;
                this.validatingToken = false;
                if (!result.success) {
                    this.showAlert('danger', result.message || 'El token es inválido o ha expirado.');
                }
            },
            error: () => {
                this.validToken = false;
                this.validatingToken = false;
                this.showAlert('danger', 'No fue posible validar el token. Intenta de nuevo.');
            },
        });
    }

    get form() {
        return this.resetForm.controls;
    }

    get passwordValue(): string {
        return (this.form['newPassword']?.value || '') as string;
    }

    get hasMinLength(): boolean {
        return this.passwordValue.length >= 12;
    }

    get hasUpper(): boolean {
        return /[A-Z]/.test(this.passwordValue);
    }

    get hasLower(): boolean {
        return /[a-z]/.test(this.passwordValue);
    }

    get hasNumber(): boolean {
        return /[0-9]/.test(this.passwordValue);
    }

    get hasSpecial(): boolean {
        return /[^A-Za-z0-9]/.test(this.passwordValue);
    }

    get hasNoSpaces(): boolean {
        return this.passwordValue.length > 0 && !/\s/.test(this.passwordValue);
    }

    generateSecurePassword(): void {
        const generated = this.buildStrongPassword(16);
        this.resetForm.patchValue({
            newPassword: generated,
            confirmPassword: '',
        });
        this.form['newPassword'].markAsTouched();
        this.form['confirmPassword'].markAsUntouched();
    }

    onSubmit(): void {
        this.visibleAlert = false;

        if (!this.validToken || !this.token) {
            this.showAlert('danger', 'No puedes actualizar la contraseña con un token inválido.');
            return;
        }

        if (this.resetForm.invalid) {
            this.resetForm.markAllAsTouched();
            return;
        }

        this.loadingSubmit = true;
        const newPassword = this.form['newPassword'].value as string;
        this.loginDao
            .resetPassword(this.token, newPassword)
            .pipe(finalize(() => (this.loadingSubmit = false)))
            .subscribe({
                next: (result) => {
                    if (result.success) {
                        this.showAlert('success', 'Tu contraseña se actualizó correctamente. Ya puedes iniciar sesión.');
                        this.resetForm.reset();
                        setTimeout(() => {
                            this.router.navigate(['/login']);
                        }, 1400);
                        return;
                    }

                    this.showAlert('danger', result.message || 'No fue posible actualizar la contraseña.');
                },
                error: () => {
                    this.showAlert('danger', 'No fue posible actualizar la contraseña. Verifica el token o solicita uno nuevo.');
                },
            });
    }

    private showAlert(type: 'success' | 'danger', message: string): void {
        this.alertType = type;
        this.alertMessage = message;
        this.visibleAlert = true;
    }

    private passwordsMatchValidator(): ValidatorFn {
        return (group: AbstractControl): ValidationErrors | null => {
            const pass = group.get('newPassword')?.value;
            const confirm = group.get('confirmPassword')?.value;
            if (!pass || !confirm) {
                return null;
            }
            return pass === confirm ? null : { passwordMismatch: true };
        };
    }

    private passwordPolicyValidator(): ValidatorFn {
        return (control: AbstractControl): ValidationErrors | null => {
            const value = (control.value || '') as string;

            if (value.length === 0) {
                return null;
            }

            const valid =
                value.length >= 12 &&
                /[A-Z]/.test(value) &&
                /[a-z]/.test(value) &&
                /[0-9]/.test(value) &&
                /[^A-Za-z0-9]/.test(value) &&
                !/\s/.test(value);

            return valid ? null : { weakPassword: true };
        };
    }

    private buildStrongPassword(length: number): string {
        const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        const lower = 'abcdefghijklmnopqrstuvwxyz';
        const numbers = '0123456789';
        const symbols = '!@#$%^&*()_+-=[]{}<>?';
        const all = upper + lower + numbers + symbols;

        const requiredChars = [
            this.pickRandom(upper),
            this.pickRandom(lower),
            this.pickRandom(numbers),
            this.pickRandom(symbols),
        ];

        while (requiredChars.length < length) {
            requiredChars.push(this.pickRandom(all));
        }

        for (let i = requiredChars.length - 1; i > 0; i--) {
            const j = this.randomIndex(i + 1);
            [requiredChars[i], requiredChars[j]] = [requiredChars[j], requiredChars[i]];
        }

        return requiredChars.join('');
    }

    private pickRandom(source: string): string {
        return source[this.randomIndex(source.length)];
    }

    private randomIndex(max: number): number {
        const array = new Uint32Array(1);
        window.crypto.getRandomValues(array);
        return array[0] % max;
    }

}
