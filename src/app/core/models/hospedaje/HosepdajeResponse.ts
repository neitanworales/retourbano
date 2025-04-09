import { DefaultResponse } from "../DefaultResponse";
import { Hospedaje } from "./Hospedaje";

export class HospedajeResponse extends DefaultResponse {
    resultado!: Hospedaje[]
}