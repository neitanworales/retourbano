import { DefaultResponse } from "../DefaultResponse";
import { Event } from "./Event";

export class RegistroResponse extends DefaultResponse {
    inscrito: boolean = false;
    events: Event[] = [];
}