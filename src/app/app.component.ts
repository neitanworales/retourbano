import { Component, OnInit } from '@angular/core';
import { AuthService } from './core/services/auth.service';
import { LoadingService } from './core/services/loading-screen/loading-screen.service';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css'],
    standalone: false
})
export class AppComponent implements OnInit {
  title = 'Reto Urbano';
  constructor(public loadingService: LoadingService, public authService: AuthService){}

  ngOnInit(): void {
    this.loadingService.setLoading(false);
    setTimeout(() => {
      this.authService.initializeSessionValidation();
    });
  }
}
