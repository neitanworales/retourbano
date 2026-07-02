import { UserRole } from "../../api/Utils";
import { User } from "../registro/User";

export interface UserEventSummary {
    event_id?: number | null;
    title?: string | null;
    event_year?: number | null;
    is_active?: number | boolean;
    start_at?: string | null;
    registration_status?: string | null;
    registration_id?: number | null;
    registration_created_at?: string | null;
}

export class MtoLogin extends User{
    editar?: boolean;
    passwordOldValue?: String;
    roles?: UserRole[]
    isSavingRoles?: boolean;
    has_password?: boolean;
    showPassword?: boolean;
    isSendingRecoveryEmail?: boolean;
    isResettingPassword?: boolean;
    actionMessage?: string;
    actionError?: boolean;
    attendance_count?: number;
    attendance_rank?: number;
    latest_event?: UserEventSummary | null;
    event_history?: UserEventSummary[];
    active_events?: UserEventSummary[];
    is_registered_in_active_event?: boolean;
}