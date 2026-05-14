import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { AvanceResponse } from "src/app/core/models/registro/AvanceResponse";
import { environment } from "src/environments/environment";
import { Utils } from "../Utils";
import { EventResponse } from "src/app/core/models/registro/EventResponse";

@Injectable()
export class EventDao {

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    public getEvents(): Observable<EventResponse> {
        const user = JSON.parse(localStorage.getItem('session')!);
        return this.http.get<EventResponse>(environment.apiUrl + 'retourbano/events.php'
        +'?user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() });
    }

    public getEventActivo(): Observable<EventResponse> {
        return this.http.get<EventResponse>(environment.apiUrl+'retourbano/event-activo.php', { headers: this.utils.getHeaders() });
    }

    public getEventInfo(idEvent: number): Observable<EventResponse> {
        return this.http.get<EventResponse>(environment.apiUrl+'retourbano/event-activo.php?id_event='+idEvent, { headers: this.utils.getHeaders() });
    }
}