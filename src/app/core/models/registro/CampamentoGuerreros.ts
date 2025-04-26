import { DefaultResponse } from "../DefaultResponse";

export class CampamentoGuerreros {
    email?: String;
    count?: Number;
    campamentos?: AsistenciaCampamentos[];
    tutoria?: AsistenciaCampamentos[];
}

export class AsistenciaCampamentos {
    guerreroID?: number;
    id?: number;
    id_guerrero?: number;
    id_campamento?: number;
    nick?: String;
    nombre?: String;
    email?: String;
    email_tutor?: String;
}

export class CampamentoGuerrerosResponse extends DefaultResponse {
    resultado?: CampamentoGuerreros[];
}