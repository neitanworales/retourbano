import { Component, OnInit, Inject } from '@angular/core';
import { CampamentoDao } from 'src/app/core/api/dao/CampamentoDao';
import { Campamento } from 'src/app/core/models/registro/Campamento';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
  standalone: false
})
export class HomeComponent implements OnInit {

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
