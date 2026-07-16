import { DatePipe } from '@angular/common';
import { Component, Input, OnInit } from '@angular/core';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { Habitacion } from 'src/app/core/models/hospedaje/Habitacion';
import { HospedajeTable } from 'src/app/core/models/hospedaje/HospedajeTable';
import { EventRegistration } from 'src/app/core/models/registro/EventRegistration';
import { Event } from 'src/app/core/models/registro/Event';
import * as XLSX from 'xlsx';
import { AuthService } from 'src/app/core/services/auth.service';

@Component({
  selector: 'app-hospedajes',
  templateUrl: './hospedajes.component.html',
  styleUrl: './hospedajes.component.css',
  standalone: false,
  providers: [DatePipe],
})
export class HospedajesComponent implements OnInit {

  readonly hospedajeSortOptions = [
    { value: '', label: 'Ordenar por' },
    { value: 'habitacion', label: 'Habitacion' },
    { value: 'sexo', label: 'Sexo' },
    { value: 'edad', label: 'Edad' },
  ];

  @Input() selectedEvento?: Event;

  tabsCampas?: boolean[];

  pageHabitaciones: boolean = true;
  pageHospedajes!: boolean;
  pageNoHospedajes!: boolean;

  pageHabitacionesDisplayStyle = 'block';
  pageHospedajesDisplayStyle = 'none';

  hospedajes: HospedajeTable[] = new Array();
  private allHospedajes: HospedajeTable[] = new Array();
  habitaciones: Habitacion[] = new Array();
  personasSinHabitacion: EventRegistration[] = new Array();

  roomFilter = '';
  genderFilter = '';
  ageMin?: number | null = null;
  ageMax?: number | null = null;
  sortBy = '';
  sortDirection: 'asc' | 'desc' = 'asc';

  // Loading states
  cargandoHabitaciones = false;
  cargandoHospedajes = false;
  guardando = false;

  // Error messages
  errorHabitaciones: string | null = null;
  errorHospedajes: string | null = null;

  columnsToDisplay = [
    'nombre',
    'confirmado',
    'asistencia',
    'hospedaje',
    'sexo',
    'edad',
    'habitacion'
  ];

  constructor(
    private registroDao: RegistroDao,
    private datePipe: DatePipe, 
    private eventDao: EventDao,
    private authService: AuthService
  ) {

  }

  ngOnInit(): void {
    this.cargarDatosHabitaciones();
  }

  private cargarDatosHospedajes() {
    this.cargandoHospedajes = true;
    this.errorHospedajes = null;

    this.registroDao.obtenerHospedajes(this.pageHospedajes, this.selectedEvento?.id!).subscribe(
      result => {
        if (!result.success) {
          this.errorHospedajes = result.message || 'Error al cargar hospedajes';
          console.error('Error loading hospedajes:', result.message);
        } else {
          console.log('Hospedajes obtenidos del backend:', result.data?.registrations);
          this.allHospedajes = result.data?.registrations?.map(reg => {
            const hospedajeTable = new HospedajeTable();
            hospedajeTable.id = reg.id;
            hospedajeTable.nombre = reg.user?.full_name;
            hospedajeTable.confirmado = reg.is_confirmed;
            hospedajeTable.asistencia = reg.attendance_confirmed;
            hospedajeTable.hospedaje = reg.requires_lodging;
            hospedajeTable.sexo = reg.user?.gender || '';
            hospedajeTable.edad = reg.user?.age;
            hospedajeTable.habitacion = reg.room_code || '';
            hospedajeTable.is_staff = reg.is_staff;
            hospedajeTable.is_admin = reg.is_admin;
            return hospedajeTable;
          }) || [];

          console.log('Hospedajes cargados:', this.allHospedajes);

          this.allHospedajes.map((p) => {
            p.editar = false;
            return p;
          });
          this.applyHospedajeFilters();
          this.errorHospedajes = null;
        }
        this.cargandoHospedajes = false;
      },
      error => {
        this.errorHospedajes = 'Error al conectar con el servidor';
        console.error('HTTP Error loading hospedajes:', error);
        this.cargandoHospedajes = false;
      }
    );
  }

  cargarHabitaciones() {
    this.cargarDatosHabitaciones();
  }

