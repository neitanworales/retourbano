import { DefaultResponse } from "../DefaultResponse";
import { Session } from "./Session";

export class SessionResponse extends DefaultResponse {
    session?: Session;
}