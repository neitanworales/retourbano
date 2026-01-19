import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';
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
    private route: ActivatedRoute,
    private campamentoDao: CampamentoDao
  ) { }

  ciudad: string | null = null;
  campamento: Campamento = new Campamento();

  ngOnInit(): void {
    this.route.queryParamMap.subscribe((params: ParamMap) => {
      this.ciudad = params.get('id_ciudad');
    });
    this.loadCampamento(this.ciudad);
  }

  private loadCampamento(ciudad: string | null): void {
    console.log('Ciudad recibida:', ciudad);
    this.campamentoDao.getCampamentoActivo().subscribe(
      result => {
        this.campamento = result.resultado![0];
      }
    );
  }

}