  private cargarDatosHabitaciones() {
    this.cargandoHabitaciones = true;
    this.errorHabitaciones = null;

    this.registroDao.obtenerHabitaciones(this.selectedEvento?.id!).subscribe(
      result => {
        if (!result.success) {
          this.errorHabitaciones = result.message || 'Error al cargar habitaciones';
          console.error('Error loading habitaciones:', result.message);
          this.habitaciones = [];
        } else {
          console.log('Habitaciones obtenidas del backend:', result.resultado);
          this.habitaciones = result.resultado;
          this.errorHabitaciones = null;
          console.log('Habitaciones cargadas:', this.habitaciones);
        }
        this.cargandoHabitaciones = false;
      },
      error => {
        this.errorHabitaciones = 'Error al conectar con el servidor';
        console.error('HTTP Error loading habitaciones:', error);
        this.habitaciones = [];
        this.cargandoHabitaciones = false;
      }
    );

    this.registroDao.obtenerPersonasSinHabitacion(this.selectedEvento?.id!).subscribe(
      result => {
        if (result.error) {
          console.error('Error loading unassigned people:', result.message);
          this.personasSinHabitacion = [];
        } else {
          this.personasSinHabitacion = result.personas || [];
        }
      },
      error => {
        console.error('HTTP Error loading unassigned people:', error);
        this.personasSinHabitacion = [];
      }
    );
  }

  editar(hosp: HospedajeTable) {
    hosp.editar = !hosp.editar;
    if (hosp.editar) {
      hosp.habitacionOldValue = hosp.habitacion;
    } else {
      hosp.habitacion = hosp.habitacionOldValue;
    }
  }

  guardar(hosp: HospedajeTable) {
    if (!hosp.id || !hosp.habitacion) {
      alert('ID o habitación no válidos');
      return;
    }

    this.guardando = true;
    this.registroDao.actualizarHabitacion(hosp.id, hosp.habitacion, this.selectedEvento?.id!).subscribe(
      result => {
        if (result.error) {
          alert('Error: ' + (result.message || 'No se pudo actualizar la habitación'));
          hosp.habitacion = hosp.habitacionOldValue;
        } else {
          alert('Habitación actualizada correctamente');
        }
        hosp.editar = false;
        this.guardando = false;
      },
      error => {
        console.error('Error updating room assignment:', error);
        alert('Error al conectar con el servidor');
        hosp.habitacion = hosp.habitacionOldValue;
        hosp.editar = false;
        this.guardando = false;
      }
    );
  }

  editarHospedaje(hosp: HospedajeTable) {
    hosp.editarHospedaje = !hosp.editarHospedaje;
    if (hosp.editar) {
      hosp.hospedajeOldValue = hosp.hospedajeOldValue;
    } else {
      hosp.hospedaje = hosp.hospedajeOldValue;
    }
  }

  guardarHospedaje(hosp: HospedajeTable) {
    if (!hosp.id || hosp.hospedaje === undefined || hosp.hospedaje === null) {
      alert('ID o valor de hospedaje no válidos');
      return;
    }

    this.guardando = true;
    this.registroDao.actualizarHospedaje(hosp.id, hosp.hospedaje, this.selectedEvento?.id!).subscribe(
      result => {
        if (result.error) {
          alert('Error: ' + (result.message || 'No se pudo actualizar el hospedaje'));
          hosp.hospedaje = hosp.hospedajeOldValue;
        } else {
          alert('Hospedaje actualizado correctamente');
        }
        hosp.editarHospedaje = false;
        this.guardando = false;
      },
      error => {
        console.error('Error updating lodging requirement:', error);
        alert('Error al conectar con el servidor');
        hosp.hospedaje = hosp.hospedajeOldValue;
        hosp.editarHospedaje = false;
        this.guardando = false;
      }
    );
  }

  exportToExcel() {
    let myDate = new Date();
    let dateString = this.datePipe.transform(myDate, 'YYYY_MM_dd_HHmmss');
    let fileName = 'HOSPEDAJE_RU_2025_' + dateString + '.xlsx';
    /* pass here the table id */
    //let element = document.getElementById('excel-table');
    //const ws: XLSX.WorkSheet =XLSX.utils.table_to_sheet(element);

    const ws: XLSX.WorkSheet = XLSX.utils.json_to_sheet(this.hospedajes!);

    /* generate workbook and add the worksheet */
    const wb: XLSX.WorkBook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Guerreros');

    const actorUserId = this.authService.getSessionValida()?.id;
    this.registroDao.registrarActividadStaff({
      action: 'exports.lodging_excel',
      summary: 'Exportacion de hospedaje a Excel',
      affected_user_id: actorUserId,
      entity_type: 'report',
      related_event_id: this.selectedEvento?.id,
      metadata: {
        file_name: fileName,
        rows: this.hospedajes?.length || 0,
        event_title: this.selectedEvento?.titulo || this.selectedEvento?.title || null,
      }
    }).subscribe({ error: () => undefined });

    /* save to file */
    XLSX.writeFile(wb, fileName);
  }

  cargarTodos() {
    this.roomFilter = '';
    this.genderFilter = '';
    this.ageMin = null;
    this.ageMax = null;
    this.sortBy = '';
    this.sortDirection = 'asc';
    this.cargarDatosHospedajes();
  }

