import { Component, Input, OnInit, SimpleChanges } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { User } from 'src/app/core/models/registro/User';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToRegister } from 'src/app/core/models/registro/ToRegister';
import { Tutor } from 'src/app/core/models/registro/Tutor';
import { Event } from 'src/app/core/models/registro/Event';
import { EventRegistration } from 'src/app/core/models/registro/EventRegistration';

@Component({
  selector: 'app-registro-form',
  templateUrl: './registro-form.component.html',
  styleUrls: ['./registro-form.component.css'],
  standalone: false
})
export class RegistroFormComponent implements OnInit {

  @Input()
  userToEdit!: User;

  @Input()
  registrationToEdit?: EventRegistration;

  @Input({ required: true })
  saveInMemory!: boolean;

  @Input({ required: true })
  event!: Event;

  registerForm!: FormGroup;

  actualizar: boolean = false;
  model = new EventRegistration();

  submitted = false;
  birthDateInvalid = false;

  displayStyle?: String = "none";
  displayCommentsStyle?: String = "block";
  displayBackgroudStyle?: String = "";
  errorRegistro?: boolean;
  mensajesRegistros!: String[];

  paraRegistrar!: User[];

  constructor(
    private formBuilder: FormBuilder,
    public registroDao: RegistroDao,
    private router: Router) {
    this.mensajesRegistros = new Array();
  }

  ngOnChanges(changes: SimpleChanges) {
    this.ensureUserModel();
    if (this.userToEdit != undefined) {
      this.actualizar = true;
      if (this.registrationToEdit) {
        this.model = { ...this.registrationToEdit };
      }

      this.model.user = this.userToEdit;
      this.ensureUserModel();

      if (this.registrationToEdit) {
        this.model.razones = this.registrationToEdit.razones ?? this.registrationToEdit.reasons ?? this.model.razones;
        this.model.reasons = this.model.razones;
        const requires_lodging = this.registrationToEdit.requires_lodging ?? this.registrationToEdit.requires_lodging ?? this.registrationToEdit.requires_lodging;
        this.model.requires_lodging = typeof requires_lodging === 'boolean' ? requires_lodging : !!requires_lodging;
      }

      const dateString = this.userToEdit.fechaNac + "";
      this.model.user!.year = Number(dateString?.substring(0, 4));
      this.model.user!.month = Number(dateString?.substring(5).substring(0, 2));
      this.model.user!.day = Number(dateString?.substring(8));
      this.model.user!.aceptaPoliticas = false;
      this.calculateEdad();
    }
  }

  ngOnInit(): void {
    this.ensureUserModel();
    if (!this.actualizar) {
      this.model.user!.sexo = "";      
      this.model.requires_lodging = true;
      this.model.user!.year = 0;
      this.model.user!.month = 0;
      this.model.user!.day = 0;
    } 
    if (!this.model.user!.talla) {
      this.model.user!.talla = "";
    }
    if (!this.model.user!.alergias) {
      this.model.user!.alergias = "";
    }
    if (!this.model.user!.medicamentos) {
      this.model.user!.medicamentos = "";
    }
    if (!this.model.razones) {
      this.model.razones = "";
    }

   /* 
    this.model.user!.nombre = "Jesús de Veracruz";
    this.model.user!.nick = "Mr. Corleone";
    this.model.user!.sexo = "M";
    this.model.user!.year = 2001;
    this.model.user!.month = 1;
    this.model.user!.day = 1;
    this.model.user!.talla = "XL";
    this.model.user!.vienesDe = "CMDX";
    this.model.razones = "Por mandato divino del yich";
    this.model.user!.tutorNombre = "Carlos Nopal";
    this.model.user!.tutorTelefono = "759783493";
    this.model.user!.email = "prueba.registro_1118@yopmail.com";
    this.model.user!.whatsapp = "2423423423423";
    this.model.user!.telefono = "2423423423423";
    this.model.user!.alergias = "A las bombas atómicas";
    this.model.user!.medicamentos = "Una pastilla de besos cada 2 horas";
    this.model.user!.aceptaPoliticas = true;
    this.model.user!.facebook = "No tengo brother";
    this.model.user!.instagram = "Para que o que?";
    this.model.user!.iglesia = "La sagrada familia";
    */

    this.registerForm = this.formBuilder.group({
      nombre: ["", Validators.required],
      nick: ["", Validators.required],
      sexo: ["", Validators.required],

      year: [0, Validators.min(1)],
      month: [0, Validators.min(1)],
      day: [0, Validators.min(1)],

      talla: ["", Validators.required],
      hospedaje: ["", Validators.required],
      vienesDe: ["", Validators.required],
      razones: ["", Validators.required],
      tutorNombre: ["", Validators.required],
      tutorTelefono: ["", Validators.required],
      email: ["", Validators.required],
      whatsapp: [""],
      telefono: ["", Validators.required],
      aceptaPoliticas: [false, Validators.requiredTrue],
    });

    this.loadListaParaRegistrar();
  }

