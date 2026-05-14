import { DefaultResponse } from "../DefaultResponse";
import { User } from "../registro/User";

export class SinHabitacionResponse extends DefaultResponse {
    personas?: User[];
}