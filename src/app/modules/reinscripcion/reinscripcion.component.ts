import { Component, ElementRef, Input, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { map, filter, tap, switchMap } from 'rxjs';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { Event } from 'src/app/core/models/registro/Event';
import { EventRegistration } from 'src/app/core/models/registro/EventRegistration';
import { User } from 'src/app/core/models/registro/User';

@Component({
  selector: 'app-reinscripcion',
  templateUrl: './reinscripcion.component.html',
  styleUrl: './reinscripcion.component.css',
  standalone: false
})
export class ReinscripcionComponent implements OnInit {

  @ViewChild('codigoInput') codigoInput?: ElementRef<HTMLInputElement>;

  registerForm!: FormGroup;
  registerFormEmail!: FormGroup;
  codigo: String = "";
  user!: User;
  existingRegistration?: EventRegistration;
  alreadyRegisteredInEvent = false;
  registrationNotice = '';
  displayStyle?: String = "none";
  displayBackgroudStyle?: String = "";
  tituloModal?: String;
  mensajeModal?: String;
  email!: string;
  events?: Event[] = [];
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
    const invalidCodeMessage = 'No fue posible validar el codigo para el evento seleccionado.';
    const eventId = this.id_event || this.event?.id;
    if (!eventId) {
      this.registrationNotice = 'Necesitas seleccionar un evento antes de validar el codigo.';
      this.alreadyRegisteredInEvent = false;
      return;
    }

    this.registroDao.validarCodigo(this.codigo, eventId).subscribe(
      result => {
        if (result.error || !result.resultado || !result.resultado.id) {
          this.user = undefined as any;
          this.existingRegistration = undefined;
          this.alreadyRegisteredInEvent = false;
          this.registrationNotice = '';
          this.codigo = '';
          this.registerForm?.controls['codigo']?.setValue('');
          this.tituloModal = 'Reinscripción';
          this.mensajeModal = invalidCodeMessage;
          this.openPopup();
          return;
        }

        this.user = result.resultado;
        this.alreadyRegisteredInEvent = !!result.already_registered;
        this.existingRegistration = result.registration;

        if (this.alreadyRegisteredInEvent) {
          this.registrationNotice = 'Ya estabas inscrito en este evento. Cargamos tus datos actuales para que puedas actualizarlos y reenviar tu reinscripcion.';
        } else {
          this.registrationNotice = 'Codigo valido. Completa los datos para finalizar tu reinscripcion al evento seleccionado.';
        }
      },
      () => {
        this.user = undefined as any;
        this.existingRegistration = undefined;
        this.alreadyRegisteredInEvent = false;
        this.registrationNotice = '';
        this.codigo = '';
        this.registerForm?.controls['codigo']?.setValue('');
        this.tituloModal = 'Reinscripción';
        this.mensajeModal = invalidCodeMessage;
        this.openPopup();
      });
  }

  validarEmail() {
    const eventId = this.id_event || this.event?.id;
    if (!eventId) {
      this.tituloModal = "Reinscripción";
      this.mensajeModal = "Selecciona un evento antes de solicitar el código.";
      this.openPopup();
      return;
    }

    this.registroDao.validarEmail(this.email, eventId).subscribe(
      result => {
        this.mensajeModal = result.message;
        this.tituloModal = "Reinscripción";
        this.openPopup();
      },
      (error) => {
        this.tituloModal = "Reinscripción";
        this.mensajeModal = error?.error?.message || error?.error?.mensaje || "No se pudo validar el correo. Intenta nuevamente.";
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

    if (!this.user) {
      setTimeout(() => {
        this.codigoInput?.nativeElement?.focus();
      }, 0);
    }
  }

  private loadEvent() {
    this.route.queryParamMap
      .pipe(
        map((params: ParamMap) => {
          const idEvent = Number(params.get('id_event'));
          if (!isNaN(idEvent) && idEvent > 0) {
            return idEvent;
          }

          const idCampamento = Number(params.get('id_campamento'));
          return idCampamento;
        }),
        filter((id) => !isNaN(id) && id > 0),
        tap((id) => {
          this.id_event = id;
        }),
        switchMap((id) => this.eventDao.getEventInfo(id))
      )
      .subscribe({
        next: (result) => {
          this.event = result.data?.events?.[0];
          this.id_event = this.event?.id || this.id_event;
          if (this.codigo) {
            this.validarCodigo();
          }
        },
        error: (error) => {
          console.error('Error al cargar campamento:', error);
        }
      });
    console.log('Campamento', this.event);
  }

  private loadCampamentos() {
    this.eventDao.getEventActivo('BASIC').subscribe({
      next: (result) => {
        this.events = result.data?.events || [];
        this.event = result.data?.events?.[0];
      },
      error: (error) => {
        console.error('Error al cargar campamentos:', error);
      }
    });
  }
}
