import { DefaultResponse } from "../DefaultResponse";
import { Habitacion } from "./Habitacion";

export class HabitacionResponse extends DefaultResponse {
    resultado!: Habitacion[]
}