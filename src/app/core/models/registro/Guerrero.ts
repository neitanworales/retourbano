import { Pago } from "./Pago";

export class Guerrero {
    id?: number;
    nombre?: String;
    nick?: String;
    year?:number;
    month?:number;
    day?:number;
    fechaNac?: Date;
    edad?: number;
    sexo?: String;
    talla?: String;
    vienesDe?: String;
    alergias?: String;
    razones?: String;
    tutorNombre?: String;
    tutorTelefono?: String;
    iglesia?: String;
    email?: String;
    whatsapp?: String;
    facebook?: String;
    instagram?: String;
    aceptaPoliticas?: boolean;
    pagos?: Pago;
    pagado?: number;
    staff?: boolean;
    admin?: boolean;
    confirmado?: boolean;
    asistencia?: boolean;
    seguimiento?: boolean;
    emailEnviado?: boolean;
    emailConfirmado?: boolean;
    password?: String;
    updatePassword?: boolean;
    medicamentos?: String;
    telefono?: String;
    hospedaje?: Boolean = false;
    habitacion?: String;
}