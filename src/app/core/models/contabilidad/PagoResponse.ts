import { Pago } from "../registro/Pago";

export class PagoResponse {
    code? : BigInt;
    success? : boolean;
    resultado? : Pago[];
}