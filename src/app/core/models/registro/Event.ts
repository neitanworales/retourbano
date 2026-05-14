import { Costo } from "./Costo";
import { Ciudad } from "./Ciudad";
import { Avance } from "./Avance";

export class Event {
    id?: number;
    legacy_event_id?: number;
    organization_id?: number;
    city_id?: number;
    event_year?: number;
    title?: string;
    start_at?: Date;
    end_at?: Date;
    is_active?: boolean;
    max_registrations?: number;
    threshold?: number;
    registration_deadline?: Date;
    registration_open_at?: Date;
    price_mxn?: number;
    price_usd?: number;
    minimum_payment_mxn?: number;
    bank_name?: string;
    bank_account?: string;
    bank_clabe?: string;
    account_holder?: string;
    contact_phone_1?: string;
    contact_phone_2?: string;
    costos?: Costo[];
    configuracion?: Avance;
    contact_email?: string;
    arrival_place?: string;
    arrival_coordinates?: string;
    arrival_note?: string;
    departure_place?: string;
    departure_coordinates?: string;
    departure_note?: string;
    cost_notes?: string;
    city_label?: string;
    is_registered?: boolean;
    registration_id?: number;
    registration_status?: string;

    // Legacy aliases for existing templates/components.
    get year(): number | undefined { return this.event_year; }
    set year(value: number | undefined) { this.event_year = value; }

    get titulo(): string | undefined { return this.title; }
    set titulo(value: string | undefined) { this.title = value; }

    get fecha_inicio(): Date | undefined { return this.start_at; }
    set fecha_inicio(value: Date | undefined) { this.start_at = value; }

    get fecha_termino(): Date | undefined { return this.end_at; }
    set fecha_termino(value: Date | undefined) { this.end_at = value; }

    get activo(): boolean | undefined { return this.is_active; }
    set activo(value: boolean | undefined) { this.is_active = value; }

    get maximo_inscr(): number | undefined { return this.max_registrations; }
    set maximo_inscr(value: number | undefined) { this.max_registrations = value; }

    get umbral(): number | undefined { return this.threshold; }
    set umbral(value: number | undefined) { this.threshold = value; }

    get fecha_maxima(): Date | undefined { return this.registration_deadline; }
    set fecha_maxima(value: Date | undefined) { this.registration_deadline = value; }

    get fecha_apertura(): Date | undefined { return this.registration_open_at; }
    set fecha_apertura(value: Date | undefined) { this.registration_open_at = value; }

    get costoMX(): number | undefined { return this.price_mxn; }
    set costoMX(value: number | undefined) { this.price_mxn = value; }

    get costoUSD(): number | undefined { return this.price_usd; }
    set costoUSD(value: number | undefined) { this.price_usd = value; }

    get pago_minimoMX(): number | undefined { return this.minimum_payment_mxn; }
    set pago_minimoMX(value: number | undefined) { this.minimum_payment_mxn = value; }

    get banco(): string | undefined { return this.bank_name; }
    set banco(value: string | undefined) { this.bank_name = value; }

    get cuenta(): string | undefined { return this.bank_account; }
    set cuenta(value: string | undefined) { this.bank_account = value; }

    get clabe(): string | undefined { return this.bank_clabe; }
    set clabe(value: string | undefined) { this.bank_clabe = value; }

    get titularCuenta(): string | undefined { return this.account_holder; }
    set titularCuenta(value: string | undefined) { this.account_holder = value; }

    get contacto1(): string | undefined { return this.contact_phone_1; }
    set contacto1(value: string | undefined) { this.contact_phone_1 = value; }

    get contacto2(): string | undefined { return this.contact_phone_2; }
    set contacto2(value: string | undefined) { this.contact_phone_2 = value; }

    get email_contacto(): string | undefined { return this.contact_email; }
    set email_contacto(value: string | undefined) { this.contact_email = value; }

    get llegada_lugar(): string | undefined { return this.arrival_place; }
    set llegada_lugar(value: string | undefined) { this.arrival_place = value; }

    get llegada_coordenadas(): string | undefined { return this.arrival_coordinates; }
    set llegada_coordenadas(value: string | undefined) { this.arrival_coordinates = value; }

    get llegada_nota(): string | undefined { return this.arrival_note; }
    set llegada_nota(value: string | undefined) { this.arrival_note = value; }

    get salida_lugar(): string | undefined { return this.departure_place; }
    set salida_lugar(value: string | undefined) { this.departure_place = value; }

    get salida_coordenadas(): string | undefined { return this.departure_coordinates; }
    set salida_coordenadas(value: string | undefined) { this.departure_coordinates = value; }

    get salida_nota(): string | undefined { return this.departure_note; }
    set salida_nota(value: string | undefined) { this.departure_note = value; }

    get notas_costos(): string | undefined { return this.cost_notes; }
    set notas_costos(value: string | undefined) { this.cost_notes = value; }

    get cruzada_lugar(): string | undefined { return this.city_label; }
    set cruzada_lugar(value: string | undefined) { this.city_label = value; }

    // Some legacy views bind event.ciudad?.nombre
    get ciudad(): Ciudad | undefined {
        if (!this.city_label) {
            return undefined;
        }
        return { nombre: this.city_label } as Ciudad;
    }
}