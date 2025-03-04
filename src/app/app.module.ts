import { NgModule } from '@angular/core';
import { AppComponent } from './app.component';
import { AuthGuardService } from './services/guards/auth-guard.service';
import { AuthService } from './services/guards/auth.service';
import { RoleGuardService } from './services/guards/role-guard.service';
import { AppRoutingModule } from './app-routing.module';
import { HomeComponent } from './modules/home/home.component';
import { RegistroComponent } from './modules/registro/registro.component';
import { NavbarComponent } from './components/main/navbar/navbar.component';
import { FooterComponent } from './components/main/footer/footer.component';
import { RegistroFormComponent } from './components/registro-form/registro-form.component';
import { RegistroAvanceComponent } from './components/registro-avance/registro-avance.component';
import { InfoCampaComponent } from './modules/info-campa/info-campa.component';
import { DashboardComponent } from './modules/staff/dashboard/dashboard.component';
import { RegistroDao } from './api/dao/RegistroDao';
import { PagoDao } from './api/dao/PagoDao';
import { Utils } from './api/Utils';
import { LoadingService } from './services/loading-screen/loading-screen.service';
import { LoadingInterceptor } from './api/LoadingInterceptor';
import { LoginComponent } from './modules/login/login.component';
import { InscripcionesComponent } from './modules/staff/inscripciones/inscripciones.component';
import { LoginDao } from './api/dao/LoginDao';
import { NavbarSeguimientoComponent } from './components/main/navbar-seguimiento/navbar-seguimiento.component';
import { TablaCostosComponent } from './components/tabla-costos/tabla-costos.component';
import { RetoDao } from './api/dao/RetoDao';
import { RecuperarPasswordComponent } from './components/recuperar-password/recuperar-password.component';
import { AsistenciaComponent } from './modules/staff/asistencia/asistencia.component';
import { UserInfoComponent } from './components/main/user-info/user-info.component';
import { RecoveryPasswordComponent } from './modules/recovery-password/recovery-password.component';
import { FooterSeguimientoComponent } from './components/main/footer-seguimiento/footer-seguimiento.component';
import { ContabilidadComponent } from './modules/staff/contabilidad/contabilidad.component';
import { RegistroDinamicoComponent } from './components/registro-dinamico/registro-dinamico.component';
import { HorarioComponent } from './components/horario/horario.component';
import { HorarioDao } from './api/dao/HorarioDao';
import { BrowserModule } from '@angular/platform-browser';
import { HTTP_INTERCEPTORS, provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
//import { MatInputModule } from '@angular/material/input';
//import { MatNativeDateModule } from '@angular/material/core';
//import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table' 
import { provideCharts, withDefaultRegisterables } from 'ng2-charts';
import { Router } from '@angular/router';
import { PieChartComponent } from "./components/pie-chart/pie-chart.component";
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { CampamentosComponent } from './modules/staff/campamentos/campamentos.component';
import { CampamentoDao } from './api/dao/CampamentoDao';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

@NgModule({ declarations: [
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
        CampamentosComponent
    ],
    bootstrap: [AppComponent], 
    imports: [BrowserModule,
        AppRoutingModule,
        FormsModule,
        ReactiveFormsModule,
        PieChartComponent,
        MatTableModule,
        BrowserAnimationsModule], providers: [
        {
            provide: 'router', useFactory: (rotuer: Router) => {
                return new Router();
            }
        },
        { provide: HTTP_INTERCEPTORS, useClass: LoadingInterceptor, multi: true },
        provideCharts(withDefaultRegisterables()),
        LoadingService,
        Utils,
        RegistroDao,
        PagoDao,
        LoginDao,
        RetoDao,
        CampamentoDao,
        AuthGuardService,
        AuthService,
        RoleGuardService,
        HorarioDao,
        provideAnimationsAsync(),
        provideHttpClient(withInterceptorsFromDi())
    ] })
export class AppModule { }
