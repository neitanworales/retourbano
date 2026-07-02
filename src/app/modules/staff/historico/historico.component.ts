import { Component, OnInit } from '@angular/core';
import { animate, state, style, transition, trigger } from '@angular/animations';
import { EventDao } from 'src/app/core/api/dao/EventDao';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { MtoLogin } from 'src/app/core/models/login/MtoLogin';
import { Event } from 'src/app/core/models/registro/Event';
import { EventRegistration } from 'src/app/core/models/registro/EventRegistration';

@Component({
  selector: 'app-historico',
  templateUrl: './historico.component.html',
  styleUrl: './historico.component.css',
  animations: [
    trigger('detailExpand', [
      state('collapsed', style({ height: '0px', minHeight: '0' })),
      state('expanded', style({ height: '*' })),
      transition('expanded <=> collapsed', animate('225ms cubic-bezier(0.4, 0.0, 0.2, 1)')),
    ]),
  ],
  standalone: false
})
export class HistoricoComponent implements OnInit {

  activeTab: 'history' | 'event' = 'history';
  users?: MtoLogin[] = [];
  allUsers?: MtoLogin[] = [];
  expandedUsers?: MtoLogin;
  searchUsers: string = '';
  events: Event[] = [];
  filteredEvents: Event[] = [];
  selectedYear: string = '';
  selectedEventId: number | null = null;
  selectedEventForRosterId: number | null = null;
  eventRosterSearch: string = '';
  eventRegistrations: EventRegistration[] = [];
  allEventRegistrations: EventRegistration[] = [];
  loadingEventRoster: boolean = false;

  eventRosterColumns = [
    'persona',
    'email',
    'status',
    'roles',
  ];

  columnsToDisplay = [
    'rank',
    'persona',
    'email',
    'asistencias',
    'ultimoEvento',
    'historial',
  ];

  constructor(
    private registroDao: RegistroDao,
    private eventDao: EventDao
  ) {
  }

  ngOnInit(): void {
    this.loadDataUsuarios();
    this.loadEvents();
  }

  cargarTodos() {
    this.searchUsers = '';
    this.loadDataUsuarios();
  }

  buscarUsuarios() {
    this.loadDataUsuarios();
  }

  changeTab(tab: 'history' | 'event') {
    this.activeTab = tab;
  }

  onYearFilterChange() {
    this.selectedEventId = null;
    this.updateFilteredEvents();
    this.applyHistoryFilters();
  }

  onEventFilterChange() {
    this.applyHistoryFilters();
  }

  onRosterEventChange() {
    this.eventRosterSearch = '';
    if (!this.selectedEventForRosterId) {
      this.allEventRegistrations = [];
      this.eventRegistrations = [];
      return;
    }

    this.loadingEventRoster = true;
    this.registroDao.consultarInscritosPorEvento(this.selectedEventForRosterId).subscribe({
      next: (resultado) => {
        this.allEventRegistrations = resultado.data?.registrations || [];
        this.applyEventRosterFilter();
        this.loadingEventRoster = false;
      },
      error: () => {
        this.allEventRegistrations = [];
        this.eventRegistrations = [];
        this.loadingEventRoster = false;
      }
    });
  }

  buscarEnEvento() {
    this.applyEventRosterFilter();
  }

  loadDataUsuarios() {
    this.registroDao.obtenerHistoricoUsuarios(this.searchUsers).subscribe(
      resultado => {
        this.allUsers = (resultado.users || []).map((user) => this.prepareUser(user));
        this.applyHistoryFilters();
      }
    );
  }

  loadEvents() {
    this.eventDao.getEvents('BASIC').subscribe((resultado) => {
      this.events = (resultado.data?.events || []).slice().sort((left, right) => {
        const yearDiff = Number(right.event_year || 0) - Number(left.event_year || 0);
        if (yearDiff !== 0) {
          return yearDiff;
        }

        const leftDate = left.start_at ? new Date(left.start_at).getTime() : 0;
        const rightDate = right.start_at ? new Date(right.start_at).getTime() : 0;
        return rightDate - leftDate;
      });
      this.updateFilteredEvents();
    });
  }

  getUserDisplayName(user: MtoLogin): string {
    return user.nombre?.toString().trim() || user.nick?.toString().trim() || 'Usuario sin nombre';
  }

  getCurrentCampLabel(user: MtoLogin): string {
    if (user.latest_event) {
      return `Ultimo: ${this.getEventLabel(user.latest_event)}`;
    }

    return 'Sin campamentos';
  }

  getCurrentCampBadgeClass(user: MtoLogin): string {
    if (user.latest_event) {
      return 'role-badge role-badge-last-event';
    }

    return 'role-badge role-badge-empty';
  }

  getHistoryPreview(user: MtoLogin): string[] {
    return (user.event_history || []).slice(0, 4).map((event) => this.getEventLabel(event));
  }

