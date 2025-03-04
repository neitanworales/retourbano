import { Component, OnInit } from '@angular/core';
import { LoginDao } from 'src/app/api/dao/LoginDao';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';

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
  loginError? : boolean;

  constructor(private formBuilder: FormBuilder, public loginDao: LoginDao, private router: Router) { }

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
    this.loginDao.login(this.username!, this.password!).subscribe(
      result => {
        if(result.success){
          console.log(result.session);
          localStorage.setItem('session', JSON.stringify(result.session));
          this.loginError=false;
          this.router.navigate(['inscripciones']);
        }else{
          this.loginError=true;
        }
      }
    );
  }

  onReset() {
    this.submitted = false;
    this.registerForm?.reset();
  }

}
