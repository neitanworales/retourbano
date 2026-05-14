import { UserRole } from "../../api/Utils";
import { Event } from "../registro/Event";
import { User } from "../registro/User";
import { Asignacion } from "./Asignacion";

export class MtoLogin extends User{
    editar?: boolean;
    passwordOldValue?: String;
    roles?: UserRole[]
    asignaciones?: Asignacion[]
}