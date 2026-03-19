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
    clabe?: string;
    titularCuenta?: string;
    contacto1?: string;
    contacto2?: string;
    costos?: Costo[];
    configuracion?: Avance;
    email_contacto?: string;
    llegada_lugar?: string;
    llegada_coordenadas?: string;
    llegada_nota?: string;
    salida_lugar?: string;
    salida_coordenadas?: string;
    salida_nota?: string;
    notas_costos?: string;
    cruzada_lugar?: string;
}