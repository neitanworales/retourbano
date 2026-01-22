import { Costo } from "./Costo";
import { Ciudad } from "./Ciudad";
import { Avance } from "./Avance";

export class Campamento {
    id_campamento?: number;
    year?: number;
    ciudad?: Ciudad;
    titulo?: string;
    fecha_inicio?: Date;
    fecha_termino?: Date;
    activo?: boolean;
    maximo_inscr?: number;
    umbral?: number;
    fecha_maxima?: Date;
    fecha_apertura?: Date;
    costoMX?: number;
    costoUSD?: number;
    pago_minimoMX?: number;
    banco?: string;
    cuenta?: string;
    titularCuenta?: string;
    contacto1?: string;
    contacto2?: string;
    costos?: Costo[];
    configuracion?: Avance;
    email_contacto?: string;
}