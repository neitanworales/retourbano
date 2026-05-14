import { DefaultResponse } from "../DefaultResponse";
import { Event } from "./Event";

export class EventResponseData {
    events: Event[] = [];
}

export class EventResponse extends DefaultResponse {
    data?: EventResponseData;
}