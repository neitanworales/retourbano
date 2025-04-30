import { DefaultResponse } from "../DefaultResponse";
import { Guerrero } from "../registro/Guerrero";
import { Session } from "./Session";

export class LoginResponse extends DefaultResponse {
    success? : boolean;
    session? : Session

    usuario_encrypted? : String;
    password_encrypted? : String;
}