import { Component, OnInit, Inject } from '@angular/core';
import { APP_BASE_HREF } from '@angular/common';
import { Campamento } from 'src/app/core/models/registro/Campamento';
import { CampamentoDao } from 'src/app/core/api/dao/CampamentoDao';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css'],
  standalone: false
})
export class NavbarComponent implements OnInit {

  campamentos?: Campamento[];
  isLoading: boolean = true;

  constructor(
    private campamentoDao: CampamentoDao
  ) {
    this.loadCampamento();
  }

  ngOnInit(): void {
  }

  private loadCampamento() {
    this.campamentoDao.getCampamentoActivo().subscribe({
      next: (result) => {
        console.log("Campamentos cargados: ", result.resultado);
        this.campamentos = result.resultado!;
        console.log("Campamentos asignados: ", this.campamentos);
        this.isLoading = false;
      },
      error: (error) => {
        console.error('Error al cargar campamentos:', error);
        this.isLoading = false;
      }
    });
  }

}
