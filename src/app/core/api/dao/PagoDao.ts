import { Injectable } from "@angular/core";
import { Observable, catchError, map, of } from "rxjs";
import { PagoResponse } from "src/app/core/models/contabilidad/PagoResponse";
import { Utils } from "../Utils";
import { IndicadoresResponse } from "src/app/core/models/registro/IndicadoresResponse";
import { HttpClient } from "@angular/common/http";

@Injectable()
export class PagoDao {

    constructor(
        private http: HttpClient,
        private utils: Utils
    ) { }

    consultarResumen(eventId?: number): Observable<IndicadoresResponse> {
        const query = this.buildQueryParams(eventId);
        return this.http.get<any>(this.utils.v1('/accounting/summary') + query, { headers: this.utils.getHeaders() }).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                code: response?.code || 200,
                message: response?.message || 'Ok',
                resultado: response?.data?.indicators || [],
            } as IndicadoresResponse)),
            catchError((error) => of({
                success: false,
                error: true,
                code: error?.status || 500,
                message: error?.error?.message || 'No fue posible cargar el resumen',
                resultado: [],
            } as IndicadoresResponse))
        );
    }

    consultarPagos(eventId?: number): Observable<PagoResponse> {
        const query = this.buildQueryParams(eventId);
        return this.http.get<any>(this.utils.v1('/accounting/payments') + query, { headers: this.utils.getHeaders() }).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                code: response?.code || 200,
                resultado: response?.data?.payments || [],
            } as PagoResponse)),
            catchError((error) => of({
                success: false,
                error: true,
                code: error?.status || 500,
                resultado: [],
            } as PagoResponse))
        );
    }

    consultarPagosAgrupados(eventId?: number): Observable<PagoResponse> {
        const query = this.buildQueryParams(eventId);
        return this.http.get<any>(this.utils.v1('/accounting/payments-by-description') + query, { headers: this.utils.getHeaders() }).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                code: response?.code || 200,
                resultado: response?.data?.payments || [],
            } as PagoResponse)),
            catchError((error) => of({
                success: false,
                error: true,
                code: error?.status || 500,
                resultado: [],
            } as PagoResponse))
        );
    }

    consultarPagosPorGuerrero(eventId?: number): Observable<PagoResponse> {
        const query = this.buildQueryParams(eventId);
        return this.http.get<any>(this.utils.v1('/accounting/payments-by-user') + query, { headers: this.utils.getHeaders() }).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                code: response?.code || 200,
                resultado: response?.data?.payments || [],
            } as PagoResponse)),
            catchError((error) => of({
                success: false,
                error: true,
                code: error?.status || 500,
                resultado: [],
            } as PagoResponse))
        );
    }

    consultarMetodosPago(eventId?: number): Observable<PagoResponse> {
        const query = this.buildQueryParams(eventId);
        return this.http.get<any>(this.utils.v1('/accounting/payment-methods') + query, { headers: this.utils.getHeaders() }).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                code: response?.code || 200,
                resultado: response?.data?.methods || [],
            } as PagoResponse)),
            catchError((error) => of({
                success: false,
                error: true,
                code: error?.status || 500,
                resultado: [],
            } as PagoResponse))
        );
    }

    consultarPendientes(eventId?: number): Observable<PagoResponse> {
        const query = this.buildQueryParams(eventId);
        return this.http.get<any>(this.utils.v1('/accounting/pending-by-user') + query, { headers: this.utils.getHeaders() }).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                code: response?.code || 200,
                resultado: response?.data?.pending || [],
            } as PagoResponse)),
            catchError((error) => of({
                success: false,
                error: true,
                code: error?.status || 500,
                resultado: [],
            } as PagoResponse))
        );
    }

    consultarFlujo(eventId?: number): Observable<PagoResponse> {
        const query = this.buildQueryParams(eventId);
        return this.http.get<any>(this.utils.v1('/accounting/cashflow') + query, { headers: this.utils.getHeaders() }).pipe(
            map((response) => ({
                success: !!response?.success,
                error: !response?.success,
                code: response?.code || 200,
                resultado: response?.data?.cashflow || [],
            } as PagoResponse)),
            catchError((error) => of({
                success: false,
                error: true,
                code: error?.status || 500,
                resultado: [],
            } as PagoResponse))
        );
    }

    private buildQueryParams(eventId?: number): string {
        const session = JSON.parse(localStorage.getItem('session') || 'null');
        const params = new URLSearchParams();

        if (session?.token) {
            params.set('token', String(session.token));
        }

        if (eventId && eventId > 0) {
            params.set('event_id', String(eventId));
        }

        const query = params.toString();
        return query ? `?${query}` : '';
    }

}