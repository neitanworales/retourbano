import { DefaultResponse } from "../DefaultResponse";
import { Event } from "./Event";

export class EventResponse extends DefaultResponse {
    resultado?: Event[];
    event?: Event;
}