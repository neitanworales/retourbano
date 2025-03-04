import { Component, OnInit, ViewChild, Input } from '@angular/core';
//import DatalabelsPlugin from 'chartjs-plugin-datalabels';
//import { ChartConfiguration, ChartData, ChartEvent, ChartType } from 'chart.js';
import { Indicador } from 'src/app/models/registro/Indicador';
import { RegistroDao } from 'src/app/api/dao/RegistroDao';
//import { BaseChartDirective } from 'ng2-charts';

@Component({
    selector: 'app-pie-chart',
    //imports: [BaseChartDirective],
    templateUrl: './pie-chart.component.html',
    styleUrls: ['./pie-chart.component.css']
})
export class PieChartComponent implements OnInit {

  //@ViewChild(BaseChartDirective) chart: BaseChartDirective | undefined;

  @Input()
  opcion?: number;

  indicadores?: Indicador[];

  etiquetas?: string[];
  datos?: number[];

  //public pieChartType: ChartType = 'pie';
  //public pieChartPlugins = [DatalabelsPlugin];

  //public pieChartData?: ChartData<'pie', number[], string | string[]>;

  constructor(public registroDao: RegistroDao) {

  }

  ngOnInit(): void {
    this.getDatos();
  }

  private getDatos() {

    this.registroDao.consultarIndicadores(this.opcion!).subscribe(
      result => {
        this.indicadores = result.resultado;
        if (this.indicadores !== undefined) {
          this.etiquetas = [];
          this.datos = [];
          for (let i = 0; i < this.indicadores?.length; i++) {
            this.etiquetas?.push(this.indicadores[i].valor!);
            this.datos?.push(this.indicadores[i].count!);
          }
          console.log(this.datos);
          /*this.pieChartData = {
            labels: this.etiquetas,
            datasets: [{
              data: this.datos!
            }]
          };*/
        }
      }
    );
  }

  /*public pieChartOptions: ChartConfiguration['options'] = {
    responsive: true,
    plugins: {
      legend: {
        display: true,
        position: 'top',
      },
      datalabels: {*/
        /*formatter: (value!, ctx!) => {
          if (ctx.chart.data.labels) {
            return ctx.chart.data.labels[ctx.dataIndex];
          }
        }
      },
    }
  };*/


}
