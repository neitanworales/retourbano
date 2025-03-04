import { Component, OnInit } from '@angular/core';
import { Session } from 'src/app/models/login/Session';

@Component({
    selector: 'app-user-info',
    templateUrl: './user-info.component.html',
    styleUrls: ['./user-info.component.css'],
    standalone: false
})
export class UserInfoComponent implements OnInit {

  session!: Session;

  constructor() { }

  ngOnInit(): void {
    this.session = JSON.parse(localStorage.getItem('session')!);
  }

}
