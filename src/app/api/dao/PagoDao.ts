import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { PagoResponse } from "src/app/models/contabilidad/PagoResponse";
import { Utils } from "../Utils";
import { environment } from 'src/environments/environment';
import { IndicadoresResponse } from "src/app/models/registro/IndicadoresResponse";
import { HttpClient } from "@angular/common/http";

@Injectable()
export class PagoDao {

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    consultarResumen(): Observable<IndicadoresResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<IndicadoresResponse>(environment.apiUrl + 'retourbano/pagos-mantenimiento.php'
        + '?opcion=1'
        + '&user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() });
    }

    consultarPagos(): Observable<PagoResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<PagoResponse>(environment.apiUrl + 'retourbano/pagos-mantenimiento.php'
        + '?opcion=2'
        + '&user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() });
    }

    consultarPagosAgrupados(): Observable<PagoResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<PagoResponse>(environment.apiUrl + 'retourbano/pagos-mantenimiento.php'
        + '?opcion=3'
        + '&user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() });
    }

    consultarPagosPorGuerrero(): Observable<PagoResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<PagoResponse>(environment.apiUrl + 'retourbano/pagos-mantenimiento.php'
        + '?opcion=4'
        + '&user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() });
    }

}