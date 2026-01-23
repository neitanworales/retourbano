import { Component, OnInit, Inject } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { filter, map, switchMap, tap } from 'rxjs/operators';
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
    private route: ActivatedRoute,
    private campamentoDao: CampamentoDao
  ) { }

  campamentos?: Campamento[];
  id_campamento?: number;
  campamento?: Campamento;

  ngOnInit(): void {
    this.loadCampamento();
    this.loadCampamentos();
  }

  private loadCampamento() {
    this.route.queryParamMap
      .pipe(
        map((params: ParamMap) => Number(params.get('id_campamento'))),
        filter((id) => !isNaN(id) && id > 0),
        tap((id) => {
          this.id_campamento = id;
        }),
        switchMap((id) => this.campamentoDao.getCampamentoInfo(id))
      )
      .subscribe({
        next: (result) => {
          this.campamento = result.campamento!;
        },
        error: (error) => {
          console.error('Error al cargar campamento:', error);
        }
      });
    console.log('Campamento', this.campamento);
  }

  private loadCampamentos() {
    this.campamentoDao.getCampamentoActivo().subscribe({
      next: (result) => {
        this.campamentos = result.resultado!;
      },
      error: (error) => {
        console.error('Error al cargar campamentos:', error);
      }
    });
  }

}
