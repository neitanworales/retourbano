import { inject, Injectable } from "@angular/core";
import { Observable, map } from 'rxjs';
import { Utils, UserRole } from "../Utils";
import { LoginResponse } from "src/app/core/models/login/LoginResponse";
import { Session } from "src/app/core/models/login/Session";
import { DefaultResponse } from "src/app/core/models/DefaultResponse";
import { HttpClient } from "@angular/common/http";
import { SessionResponse } from "../../models/login/SessionResponse";
import { AuthService } from "../../services/auth.service";
import { Usuario } from "../../models/usuario/Usuario";

interface V1LoginUser {
    id: number;
    full_name?: string;
    display_name?: string;
    email?: string;
}

interface V1LoginPayload {
    token: string;
    user: V1LoginUser;
    roles?: UserRole[];
}

interface V1ValidatePayload {
    user: V1LoginUser;
    roles?: UserRole[];
}

interface V1Response<T> {
    success?: boolean;
    message?: string;
    data?: T;
    code?: number;
}

@Injectable()
export class LoginDao {

    session? : Session;

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    public login(username: String, password: String): Observable<LoginResponse> {
        const body = {
            email: username.toString(),
            password: password.toString()
        };

        return this.http.post<V1Response<V1LoginPayload>>(this.utils.v1('/auth/login'), body, { headers: this.utils.getHeaders() }).pipe(
            map((response) => this.mapV1LoginToLegacy(response))
        );
    }

    public logout(): Observable<LoginResponse>{
        this.session = JSON.parse(localStorage.getItem('session')!);
        const body = { token: this.session?.token?.toString() || '' };

        return this.http.post<V1Response<Record<string, never>>>(this.utils.v1('/auth/logout'), body, { headers: this.utils.getHeaders() }).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                message: response?.message || 'logout',
                code: response?.code || 200
            } as LoginResponse))
        );
    }

    public getSession(): Observable<SessionResponse> {
        this.session = JSON.parse(localStorage.getItem('session')!);
        const body = { token: this.session?.token?.toString() || '' };

        return this.http.post<V1Response<V1ValidatePayload>>(this.utils.v1('/auth/validate'), body, { headers: this.utils.getHeaders() }).pipe(
            map((response) => {
                const user = response?.data?.user;
                const roles = response?.data?.roles || this.session?.roles || [];
                const usuario = new Usuario();
                usuario.id = user?.id;
                usuario.nombre = user?.full_name || '';
                usuario.nick = user?.display_name || '';
                usuario.email = user?.email || '';

                const validSession: Session = {
                    id: user?.id,
                    token: this.session?.token,
                    usuario: usuario,
                    guerrero: usuario,
                    roles: roles
                };

                return {
                    success: !!response?.success,
                    error: !response?.success,
                    message: response?.message || 'session validated',
                    code: response?.code || 200,
                    session: validSession
                } as SessionResponse;
            })
        );
    }

    public isAdmin(): Observable<boolean> {
        this.session = inject(AuthService).getSession()!;
        return this.http.get<any>(
            this.utils.v1('/users/profile') + '?token=' + encodeURIComponent(this.session?.token?.toString() || ''),
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => {
                const roles = response?.data?.roles || [];
                return !(roles.includes('admin') || roles.includes('staff'));
            })
        );
    }

    public recoveryPassword(email: string) : Observable<DefaultResponse> {
        return this.http.post<V1Response<Record<string, never>>>(
            this.utils.v1('/auth/forgot-password'),
            { email },
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                message: response?.message || 'if the email exists, password reset instructions were sent',
                code: response?.code || 200
            } as DefaultResponse))
        );
    }

    private mapV1LoginToLegacy(response: V1Response<V1LoginPayload>): LoginResponse {
        const user = response?.data?.user;
        const usuario = new Usuario();
        usuario.id = user?.id;
        usuario.nombre = user?.full_name || '';
        usuario.nick = user?.display_name || '';
        usuario.email = user?.email || '';

        const session: Session = {
            id: user?.id,
            token: response?.data?.token,
            usuario: usuario,
            guerrero: usuario,
            roles: response?.data?.roles || []
        };

        return {
            success: !!response?.success,
            error: !response?.success,
            message: response?.message || 'login successful',
            code: response?.code || 200,
            session: session
        } as LoginResponse;
    }

}