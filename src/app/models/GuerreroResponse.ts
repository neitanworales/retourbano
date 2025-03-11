import { DefaultResponse } from "./DefaultResponse";
import { Guerrero } from "./registro/Guerrero";

export class GuerreroResponse extends DefaultResponse{
    resultado!: Guerrero;
}