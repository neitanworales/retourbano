import { DefaultResponse } from "../DefaultResponse";
import { Event } from "./Event";

export class EventResponseData {
    events: Event[] = [];
    event?: Event;
}

export class EventResponse extends DefaultResponse {
    data?: EventResponseData;
}