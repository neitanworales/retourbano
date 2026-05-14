import { Event } from "../registro/Event";

export class Asignacion {
    id_guerrero?: number;
    id_campamento?: number;
    default?: boolean;
    fecha_asignacion?: Date;
    event?: Event
}