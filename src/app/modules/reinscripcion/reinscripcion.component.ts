import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
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
  codigo: String = "43fds-243f4-4e244";
  guerrero!: Guerrero;

  constructor(
    private formBuilder: FormBuilder,
    private registroDao: RegistroDao) {
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

}
