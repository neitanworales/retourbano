import { DefaultResponse } from "../DefaultResponse";
import { Indicador } from "./Indicador";

export class IndicadoresResponse extends DefaultResponse {
    resultado?: Indicador[];
    reporte?: Indicador[];
    'reporte-html'? : String;
}