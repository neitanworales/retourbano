import { UserRole } from "../../api/Utils";
import { Guerrero } from "../registro/Guerrero";

export class Session {
    token?: String;
    guerrero? : Guerrero;
    roles: UserRole[] = [];
}
