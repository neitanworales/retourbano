export class Pago {
    id?: number;
    event_registration_id?: number;
    amount?: number;
    description?: string;
    currency?: string;
    receipt_number?: string;
    
    nuevo?: boolean;
    actualizar?: boolean;
    nombre?: string;
    pagos?: number;

    payment_method?: string;
    paid_at?: Date;
    created_by_user_id?: number;
    created_at?: Date;
    updated_at?: Date;
}