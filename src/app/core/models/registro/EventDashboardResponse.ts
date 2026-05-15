import { DefaultResponse } from '../DefaultResponse';
import { Event } from './Event';

export interface EventDashboardChartItem {
    key: string;
    label: string;
    count: number;
    total_amount?: number;
}

export interface EventDashboardSummary {
    capacity: number;
    registered: number;
    inactive: number;
    available: number | null;
    occupancy_percentage: number | null;
    confirmed: number;
    attendance_confirmed: number;
    followup: number;
    welcome_email_sent: number;
    email_confirmed: number;
    total_revenue: number;
    payments_count: number;
    registrations_with_payments: number;
    fully_paid_count: number | null;
    average_payment: number;
    expected_revenue: number | null;
    payment_coverage_percentage: number | null;
    pending_balance: number | null;
}

export interface EventDashboardCharts {
    availability?: EventDashboardChartItem[];
    roles?: EventDashboardChartItem[];
    gender?: EventDashboardChartItem[];
    staff_gender?: EventDashboardChartItem[];
    shirt_sizes?: EventDashboardChartItem[];
    lodging?: EventDashboardChartItem[];
    confirmation?: EventDashboardChartItem[];
    payment_methods?: EventDashboardChartItem[];
}

export interface EventDashboardData {
    event?: Event;
    summary?: EventDashboardSummary;
    charts?: EventDashboardCharts;
    birthdays_during_event?: EventDashboardBirthdayItem[];
}

export interface EventDashboardBirthdayItem {
    user_id: number;
    name: string;
    full_name?: string;
    display_name?: string;
    birth_date: string;
    birthday_on: string;
    birthday_label: string;
    age_turning: number;
}

export class EventDashboardResponse extends DefaultResponse {
    data?: EventDashboardData;
}
