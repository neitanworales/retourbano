import { Injectable } from "@angular/core";
import { Observable, catchError, map, of } from 'rxjs';
import { environment } from 'src/environments/environment';
import { Utils } from "../Utils";
import { AvanceResponse } from "src/app/core/models/registro/AvanceResponse";
import { User } from "src/app/core/models/registro/User";
import { EventRegistration, EventRegistrationResponse } from "src/app/core/models/registro/EventRegistration";
import { RegistroResponse } from "src/app/core/models/registro/RegistroResponse";
import { IndicadoresResponse } from "src/app/core/models/registro/IndicadoresResponse";
import { EventDashboardResponse } from "src/app/core/models/registro/EventDashboardResponse";
import { DefaultResponse } from "src/app/core/models/DefaultResponse";
import { Pago } from "src/app/core/models/registro/Pago";
import { HttpClient } from "@angular/common/http";
import { GuerreroResponse } from "src/app/core/models/GuerreroResponse";
import { HospedajeResponse } from "../../models/hospedaje/HosepdajeResponse";
import { AuthService } from "../../services/auth.service";
import { MtoLoginResponse } from "../../models/login/MtoLoginResponse";
import { HabitacionResponse } from "../../models/hospedaje/HabitacionResponse";
import { SinHabitacionResponse } from "../../models/hospedaje/SinHabitacionResponse";
import { EventResponse } from "../../models/registro/EventResponse";

@Injectable()
export class RegistroDao {

    constructor(
        private http: HttpClient,
        private utils: Utils,
        private autho: AuthService
    ) { }

    public getAvanceRegistro(): Observable<AvanceResponse> {
        return this.http.get<AvanceResponse>(environment.apiUrl + 'retourbano/configuracion.php', { headers: this.utils.getHeaders() });
    }

    public agregarGuerrero(guerrero: EventRegistration, tutor: boolean, event_id: number): Observable<RegistroResponse> {
        const payload = {
            legacy_user_id: guerrero?.user?.legacy_user_id,
            legacy_registration_id: guerrero?.legacy_registration_id,
            nombre: guerrero?.user?.nombre,
            nick: guerrero?.user?.nick,
            fechaNac: guerrero?.user?.fechaNac,
            edad: guerrero?.user?.edad,
            sexo: guerrero?.user?.sexo,
            talla: guerrero?.user?.talla,
            vienesDe: guerrero?.user?.vienesDe,
            alergias: guerrero?.user?.alergias,
            razones: guerrero?.razones,
            tutorNombre: guerrero?.user?.tutorNombre,
            tutorTelefono: guerrero?.user?.tutorTelefono,
            emailTutor: guerrero?.user?.emailTutor ?? guerrero?.user?.guardian_email,
            iglesia: guerrero?.user?.iglesia,
            email: guerrero?.user?.email,
            whatsapp: guerrero?.user?.whatsapp,
            telefono: guerrero?.user?.telefono,
            facebook: guerrero?.user?.facebook,
            medicamentos: guerrero?.user?.medicamentos,
            instagram: guerrero?.user?.instagram,
            aceptaPoliticas: guerrero?.user?.aceptaPoliticas,
            hospedaje: guerrero?.hospedaje,
            event_id: event_id,
        };

        return this.http.post<RegistroResponse>(
            this.utils.v1('/registrations') + '?tutor=' + (tutor ? '1' : '0') + '&event_id=' + event_id,
            payload,
            { headers: this.utils.getHeaders() }
        );
    }

