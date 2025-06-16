import { NgModule } from '@angular/core';
import { AuthService } from './core/services/auth.service';
import { AppRoutingModule } from './app-routing.module';
import { HomeComponent } from './modules/home/home.component';
import { RegistroComponent } from './modules/registro/registro.component';
import { NavbarComponent } from './components/main/navbar/navbar.component';
import { FooterComponent } from './components/main/footer/footer.component';
import { RegistroFormComponent } from './components/registro-form/registro-form.component';
import { RegistroAvanceComponent } from './components/registro-avance/registro-avance.component';
import { InfoCampaComponent } from './modules/info-campa/info-campa.component';
import { DashboardComponent } from './modules/staff/dashboard/dashboard.component';
import { RegistroDao } from './core/api/dao/RegistroDao';
import { PagoDao } from './core/api/dao/PagoDao';
import { Utils } from './core/api/Utils';
import { LoadingService } from './core/services/loading-screen/loading-screen.service';
import { LoadingInterceptor } from './core/api/LoadingInterceptor';
import { LoginComponent } from './modules/login/login.component';
import { InscripcionesComponent } from './modules/staff/inscripciones/inscripciones.component';
import { LoginDao } from './core/api/dao/LoginDao';
import { NavbarSeguimientoComponent } from './components/main/navbar-seguimiento/navbar-seguimiento.component';
import { TablaCostosComponent } from './components/tabla-costos/tabla-costos.component';
import { RetoDao } from './core/api/dao/RetoDao';
import { RecuperarPasswordComponent } from './components/recuperar-password/recuperar-password.component';
import { AsistenciaComponent } from './modules/staff/asistencia/asistencia.component';
import { UserInfoComponent } from './components/main/user-info/user-info.component';
import { RecoveryPasswordComponent } from './modules/recovery-password/recovery-password.component';
import { FooterSeguimientoComponent } from './components/main/footer-seguimiento/footer-seguimiento.component';
import { ContabilidadComponent } from './modules/staff/contabilidad/contabilidad.component';
import { RegistroDinamicoComponent } from './components/registro-dinamico/registro-dinamico.component';
import { HorarioComponent } from './components/horario/horario.component';
import { HorarioDao } from './core/api/dao/HorarioDao';
import { BrowserModule } from '@angular/platform-browser';
import { HTTP_INTERCEPTORS, provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatNativeDateModule } from '@angular/material/core';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatTableModule } from '@angular/material/table'
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatTimepickerModule } from '@angular/material/timepicker';
import { provideCharts, withDefaultRegisterables } from 'ng2-charts';
import { Router } from '@angular/router';
import { PieChartComponent } from "./components/pie-chart/pie-chart.component";
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { CampamentosComponent } from './modules/staff/campamentos/campamentos.component';
import { CampamentoDao } from './core/api/dao/CampamentoDao';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations'
import { AppComponent } from './app.component';
import { ReinscripcionComponent } from './modules/reinscripcion/reinscripcion.component';
import { HospedajesComponent } from './modules/staff/hospedajes/hospedajes.component';
import { CuentaComponent } from './modules/staff/cuenta/cuenta.component';
import { AuthInterceptor } from './core/services/ auth.interceptor';
import { UsuariosComponent } from './modules/staff/usuarios/usuarios.component';
import { TumbaService } from './core/services/tumbaService';
import { QueTraerComponent } from "./components/que-traer/que-traer.component";

@NgModule({
    declarations: [
        AppComponent,
        HomeComponent,
        RegistroComponent,
        NavbarComponent,
        FooterComponent,
        RegistroFormComponent,
        RegistroAvanceComponent,
        InfoCampaComponent,
        DashboardComponent,
        LoginComponent,
        InscripcionesComponent,
        NavbarSeguimientoComponent,
        TablaCostosComponent,
        RecuperarPasswordComponent,
        AsistenciaComponent,
        UserInfoComponent,
        RecoveryPasswordComponent,
        FooterSeguimientoComponent,
        ContabilidadComponent,
        RegistroDinamicoComponent,
        HorarioComponent,
        CampamentosComponent,
        ReinscripcionComponent,
        HospedajesComponent,
        CuentaComponent,
        UsuariosComponent,
        QueTraerComponent
    ],
    bootstrap: [AppComponent],
    imports: [BrowserModule,
        AppRoutingModule,
        FormsModule,
        ReactiveFormsModule,
        PieChartComponent,
        MatTableModule,
        MatNativeDateModule,
        MatFormFieldModule,
        MatDatepickerModule,
        MatTimepickerModule,
        BrowserAnimationsModule],
    providers: [
        {
            provide: 'router', useFactory: (rotuer: Router) => {
                return new Router();
            }
        },
        { provide: HTTP_INTERCEPTORS, useClass: LoadingInterceptor, multi: true },
        { provide: HTTP_INTERCEPTORS, useClass: AuthInterceptor, multi: true },
        provideCharts(withDefaultRegisterables()),
        LoadingService,
        Utils,
        RegistroDao,
        PagoDao,
        LoginDao,
        RetoDao,
        CampamentoDao,
        AuthService,
        HorarioDao,
        provideAnimationsAsync(),
        provideHttpClient(withInterceptorsFromDi()),
        TumbaService,
        MatDatepickerModule,
        MatNativeDateModule,
        MatTimepickerModule,
    ]
})
export class AppModule { }
