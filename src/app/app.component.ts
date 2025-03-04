import { Component } from '@angular/core';
import { LoadingService } from './services/loading-screen/loading-screen.service';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css'],
    standalone: false
})
export class AppComponent {
  title = 'retourbano';
  constructor(public loadingService: LoadingService){}
}
