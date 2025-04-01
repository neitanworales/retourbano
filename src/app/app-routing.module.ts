import { NgModule } from '@angular/core';
import { RegistroFormComponent } from './components/registro-form/registro-form.component';
import { DashboardComponent } from './modules/staff/dashboard/dashboard.component';
import { HomeComponent } from './modules/home/home.component';
import { RegistroComponent } from './modules/registro/registro.component';
import { InscripcionesComponent } from './modules/staff/inscripciones/inscripciones.component';
import { LoginComponent } from './modules/login/login.component';
import { AsistenciaComponent } from './modules/staff/asistencia/asistencia.component';
import { RecoveryPasswordComponent } from './modules/recovery-password/recovery-password.component';
import { InfoCampaComponent } from './modules/info-campa/info-campa.component';
import { ContabilidadComponent } from './modules/staff/contabilidad/contabilidad.component';
import { HorarioComponent } from './components/horario/horario.component';
import { RouterModule, Routes } from '@angular/router';
import { CampamentosComponent } from './modules/staff/campamentos/campamentos.component';
import { ReinscripcionComponent } from './modules/reinscripcion/reinscripcion.component';
import { hasRoleGuard } from './core/guards/has-role.guard';
import { authGuard } from './core/guards/auth.guard';

const routes: Routes = [
  { path: '', redirectTo: '/home', pathMatch: 'full' },
  { path: 'home', component: HomeComponent },
  { path: 'registro', component: RegistroComponent },
  { path: 'registro-puro', component: RegistroFormComponent },
  { path: 'login', component: LoginComponent },
  { path: 'recovery-password', component: RecoveryPasswordComponent },
  { path: 'info', component: InfoCampaComponent },
  { path: 'horario', component: HorarioComponent },
  { path: 'reinscripcion', component: ReinscripcionComponent },
  { path: 'staff', component: DashboardComponent, canMatch: [authGuard] },
  { path: 'inscripciones', component: InscripcionesComponent, canActivate: [hasRoleGuard(['admin'])] },
  { path: 'asistencia', component: AsistenciaComponent, canActivate: [hasRoleGuard(['admin', 'staff'])] },
  { path: 'contabilidad', component: ContabilidadComponent, canActivate: [hasRoleGuard(['admin'])] },
  { path: 'campamentos', component: CampamentosComponent, canActivate: [hasRoleGuard(['admin'])] },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
