import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
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

  constructor(
    private formBuilder: FormBuilder,
    private registroDao: RegistroDao,
    private route: ActivatedRoute,
    private router: Router) {
    this.route.queryParams.subscribe(params => {
      this.codigo = params['code'];
    });
    this.validarCodigo();
  }
  ngOnInit(): void {
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
    this.registroDao.validarEmail(this.email).subscribe(
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

}
