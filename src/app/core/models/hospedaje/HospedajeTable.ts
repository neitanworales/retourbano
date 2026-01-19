import { Hospedaje } from "./Hospedaje";

export class HospedajeTable extends Hospedaje {
    editar? :boolean = false;
    editarHospedaje?: boolean = false;
    hospedajeOldValue?: boolean;
    habitacionOldValue? :string = "";
}