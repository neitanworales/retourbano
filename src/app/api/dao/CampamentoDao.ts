import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { AvanceResponse } from "src/app/models/registro/AvanceResponse";
import { environment } from "src/environments/environment";
import { Utils } from "../Utils";
import { CampamentoResponse } from "src/app/models/registro/CampamentoResponse";

@Injectable()
export class CampamentoDao {

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    public getCampamentos(): Observable<CampamentoResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<CampamentoResponse>(environment.apiUrl + 'retourbano/campamentos.php'
        +'?user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() });
    }
}