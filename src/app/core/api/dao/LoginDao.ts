import { inject, Injectable } from "@angular/core";
import { Observable, map } from 'rxjs';
import { environment } from 'src/environments/environment';
import { Utils } from "../Utils";
import { LoginResponse } from "src/app/core/models/login/LoginResponse";
import { Session } from "src/app/core/models/login/Session";
import { DefaultResponse } from "src/app/core/models/DefaultResponse";
import { HttpClient } from "@angular/common/http";
import { SessionResponse } from "../../models/login/SessionResponse";
import { AuthService } from "../../services/auth.service";

@Injectable()
export class LoginDao {

    session? : Session;

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    public login(username: String, password: String): Observable<LoginResponse> {
        const usernameSafe = encodeURIComponent(username.toString());
        const passwordSafe = encodeURIComponent(password.toString());
        return this.http.get<LoginResponse>(environment.apiUrl + 'retourbano/login.php?username=' + usernameSafe + '&password=' + passwordSafe, { headers: this.utils.getHeaders() });
    }

    public logout(): Observable<LoginResponse>{
        this.session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<LoginResponse>(environment.apiUrl + 'retourbano/logout.php?id='+this.session?.guerrero?.id+"&token="+this.session?.token , { headers: this.utils.getHeaders() });
    }

    public getSession(): Observable<SessionResponse> {
        this.session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<SessionResponse>(environment.apiUrl + 'retourbano/session.php?id='+this.session?.guerrero?.id+"&token="+this.session?.token , { headers: this.utils.getHeaders() });
    }

    public isAdmin(): Observable<boolean> {
        this.session = inject(AuthService).getSession()!;
        return this.http.get<SessionResponse>(environment.apiUrl + 'retourbano/session.php?id='+this.session?.guerrero?.id+"&token="+this.session?.token , { headers: this.utils.getHeaders() }).pipe(
            map(response => !response.session?.guerrero?.admin)
        );
    }

    public recoveryPassword(email: string) : Observable<DefaultResponse> {
        return this.http.get<DefaultResponse>(environment.apiUrl + 'retourbano/recovery-password.php?email=' + email, { headers: this.utils.getHeaders() });
    }

}