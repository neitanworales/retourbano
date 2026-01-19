import { Component, inject, OnInit } from '@angular/core';
import { Session } from 'src/app/core/models/login/Session';
import { AuthService } from 'src/app/core/services/auth.service';

@Component({
  selector: 'app-cuenta',
  templateUrl: './cuenta.component.html',
  styleUrl: './cuenta.component.css',
  standalone: false
})
export class CuentaComponent implements OnInit {
  
  session!: Session;

  constructor(){
    this.session = inject(AuthService).getSession()!;
  }

  ngOnInit(): void {
    
  }

}
