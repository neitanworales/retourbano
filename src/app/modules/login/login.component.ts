import { Component, inject, OnInit } from '@angular/core';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/core/services/auth.service';
import { TumbaService } from 'src/app/core/services/tumbaService';

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

  constructor(
    private formBuilder: FormBuilder,
    public loginDao: LoginDao,
    private router: Router,
    private autho: AuthService, 
    private tumba: TumbaService
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
    this.loginDao.login(this.tumba.encryptar(this.username!), this.tumba.encryptar(this.password!)).subscribe(
      result => {
        console.log("sucess : " + result.success);
        if (result.success) {
          localStorage.setItem('session', JSON.stringify(result.session));
          this.loginError = false;
          this.autho.setSession(result.session!);
          this.router.navigateByUrl('/staff');
          return;
        } else {
          this.loginError = true;
        }
      }
    );
  }

  onReset() {
    this.submitted = false;
    this.registerForm?.reset();
  }

}
