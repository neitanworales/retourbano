import { Guerrero } from "../registro/Guerrero";

export class Session {
    nombre? : String;
    id?: BigInteger;
    staff?: boolean;
    email?: String;
    error?: boolean;
    mensaje?: String;
    token?: String;
    guerrero? : Guerrero;
}
