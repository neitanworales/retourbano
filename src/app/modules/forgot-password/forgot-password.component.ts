import { Component, OnInit } from '@angular/core';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';

@Component({
  selector: 'app-forgot-password',
  imports: [],
  templateUrl: './forgot-password.component.html',
  styleUrl: './forgot-password.component.css'
})
export class ForgotPasswordComponent implements OnInit {

  email?: string;
  mensaje?: string;
  typeAlert?: string = "success"
  visibleAlert?: boolean = false;

  constructor(private loginDao: LoginDao) { }

  ngOnInit(): void {
  }

  recovery(email: string){ 
    this.loginDao.recoveryPassword(email!).subscribe(
      result => {
        this.mensaje = result.message;
        this.visibleAlert = true;
        if(result.error){
          this.typeAlert = "danger"
        }else{
          this.typeAlert = "success"
        }
      }
    );
  }
}