import { DefaultResponse } from "./DefaultResponse";
import { User } from "./registro/User";

export class GuerreroResponse extends DefaultResponse{
    resultado!: User;
}