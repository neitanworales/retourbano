import { Component, OnInit , Inject } from '@angular/core';
import { APP_BASE_HREF } from '@angular/common';

@Component({
    selector: 'app-navbar',
    templateUrl: './navbar.component.html',
    styleUrls: ['./navbar.component.css'],
    standalone: false
})
export class NavbarComponent implements OnInit {

  ngOnInit(): void {
  }

}
