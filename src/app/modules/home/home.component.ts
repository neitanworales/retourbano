import { Component, OnInit, Inject } from '@angular/core';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
  standalone: false
})
export class HomeComponent implements OnInit {

  events?: Event[];
  isLoading: boolean = true;
  readonly galleryImages: string[] = [
    'assets/img/media/1.0ef5bf1c.jpeg',
    'assets/img/media/2.45441791.jpeg',
    'assets/img/media/3.6c5113e5.jpeg',
    'assets/img/media/4.c26f32c4.jpeg',
    'assets/img/media/5.a6e705ca.jpeg',
    'assets/img/media/6.562ce17c.jpeg',
    'assets/img/media/7.6b0e3671.jpeg',
    'assets/img/media/8.07903f89.jpeg',
    'assets/img/media/9.da456690.jpeg',
    'assets/img/media/10.6ba5fd42.jpeg',
    'assets/img/media/11.106254da.jpeg',
    'assets/img/media/12.59ee5962.jpeg',
    'assets/img/media/13.c79dc848.jpeg',
    'assets/img/media/14.67291eec.jpeg',
    'assets/img/media/15.26c2d118.jpeg',
    'assets/img/media/16.9560e803.jpeg',
    'assets/img/media/17.717b4e16.jpeg',
    'assets/img/media/18.6bb61c54.jpeg',
    'assets/img/media/19.fe3f52da.jpeg',
    'assets/img/media/20.b8f49220.jpeg',
    'assets/img/media/21.d079e376.jpeg',
    'assets/img/media/22.33af8532.jpeg',
    'assets/img/media/23.38ab782f.jpeg',
    'assets/img/media/24.c5b7b281.jpeg',
    'assets/img/media/25.f34f40eb.jpeg',
    'assets/img/media/26.7b4dd73a.jpeg',
    'assets/img/media/27.689f98b7.jpeg',
    'assets/img/media/28.64b2966c.jpeg',
    'assets/img/media/29.3f3e1b1e.jpeg',
    'assets/img/media/30.0b01adc4.jpeg',
    'assets/img/media/31.e2e31145.jpeg',
    'assets/img/media/32.83350ac7.jpeg',
    'assets/img/media/33.3499a95e.jpeg',
    'assets/img/media/34.55cea353.jpeg',
    'assets/img/media/35.0acee0e8.jpeg',
    'assets/img/media/36.db8f0a5a.jpeg',
    'assets/img/media/37.b5579314.jpeg',
    'assets/img/media/38.07077a63.jpeg',
    'assets/img/media/39.d8b17117.jpeg',
    'assets/img/media/40.188f4958.jpeg',
    'assets/img/media/41.fa57a46f.jpeg',
    'assets/img/media/42.44721956.jpeg',
    'assets/img/media/43.c92df929.jpeg',
    'assets/img/media/44.760da1af.jpeg',
    'assets/img/media/45.8b915142.jpeg',
    'assets/img/media/46.0c28cd66.jpeg',
    'assets/img/media/47.6ac52257.jpeg',
    'assets/img/media/48.ef0d1147.jpeg',
    'assets/img/media/49.a5d7ff26.jpeg',
    'assets/img/media/50.5011bfa6.jpeg',
    'assets/img/media/51.93e56519.jpeg',
    'assets/img/media/52.01f97a1f.jpeg',
    'assets/img/media/53.b93ba7c5.jpeg',
    'assets/img/media/54.b5ae8e1e.jpeg',
    'assets/img/media/55.957f7479.jpeg',
    'assets/img/media/56.9dd0cf1e.jpeg',
    'assets/img/media/57.83bb2320.jpeg',
    'assets/img/media/58.efdebfa5.jpeg',
    'assets/img/media/59.a0e5b9a3.jpeg',
    'assets/img/media/60.d7753119.jpeg',
    'assets/img/media/61.152fe94f.jpeg',
    'assets/img/media/62.d6ced3eb.jpeg'
  ];
  currentGalleryIndex = 0;

  constructor(
    private eventDao: EventDao
  ) { 
    this.loadEvents();
  }

  ngOnInit(): void {
    
  }

  prevGalleryImage(): void {
    if (!this.galleryImages.length) {
      return;
    }

    this.currentGalleryIndex = (this.currentGalleryIndex - 1 + this.galleryImages.length) % this.galleryImages.length;
  }

  nextGalleryImage(): void {
    if (!this.galleryImages.length) {
      return;
    }

    this.currentGalleryIndex = (this.currentGalleryIndex + 1) % this.galleryImages.length;
  }

  onGalleryKeydown(event: KeyboardEvent): void {
    if (event.key === 'ArrowLeft') {
      event.preventDefault();
      this.prevGalleryImage();
    }

    if (event.key === 'ArrowRight') {
      event.preventDefault();
      this.nextGalleryImage();
    }
  }

  private loadEvents() {
    this.eventDao.getEventActivo('BASIC').subscribe({
      next: (result) => {
        console.log("Eventos cargados: ", result.data?.events);
        this.events = result.data?.events!;
        console.log("Eventos asignados: ", this.events);
        this.isLoading = false;
      },
      error: (error) => {
        console.error('Error al cargar eventos:', error);
        this.isLoading = false;
      }
    });
  }

}
