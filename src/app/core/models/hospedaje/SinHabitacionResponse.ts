import { DefaultResponse } from "../DefaultResponse";
import { Guerrero } from "../registro/Guerrero";

export class SinHabitacionResponse extends DefaultResponse {
    personas?: Guerrero[];
}