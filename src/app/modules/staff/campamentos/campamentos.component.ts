import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { CampamentoDao } from 'src/app/core/api/dao/CampamentoDao';
import { Campamento } from 'src/app/core/models/registro/Campamento';

@Component({
  selector: 'app-campamentos',
  templateUrl: './campamentos.component.html',
  //styleUrl: './campamentos.component.css',
  standalone: false
})
export class CampamentosComponent implements OnInit {

  constructor(
    public campaDao: CampamentoDao,
    private formBuilder: FormBuilder) { }

  columnsToDisplay = [
    'botonera',
    'id_campamento',
    'titulo',
    'fecha_inicio',
    'fecha_termino',
    'activo',
    'maximo_inscr',
    'umbral',
    'fecha_apertura',
    'fecha_maxima',
    'costo'
  ];

  dataSource?: Campamento[];
  eventoActivo = new Campamento();
  eventoForm!: FormGroup;

  ngOnInit(): void {
    this.inicializarForm();
    this.cargarDatos();
  }

  inicializarForm() {
    this.eventoForm = this.formBuilder.group({
      id_campamento: ["", Validators.required],
      titulo: ["", Validators.required],
      fecha_inicio: ["", Validators.required],
      fecha_termino: ["", Validators.required],
      activo: [""],
      maximo_inscr: ["", Validators.required],
      umbral: ["", Validators.required],
      fecha_maxima: ["", Validators.required],
      fecha_apertura: ["", Validators.required],
      pago_minimoMX: ["", Validators.required],
      banco: ["", Validators.required],
      cuenta: ["", Validators.required],
      titularCuenta: ["", Validators.required],
      contacto1: ["", Validators.required],
      contacto2: ["", Validators.required],
    });
  }

  cargarDatos() {
    this.campaDao.getCampamentos().subscribe(
      response => {
        this.dataSource = response.resultado;
      }
    );

    this.campaDao.getCampamentoActivo().subscribe(
      response => {
        console.log(response.resultado![0]);
        this.eventoActivo = response.resultado![0];
        console.log(this.eventoActivo);
        this.eventoForm.patchValue(this.eventoActivo);
      }
    );
  }
}