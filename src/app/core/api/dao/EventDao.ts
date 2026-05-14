import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, map } from "rxjs";
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
        return this.http.get<any>(environment.apiUrl + 'retourbano/events.php'
        +'?user=' + user.id
        + '&token=' + user.token
        , { headers: this.utils.getHeaders() }).pipe(
            map(response => this.normalizeEventResponse(response))
        );
    }

    public getEventActivo(): Observable<EventResponse> {
        return this.http.get<any>(environment.apiUrl+'retourbano/event-activo.php', { headers: this.utils.getHeaders() }).pipe(
            map(response => this.normalizeEventResponse(response))
        );
    }

    public getEventInfo(idEvent: number): Observable<EventResponse> {
        return this.http.get<any>(environment.apiUrl+'retourbano/event-activo.php?id_event='+idEvent, { headers: this.utils.getHeaders() }).pipe(
            map(response => this.normalizeEventResponse(response))
        );
    }

    private normalizeEventResponse(response: any): EventResponse {
        // Handle legacy formato: { resultado: Event[], event: Event } o nuevo { data: { events: Event[] } }
        let events: any[] = [];
        
        if (response?.data?.events) {
            events = response.data.events;
        } else if (response?.resultado) {
            events = Array.isArray(response.resultado) ? response.resultado : [response.resultado];
        } else if (response?.event) {
            events = [response.event];
        }
        
        return {
            success: response?.success ?? !response?.error,
            error: !!response?.error,
            message: response?.message || 'Events retrieved',
            code: response?.code || 200,
            data: {
                events: events
            }
        } as EventResponse;
    }
}