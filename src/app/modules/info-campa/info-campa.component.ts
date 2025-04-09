import { Component, OnInit } from '@angular/core';
import { CampamentoDao } from 'src/app/core/api/dao/CampamentoDao';
import { Campamento } from 'src/app/core/models/registro/Campamento';

@Component({
    selector: 'app-info-campa',
    templateUrl: './info-campa.component.html',
    styleUrls: ['./info-campa.component.css'],
    standalone: false
})
export class InfoCampaComponent implements OnInit {

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
