import { Component, OnInit } from '@angular/core';
import { LoadingService } from './core/services/loading-screen/loading-screen.service';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css'],
    standalone: false
})
export class AppComponent implements OnInit {
  title = 'Reto Urbano';
  constructor(public loadingService: LoadingService){}

  ngOnInit(): void {
    this.loadingService.setLoading(false);
  }
}
