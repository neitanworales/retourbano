import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { RegistroDao } from 'src/app/api/dao/RegistroDao';
import { Guerrero } from 'src/app/models/registro/Guerrero';

@Component({
  selector: 'app-reinscripcion',
  templateUrl: './reinscripcion.component.html',
  styleUrl: './reinscripcion.component.css',
  standalone: false
})
export class ReinscripcionComponent implements OnInit {

  registerForm!: FormGroup;
  codigo: String = "";
  guerrero!: Guerrero;
  displayStyle?: String = "none";
  tituloModal?: String;
  mensajeModal?: String;

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
    this.registerForm = this.formBuilder.group({
      codigo: ["", Validators.required]
    });
  }

  get form() {
    return this.registerForm?.controls;
  }

  validarCodigo() {
    this.registroDao.validarCodigo(this.codigo).subscribe(
      result => {
        this.guerrero = result.resultado
      });
  }

  openPopup() {
    this.displayStyle = "block";
  }

  closePopup() {
    this.displayStyle = "none";
    this.router.navigate(['/']);
  }

}
