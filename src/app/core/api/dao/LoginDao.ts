import { inject, Injectable } from "@angular/core";
import { Observable, catchError, map } from 'rxjs';
import { environment } from 'src/environments/environment';
import { Utils } from "../Utils";
import { LoginResponse } from "src/app/core/models/login/LoginResponse";
import { Session } from "src/app/core/models/login/Session";
import { DefaultResponse } from "src/app/core/models/DefaultResponse";
import { HttpClient } from "@angular/common/http";
import { SessionResponse } from "../../models/login/SessionResponse";
import { AuthService } from "../../services/auth.service";
import { TumbaService } from "../../services/tumbaService";
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
        private utils: Utils,
        private tumba: TumbaService
    ) { }

    public login(username: String, password: String): Observable<LoginResponse> {
        const body = {
            email: username.toString(),
            password: password.toString()
        };

        return this.http.post<V1Response<V1LoginPayload>>(this.v1('/auth/login'), body, { headers: this.utils.getHeaders() }).pipe(
            map((response) => this.mapV1LoginToLegacy(response)),
            catchError(() => {
                const usernameEncrypted = this.tumba.encryptar(username);
                const passwordEncrypted = this.tumba.encryptar(password);
                const usernameSafe = encodeURIComponent(usernameEncrypted.toString());
                const passwordSafe = encodeURIComponent(passwordEncrypted.toString());
                return this.http.get<LoginResponse>(
                    environment.apiUrl + 'retourbano/login.php?username=' + usernameSafe + '&password=' + passwordSafe,
                    { headers: this.utils.getHeaders() }
                );
            })
        );
    }

    public logout(): Observable<LoginResponse>{
        this.session = JSON.parse(localStorage.getItem('session')!);
        const body = { token: this.session?.token?.toString() || '' };

        return this.http.post<V1Response<Record<string, never>>>(this.v1('/auth/logout'), body, { headers: this.utils.getHeaders() }).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                mensaje: response?.message || 'logout',
                code: response?.code || 200
            } as LoginResponse)),
            catchError(() => this.http.get<LoginResponse>(
                environment.apiUrl + 'retourbano/logout.php?id=' + this.getSessionUserId(this.session) + '&token=' + this.session?.token,
                { headers: this.utils.getHeaders() }
            ))
        );
    }

    public getSession(): Observable<SessionResponse> {
        this.session = JSON.parse(localStorage.getItem('session')!);
        const body = { token: this.session?.token?.toString() || '' };

        return this.http.post<V1Response<{ user: V1LoginUser }>>(this.v1('/auth/validate'), body, { headers: this.utils.getHeaders() }).pipe(
            map((response) => {
                const user = response?.data?.user;
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
                    roles: this.session?.roles || []
                };

                return {
                    success: !!response?.success,
                    error: !response?.success,
                    mensaje: response?.message || 'session validated',
                    code: response?.code || 200,
                    session: validSession
                } as SessionResponse;
            }),
            catchError(() => this.http.get<SessionResponse>(
                environment.apiUrl + 'retourbano/session.php?id=' + this.getSessionUserId(this.session) + '&token=' + this.session?.token,
                { headers: this.utils.getHeaders() }
            ))
        );
    }

    public isAdmin(): Observable<boolean> {
        this.session = inject(AuthService).getSession()!;
        return this.http.get<SessionResponse>(environment.apiUrl + 'retourbano/session.php?id=' + this.getSessionUserId(this.session) + "&token=" + this.session?.token , { headers: this.utils.getHeaders() }).pipe(
            map(response => !(response.session?.usuario?.admin ?? response.session?.guerrero?.admin))
        );
    }

    public recoveryPassword(email: string) : Observable<DefaultResponse> {
        return this.http.post<V1Response<Record<string, never>>>(
            this.v1('/auth/forgot-password'),
            { email },
            { headers: this.utils.getHeaders() }
        ).pipe(
            map((response) => ({
                error: !response?.success,
                mensaje: response?.message || 'if the email exists, password reset instructions were sent',
                code: response?.code || 200
            } as DefaultResponse)),
            catchError(() => this.http.get<DefaultResponse>(
                environment.apiUrl + 'retourbano/recovery-password.php?email=' + email,
                { headers: this.utils.getHeaders() }
            ))
        );
    }

    private v1(path: string): string {
        const base = (environment.apiUrl || '').replace(/\/+$/, '');
        return `${base}${path}`;
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
            roles: []
        };

        return {
            success: !!response?.success,
            error: !response?.success,
            mensaje: response?.message || 'login successful',
            code: response?.code || 200,
            session: session
        } as LoginResponse;
    }

    private getSessionUserId(session?: Session): number | undefined {
        return session?.usuario?.id ?? session?.guerrero?.id;
    }

}