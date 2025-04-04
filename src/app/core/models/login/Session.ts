import { UserRole } from "../../api/Utils";
import { Guerrero } from "../registro/Guerrero";

export class Session {
    id?: number;
    token?: String;
    guerrero? : Guerrero;
    roles: UserRole[] = [];
}
