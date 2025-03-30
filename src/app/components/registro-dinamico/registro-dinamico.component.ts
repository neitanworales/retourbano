import { APP_BASE_HREF } from '@angular/common';
import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';

@Component({
  selector: 'app-registro-dinamico',
  templateUrl: './registro-dinamico.component.html',
  styleUrls: ['./registro-dinamico.component.css'],
  standalone: false
})
export class RegistroDinamicoComponent implements OnInit {

  registerForm!: FormGroup;
  step: number = 1;
  tutor: boolean = false;
  email!: string;
  activarInscripcion: boolean = false;
  activarReinscripcion: boolean = false;
  displayStyle?: String = "none";
  tituloModal?: String;
  mensajeModal?: String;

  constructor(
    private registroDao: RegistroDao,
    private formBuilder: FormBuilder,
    private router: Router) {
  }

  ngOnInit(): void {
    this.registerForm = this.formBuilder.group({
      email: ["", Validators.required]
    });
  }

  setStep(step: number) {
    this.step = step;
  }

  setActivacion(t: boolean, reinscripcion: boolean) {
    this.tutor = t;
    this.step = this.step + 1;
    this.activarInscripcion = !reinscripcion;
    this.activarReinscripcion = reinscripcion;
  }

  validarEmail() {
    this.registroDao.validarEmail(this.email).subscribe(
      result => {
        this.mensajeModal = result.mensaje;
        this.tituloModal = "Reinscripcion";
        this.openPopup();
      }
    );
  }

  get form() {
    return this.registerForm?.controls;
  }

  openPopup() {
    this.displayStyle = "block";
  }

  closePopup() {
    this.displayStyle = "none";
    this.router.navigate(['/reinscripcion']);
  }
}