  loadListaParaRegistrar() {
    var objectRegister = JSON.parse(localStorage.getItem('toRegister')!) as ToRegister;
    console.log(objectRegister);
    if (objectRegister == null) {
      objectRegister = new ToRegister();
    }
    this.paraRegistrar = objectRegister.guerreros;
  }

  quitarDeLaLista(i: number) {
    var objectRegister = JSON.parse(localStorage.getItem('toRegister')!) as ToRegister;
    if (objectRegister != null) {
      objectRegister.guerreros.splice(i, 1);
      localStorage.setItem('toRegister', JSON.stringify(objectRegister));
      this.loadListaParaRegistrar();
    }
  }

  limpiarLista() {
    var objectRegister = new ToRegister();
    objectRegister.guerreros = new Array();
    localStorage.setItem('toRegister', JSON.stringify(objectRegister));
    this.loadListaParaRegistrar();
  }

  calculateEdad() {
    this.ensureUserModel();

    const year = Number(this.model.user!.year);
    const month = Number(this.model.user!.month);
    const day = Number(this.model.user!.day);

    if (!year || !month || !day) {
      this.birthDateInvalid = false;
      this.model.user!.edad = undefined;
      this.model.user!.fechaNac = undefined;
      return;
    }

    const birthDate = new Date(year, month - 1, day);
    const isValidDate =
      birthDate.getFullYear() === year &&
      birthDate.getMonth() === month - 1 &&
      birthDate.getDate() === day;

    if (!isValidDate) {
      this.birthDateInvalid = true;
      this.model.user!.edad = undefined;
      this.model.user!.fechaNac = undefined;
      return;
    }

    this.birthDateInvalid = false;

    const today = new Date();
    let age = today.getFullYear() - year;
    const currentMonth = today.getMonth() + 1;
    const hasNotHadBirthday = month > currentMonth || (month === currentMonth && day > today.getDate());

    if (hasNotHadBirthday) {
      age -= 1;
    }

    this.model.user!.edad = age;
    this.model.user!.fechaNac = birthDate;
  }

  private ensureUserModel() {
    if (!this.model.user) {
      this.model.user = new User();
    }
  }

  newGuerrero() {
    this.calculateEdad();
    if (this.saveInMemory) {
      var objectRegister = JSON.parse(localStorage.getItem('toRegister')!) as ToRegister;
      if (objectRegister == null) {
        objectRegister = new ToRegister();
      }
      objectRegister.guerreros.push(this.model);
      localStorage.setItem('toRegister', JSON.stringify(objectRegister));
      console.log(localStorage.getItem('toRegister'));
      var tutor = new Tutor();
      tutor.tutorEmail = this.model.user!.email;
      tutor.tutorNombre = this.model.user!.tutorNombre;
      tutor.tutorTelefono = this.model.user!.tutorTelefono;
      this.submitted = false;
      this.registerForm?.reset();
      this.registerForm.controls['email'].setValue(tutor.tutorEmail);
      this.registerForm.controls['tutorNombre'].setValue(tutor.tutorNombre);
      this.registerForm.controls['tutorTelefono'].setValue(tutor.tutorTelefono);
      this.loadListaParaRegistrar();
    } else {
      this.registroDao.agregarGuerrero(this.model, this.saveInMemory, this.event.id!).subscribe(
        result => {
          this.errorRegistro = result.error;
          this.mensajesRegistros.push(result.message!);
          this.openPopup();
        }
      );
    }
  }

  registrarBatch() {
    this.paraRegistrar.forEach(async (warrior) => {
      this.registroDao.agregarGuerrero(warrior, this.saveInMemory, this.event.id!).subscribe(
        result => {
          this.errorRegistro = result.error;
          this.mensajesRegistros.push(result.message!);
        }
      );
    });
    if (!this.errorRegistro) {
      this.limpiarLista();
    }
    this.openPopup();
  }

  updateGuerrero() {
    this.registroDao.updateGuerrero(this.model, this.event.id!).subscribe(
      result => {
        this.errorRegistro = result.error;
        this.mensajesRegistros.push(result.message!);
        this.openPopup();
      }
    );
  }

  get form() {
    return this.registerForm?.controls;
  }

  onSubmit() {
    this.submitted = true;
    this.calculateEdad();

    if (this.birthDateInvalid) {
      return;
    }

    if (this.actualizar) {
      this.updateGuerrero();
    } else {
      if (this.registerForm?.invalid) {
        return;
      }
      this.newGuerrero();
    }
  }

  onReset() {
    this.submitted = false;
    this.registerForm?.reset();
  }

  openPopup() {
    if(this.errorRegistro){
      this.displayCommentsStyle = 'none';
    } else {
      this.displayCommentsStyle = 'block';
    }
    this.displayStyle = "block";
    this.displayBackgroudStyle = "loading";
  }

  closePopup() {
    this.displayStyle = "none";
    this.displayBackgroudStyle = "";
    this.mensajesRegistros = new Array();
    if (!this.errorRegistro && !this.actualizar) {
      this.router.navigate(['/info'], { queryParams: { id_event: this.event.id } });
    } else {
      // ??
    }
  }
}

function moment(arg0: any) {
  throw new Error('Function not implemented.');
}

