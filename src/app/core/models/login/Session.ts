import { UserRole } from "../../api/Utils";
import { Usuario } from "../usuario/Usuario";

export class Session {
    id?: number;
    token?: String;
    usuario?: Usuario;
    guerrero?: Usuario;
    roles: UserRole[] = [];
}
