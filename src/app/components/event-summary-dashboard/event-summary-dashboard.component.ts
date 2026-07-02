import { CommonModule } from '@angular/common';
import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { EventDashboardBirthdayItem, EventDashboardChartItem, EventDashboardResponse } from 'src/app/core/models/registro/EventDashboardResponse';
import { Indicador } from 'src/app/core/models/registro/Indicador';
import { PieChartComponent } from '../pie-chart/pie-chart.component';

@Component({
  selector: 'app-event-summary-dashboard',
  standalone: true,
  imports: [CommonModule, PieChartComponent],
  templateUrl: './event-summary-dashboard.component.html',
  styleUrls: ['./event-summary-dashboard.component.css']
})
export class EventSummaryDashboardComponent implements OnChanges {
  @Input() eventId?: number;
  @Input() eventTitle?: string;
  @Input() eventDate?: string | Date;

  eventDashboard?: EventDashboardResponse;
  indicadoresOperacion: Indicador[] = [];
  indicadoresFinanzas: Indicador[] = [];
  cardsOperacion: Array<{ label: string; value: number | null | undefined; tone: string }> = [];
  cardsFinanzas: Array<{ label: string; value: number | null | undefined; tone: string }> = [];
  paquetes: Array<{ title: string; option: number }> = [];
  birthdaysDuringEvent: EventDashboardBirthdayItem[] = [];

  constructor(private registroDao: RegistroDao) {}

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['eventId']) {
      this.loadDashboard();
    }
  }

  private loadDashboard() {
    if (!this.eventId) {
      this.eventDashboard = undefined;
      this.indicadoresOperacion = [];
      this.indicadoresFinanzas = [];
      this.cardsOperacion = [];
      this.cardsFinanzas = [];
      this.paquetes = [];
      this.birthdaysDuringEvent = [];
      return;
    }

    this.registroDao.getEventDashboard(this.eventId).subscribe(result => {
      this.eventDashboard = result;
      const summary = result.data?.summary;
      this.birthdaysDuringEvent = result.data?.birthdays_during_event || [];

      this.indicadoresOperacion = [
        { valor: 'Capacidad', count: summary?.capacity ?? 0 },
        { valor: 'Inscritos', count: summary?.registered ?? 0 },
        { valor: 'Disponibles', count: summary?.available ?? 0 },
        { valor: 'Ocupacion %', count: summary?.occupancy_percentage ?? 0 },
        { valor: 'Seguimiento', count: summary?.followup ?? 0 },
        { valor: 'Emails enviados', count: summary?.welcome_email_sent ?? 0 },
        { valor: 'Emails confirmados', count: summary?.email_confirmed ?? 0 },
      ];

      this.indicadoresFinanzas = [
        { valor: 'Ingresos MXN', count: summary?.total_revenue ?? 0 },
        { valor: 'Cobertura pagos %', count: summary?.payment_coverage_percentage ?? 0 },
        { valor: 'Pago promedio', count: summary?.average_payment ?? 0 },
        { valor: 'Saldo pendiente', count: summary?.pending_balance ?? 0 },
        { valor: 'Pagos completos', count: summary?.fully_paid_count ?? 0 },
      ];

      this.cardsOperacion = [
        { label: 'Inscritos', value: summary?.registered ?? 0, tone: 'primary' },
        { label: 'Disponibles', value: summary?.available ?? 0, tone: 'success' },
        { label: 'Ocupación', value: summary?.occupancy_percentage ?? 0, tone: 'warning' },
        { label: 'Seguimiento', value: summary?.followup ?? 0, tone: 'info' },
      ];

      this.cardsFinanzas = [
        { label: 'Ingresos', value: summary?.total_revenue ?? 0, tone: 'primary' },
        { label: 'Cobertura pagos', value: summary?.payment_coverage_percentage ?? 0, tone: 'success' },
        { label: 'Pago promedio', value: summary?.average_payment ?? 0, tone: 'warning' },
        { label: 'Saldo pendiente', value: summary?.pending_balance ?? 0, tone: 'danger' },
      ];

      this.paquetes = [
        { title: 'Disponibilidad', option: 4 },
        { title: 'Roles', option: 5 },
        { title: 'Genero', option: 6 },
        { title: 'Genero Staff', option: 7 },
        { title: 'Tallas', option: 8 },
        { title: 'Hospedaje', option: 14 },
      ];
    });
  }

  formatValue(label: string, value: number | null | undefined): string {
    const normalized = value ?? 0;

    if (label.includes('%')) {
      return `${normalized}%`;
    }

    if (label.includes('Ingresos') || label.includes('Pago promedio') || label.includes('Saldo pendiente')) {
      return `$${Number(normalized).toLocaleString('es-MX', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
    }

    return Number(normalized).toLocaleString('es-MX');
  }

  get hasData(): boolean {
    return this.cardsOperacion.length > 0 || this.cardsFinanzas.length > 0;
  }

  get totalRevenue(): number {
    return this.eventDashboard?.data?.summary?.total_revenue ?? 0;
  }

  get occupancy(): number {
    return this.eventDashboard?.data?.summary?.occupancy_percentage ?? 0;
  }

  get coverage(): number {
    return this.eventDashboard?.data?.summary?.payment_coverage_percentage ?? 0;
  }
}
