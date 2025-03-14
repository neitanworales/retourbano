import { DefaultResponse } from "../DefaultResponse";
import { Campamento } from "./Campamento";

export class CampamentoResponse extends DefaultResponse {
    resultado?: Campamento[];
}