import { DefaultResponse } from "../DefaultResponse";
import { Event } from "./Event";
import { Pago } from "./Pago";
import { User } from "./User";

export class EventRegistration {
    // DB fields from event_registrations
    id?: number;
    legacy_registration_id?: number;
    event_id?: number;
    user_id?: number;
    registration_status?: string;
    is_confirmed?: boolean;
    attendance_confirmed?: boolean;
    is_staff?: boolean;
    is_admin?: boolean;
    is_followup?: boolean;
    welcome_email_sent?: boolean;
    email_confirmed?: boolean;
    requires_lodging?: boolean;
    room_code?: string;
    reasons?: string;
    razones?: string;

    // Payment data
    pagado?: number;
    pagos?: Pago[] = [];
    previous_events?: Event[];

    // Legacy UI field
    numero?: number;

    // Legacy Spanish aliases for registration flags (used in UI)
    confirmado?: boolean;
    asistencia?: boolean;
    staff?: boolean;
    admin?: boolean;
    seguimiento?: boolean;
    emailEnviado?: boolean;
    emailConfirmado?: boolean;
    hospedaje?: boolean;
    habitacion?: string;

    // Nested user profile data
    user?: User;
}

export class EventRegistrationResponse extends DefaultResponse {
    data?: {
        registrations?: EventRegistration[];
    };
}