    public updateGuerrero(guerrero: EventRegistration, event_id: number): Observable<RegistroResponse> {
        const payload = {
            id: guerrero?.user?.id ?? guerrero?.user_id,
            legacy_user_id: guerrero?.user?.legacy_user_id,
            legacy_registration_id: guerrero?.legacy_registration_id,
            nombre: guerrero?.user?.nombre,
            nick: guerrero?.user?.nick,
            fechaNac: guerrero?.user?.fechaNac,
            year: guerrero?.user?.year,
            month: guerrero?.user?.month,
            day: guerrero?.user?.day,
            edad: guerrero?.user?.edad,
            sexo: guerrero?.user?.sexo,
            talla: guerrero?.user?.talla,
            vienesDe: guerrero?.user?.vienesDe,
            alergias: guerrero?.user?.alergias,
            razones: guerrero?.razones,
            tutorNombre: guerrero?.user?.tutorNombre,
            tutorTelefono: guerrero?.user?.tutorTelefono,
            emailTutor: guerrero?.user?.emailTutor ?? guerrero?.user?.guardian_email,
            iglesia: guerrero?.user?.iglesia,
            email: guerrero?.user?.email,
            whatsapp: guerrero?.user?.whatsapp,
            telefono: guerrero?.user?.telefono,
            facebook: guerrero?.user?.facebook,
            medicamentos: guerrero?.user?.medicamentos,
            instagram: guerrero?.user?.instagram,
            aceptaPoliticas: guerrero?.user?.aceptaPoliticas,
            hospedaje: guerrero?.hospedaje,
            event_id: event_id,
        };

        return this.http.put<RegistroResponse>(
            this.utils.v1('/registrations') + '?event_id=' + event_id,
            payload,
            { headers: this.utils.getHeaders() }
        );
    }

    public consultarInscritos(opcion: number, activo: boolean, staff: boolean, admin: boolean, byName: string, seg: boolean, event_id?: number): Observable<EventRegistrationResponse> {
        const user = this.autho.getSessionValida();
        const params: string[] = [
            'event_id=' + encodeURIComponent(String(event_id || '')),
            'token=' + encodeURIComponent(String(user?.token || '')),
        ];

        // Keep legacy UX behavior: only send positive boolean filters.
        params.push('is_staff=' + (staff ? '1' : '0'));
        params.push('is_admin=' + (admin ? '1' : '0'));
        // Do not filter by follow-up unless the seguimiento view explicitly requests it.
        if (seg) {
            params.push('is_followup=1');
        }

        // Legacy "activo=false" maps to "baja" in UI, represented as inactive status.
        params.push('registration_status='+(activo ? 'A' : 'B'));

        return this.http.get<any>(this.utils.v1('/registrations/by-event')
            + '?' + params.join('&')
            , { headers: this.utils.getHeaders() }).pipe(
                map((response) => {
                    const registrations = response?.data?.registrations || response?.resultado || [];
                    const users = registrations.map((item: any) => {
                        const rawUser = item?.user || item;
                        const normalizedUser = this.normalizeUser(rawUser);

                        const reg: EventRegistration = {
                            id: item?.id,
                            event_id: item?.event_id,
                            user_id: item?.user_id,
                            registration_status: item?.registration_status,
                            is_confirmed: (item?.is_confirmed ?? 0) === 1,
                            attendance_confirmed: (item?.attendance_confirmed ?? 0) === 1,
                            is_staff: (item?.is_staff ?? 0) === 1,
                            is_admin: (item?.is_admin ?? 0) === 1,
                            is_followup: (item?.is_followup ?? 0) === 1,
                            welcome_email_sent: (item?.welcome_email_sent ?? item?.email_enviado ?? 0) === 1,
                            email_confirmed: (item?.email_confirmed ?? item?.email_confirmado ?? 0) === 1,
                            requires_lodging: (item?.requires_lodging ?? 0) === 1,
                            room_code: item?.room_code,
                            reasons: item?.reasons,
                            razones: item?.reasons,
                            pagado: rawUser?.pagado ?? item?.pagado,
                            pagos: rawUser?.pagos ?? item?.pagos,
                            // Legacy Spanish aliases for UI compatibility
                            confirmado: (item?.is_confirmed ?? 0) === 1,
                            asistencia: (item?.attendance_confirmed ?? 0) === 1,
                            staff: (item?.is_staff ?? 0) === 1,
                            admin: (item?.is_admin ?? 0) === 1,
                            seguimiento: (item?.is_followup ?? 0) === 1,
                            emailEnviado: (item?.welcome_email_sent ?? item?.email_enviado ?? 0) === 1,
                            emailConfirmado: (item?.email_confirmed ?? item?.email_confirmado ?? 0) === 1,
                            hospedaje: (item?.requires_lodging ?? 0) === 1,
                            habitacion: item?.room_code,
                            user: normalizedUser,
                        };

                        return reg;
                    });

                    return {
                        success: !!response?.success,
                        error: !response?.success,
                        message: response?.message || 'Registros consultados',
                        code: response?.code || 200,
                        data: {
                            registrations: users
                        },
                        resultado: users
                    } as EventRegistrationResponse;
                })
            );
    }

