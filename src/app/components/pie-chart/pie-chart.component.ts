import { Component, Input, OnChanges, OnInit, SimpleChanges, ViewChild } from '@angular/core';
import DatalabelsPlugin from 'chartjs-plugin-datalabels';
import { ChartConfiguration, ChartData, ChartType } from 'chart.js';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';
import { BaseChartDirective } from 'ng2-charts';
import { EventDashboardChartItem, EventDashboardCharts } from 'src/app/core/models/registro/EventDashboardResponse';

@Component({
    selector: 'app-pie-chart',
    imports: [BaseChartDirective],
    templateUrl: './pie-chart.component.html',
    styleUrls: ['./pie-chart.component.css']
})
export class PieChartComponent implements OnInit, OnChanges {

  @ViewChild(BaseChartDirective) chart: BaseChartDirective | undefined;

  @Input()
  opcion?: number;

  @Input()
  eventSelectedId?: number;

  @Input()
  title?: string;

  indicadores?: EventDashboardChartItem[];

  etiquetas?: string[];
  datos?: number[];

  public pieChartType: ChartType = 'pie';
  public pieChartPlugins = [DatalabelsPlugin];

  public pieChartData?: ChartData<'pie', number[], string | string[]>;

  constructor(public registroDao: RegistroDao) {

  }

  ngOnInit(): void {
    this.getDatos();
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['eventSelectedId'] || changes['opcion']) {
      this.getDatos();
    }
  }

  private getDatos() {
    if (!this.eventSelectedId || !this.opcion) {
      this.pieChartData = undefined;
      return;
    }

    this.registroDao.getEventDashboard(this.eventSelectedId).subscribe(
      result => {
        const charts = result.data?.charts;
        const chartKey = this.resolveChartKey(this.opcion!);
        this.indicadores = chartKey ? charts?.[chartKey] || [] : [];
        if (this.indicadores !== undefined) {
          this.etiquetas = [];
          this.datos = [];
          for (let i = 0; i < this.indicadores?.length; i++) {
            this.etiquetas?.push(this.indicadores[i].label);
            this.datos?.push(this.indicadores[i].count!);
          }
          this.pieChartData = {
            labels: this.etiquetas,
            datasets: [{
              data: this.datos!
            }]
          };
        }
      }
    );
  }

  public pieChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    plugins: {
      legend: {
        display: true,
        position: 'top',
      },
      datalabels: {
        /*formatter: (value!, ctx!) => {
          if (ctx.chart.data.labels) {
            return ctx.chart.data.labels[ctx.dataIndex];
          }
        }*/
      },
    }
  };

  public refrescar(opcion: number) {
    this.opcion = opcion;
    this.getDatos();
  }

  public get chartTitle(): string {
    if (this.title && this.title.trim() !== '') {
      return this.title;
    }

    return this.resolveDefaultTitle(this.opcion);
  }

  private resolveChartKey(opcion: number): keyof EventDashboardCharts | undefined {
    const mapping: Record<number, keyof EventDashboardCharts> = {
      4: 'availability',
      5: 'roles',
      6: 'gender',
      7: 'staff_gender',
      8: 'shirt_sizes',
      14: 'lodging',
    };

    return mapping[opcion];
  }

  private resolveDefaultTitle(opcion?: number): string {
    const mapping: Record<number, string> = {
      4: 'Disponibilidad',
      5: 'Roles',
      6: 'Genero',
      7: 'Genero Staff',
      8: 'Tallas',
      14: 'Hospedaje',
    };

    if (!opcion) {
      return 'Grafica';
    }

    return mapping[opcion] || 'Grafica';
  }

}
