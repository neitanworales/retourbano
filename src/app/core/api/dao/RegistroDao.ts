import { Injectable } from "@angular/core";
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { Utils } from "../Utils";
import { AvanceResponse } from "src/app/core/models/registro/AvanceResponse";
import { Guerrero } from "src/app/core/models/registro/Guerrero";
import { MantenimientoResponse } from "src/app/core/models/registro/MantenimientoResponse";
import { RegistroResponse } from "src/app/core/models/registro/RegistroResponse";
import { IndicadoresResponse } from "src/app/core/models/registro/IndicadoresResponse";
import { DefaultResponse } from "src/app/core/models/DefaultResponse";
import { Pago } from "src/app/core/models/registro/Pago";
import { HttpClient } from "@angular/common/http";
import { GuerreroResponse } from "src/app/core/models/GuerreroResponse";
import { HospedajeResponse } from "../../models/hospedaje/HosepdajeResponse";

@Injectable()
export class RegistroDao {

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    public getAvanceRegistro(): Observable<AvanceResponse> {
        return this.http.get<AvanceResponse>(environment.apiUrl + 'retourbano/configuracion.php', { headers: this.utils.getHeaders() });
    }

    public agregarGuerrero(guerrero: Guerrero, tutor: boolean): Observable<RegistroResponse> {
        return this.http.post<RegistroResponse>(environment.apiUrl + 'retourbano/inscribir.php?tutor=' + (tutor ? "1" : "0"), guerrero, { headers: this.utils.getHeaders() });
    }

    public updateGuerrero(guerrero: Guerrero): Observable<RegistroResponse> {
        return this.http.put<RegistroResponse>(environment.apiUrl + 'retourbano/reinscribir.php', guerrero, { headers: this.utils.getHeaders() });
    }

    public consultarGuerreros(opcion: number, activo: boolean, staff: boolean, admin: boolean, byName: string, seg: boolean): Observable<MantenimientoResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<MantenimientoResponse>(environment.apiUrl + 'retourbano/mantenimiento.php'
            + '?opcion=' + opcion
            + '&status=' + (activo ? 'A' : 'B')
            + '&staff=' + (staff ? '1' : '0')
            + '&admin=' + ((staff && admin) ? '1' : '0')
            + '&byname=' + byName
            + '&seguimiento=' + (seg ? '1' : '0')
            + '&user=' + user.id
            + '&token=' + user.token
            , { headers: this.utils.getHeaders() });
    }

    public consultarIndicadores(opcion: number): Observable<IndicadoresResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<IndicadoresResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=' + opcion
            + '&user=' + user.id
            + '&token=' + user.token
            , { headers: this.utils.getHeaders() });
    }

    public actualizarStaff(isStaff: boolean, id: number): Observable<DefaultResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<DefaultResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=3&id=' + id + '&staff=' + (isStaff ? 1 : 0)
            + '&user=' + user.id
            + '&token=' + user.token
            , { headers: this.utils.getHeaders() });
    }

    public actualizarStatus(isActived: boolean, id: number): Observable<DefaultResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<DefaultResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=2&id=' + id + '&status=' + (isActived ? 'A' : 'B')
            + '&user=' + user.id
            + '&token=' + user.token
            , { headers: this.utils.getHeaders() });
    }

    public actualizarAdmin(isAdmin: boolean, id: number): Observable<DefaultResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<DefaultResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=9&id=' + id + '&admin=' + (isAdmin ? 1 : 0)
            + '&user=' + user.id
            + '&token=' + user.token
            , { headers: this.utils.getHeaders() });
    }

    public cambiarContrasena(newPassword: String, id: number): Observable<DefaultResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<DefaultResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=10&id=' + id
            + '&newPassword=' + newPassword
            + '&user=' + user.id
            + '&token=' + user.token
            , { headers: this.utils.getHeaders() });
    }

    public guardarPago(pago: Pago, idGuerrero: number) {
        return this.http.post<RegistroResponse>(environment.apiUrl + 'retourbano/guardar-pago.php?idguerrero=' + idGuerrero, pago, { headers: this.utils.getHeaders() });
    }

    public actualizarPago(pago: Pago) {
        return this.http.put<RegistroResponse>(environment.apiUrl + 'retourbano/guardar-pago.php?idpago=' + pago.id_pago, pago, { headers: this.utils.getHeaders() });
    }

    public borrarPago(pago: Pago) {
        return this.http.delete<RegistroResponse>(environment.apiUrl + 'retourbano/guardar-pago.php?idpago=' + pago.id_pago, { headers: this.utils.getHeaders() });
    }

    public guardarConfirmacion(valor: boolean, idGuerrero: number) {
        return this.http.post<RegistroResponse>(environment.apiUrl + 'retourbano/confirmacion-asistencia.php?asistencia=false&idguerrero=' + idGuerrero + "&valor=" + valor, null, { headers: this.utils.getHeaders() });
    }

    public guardarAsistencia(valor: boolean, idGuerrero: number) {
        return this.http.post<RegistroResponse>(environment.apiUrl + 'retourbano/confirmacion-asistencia.php?asistencia=true&idguerrero=' + idGuerrero + "&valor=" + valor, null, { headers: this.utils.getHeaders() });
    }

    public enviarConfirmarEmail(enviar: boolean, confirmar: boolean, idGuerrero: number) {
        return this.http.post<RegistroResponse>(environment.apiUrl + 'retourbano/send-email.php?enviado=' + enviar + '&idguerrero=' + idGuerrero + "&confirmado=" + confirmar, null, { headers: this.utils.getHeaders() });
    }

    public guardarSeguimiento(valor: boolean, idGuerrero: number) {
        return this.http.post<RegistroResponse>(environment.apiUrl + 'retourbano/confirmar-seguimiento.php?idguerrero=' + idGuerrero + "&seguimiento=" + valor, null, { headers: this.utils.getHeaders() });
    }

    public consultarHistorico(year: number): Observable<MantenimientoResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<MantenimientoResponse>(environment.apiUrl + 'retourbano/mantenimiento.php'
            + '?opcion=11'
            + '&year=' + year
            + '&user=' + user.id
            + '&token=' + user.token
            , { headers: this.utils.getHeaders() });
    }

    public validarEmail(email: String): Observable<DefaultResponse>{
        return this.http.get<DefaultResponse>(environment.apiUrl + 'retourbano/validar-email.php?email='+email, { headers: this.utils.getHeaders() });
    }

    public validarCodigo(email: String): Observable<GuerreroResponse>{
        return this.http.get<GuerreroResponse>(environment.apiUrl + 'retourbano/validar-codigo.php?codigo='+email, { headers: this.utils.getHeaders() });
    }

    public validarInscripcion() : Observable<RegistroResponse> {
        const session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<RegistroResponse>(environment.apiUrl + 'retourbano/validar-inscripcion.php?id='+session?.id, { headers: this.utils.getHeaders() });
    }

    public obtenerHospedajes() : Observable<HospedajeResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<HospedajeResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=12'
            + '&user=' + user.id
            + '&token=' + user.token
            , { headers: this.utils.getHeaders() });
    }
}