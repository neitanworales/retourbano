import { Costo } from "./Costo";

export class Campamento {
    id_campamento?: number;
    titulo?: string;
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
}