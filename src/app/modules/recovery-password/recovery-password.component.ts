import { Component, OnInit } from '@angular/core';
import { LoginDao } from 'src/app/core/api/dao/LoginDao';

@Component({
    selector: 'app-recovery-password',
    templateUrl: './recovery-password.component.html',
    styleUrls: ['./recovery-password.component.css'],
    standalone: false
})
export class RecoveryPasswordComponent implements OnInit {

  email?: string;
  mensaje?: string;
  typeAlert?: string = "success"
  visibleAlert?: boolean = false;

  constructor(private loginDao: LoginDao) { }

  ngOnInit(): void {
  }

  recovery() {
    this.loginDao.recoveryPassword(this.email!).subscribe(
      result => {
        this.mensaje = result.mensaje;
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
