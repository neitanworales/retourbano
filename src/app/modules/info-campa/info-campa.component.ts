import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { filter, map, switchMap, tap } from 'rxjs/operators';
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

  id_campamento?: number;
  campamento: Campamento = new Campamento();
  isLoading = false;

  ngOnInit(): void {
    this.route.queryParamMap
      .pipe(
        map((params: ParamMap) => Number(params.get('id_campamento'))),
        filter((id) => !isNaN(id) && id > 0),
        tap((id) => {
          this.isLoading = true;
          this.id_campamento = id;
        }),
        switchMap((id) => this.campamentoDao.getCampamentoInfo(id))
      )
      .subscribe({
        next: (result) => {
          this.campamento = result.campamento!;
          this.isLoading = false;
        },
        error: (error) => {
          console.error('Error al cargar campamento:', error);
          this.isLoading = false;
        }
      });
  }

  private loadCampamento(id_campamento: number): void {
    console.log('Id campamento recibida:', id_campamento);
    this.isLoading = true;
    this.campamentoDao.getCampamentoInfo(id_campamento).subscribe({
      next: (result) => {
        this.campamento = result.campamento!;
        this.isLoading = false;
      },
      error: (error) => {
        console.error('Error al cargar campamento:', error);
        this.isLoading = false;
      }
    });
  }

}
