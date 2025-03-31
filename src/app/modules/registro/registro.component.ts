import { Component, OnInit, Inject } from '@angular/core';
import { CampamentoDao } from 'src/app/core/api/dao/CampamentoDao';
import { Campamento } from 'src/app/core/models/registro/Campamento';

@Component({
  selector: 'app-registro',
  templateUrl: './registro.component.html',
  styleUrls: ['./registro.component.css'],
  standalone: false
})
export class RegistroComponent implements OnInit {

  constructor(
    private campamentoDao: CampamentoDao
  ) { }

  campamento!: Campamento;

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
