import { Injectable } from "@angular/core";
import { Observable, catchError, map, of, switchMap } from 'rxjs';
import { environment } from 'src/environments/environment';
import { UserRole, Utils } from "../Utils";
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
import { AuthService } from "../../services/auth.service";
import { MtoLoginResponse } from "../../models/login/MtoLoginResponse";
import { HabitacionResponse } from "../../models/hospedaje/HabitacionResponse";
import { SinHabitacionResponse } from "../../models/hospedaje/SinHabitacionResponse";
import { EventResponse } from "../../models/registro/EventResponse";
import { CampamentoGuerreros, CampamentoGuerrerosResponse } from "../../models/registro/CampamentoGuerreros";

interface UserProfileResponse extends DefaultResponse {
    user?: User;
    roles?: UserRole[];
    has_password?: boolean;
    active_registrations?: any[];
    historical_registrations?: any[];
}

interface UserActivityItem {
    id?: number;
    affected_user_id?: number;
    action?: string;
    old_value?: string;
    new_value?: string;
    created_at?: string;
}

interface UserActivityResponse extends DefaultResponse {
    movements?: UserActivityItem[];
}

interface StaffActivityLogItem {
    id?: number;
    action?: string;
    action_label?: string;
    actor_user_id?: number;
    actor_name?: string;
    actor_email?: string;
    affected_user_id?: number;
    affected_name?: string;
    affected_email?: string;
    entity_type?: string;
    entity_id?: number;
    related_event_id?: number;
    related_event_title?: string;
    related_event_year?: number;
    related_registration_id?: number;
    source?: string;
    old_value?: string;
    new_value?: string;
    metadata_json?: string;
    created_at?: string;
    updated_at?: string;
}

interface StaffActivityLogFilterOption {
    value: string;
    label: string;
}

interface StaffActivityLogResponse extends DefaultResponse {
    items?: StaffActivityLogItem[];
    filters?: {
        actions?: StaffActivityLogFilterOption[];
    };
    pagination?: {
        limit?: number;
        offset?: number;
        count?: number;
        total?: number;
        search?: string;
        action?: string;
    };
}

interface StaffClientActivityPayload {
    action: string;
    summary?: string;
    affected_user_id?: number;
    entity_type?: string;
    entity_id?: number;
    related_event_id?: number;
    related_registration_id?: number;
    metadata?: Record<string, unknown>;
}

interface UserProfileUpdatePayload {
    full_name?: string;
    display_name?: string;
    birth_date?: string;
    age?: number | null;
    gender?: string;
    shirt_size?: string;
    coming_from?: string;
    email?: string;
    whatsapp?: string;
    phone?: string;
    allergies?: string;
    guardian_phone?: string;
    guardian_name?: string;
    guardian_email?: string;
    church?: string;
    medications?: string;
}

@Injectable()
export class RegistroDao {

    constructor(
        private http: HttpClient,
        private utils: Utils,
        private autho: AuthService
    ) { }

