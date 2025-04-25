import { Component, Input, OnInit, SimpleChanges } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { Guerrero } from 'src/app/core/models/registro/Guerrero';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToRegister } from 'src/app/core/models/registro/ToRegister';
import { Tutor } from 'src/app/core/models/registro/Tutor';

@Component({
  selector: 'app-registro-form',
  templateUrl: './registro-form.component.html',
  styleUrls: ['./registro-form.component.css'],
  standalone: false
})
export class RegistroFormComponent implements OnInit {

  @Input()
  guerreroToEdit!: Guerrero;

  @Input()
  saveInMemory!: boolean;

  registerForm!: FormGroup;

  actualizar: boolean = false;
  model = new Guerrero();

  submitted = false;

  displayStyle?: String = "none";
  displayCommentsStyle?: String = "block";
  displayBackgroudStyle?: String = "";
  errorRegistro?: boolean;
  mensajesRegistros!: String[];

  paraRegistrar!: Guerrero[];

  constructor(
    private formBuilder: FormBuilder,
    public registroDao: RegistroDao,
    private router: Router) {
    this.mensajesRegistros = new Array();
  }

  ngOnChanges(changes: SimpleChanges) {
    if (this.guerreroToEdit != undefined) {
      this.actualizar = true;
      this.model = this.guerreroToEdit;
      const dateString = this.guerreroToEdit.fechaNac + "";
      this.model.year = Number(dateString?.substring(0, 4));
      this.model.month = Number(dateString?.substring(5).substring(0, 2));
      this.model.day = Number(dateString?.substring(8));
      this.model.aceptaPoliticas = false;
    }
  }

  ngOnInit(): void {
    if (!this.actualizar) {
      this.model.sexo = "";      
      this.model.hospedaje = null;
      this.model.year = 0;
      this.model.month = 0;
      this.model.day = 0;
    } 
    this.model.talla = "";
    this.model.alergias = "";
    this.model.medicamentos = "";
    this.model.razones = "";

    /*this.model.nombre = "Jesús de Veracruz";
    this.model.nick = "Mr. Corleone";
    this.model.sexo = "M";
    this.model.year = 2001;
    this.model.month = 1;
    this.model.day = 1;
    this.model.talla = "XL";
    this.model.vienesDe = "CMDX";
    this.model.razones = "El Rich me obliga";
    this.model.tutorNombre = "Carlos Nopal";
    this.model.tutorTelefono = "759783493";
    this.model.email = "neitan.morales@gmail.com";
    this.model.whatsapp = "2423423423423";
    this.model.telefono = "2423423423423";
    this.model.alergias = "A las bombas atómicas";
    this.model.medicamentos = "Una pastilla de besos cada 2 horas";
    this.model.aceptaPoliticas = true;
    this.model.facebook = "No tengo brother";
    this.model.instagram = "Para que o que?";
    this.model.iglesia = "La sagrada familia"*/

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
    let now = new Date();

    if (this.model.year !== undefined) {
      this.model.edad = now.getFullYear() - this.model.year;
    }

    if (this.model.month !== undefined) {
      if (this.model.month < now.getMonth()) {
        this.model.edad = (this.model.edad!) - 1;
      }
    }

    if (this.model.year !== undefined && this.model.month !== undefined && this.model.day !== undefined) {
      this.model.fechaNac = new Date(this.model.year + '/' + this.model.month + '/' + this.model.day);
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
      tutor.tutorEmail = this.model.email;
      tutor.tutorNombre = this.model.tutorNombre;
      tutor.tutorTelefono = this.model.tutorTelefono;
      this.submitted = false;
      this.registerForm?.reset();
      this.registerForm.controls['email'].setValue(tutor.tutorEmail);
      this.registerForm.controls['tutorNombre'].setValue(tutor.tutorNombre);
      this.registerForm.controls['tutorTelefono'].setValue(tutor.tutorTelefono);
      this.loadListaParaRegistrar();
    } else {
      this.registroDao.agregarGuerrero(this.model, this.saveInMemory).subscribe(
        result => {
          this.errorRegistro = result.error;
          this.mensajesRegistros.push(result.mensaje!);
          this.openPopup();
        }
      );
    }
  }

  registrarBatch() {
    this.paraRegistrar.forEach(async (warrior) => {
      this.registroDao.agregarGuerrero(warrior, this.saveInMemory).subscribe(
        result => {
          this.errorRegistro = result.error;
          this.mensajesRegistros.push(result.mensaje!);
        }
      );
    });
    if (!this.errorRegistro) {
      this.limpiarLista();
    }
    this.openPopup();
  }

  updateGuerrero() {
    this.registroDao.updateGuerrero(this.model).subscribe(
      result => {
        this.errorRegistro = result.error;
        this.mensajesRegistros.push(result.mensaje!);
        this.openPopup();
      }
    );
  }

  get form() {
    return this.registerForm?.controls;
  }

  onSubmit() {
    this.submitted = true;
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
      this.router.navigate(['/info']);
    } else {
      // ??
    }
  }
}

function moment(arg0: any) {
  throw new Error('Function not implemented.');
}