    public actualizarRolesGlobales(userId: number, payload: { roles?: string[]; add_roles?: string[]; remove_roles?: string[] }): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.patch<DefaultResponse>(
            this.utils.v1('/users/roles') + '?token=' + token,
            {
                user_id: userId,
                roles: payload?.roles,
                add_roles: payload?.add_roles,
                remove_roles: payload?.remove_roles,
            },
            { headers: this.utils.getHeaders() }
        );
    }

    public actualizarRolesEvento(userId: number, eventId: number, payload: { event_roles?: string[]; event_is_staff?: boolean; event_is_admin?: boolean }): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.patch<DefaultResponse>(
            this.utils.v1('/users/event-roles') + '?token=' + token,
            {
                user_id: userId,
                event_id: eventId,
                event_roles: payload?.event_roles,
                event_is_staff: payload?.event_is_staff,
                event_is_admin: payload?.event_is_admin,
            },
            { headers: this.utils.getHeaders() }
        );
    }

    private normalizeUser(rawUser: any): User {
        return {
            id: rawUser?.id,
            legacy_user_id: rawUser?.legacy_user_id,
            full_name: rawUser?.full_name,
            display_name: rawUser?.display_name,
            birth_date: rawUser?.birth_date,
            age: rawUser?.age,
            gender: rawUser?.gender,
            shirt_size: rawUser?.shirt_size,
            coming_from: rawUser?.coming_from,
            allergies: rawUser?.allergies,
            guardian_phone: rawUser?.guardian_phone,
            church: rawUser?.church,
            registered_at: rawUser?.registered_at,
            guardian_name: rawUser?.guardian_name,
            guardian_email: rawUser?.guardian_email,
            medications: rawUser?.medications,
            phone: rawUser?.phone,
            user_status: rawUser?.user_status,
            accepted_policies: rawUser?.accepted_policies,
            nombre: rawUser?.nombre ?? rawUser?.full_name,
            nick: rawUser?.nick ?? rawUser?.display_name,
            fechaNac: rawUser?.fechaNac ?? rawUser?.birth_date,
            edad: rawUser?.edad ?? rawUser?.age,
            sexo: rawUser?.sexo ?? rawUser?.gender,
            talla: rawUser?.talla ?? rawUser?.shirt_size,
            vienesDe: rawUser?.vienesDe ?? rawUser?.coming_from,
            alergias: rawUser?.alergias ?? rawUser?.allergies,
            tutorTelefono: rawUser?.tutorTelefono ?? rawUser?.guardian_phone,
            iglesia: rawUser?.iglesia ?? rawUser?.church,
            tutorNombre: rawUser?.tutorNombre ?? rawUser?.guardian_name,
            emailTutor: rawUser?.emailTutor ?? rawUser?.guardian_email,
            medicamentos: rawUser?.medicamentos ?? rawUser?.medications,
            telefono: rawUser?.telefono ?? rawUser?.phone,
            aceptaPoliticas: rawUser?.aceptaPoliticas ?? rawUser?.accepted_policies,
            email: rawUser?.email,
            whatsapp: rawUser?.whatsapp,
            facebook: rawUser?.facebook,
            instagram: rawUser?.instagram,
        } as User;
    }

    public consultarIndicadores(opcion: number, campamentoId: number): Observable<IndicadoresResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<IndicadoresResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=' + opcion
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public getEventDashboard(eventId: number): Observable<EventDashboardResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.get<EventDashboardResponse>(
            this.utils.v1('/events/dashboard') + '?token=' + token + '&event_id=' + encodeURIComponent(String(eventId)),
            { headers: this.utils.getHeaders() }
        );
    }

    public actualizarEventRol(user_id: number, event_id: number, event_is_staff: boolean, event_is_admin: boolean): Observable<DefaultResponse> {
        const user = this.autho.getSessionValida();
        return this.http.patch<DefaultResponse>(this.utils.v1('/users/event-roles') 
            + '?token=' + user?.token
            , {
                "user_id": user_id,
                "event_id": event_id,
                "event_is_staff": event_is_staff,
                "event_is_admin": event_is_admin
            }
            , { headers: this.utils.getHeaders() });
    }

    public actualizarRegistro(registrationId: number, payload: {
        status?: string;
        is_confirmed?: boolean;
        attendance_confirmed?: boolean;
        is_followup?: boolean;
        welcome_email_sent?: boolean;
        email_confirmed?: boolean;
    }): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.patch<DefaultResponse>(
            this.utils.v1('/registrations/status') + '?token=' + token,
            {
                registration_id: registrationId,
                status: payload?.status,
                is_confirmed: payload?.is_confirmed,
                attendance_confirmed: payload?.attendance_confirmed,
                is_followup: payload?.is_followup,
                welcome_email_sent: payload?.welcome_email_sent,
                email_confirmed: payload?.email_confirmed,
            },
            { headers: this.utils.getHeaders() }
        );
    }

    public actualizarStatus(isActived: boolean, registrationId: number): Observable<DefaultResponse> {
        return this.actualizarRegistro(registrationId, { status: (isActived ? 'A' : 'B') });
    }

    public cambiarContrasena(newPassword: String, id: number, campamentoId: number): Observable<DefaultResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<DefaultResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=10&id=' + id
            + '&newPassword=' + newPassword
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public guardarPago(pago: Pago, eventRegistrationId: number): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.post<DefaultResponse>(
            this.utils.v1('/payments') + '?token=' + token,
            {
                event_registration_id: eventRegistrationId,
                amount: pago.amount,
                description: pago.description,
                currency: pago.currency || 'MXN',
                receipt_number: pago.receipt_number,
            },
            { headers: this.utils.getHeaders() }
        );
    }

    public actualizarPago(pago: Pago): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.patch<DefaultResponse>(
            this.utils.v1('/payments') + '?token=' + token,
            {
                payment_id: pago.id,
                amount: pago.amount,
                description: pago.description,
                currency: pago.currency,
                receipt_number: pago.receipt_number,
            },
            { headers: this.utils.getHeaders() }
        );
    }

    public borrarPago(pago: Pago): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.delete<DefaultResponse>(
            this.utils.v1('/payments') + '?token=' + token + '&payment_id=' + pago.id,
            { headers: this.utils.getHeaders() }
        );
    }

    public guardarConfirmacion(valor: boolean, registrationId: number): Observable<DefaultResponse> {
        return this.actualizarRegistro(registrationId, { is_confirmed: valor });
    }

    public guardarAsistencia(valor: boolean, registrationId: number): Observable<DefaultResponse> {
        return this.actualizarRegistro(registrationId, { attendance_confirmed: valor });
    }

    public enviarConfirmarEmail(enviar: boolean, confirmar: boolean, registrationId: number): Observable<DefaultResponse> {
        return this.actualizarRegistro(registrationId, {
            welcome_email_sent: enviar,
            email_confirmed: confirmar,
        });
    }

    public guardarSeguimiento(valor: boolean, registrationId: number): Observable<DefaultResponse> {
        return this.actualizarRegistro(registrationId, { is_followup: valor });
    }

    public consultarHistorico(year: number, campamentoId: number): Observable<EventRegistrationResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<any>(environment.apiUrl + 'retourbano/mantenimiento.php'
            + '?opcion=11'
            + '&year=' + year
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() }).pipe(
                map((response) => {
                    const rawList = response?.resultado || [];
                    const resultado: EventRegistration[] = rawList.map((item: any) => ({
                        user: this.normalizeUser(item),
                    } as EventRegistration));
                    return { ...response, data: { registrations: resultado } } as EventRegistrationResponse;
                })
            );
    }

    public validarEmail(email: String, id_campamento: number): Observable<DefaultResponse> {
        return this.http.post<any>(
            this.utils.v1('/re-enrollment/request-code'),
            {
                email,
                event_id: id_campamento,
            },
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                code: response?.code || 200,
                message: response?.message || 'Solicitud procesada',
            } as DefaultResponse)),
            catchError((error) => {
                const apiMessage = error?.error?.message || error?.error?.mensaje;
                if (apiMessage) {
                    return of({
                        success: false,
                        error: true,
                        code: error?.status || error?.error?.code || 500,
                        message: apiMessage,
                    } as DefaultResponse);
                }

                return this.http.get<any>(
                environment.apiUrl + 'retourbano/validar-email.php?email=' + encodeURIComponent(String(email || '')) + '&id_campamento=' + encodeURIComponent(String(id_campamento || '')),
                { headers: this.utils.getHeaders() }
            ).pipe(
                map((legacy) => ({
                    success: legacy?.success ?? !legacy?.error,
                    error: !!legacy?.error,
                    code: legacy?.code || 200,
                    message: legacy?.message || legacy?.mensaje || 'Solicitud procesada',
                } as DefaultResponse))
                );
            })
        );
    }

    public validarCodigo(code: String, eventId?: number): Observable<GuerreroResponse> {
        const eventQuery = eventId && eventId > 0 ? '&event_id=' + encodeURIComponent(String(eventId)) : '';
        return this.http.get<any>(
            this.utils.v1('/re-enrollment/validate-code') + '?code=' + encodeURIComponent(String(code || '')) + eventQuery,
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => {
                const rawUser = response?.data?.user || response?.resultado || null;
                const rawRegistration = response?.data?.registration || null;
                const normalizedRegistration = rawRegistration
                    ? ({
                        ...rawRegistration,
                        user: this.normalizeUser(rawRegistration?.user || rawUser),
                        razones: rawRegistration?.razones ?? rawRegistration?.reasons,
                        hospedaje: (rawRegistration?.hospedaje ?? rawRegistration?.requires_lodging ?? 0) === 1,
                    } as EventRegistration)
                    : undefined;

                return {
                    success: !!response?.success,
                    error: !response?.success,
                    code: response?.code || 200,
                    message: response?.message || 'Ok',
                    resultado: this.normalizeUser(rawUser),
                    already_registered: !!response?.data?.already_registered,
                    registration: normalizedRegistration,
                } as GuerreroResponse;
            }),
            catchError((error) => {
                const apiMessage = error?.error?.message || error?.error?.mensaje;
                if (apiMessage) {
                    return of({
                        success: false,
                        error: true,
                        code: error?.status || error?.error?.code || 500,
                        message: apiMessage,
                        resultado: {} as User,
                        already_registered: false,
                    } as GuerreroResponse);
                }

                return this.http.get<any>(
                environment.apiUrl + 'retourbano/validar-codigo.php?codigo=' + encodeURIComponent(String(code || '')),
                { headers: this.utils.getHeaders() }
            ).pipe(
                map((legacy) => ({
                    success: legacy?.success ?? !legacy?.error,
                    error: !!legacy?.error,
                    code: legacy?.code || 200,
                    message: legacy?.message || legacy?.mensaje || 'Ok',
                    resultado: this.normalizeUser(legacy?.resultado),
                    already_registered: false,
                } as GuerreroResponse))
                );
            })
        );
    }

    public validarInscripcion(eventId?: number): Observable<RegistroResponse> {
        const session = this.autho.getSessionValida();
        const token = session?.token?.toString() || '';
        const eventQuery = eventId && eventId > 0 ? '&event_id=' + eventId : '';

        return this.http.get<any>(
            this.utils.v1('/events/upcoming-availability') + '?token=' + encodeURIComponent(token) + eventQuery,
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => {
                return {
                    success: !!response?.success,
                    error: !response?.success,
                    message: response?.message || 'Disponibilidad consultada',
                    code: response?.code || 200,
                    inscrito: !!response?.data?.inscrito,
                    events: response?.data?.events || []
                } as RegistroResponse;
            }),
            catchError(() => this.http.get<any>(
                this.utils.v1('/retourbano/validar-inscripcion.php?id=' + session?.id),
                { headers: this.utils.getHeaders() }
            ).pipe(
                map((legacy) => ({
                    success: legacy?.success ?? !legacy?.error,
                    error: !!legacy?.error,
                    message: legacy?.message || legacy?.mensaje || 'Disponibilidad consultada',
                    code: legacy?.code || 200,
                    inscrito: !!legacy?.inscrito,
                    events: legacy?.events || []
                } as RegistroResponse))
            ))
        );
    }

    public obtenerHospedajes(con_hospedaje: Boolean, campamentoId: number): Observable<HospedajeResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<HospedajeResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=12'
            + '&con_hospedaje=' + (con_hospedaje ? '1' : '0')
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public obtenerHabitaciones(campamentoId: number): Observable<HabitacionResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<HabitacionResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=19'
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public obtenerPersonasSinHabitacion(campamentoId: number): Observable<SinHabitacionResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<SinHabitacionResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=20'
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public actualizarHabitacion(id: number, habitacion: string, campamentoId: number): Observable<DefaultResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<DefaultResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=13&id=' + id
            + '&habitacion=' + habitacion
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public actualizarHospedaje(id: number, hospedaje: boolean, campamentoId: number): Observable<DefaultResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<DefaultResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=21&id=' + id
            + '&hospedaje=' + (hospedaje ? '1' : '0')
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public obtenerUsuarios(campamentoId: number): Observable<MtoLoginResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<MtoLoginResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=15'
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public obtenerRepetidos(campamentoId: number): Observable<EventRegistrationResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<EventRegistrationResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=16'
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public updateEmailTutor(id: number, email: String, email_tutor: String, campamentoId: number): Observable<DefaultResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<DefaultResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=17'
            + '&id=' + id
            + '&email=' + email
            + '&email_tutor=' + email_tutor
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public actualizarPassword(email: String, password: String, campamentoId: number): Observable<DefaultResponse> {
        const usernameSafe = encodeURIComponent(email.toString());
        const passwordSafe = encodeURIComponent(password.toString());
        const user = this.autho.getSessionValida();
        return this.http.get<DefaultResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=18&email=' + usernameSafe
            + '&password=' + passwordSafe
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public getIndicadores(campamentoId: number): Observable<IndicadoresResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<IndicadoresResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=22'
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public getUserRegistrations(limit: number = 100, offset: number = 0): Observable<EventResponse> {
        const session = this.autho.getSessionValida();
        const token = session?.token?.toString() || '';

        return this.http.get<any>(
            this.utils.v1('/registrations/by-user') + '?token=' + encodeURIComponent(token) + '&user_id=' + session?.id + '&limit=' + limit + '&offset=' + offset,
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => {
                return {
                    success: !!response?.success,
                    error: !response?.success,
                    message: response?.message || 'Registrations retrieved',
                    code: response?.code || 200,
                    data: {
                        events: response?.data?.registrations || []
                    }
                } as EventResponse;
            }),
            catchError((error) => {
                console.error('Error getting user registrations:', error);
                return of({
                    success: false,
                    error: true,
                    message: 'Error al obtener historial de eventos',
                    code: 500,
                    data: {
                        events: []
                    }
                } as EventResponse);
            })
        );
    }
}