import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { PagoResponse } from "src/app/core/models/contabilidad/PagoResponse";
import { Utils } from "../Utils";
import { environment } from 'src/environments/environment';
import { IndicadoresResponse } from "src/app/core/models/registro/IndicadoresResponse";
import { HttpClient } from "@angular/common/http";

@Injectable()
export class PagoDao {

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    /**
     * @deprecated Uses legacy endpoint retourbano/pagos-mantenimiento.php. Migrate to v1 endpoints.
     */
    consultarResumen(): Observable<IndicadoresResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<IndicadoresResponse>(environment.apiUrl + 'retourbano/pagos-mantenimiento.php'
        + '?opcion=1'
        + '&user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() });
    }

    /**
     * @deprecated Uses legacy endpoint retourbano/pagos-mantenimiento.php. Migrate to v1 endpoints.
     */
    consultarPagos(): Observable<PagoResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<PagoResponse>(environment.apiUrl + 'retourbano/pagos-mantenimiento.php'
        + '?opcion=2'
        + '&user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() });
    }

    /**
     * @deprecated Uses legacy endpoint retourbano/pagos-mantenimiento.php. Migrate to v1 endpoints.
     */
    consultarPagosAgrupados(): Observable<PagoResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<PagoResponse>(environment.apiUrl + 'retourbano/pagos-mantenimiento.php'
        + '?opcion=3'
        + '&user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() });
    }

    /**
     * @deprecated Uses legacy endpoint retourbano/pagos-mantenimiento.php. Migrate to v1 endpoints.
     */
    consultarPagosPorGuerrero(): Observable<PagoResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<PagoResponse>(environment.apiUrl + 'retourbano/pagos-mantenimiento.php'
        + '?opcion=4'
        + '&user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() });
    }

}