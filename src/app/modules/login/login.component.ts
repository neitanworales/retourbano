import { Component, inject, OnInit } from '@angular/core';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/core/services/auth.service';
import { HttpErrorResponse } from '@angular/common/http';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
  standalone: false
})
export class LoginComponent implements OnInit {

  username?: String = "";
  password?: String = "";
  registerForm!: FormGroup;
  submitted = false;
  loginError?: boolean;
  loginErrorMessage: string = 'Usuario y/o contraseña son incorrectos';

  constructor(
    private formBuilder: FormBuilder,
    public loginDao: LoginDao,
    private router: Router,
    private autho: AuthService
  ) {
    const session = inject(AuthService).getSession();
    if (session) {
      console.log("se envia al dashbord");
      this.router.navigate(['staff']);
    }
  }

  ngOnInit(): void {
    this.registerForm = this.formBuilder.group({
      username: ["", Validators.required],
      password: ["", Validators.required],
    })
    this.loginError = false;
  }

  get form() {
    return this.registerForm?.controls;
  }

  onSubmit() {
    this.submitted = true;
    if (this.registerForm?.invalid) {
      return;
    }
    this.loginDao.login(this.username!, this.password!).subscribe({
      next: result => {
        console.log("sucess : " + result.success);
        if (result.success) {
          localStorage.setItem('session', JSON.stringify(result.session));
          this.loginError = false;
          this.autho.setSession(result.session!);
          this.router.navigateByUrl('/staff');
          return;
        } else {
          this.loginError = true;
          this.loginErrorMessage = 'Usuario y/o contraseña son incorrectos';
        }
      },
      error: (err: HttpErrorResponse) => {
        this.loginError = true;
        if (err.status === 401) {
          this.loginErrorMessage = 'Usuario y/o contraseña son incorrectos';
        } else {
          this.loginErrorMessage = 'Ocurrió un error al iniciar sesión. Intenta de nuevo.';
        }
      }
    });
  }

  onReset() {
    this.submitted = false;
    this.registerForm?.reset();
  }

}
