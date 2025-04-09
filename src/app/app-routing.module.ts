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
import { HospedajesComponent } from './modules/staff/hospedajes/hospedajes.component';
import { CuentaComponent } from './modules/staff/cuenta/cuenta.component';
import { UsuariosComponent } from './modules/staff/usuarios/usuarios.component';
import { TerminosYCondicionesComponent } from './modules/terminos-y-condiciones/terminos-y-condiciones.component';

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
  { path: 'terminos-y-condiciones', component: TerminosYCondicionesComponent },
  { path: 'staff', component: DashboardComponent, canMatch: [authGuard] },
  { path: 'staff/cuenta', component: CuentaComponent, canMatch: [authGuard] },
  { path: 'staff/inscripciones', component: InscripcionesComponent, canActivate: [hasRoleGuard(['super', 'admin'])] },
  { path: 'staff/hospedaje', component: HospedajesComponent, canActivate: [hasRoleGuard(['super', 'admin', 'staff'])] },
  { path: 'staff/asistencia', component: AsistenciaComponent, canActivate: [hasRoleGuard(['super', 'admin', 'staff'])] },
  { path: 'staff/contabilidad', component: ContabilidadComponent, canActivate: [hasRoleGuard(['super', 'admin'])] },
  { path: 'staff/campamentos', component: CampamentosComponent, canActivate: [hasRoleGuard(['super', 'admin'])] },
  { path: 'staff/usuarios', component: UsuariosComponent, canActivate: [hasRoleGuard(['super', 'admin'])] },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
