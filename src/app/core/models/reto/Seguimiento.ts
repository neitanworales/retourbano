import { Time } from "@angular/common";

export class Seguimiento {
    id_seguimiento?: number;
    fecha_inicio?: Date;
    activo?: boolean;
    titulo?: string;
    texto_fecha?: string;
    seguimiento_id?: number;
    estudiante_id?: number;
    confirmacion?: boolean;
    dia_llegada?: string;
    registro?: Date;
    hora_llegada?: string;
}