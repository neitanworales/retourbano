import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable, map } from "rxjs";
import { AvanceResponse } from "src/app/core/models/registro/AvanceResponse";
import { environment } from "src/environments/environment";
import { Utils } from "../Utils";
import { EventResponse } from "src/app/core/models/registro/EventResponse";
import { DefaultResponse } from "src/app/core/models/DefaultResponse";
import { Event } from "src/app/core/models/registro/Event";

@Injectable()
export class EventDao {

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    public getEvents(): Observable<EventResponse> {
        return this.http.get<any>(this.utils.v1('/events'), { headers: this.utils.getHeaders() }).pipe(
            map(response => this.normalizeEventResponse(response))
        );
    }

    public getEventActivo(): Observable<EventResponse> {
        return this.http.get<any>(this.utils.v1('/events')+"?active=1", { headers: this.utils.getHeaders() }).pipe(
            map(response => this.normalizeEventResponse(response))
        );
    }

    public getEventInfo(idEvent: number): Observable<EventResponse> {
        return this.http.get<any>(this.utils.v1('/events/detail') + '?event_id=' + idEvent, { headers: this.utils.getHeaders() }).pipe(
            map(response => this.normalizeEventResponse(response))
        );
    }

    public createEvent(payload: Partial<Event>): Observable<EventResponse> {
        return this.http.post<any>(this.withToken(this.utils.v1('/events')), payload, { headers: this.utils.getHeaders() }).pipe(
            map(response => this.normalizeEventResponse(response))
        );
    }

    public updateEvent(payload: Partial<Event>): Observable<EventResponse> {
        return this.http.put<any>(this.withToken(this.utils.v1('/events')), payload, { headers: this.utils.getHeaders() }).pipe(
            map(response => this.normalizeEventResponse(response))
        );
    }

    public deleteEvent(eventId: number): Observable<DefaultResponse> {
        return this.http.delete<any>(this.withToken(this.utils.v1('/events') + '?id=' + encodeURIComponent(String(eventId))), { headers: this.utils.getHeaders() }).pipe(
            map(response => this.normalizeDefaultResponse(response))
        );
    }

    private normalizeEventResponse(response: any): EventResponse {
        // Handle legacy formato: { resultado: Event[], event: Event }
        // and v1 formato: { data: { event: Event } } or { data: { events: Event[] } }
        let events: any[] = [];
        let event: any = undefined;
        
        if (response?.data?.events) {
            events = response.data.events;
            event = response.data.events?.[0];
        } else if (response?.data?.event) {
            event = response.data.event;
            events = [response.data.event];
        } else if (response?.resultado) {
            events = Array.isArray(response.resultado) ? response.resultado : [response.resultado];
            event = events[0];
        } else if (response?.event) {
            events = [response.event];
            event = response.event;
        }
        
        const normalizedEvents = events.map((item) => this.normalizeEvent(item));
        const normalizedEvent = event ? this.normalizeEvent(event) : normalizedEvents[0];

        return {
            success: response?.success ?? !response?.error,
            error: !!response?.error,
            message: response?.message || 'Events retrieved',
            code: response?.code || 200,
            data: {
                events: normalizedEvents,
                event: normalizedEvent,
            }
        } as EventResponse;
    }

    private normalizeEvent(rawEvent: any): any {
        if (!rawEvent) {
            return rawEvent;
        }

        const normalized = { ...rawEvent };
        const costos = Array.isArray(normalized.costos) ? normalized.costos : [];

        if (costos.length === 0) {
            const synthesizedCosts: any[] = [];
            const priceMxn = normalized.price_mxn != null && normalized.price_mxn !== '' ? Number(normalized.price_mxn) : null;
            const priceUsd = normalized.price_usd != null && normalized.price_usd !== '' ? Number(normalized.price_usd) : null;
            const minimumPaymentMxn = normalized.minimum_payment_mxn != null && normalized.minimum_payment_mxn !== ''
                ? Number(normalized.minimum_payment_mxn)
                : null;

            if (priceMxn !== null && !Number.isNaN(priceMxn)) {
                synthesizedCosts.push({
                    descripcion: 'Costo general MXN',
                    cantidad: priceMxn,
                    divisa: 'MXN',
                    incluye: minimumPaymentMxn !== null && !Number.isNaN(minimumPaymentMxn)
                        ? ['Anticipo minimo sugerido: $' + minimumPaymentMxn.toLocaleString('es-MX') + ' MXN']
                        : [],
                });
            }

            if (priceUsd !== null && !Number.isNaN(priceUsd)) {
                synthesizedCosts.push({
                    descripcion: 'Costo general USD',
                    cantidad: priceUsd,
                    divisa: 'USD',
                    incluye: [],
                });
            }

            normalized.costos = synthesizedCosts;
        }

        return normalized;
    }

    private normalizeDefaultResponse(response: any): DefaultResponse {
        return {
            success: response?.success ?? !response?.error,
            error: !!response?.error,
            message: response?.message || 'Operation executed',
            code: response?.code || 200,
        } as DefaultResponse;
    }

    private withToken(url: string): string {
        const sessionRaw = localStorage.getItem('session');
        if (!sessionRaw) {
            return url;
        }

        try {
            const session = JSON.parse(sessionRaw);
            const token = session?.token;
            if (!token) {
                return url;
            }
            return url + (url.includes('?') ? '&' : '?') + 'token=' + encodeURIComponent(String(token));
        } catch {
            return url;
        }
    }
}