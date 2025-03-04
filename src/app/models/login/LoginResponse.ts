import { Guerrero } from "../registro/Guerrero";
import { Session } from "./Session";

export class LoginResponse {
    code? : BigInt;
    success? : boolean;
    resultado? : Guerrero[];
    session? : Session
}