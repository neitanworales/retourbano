import { UserRole } from "../../api/Utils";
import { Guerrero } from "../registro/Guerrero";

export class MtoLogin extends Guerrero{
    editar?: boolean;
    passwordOldValue?: String;
    roles?: UserRole[]
}