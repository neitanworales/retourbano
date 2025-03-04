import { APP_BASE_HREF } from '@angular/common';
import { Component, Inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
    selector: 'app-registro-dinamico',
    templateUrl: './registro-dinamico.component.html',
    styleUrls: ['./registro-dinamico.component.css'],
    standalone: false
})
export class RegistroDinamicoComponent {

  constructor(
    private formBuilder: FormBuilder) {
     
    }

  step: number =1;
  tutor: boolean = false;
  mayorEdad: Boolean = false;

  setStep(step : number){
    this.step = step;
  }

  setTutor(t:boolean){
    this.tutor  = t;
    this.step = this.step+1;
  }

  setMayorEdad(mayor:boolean){
    this.mayorEdad = mayor;
    this.step = this.step+1;
  }

  components : FormGroup[] = [this.createRegisterForm()];

  addComponent(){
    this.components.push(this.createRegisterForm());
  }

  createRegisterForm(){
    return this.formBuilder.group({
      nombre: ["", Validators.required],
      nick: ["", Validators.required],
      sexo: ["", Validators.required],

      year: [0, Validators.min(1)],
      month: [0, Validators.min(1)],
      day: [0, Validators.min(1)],

      talla: ["", Validators.required],
      vienesDe: ["", Validators.required],
      razones: ["", Validators.required],
      tutorNombre: ["", Validators.required],
      tutorTelefono: ["", Validators.required],
      email: ["", Validators.required],
      whatsapp: ["", Validators.required],
      aceptaPoliticas: [false, Validators.requiredTrue],
    });
  }
}
