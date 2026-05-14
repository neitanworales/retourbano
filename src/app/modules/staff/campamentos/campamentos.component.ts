import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { Event } from 'src/app/core/models/registro/Event';

@Component({
  selector: 'app-campamentos',
  templateUrl: './campamentos.component.html',
  styleUrl: './campamentos.component.css',
  standalone: false
})
export class CampamentosComponent implements OnInit {

  constructor(
    public eventDao: EventDao,
    private formBuilder: FormBuilder) { }

  columnsToDisplay = [
    'botonera',
    'id_event',
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

  dataSource?: Event[];
  eventoActivo = new Event();
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
      email_contacto: ["", Validators.required],
      llegada_lugar: ["", Validators.required],
      llegada_coordenadas: ["", Validators.required],
      llegada_nota: ["", Validators.required],
      salida_lugar: ["", Validators.required],
      salida_coordenadas: ["", Validators.required],
      salida_nota: ["", Validators.required]
    });
  }

  cargarDatos() {
    this.eventDao.getEvents().subscribe(
      response => {
        this.dataSource = response.resultado;
      }
    );

    this.eventDao.getEventActivo().subscribe(
      response => {
        console.log(response.resultado![0]);
        this.eventoActivo = response.resultado![0];
        console.log(this.eventoActivo);
        this.eventoForm.patchValue(this.eventoActivo);
      }
    );
  }
}