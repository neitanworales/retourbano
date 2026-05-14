import { DefaultResponse } from "../DefaultResponse";
import { User } from "../registro/User";
import { Session } from "./Session";

export class LoginResponse extends DefaultResponse {
    session? : Session

    usuario_encrypted? : String;
    password_encrypted? : String;
}