    /**
     * @deprecated Uses legacy endpoint retourbano/configuracion.php. Migrate to v1 endpoint.
     */
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
            requires_lodging: guerrero?.requires_lodging,
            event_id: event_id,
        };

        return this.http.post<RegistroResponse>(
            this.utils.v1('/registrations') + '?tutor=' + (tutor ? '1' : '0') + '&event_id=' + event_id+'&reinscription=0',
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
            requires_lodging: guerrero?.requires_lodging,
            event_id: event_id,
        };

        return this.http.put<RegistroResponse>(
            this.utils.v1('/registrations') + '?event_id=' + event_id,
            payload,
            { headers: this.utils.getHeaders() }
        );
    }

    public consultarInscritos(opcion: number, activo: boolean, staff: boolean, byName: string, seg: boolean, event_id?: number): Observable<EventRegistrationResponse> {
        const user = this.autho.getSessionValida();
        const params: string[] = [
            'event_id=' + encodeURIComponent(String(event_id || '')),
            'token=' + encodeURIComponent(String(user?.token || '')),
        ];

        // Keep legacy UX behavior: only send positive boolean filters.
        params.push('is_staff=' + (staff ? '1' : '0'));
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
                            welcome_email_sent: this.toIntegerCount(item?.welcome_email_sent ?? item?.email_enviado ?? 0),
                            email_confirmed: this.toIntegerCount(item?.email_confirmed ?? item?.email_confirmado ?? 0),
                            requires_lodging: (item?.requires_lodging ?? 0) === 1,
                            room_code: item?.room_code,
                            reasons: item?.reasons,
                            razones: item?.reasons,
                            pagado: rawUser?.pagado ?? item?.pagado,
                            pagos: rawUser?.pagos ?? item?.pagos,
                            previous_events: item?.previous_events ?? [],
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

    public consultarInscritosPorEvento(eventId: number): Observable<EventRegistrationResponse> {
        const user = this.autho.getSessionValida();
        const params: string[] = [
            'event_id=' + encodeURIComponent(String(eventId || '')),
            'token=' + encodeURIComponent(String(user?.token || '')),
        ];

        return this.http.get<any>(
            this.utils.v1('/registrations/by-event') + '?' + params.join('&'),
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => {
                const registrations = response?.data?.registrations || [];
                const users = registrations.map((item: any) => {
                    const rawUser = item?.user || item;
                    const normalizedUser = this.normalizeUser(rawUser);

                    return {
                        id: item?.id,
                        event_id: item?.event_id,
                        user_id: item?.user_id,
                        registration_status: item?.registration_status,
                        is_confirmed: (item?.is_confirmed ?? 0) === 1,
                        attendance_confirmed: (item?.attendance_confirmed ?? 0) === 1,
                        is_staff: (item?.is_staff ?? 0) === 1,
                        is_admin: (item?.is_admin ?? 0) === 1,
                        is_followup: (item?.is_followup ?? 0) === 1,
                        welcome_email_sent: this.toIntegerCount(item?.welcome_email_sent ?? item?.email_enviado ?? 0),
                        email_confirmed: this.toIntegerCount(item?.email_confirmed ?? item?.email_confirmado ?? 0),
                        requires_lodging: (item?.requires_lodging ?? 0) === 1,
                        room_code: item?.room_code,
                        reasons: item?.reasons,
                        razones: item?.reasons,
                        pagado: rawUser?.pagado ?? item?.pagado,
                        pagos: rawUser?.pagos ?? item?.pagos,
                        previous_events: item?.previous_events ?? [],
                        roles: item?.roles ?? [],
                        user: normalizedUser,
                    };
                });

                return {
                    success: !!response?.success,
                    error: !response?.success,
                    message: response?.message || 'Inscritos por evento consultados',
                    code: response?.code || 200,
                    data: {
                        registrations: users
                    }
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

    private toIntegerCount(value: any): number {
        const parsed = Number(value ?? 0);
        return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
    }

    /**
     * @deprecated Uses legacy endpoint retourbano/mantenimiento.php. Migrate to v1 endpoint.
     */
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
        welcome_email_sent?: number | boolean;
        email_confirmed?: number | boolean;
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

    /**
     * @deprecated Uses legacy endpoint retourbano/mantenimiento.php. Migrate to v1 endpoint.
     */
    public cambiarContrasena(newPassword: String, id: number, campamentoId: number): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.patch<DefaultResponse>(
            this.utils.v1('/users/password') + '?token=' + token,
            {
                user_id: id,
                new_password: newPassword,
                event_id: campamentoId,
            },
            { headers: this.utils.getHeaders() }
        );
    }

    public resetearContrasena(id: number): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.patch<DefaultResponse>(
            this.utils.v1('/users/password/reset') + '?token=' + token,
            {
                user_id: id,
            },
            { headers: this.utils.getHeaders() }
        );
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

    public enviarConfirmarEmail(registrationId: number): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.post<DefaultResponse>(
            this.utils.v1('/registrations/confirmation-email') + '?token=' + token,
            { registration_id: registrationId },
            { headers: this.utils.getHeaders() }
        );
    }

    public guardarSeguimiento(valor: boolean, registrationId: number): Observable<DefaultResponse> {
        return this.actualizarRegistro(registrationId, { is_followup: valor });
    }

    public reenviarWelcomeEmail(registrationId: number): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.post<DefaultResponse>(
            this.utils.v1('/registrations/welcome-email') + '?token=' + token,
            { registration_id: registrationId },
            { headers: this.utils.getHeaders() }
        );
    }

    public borrarRegistro(registrationId: number): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.delete<DefaultResponse>(
            this.utils.v1('/registrations') + '?token=' + token + '&registration_id=' + registrationId,
            { headers: this.utils.getHeaders() }
        );
    }

    /**
     * @deprecated Uses legacy endpoint retourbano/mantenimiento.php. Migrate to v1 endpoint.
     */
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

                return of({
                    success: false,
                    error: true,
                    code: error?.status || 500,
                    message: 'No fue posible procesar la solicitud',
                } as DefaultResponse);
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

                return of({
                    success: false,
                    error: true,
                    code: error?.status || 500,
                    message: 'No fue posible validar el codigo',
                    resultado: {} as User,
                    already_registered: false,
                } as GuerreroResponse);
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
            catchError((error) => of({
                success: false,
                error: true,
                message: error?.error?.message || 'No fue posible consultar disponibilidad',
                code: error?.status || 500,
                inscrito: false,
                events: []
            } as RegistroResponse))
        );
    }

    /**
     * GET /api/v1/lodging/registrations
     * Get registrations filtered by lodging requirement
     */
    public obtenerHospedajes(con_hospedaje: Boolean, campamentoId: number): Observable<EventRegistrationResponse> {
        const session = this.autho.getSessionValida();
        const params = [
            'event_id=' + String(campamentoId || ''),
            'token=' + String(session?.token || ''),
        ];

        if (con_hospedaje !== null && con_hospedaje !== undefined) {
            params.push('with_lodging=' + (con_hospedaje ? '1' : '0'));
        }

        return this.http.get<any>(this.utils.v1('/lodging/registrations') + '?' + params.join('&'),
            { headers: this.utils.getHeaders() }).pipe(
            map((response) => {
                return {
                    success: !!response?.success,
                    error: !response?.success,
                    message: response?.message || 'OK',
                    code: response?.code || 200,
                    data: response?.data
                } as EventRegistrationResponse;
            })
        );
    }

    /**
     * GET /api/v1/lodging/rooms
     * Get all rooms with their occupants
     */
    public obtenerHabitaciones(campamentoId: number): Observable<HabitacionResponse> {
        const session = this.autho.getSessionValida();
        const params = [
            'event_id=' + encodeURIComponent(String(campamentoId || '')),
            'token=' + encodeURIComponent(String(session?.token || ''))
        ];

        return this.http.get<any>(this.utils.v1('/lodging/rooms') + '?' + params.join('&'),
            { headers: this.utils.getHeaders() }).pipe(
            map((response) => {
                const rooms = response?.data.rooms || [];
                const habitaciones = rooms.map((room: any) => ({
                    habitacion: room.room_code,
                    count: room.occupants_count,
                    personas: room.registrations
                }));

                return {
                    success: !!response?.success,
                    error: !response?.success,
                    message: response?.message || 'OK',
                    code: response?.code || 200,
                    resultado: habitaciones
                } as HabitacionResponse;
            })
        );
    }

    /**
     * GET /api/v1/lodging/unassigned
     * Get registrations without room assignment
     */
    public obtenerPersonasSinHabitacion(campamentoId: number): Observable<SinHabitacionResponse> {
        const session = this.autho.getSessionValida();
        const params = [
            'event_id=' + encodeURIComponent(String(campamentoId || '')),
            'token=' + encodeURIComponent(String(session?.token || ''))
        ];

        return this.http.get<any>(this.utils.v1('/lodging/unassigned') + '?' + params.join('&'),
            { headers: this.utils.getHeaders() }).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                message: response?.message || 'OK',
                code: response?.code || 200,
                personas: response?.registrations || []
            } as SinHabitacionResponse))
        );
    }

    /**
     * PATCH /api/v1/lodging/room-assignment
     * Update room assignment for a registration
     */
    public actualizarHabitacion(id: number, habitacion: String, campamentoId: number): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const payload = {
            registration_id: id,
            room_code: habitacion,
            token: session?.token
        };

        return this.http.patch<DefaultResponse>(this.utils.v1('/lodging/room-assignment'),
            payload,
            { headers: this.utils.getHeaders() });
    }

    /**
     * PATCH /api/v1/lodging/lodging-requirement
     * Update lodging requirement for a registration
     */
    public actualizarHospedaje(id: number, hospedaje: boolean, campamentoId: number): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const payload = {
            registration_id: id,
            requires_lodging: hospedaje ? 1 : 0,
            token: session?.token
        };

        return this.http.patch<DefaultResponse>(this.utils.v1('/lodging/lodging-requirement'),
            payload,
            { headers: this.utils.getHeaders() });
    }

    /**
     * @deprecated Uses legacy endpoint retourbano/mantenimiento.php. Migrate to v1 endpoint.
     */
    public obtenerUsuarios(campamentoId: number, search: string = ''): Observable<MtoLoginResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));
        const searchParam = encodeURIComponent(search.trim());

        return this.http.get<any>(
            this.utils.v1('/users') + '?token=' + token + '&search=' + searchParam,
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => {
                const users = (response?.data?.users || []).map((item: any) => ({
                    ...item,
                    roles: Array.isArray(item?.roles) ? item.roles : [],
                    password: '',
                }));

                return {
                    success: !!response?.success,
                    error: !response?.success,
                    message: response?.message || 'Usuarios consultados',
                    code: response?.code || 200,
                    users,
                } as MtoLoginResponse;
            })
        );
    }

    public obtenerHistoricoUsuarios(search: string = ''): Observable<MtoLoginResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));
        const searchParam = encodeURIComponent(search.trim());

        return this.http.get<any>(
            this.utils.v1('/users/history') + '?token=' + token + '&search=' + searchParam,
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => {
                const users = (response?.data?.users || []).map((item: any) => ({
                    ...item,
                    roles: Array.isArray(item?.roles) ? item.roles : [],
                    password: '',
                }));

                return {
                    success: !!response?.success,
                    error: !response?.success,
                    message: response?.message || 'Historico consultado',
                    code: response?.code || 200,
                    users,
                } as MtoLoginResponse;
            })
        );
    }

    public obtenerPerfilCuenta(includeDashboard: boolean = false): Observable<UserProfileResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));
        const dashboardFlag = includeDashboard ? '&include_dashboard=1' : '';

        return this.http.get<any>(
            this.utils.v1('/users/profile') + '?token=' + token + dashboardFlag,
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                message: response?.message || 'Perfil consultado',
                code: response?.code || 200,
                user: response?.data?.user as User,
                roles: Array.isArray(response?.data?.roles) ? response.data.roles : [],
                has_password: !!response?.data?.has_password,
                active_registrations: Array.isArray(response?.data?.active_registrations) ? response.data.active_registrations : [],
                historical_registrations: Array.isArray(response?.data?.historical_registrations) ? response.data.historical_registrations : [],
            } as UserProfileResponse))
        );
    }

    public actualizarPerfilCuenta(payload: UserProfileUpdatePayload): Observable<UserProfileResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.patch<any>(
            this.utils.v1('/users/profile') + '?token=' + token,
            payload,
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                message: response?.message || 'Perfil actualizado',
                code: response?.code || 200,
                user: response?.data?.user as User,
                roles: Array.isArray(response?.data?.roles) ? response.data.roles : [],
                has_password: !!response?.data?.has_password,
            } as UserProfileResponse))
        );
    }

    public actualizarPasswordPropia(newPassword: string): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.patch<DefaultResponse>(
            this.utils.v1('/users/profile/password') + '?token=' + token,
            { new_password: newPassword },
            { headers: this.utils.getHeaders() }
        );
    }

    public obtenerActividadCuenta(limit: number = 10): Observable<UserActivityResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.get<any>(
            this.utils.v1('/users/profile/activity') + '?token=' + token + '&limit=' + limit,
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                message: response?.message || 'Actividad consultada',
                code: response?.code || 200,
                movements: Array.isArray(response?.data?.movements) ? response.data.movements : [],
            } as UserActivityResponse))
        );
    }

    public obtenerBitacoraStaff(limit: number = 100, offset: number = 0, search: string = '', action: string = ''): Observable<StaffActivityLogResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));
        const params = new URLSearchParams({
            token,
            limit: String(limit),
            offset: String(offset),
        });

        if (search.trim()) {
            params.set('search', search.trim());
        }

        if (action.trim()) {
            params.set('action', action.trim());
        }

        return this.http.get<any>(
            this.utils.v1('/users/activity-log') + '?' + params.toString(),
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                message: response?.message || 'Bitacora consultada',
                code: response?.code || 200,
                items: Array.isArray(response?.data?.items) ? response.data.items : [],
                filters: {
                    actions: Array.isArray(response?.data?.filters?.actions) ? response.data.filters.actions : [],
                },
                pagination: response?.data?.pagination || {},
            } as StaffActivityLogResponse))
        );
    }

    public registrarActividadStaff(payload: StaffClientActivityPayload): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.post<any>(
            this.utils.v1('/users/activity-log') + '?token=' + token,
            payload,
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                message: response?.message || 'Actividad registrada',
                code: response?.code || 200,
            } as DefaultResponse))
        );
    }

    /**
     * @deprecated Uses legacy endpoint retourbano/mantenimiento.php. Migrate to v1 endpoint.
     */
    public obtenerRepetidos(campamentoId: number): Observable<CampamentoGuerrerosResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.get<any>(
            this.utils.v1('/users/duplicates') + '?token=' + token,
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                message: response?.message || 'Repetidos consultados',
                code: response?.code || 200,
                data: {
                    duplicates: (response?.data?.duplicates || []) as CampamentoGuerreros[],
                },
            } as CampamentoGuerrerosResponse))
        );
    }

    /**
     * @deprecated Uses legacy endpoint retourbano/mantenimiento.php. Migrate to v1 endpoint.
     */
    public updateEmailTutor(id: number, email: String, email_tutor: String, campamentoId: number): Observable<DefaultResponse> {
        const session = this.autho.getSessionValida();
        const token = encodeURIComponent(String(session?.token || ''));

        return this.http.patch<DefaultResponse>(
            this.utils.v1('/users/tutor-link') + '?token=' + token,
            {
                legacy_user_id: id,
                email,
                email_tutor,
            },
            { headers: this.utils.getHeaders() }
        );
    }

    /**
     * @deprecated Uses legacy endpoint retourbano/mantenimiento.php. Migrate to v1 endpoint.
     */
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

    /**
     * @deprecated Uses legacy endpoint retourbano/mantenimiento.php. Migrate to v1 endpoint.
     */
    public getIndicadores(campamentoId: number): Observable<IndicadoresResponse> {
        const user = this.autho.getSessionValida();
        return this.http.get<IndicadoresResponse>(environment.apiUrl
            + 'retourbano/mantenimiento.php?opcion=22'
            + '&user=' + user?.id
            + '&token=' + user?.token
            + '&campamento_id=' + campamentoId
            , { headers: this.utils.getHeaders() });
    }

    public getUserRegistrations(limit: number = 100, offset: number = 0, includeActive: boolean = false): Observable<EventResponse> {
        const session = this.autho.getSessionValida();
        const token = session?.token?.toString() || '';
        const includeActiveFlag = includeActive ? '&include_active=1' : '';

        return this.http.get<any>(
            this.utils.v1('/registrations/by-user') + '?token=' + encodeURIComponent(token) + '&user_id=' + session?.id + '&limit=' + limit + '&offset=' + offset + includeActiveFlag,
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