  getTopAttendees(limit: number = 5): MtoLogin[] {
    return (this.users || []).slice(0, limit);
  }

  getTotalAttendanceRecords(): number {
    return (this.allUsers || []).reduce((total, user) => total + (user.attendance_count || 0), 0);
  }

  getUniqueHistoricalEvents(): number {
    const eventIds = new Set<number>();
    (this.users || []).forEach((user) => {
      (user.event_history || []).forEach((event) => {
        if (event.event_id) {
          eventIds.add(event.event_id);
        }
      });
    });
    return eventIds.size;
  }

  getRegistrationStatusLabel(status?: string | null): string {
    const normalizedStatus = (status || '').trim().toUpperCase();

    if (normalizedStatus === 'A' || normalizedStatus === '') {
      return 'Activa';
    }

    if (normalizedStatus === 'B' || normalizedStatus === 'INACTIVE') {
      return 'Baja';
    }

    if (normalizedStatus === 'P') {
      return 'Pendiente';
    }

    return normalizedStatus;
  }

  getRegistrationStatusBadgeClass(status?: string | null): string {
    const normalizedStatus = (status || '').trim().toUpperCase();

    if (normalizedStatus === 'A' || normalizedStatus === '') {
      return 'role-badge role-badge-status-active';
    }

    if (normalizedStatus === 'B' || normalizedStatus === 'INACTIVE') {
      return 'role-badge role-badge-status-inactive';
    }

    if (normalizedStatus === 'P') {
      return 'role-badge role-badge-status-pending';
    }

    return 'role-badge role-badge-empty';
  }

  getEventLabel(event?: { title?: string | null; event_year?: number | null }): string {
    if (!event) {
      return 'Sin campamento';
    }

    const title = event.title?.trim() || 'Campamento sin titulo';
    return event.event_year ? `${title} ${event.event_year}` : title;
  }

  getAvailableYears(): string[] {
    const years = new Set<string>();
    (this.events || []).forEach((event) => {
      if (event.event_year) {
        years.add(String(event.event_year));
      }
    });
    return Array.from(years).sort((left, right) => Number(right) - Number(left));
  }

  getEventRosterName(registration: EventRegistration): string {
    const user = registration.user;
    return user?.nombre?.toString().trim() || user?.nick?.toString().trim() || 'Usuario sin nombre';
  }

  getEventRosterRoleBadges(registration: EventRegistration): string[] {
    const roles: string[] = [];

    if (registration.is_admin) {
      roles.push('admin');
    }

    if (registration.is_staff) {
      roles.push('staff');
    }

    return roles.length > 0 ? roles : ['campero'];
  }

  getDisplayRank(user: MtoLogin, fallbackIndex?: number): number {
    const sourceUsers = this.users || [];
    const resolvedIndex = sourceUsers.findIndex((item) => item.id === user.id);

    if (resolvedIndex >= 0) {
      return resolvedIndex + 1;
    }

    if (typeof fallbackIndex === 'number' && !Number.isNaN(fallbackIndex)) {
      return fallbackIndex + 1;
    }

    const rankFromPayload = Number(user.attendance_rank);
    return Number.isFinite(rankFromPayload) && rankFromPayload > 0 ? rankFromPayload : 0;
  }

  private prepareUser(user: MtoLogin): MtoLogin {
    return {
      ...user,
      event_history: user.event_history || [],
    };
  }

  private updateFilteredEvents() {
    this.filteredEvents = this.selectedYear
      ? (this.events || []).filter((event) => String(event.event_year || '') === this.selectedYear)
      : (this.events || []);

    if (this.selectedEventId && !this.filteredEvents.some((event) => event.id === this.selectedEventId)) {
      this.selectedEventId = null;
    }

    if (this.selectedEventForRosterId && !(this.events || []).some((event) => event.id === this.selectedEventForRosterId)) {
      this.selectedEventForRosterId = null;
      this.allEventRegistrations = [];
      this.eventRegistrations = [];
    }
  }

  private applyHistoryFilters() {
    const year = this.selectedYear;
    const eventId = this.selectedEventId;
    const sourceUsers = this.allUsers || [];

    this.users = sourceUsers.filter((user) => {
      const history = user.event_history || [];

      if (year && !history.some((event) => String(event.event_year || '') === year)) {
        return false;
      }

      if (eventId && !history.some((event) => event.event_id === eventId)) {
        return false;
      }

      return true;
    });
  }

  private applyEventRosterFilter() {
    const search = this.eventRosterSearch.trim().toLowerCase();
    const registrations = this.allEventRegistrations || [];

    this.eventRegistrations = search
      ? registrations.filter((registration) => {
          const user = registration.user;
          const haystack = [
            user?.nombre,
            user?.nick,
            user?.email,
          ].map((value) => String(value || '').toLowerCase());

          return haystack.some((value) => value.includes(search));
        })
      : registrations;
  }

}
