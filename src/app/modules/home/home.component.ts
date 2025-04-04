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

  constructor(
    private campamentoDao: CampamentoDao
  ) { }

  campamento: Campamento = new Campamento();

  ngOnInit(): void {
    this.loadCampamento();
  }

  private loadCampamento() {
    this.campamentoDao.getCampamentoActivo().subscribe(
      result => {
        this.campamento = result.resultado![0];
      }
    );
  }

}
