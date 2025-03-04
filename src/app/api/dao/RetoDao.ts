import { Injectable } from "@angular/core";
import { Observable } from 'rxjs';
import { Session } from "src/app/models/login/Session";
import { DefaultResponse } from "src/app/models/DefaultResponse";
import { SeguimientoResponse } from "src/app/models/reto/SeguimientoResponse";
import { environment } from 'src/environments/environment';
import { Utils } from "../Utils";
import { AsistenciaResponse } from "src/app/models/reto/AsistenciaResponse";
import { HttpClient } from "@angular/common/http";

@Injectable()
export class RetoDao {

    session?: Session;

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    public getAsistencia(): Observable<AsistenciaResponse> {
        this.session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<AsistenciaResponse>(environment.apiUrl + 'retourbano/asistencia-reto.php', { headers: this.utils.getHeaders() });
    }

    public getSeguimientosByGuerror(): Observable<SeguimientoResponse> {
        this.session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<SeguimientoResponse>(environment.apiUrl + 'retourbano/seguimientos-by-guerrero.php?id=' + this.session?.id, { headers: this.utils.getHeaders() });
    }

    public confirmaAsistencia(dia: string): Observable<DefaultResponse> {
        this.session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<DefaultResponse>(environment.apiUrl + 'retourbano/asistencia.php?id=' + this.session?.id + '&dia=' + dia, { headers: this.utils.getHeaders() });
    }

    public confirmaAsistenciaHora(hora: string): Observable<DefaultResponse> {
        this.session = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<DefaultResponse>(environment.apiUrl + 'retourbano/asistencia-hora.php?id=' + this.session?.id + '&hora=' + hora, { headers: this.utils.getHeaders() });
    }

}