  activarPageHabitaciones() {
    this.pageHospedajesDisplayStyle = 'none';
    this.pageHabitacionesDisplayStyle = 'block';
    this.pageHabitaciones = true;
    this.pageHospedajes = false;
    this.pageNoHospedajes = false;
    this.cargarDatosHabitaciones();
  }

  activarPageHospedajes() {
    this.pageHospedajesDisplayStyle = 'block';
    this.pageHabitacionesDisplayStyle = 'none';
    this.pageHabitaciones = false;
    this.pageHospedajes = true;
    this.pageNoHospedajes = false;
    this.cargarDatosHospedajes();
  }

  activarPageNoHospedajes() {
    this.pageHospedajesDisplayStyle = 'block';
    this.pageHabitacionesDisplayStyle = 'none';
    this.pageHabitaciones = false;
    this.pageHospedajes = false;
    this.pageNoHospedajes = true;
    this.cargarDatosHospedajes();
  }

  tabCampamentos(arg0: number) {
    this.tabsCampas = [false, false];
    this.tabsCampas[arg0] = true;
    this.selectedEvento = this.selectedEvento;
    console.log("Evento seleccionado: ", this.selectedEvento);
    console.log("ID evento seleccionado: ", this.selectedEvento?.id);
  }

  getGenderClass(gender?: string | String | null) {
    const normalizedGender = this.normalizeGender(gender);

    if (normalizedGender === 'M') {
      return 'persona-blue';
    }

    if (normalizedGender === 'F') {
      return 'persona-pink';
    }

    return '';
  }

  hasMixedGenderRoom(room?: Habitacion | null) {
    const genders = new Set(
      (room?.personas || [])
        .map((person) => this.normalizeGender(person.user?.gender || person.user?.sexo))
        .filter((gender) => gender === 'M' || gender === 'F')
    );

    return genders.size > 1;
  }

  getConflictingRooms() {
    return this.habitaciones.filter((room) => this.hasMixedGenderRoom(room));
  }

  getConflictingRoomsCount() {
    return this.getConflictingRooms().length;
  }

  getConflictingRoomNames() {
    return this.getConflictingRooms()
      .map((room) => room.habitacion || 'Sin numero')
      .join(', ');
  }

  hasMixedGenderByRoomCode(roomCode?: string | String | null) {
    const normalizedRoomCode = String(roomCode || '').trim().toLowerCase();

    if (!normalizedRoomCode) {
      return false;
    }

    const genders = new Set(
      this.allHospedajes
        .filter((item) => String(item.habitacion || '').trim().toLowerCase() === normalizedRoomCode)
        .map((item) => this.normalizeGender(item.sexo))
        .filter((gender) => gender === 'M' || gender === 'F')
    );

    return genders.size > 1;
  }

  private normalizeGender(gender?: string | String | null) {
    return String(gender || '').trim().toUpperCase();
  }

  applyHospedajeFilters() {
    let filtered = [...this.allHospedajes];
    const normalizedRoomFilter = this.roomFilter.trim().toLowerCase();
    const normalizedGenderFilter = this.genderFilter.trim().toUpperCase();

    if (normalizedRoomFilter) {
      filtered = filtered.filter((item) => String(item.habitacion || '').toLowerCase().includes(normalizedRoomFilter));
    }

    if (normalizedGenderFilter) {
      filtered = filtered.filter((item) => String(item.sexo || '').trim().toUpperCase() === normalizedGenderFilter);
    }

    if (this.ageMin != null) {
      filtered = filtered.filter((item) => Number(item.edad || 0) >= Number(this.ageMin));
    }

    if (this.ageMax != null) {
      filtered = filtered.filter((item) => Number(item.edad || 0) <= Number(this.ageMax));
    }

    this.hospedajes = this.sortHospedajes(filtered);
  }

  private sortHospedajes(items: HospedajeTable[]): HospedajeTable[] {
    if (!this.sortBy) {
      return [...items];
    }

    const direction = this.sortDirection === 'desc' ? -1 : 1;

    return [...items].sort((left, right) => {
      const leftValue = this.getSortValue(left);
      const rightValue = this.getSortValue(right);

      if (leftValue < rightValue) {
        return -1 * direction;
      }

      if (leftValue > rightValue) {
        return 1 * direction;
      }

      return 0;
    });
  }

  private getSortValue(item: HospedajeTable): number | string {
    switch (this.sortBy) {
      case 'edad':
        return Number(item.edad || 0);
      case 'sexo':
        return String(item.sexo || '').toUpperCase();
      case 'habitacion':
      default:
        return String(item.habitacion || '').toLowerCase();
    }
  }

}
