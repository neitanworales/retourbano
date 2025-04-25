import { DefaultResponse } from "../DefaultResponse";
import { MtoLogin } from "./MtoLogin";

export class MtoLoginResponse extends DefaultResponse {
    users?: MtoLogin[]
}