import { Injectable } from "@angular/core";
import { Observable, map } from 'rxjs';
import { environment } from 'src/environments/environment';
import { Utils } from "../Utils";
import { LoginResponse } from "src/app/models/login/LoginResponse";
import { Session } from "src/app/models/login/Session";
import { DefaultResponse } from "src/app/models/DefaultResponse";
import { HttpClient } from "@angular/common/http";

@Injectable()
export class LoginDao {

    session? : Session;

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    public login(username: String, password: String): Observable<LoginResponse> {
        return this.http.get<LoginResponse>(environment.apiUrl + 'retourbano/login.php?username=' + username + '&password=' + password, { headers: this.utils.getHeaders() });
    }

    public logout(): Observable<LoginResponse>{
        this.session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<LoginResponse>(environment.apiUrl + 'retourbano/logout.php?id='+this.session?.id+"&token="+this.session?.token , { headers: this.utils.getHeaders() });
    }

    public getSession(): Observable<Session> {
        this.session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<Session>(environment.apiUrl + 'retourbano/session.php?id='+this.session?.id+"&token="+this.session?.token , { headers: this.utils.getHeaders() });
    }

    public validarSession(): Observable<boolean> {
        this.session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<Session>(environment.apiUrl + 'retourbano/session.php?id='+this.session?.id+"&token="+this.session?.token , { headers: this.utils.getHeaders() }).pipe(
            map(response => !response.error)
        );
    }

    public isAdmin(): Observable<boolean> {
        this.session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<Session>(environment.apiUrl + 'retourbano/session.php?id='+this.session?.id+"&token="+this.session?.token , { headers: this.utils.getHeaders() }).pipe(
            map(response => !response.guerrero?.admin)
        );
    }

    public recoveryPassword(email: string) : Observable<DefaultResponse> {
        return this.http.get<DefaultResponse>(environment.apiUrl + 'retourbano/recovery-password.php?email=' + email, { headers: this.utils.getHeaders() });
    }

}