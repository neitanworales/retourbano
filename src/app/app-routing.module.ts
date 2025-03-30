import { NgModule } from '@angular/core';
import { RegistroFormComponent } from './components/registro-form/registro-form.component';
import { DashboardComponent } from './modules/staff/dashboard/dashboard.component';
import { HomeComponent } from './modules/home/home.component';
import { RegistroComponent } from './modules/registro/registro.component';

import { AuthGuardService as AuthGuard } from './services/guards/auth-guard.service';
import { RoleGuardService as RoleGuard } from './services/guards/role-guard.service';

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

const routes: Routes = [
  { path: '', redirectTo: '/home', pathMatch: 'full' },
  { path: 'home', component: HomeComponent },
  { path: 'registro', component: RegistroComponent },
  { path: 'registro-puro', component: RegistroFormComponent },
  { path: 'login', component: LoginComponent },
  { path: 'staff', component: DashboardComponent, canActivate: [AuthGuard] },
  { path: 'inscripciones', component: InscripcionesComponent, canActivate: [RoleGuard], data: { isAdmin: true} },
  { path: 'asistencia', component: AsistenciaComponent, canActivate: [RoleGuard], data: { isAdmin: true} },
  { path: 'recovery-password', component: RecoveryPasswordComponent },
  { path: 'info', component: InfoCampaComponent },
  { path: 'contabilidad', component: ContabilidadComponent, canActivate: [RoleGuard], data: { isAdmin: true}},
  { path: 'horario', component: HorarioComponent},
  { path: 'campamentos', component: CampamentosComponent, canActivate: [AuthGuard]},
  { path: 'reinscripcion', component: ReinscripcionComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
