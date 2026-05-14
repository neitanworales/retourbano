import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { map, filter, tap, switchMap } from 'rxjs';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { Event } from 'src/app/core/models/registro/Event';
import { User } from 'src/app/core/models/registro/User';

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
  guerrero!: User;
  displayStyle?: String = "none";
  displayBackgroudStyle?: String = "";
  tituloModal?: String;
  mensajeModal?: String;
  email!: string;
  events?: Event[];
  id_event?: number;
  event?: Event;

  constructor(
    private formBuilder: FormBuilder,
    private registroDao: RegistroDao,
    private route: ActivatedRoute,
    private router: Router,
    private eventDao: EventDao) {
    this.route.queryParams.subscribe(params => {
      this.codigo = params['code'];
    });
    this.validarCodigo();
  }
  ngOnInit(): void {
    this.loadCampamentos();
    this.loadEvent();

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
    this.registroDao.validarEmail(this.email, this.id_event!).subscribe(
      result => {
        this.mensajeModal = result.message;
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

  private loadEvent() {
    this.route.queryParamMap
      .pipe(
        map((params: ParamMap) => Number(params.get('id_event'))),
        filter((id) => !isNaN(id) && id > 0),
        tap((id) => {
          this.id_event = id;
        }),
        switchMap((id) => this.eventDao.getEventInfo(id))
      )
      .subscribe({
        next: (result) => {
          this.event = result.data?.events?.[0];
        },
        error: (error) => {
          console.error('Error al cargar campamento:', error);
        }
      });
    console.log('Campamento', this.event);
  }

  private loadCampamentos() {
    this.eventDao.getEventActivo().subscribe({
      next: (result) => {
        this.event = result.data?.events?.[0];
      },
      error: (error) => {
        console.error('Error al cargar campamentos:', error);
      }
    });
  }
}
