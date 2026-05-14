import { UserRole } from "../../api/Utils";
import { Event } from "../registro/Event";
import { Guerrero } from "../registro/Guerrero";
import { Asignacion } from "./Asignacion";

export class MtoLogin extends Guerrero{
    editar?: boolean;
    passwordOldValue?: String;
    roles?: UserRole[]
    asignaciones?: Asignacion[]
}