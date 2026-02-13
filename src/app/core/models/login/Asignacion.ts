import { Campamento } from "../registro/Campamento";

export class Asignacion {
    id_guerrero?: number;
    id_campamento?: number;
    default?: boolean;
    fecha_asignacion?: Date;
    campamento?: Campamento
}