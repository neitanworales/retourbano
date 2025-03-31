import { APP_BASE_HREF } from "@angular/common";
import { Inject, Injectable } from "@angular/core";
import { Observable } from "rxjs/internal/Observable";
import { HorarioActividades } from "src/app/core/models/horario/HorarioActividades";
import { Utils } from "../Utils";
import { HttpClient } from "@angular/common/http";

@Injectable()
export class HorarioDao {

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }


    public getData(): Observable<HorarioActividades> {
        return this.http.get<HorarioActividades>('assets/data/horario.json', { headers: this.utils.getHeaders() });
    }

}