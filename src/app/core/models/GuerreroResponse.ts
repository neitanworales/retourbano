import { DefaultResponse } from "./DefaultResponse";
import { EventRegistration } from "./registro/EventRegistration";
import { User } from "./registro/User";

export class GuerreroResponse extends DefaultResponse{
    resultado!: User;
    already_registered?: boolean;
    registration?: EventRegistration;
}