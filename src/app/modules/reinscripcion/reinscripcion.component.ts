import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { map, filter, tap, switchMap } from 'rxjs';
import { CampamentoDao } from 'src/app/core/api/dao/CampamentoDao';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { Campamento } from 'src/app/core/models/registro/Campamento';
import { Guerrero } from 'src/app/core/models/registro/Guerrero';

@Component({
  selector: 'app-reinscripcion',
  templateUrl: './reinscripcion.component.html',
  styleUrl: './reinscripcion.component.css',
  standalone: false
})
export class ReinscripcionComponent implements OnInit {

  registerForm!: FormGroup;
  registerFormEmail!: FormGroup;
  codigo: String = "";
  guerrero!: Guerrero;
  displayStyle?: String = "none";
  displayBackgroudStyle?: String = "";
  tituloModal?: String;
  mensajeModal?: String;
  email!: string;
  campamentos?: Campamento[];
  id_campamento?: number;
  campamento?: Campamento;

  constructor(
    private formBuilder: FormBuilder,
    private registroDao: RegistroDao,
    private route: ActivatedRoute,
    private router: Router,
    private campamentoDao: CampamentoDao) {
    this.route.queryParams.subscribe(params => {
      this.codigo = params['code'];
    });
    this.validarCodigo();
  }
  ngOnInit(): void {
    this.loadCampamentos();
    this.loadCampamento();

    this.registerFormEmail = this.formBuilder.group({
      email: ["", Validators.required]
    });

    this.registerForm = this.formBuilder.group({
      codigo: ["", Validators.required]
    });
  }

  get form() {
    return this.registerForm?.controls;
  }

  get formEmail() {
    return this.registerFormEmail?.controls;
  }

  validarCodigo() {
    this.registroDao.validarCodigo(this.codigo).subscribe(
      result => {
        this.guerrero = result.resultado
      });
  }

  validarEmail() {
    this.registroDao.validarEmail(this.email, this.id_campamento!).subscribe(
      result => {
        this.mensajeModal = result.mensaje;
        this.tituloModal = "Reinscripción";
        this.openPopup();
      }
    );
  }

  openPopup() {
    this.displayBackgroudStyle = "loading";
    this.displayStyle = "block";
  }

  closePopup() {
    this.displayBackgroudStyle = "";
    this.displayStyle = "none";
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
