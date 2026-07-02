import { Component, inject, OnInit } from '@angular/core';
import { RegistroDao } from 'src/app/core/api/dao/RegistroDao';

interface ActivityLogFilterOption {
  value: string;
  label: string;
}

interface ActivityLogApiItem {
  action?: string;
  action_label?: string;
  actor_name?: string;
  actor_email?: string;
  affected_name?: string;
  affected_email?: string;
  entity_type?: string;
  related_event_title?: string;
  related_event_year?: number;
  source?: string;
  old_value?: string;
  new_value?: string;
  metadata_json?: string;
  created_at?: string;
}

interface ActivityLogViewItem {
  actionLabel: string;
  actorLabel: string;
  affectedLabel: string;
  contextLabel: string;
  summaryLabel: string;
  timestampLabel: string;
  sourceLabel: string;
}

@Component({
  selector: 'app-bitacora',
  templateUrl: './bitacora.component.html',
  styleUrls: ['./bitacora.component.css'],
  standalone: false
})
export class BitacoraComponent implements OnInit {

  private readonly registroDao = inject(RegistroDao);

  readonly pageSize = 50;

  loading = false;
  errorMessage = '';
  searchTerm = '';
  selectedAction = '';
  actionOptions: ActivityLogFilterOption[] = [];
  items: ActivityLogViewItem[] = [];
  total = 0;
  offset = 0;

  ngOnInit(): void {
    this.loadActivityLog();
  }

  loadActivityLog(): void {
    this.loading = true;
    this.errorMessage = '';

    this.registroDao.obtenerBitacoraStaff(this.pageSize, this.offset, this.searchTerm, this.selectedAction).subscribe({
      next: (response: any) => {
        const rawItems = Array.isArray(response?.items) ? response.items as ActivityLogApiItem[] : [];
        this.items = rawItems.map((item) => this.mapItem(item));
        this.actionOptions = Array.isArray(response?.filters?.actions) ? response.filters.actions : [];
        this.total = Number(response?.pagination?.total || 0);
        this.loading = false;
      },
      error: () => {
        this.loading = false;
        this.errorMessage = 'No se pudo cargar la bitacora general.';
        this.items = [];
      }
    });
  }

  applyFilters(): void {
    this.offset = 0;
    this.loadActivityLog();
  }

  clearFilters(): void {
    this.searchTerm = '';
    this.selectedAction = '';
    this.offset = 0;
    this.loadActivityLog();
  }

  goToPreviousPage(): void {
    if (this.offset <= 0) {
      return;
    }

    this.offset = Math.max(0, this.offset - this.pageSize);
    this.loadActivityLog();
  }

  goToNextPage(): void {
    if (!this.hasNextPage()) {
      return;
    }

    this.offset += this.pageSize;
    this.loadActivityLog();
  }

  hasPreviousPage(): boolean {
    return this.offset > 0;
  }

  hasNextPage(): boolean {
    return this.offset + this.pageSize < this.total;
  }

  getStartIndex(): number {
    if (this.total === 0) {
      return 0;
    }

    return this.offset + 1;
  }

  getEndIndex(): number {
    return Math.min(this.offset + this.items.length, this.total);
  }

  trackByIndex(index: number): number {
    return index;
  }

  private mapItem(item: ActivityLogApiItem): ActivityLogViewItem {
    return {
      actionLabel: this.resolveActionLabel(item),
      actorLabel: this.resolvePersonLabel(item.actor_name, item.actor_email, 'Sistema'),
      affectedLabel: this.resolvePersonLabel(item.affected_name, item.affected_email, 'Sin usuario afectado'),
      contextLabel: this.buildContextLabel(item),
      summaryLabel: this.buildSummaryLabel(item),
      timestampLabel: this.formatTimestamp(item.created_at),
      sourceLabel: String(item.source || 'api.v1')
    };
  }

  private resolveActionLabel(item: ActivityLogApiItem): string {
    const label = String(item.action_label || '').trim();
    if (label) {
      return label;
    }

    const action = String(item.action || '').trim();
    return action || 'Movimiento';
  }

  private resolvePersonLabel(name?: string, email?: string, fallback: string = 'Sistema'): string {
    const normalizedName = String(name || '').trim();
    if (normalizedName) {
      return normalizedName;
    }

    const normalizedEmail = String(email || '').trim();
    if (normalizedEmail) {
      return normalizedEmail;
    }

    return fallback;
  }

  private buildContextLabel(item: ActivityLogApiItem): string {
    const parts: string[] = [];
    const entityType = String(item.entity_type || '').trim();
    const eventTitle = String(item.related_event_title || '').trim();
    const eventYear = item.related_event_year ? String(item.related_event_year) : '';

    if (entityType) {
      parts.push(this.translateEntityType(entityType));
    }

    if (eventTitle) {
      parts.push(eventYear ? eventTitle + ' ' + eventYear : eventTitle);
    }

    return parts.length > 0 ? parts.join(' · ') : 'Sin contexto adicional';
  }

  private buildSummaryLabel(item: ActivityLogApiItem): string {
    const summaries: string[] = [];
    const normalizedNewValue = this.normalizeText(item.new_value);
    const normalizedOldValue = this.normalizeText(item.old_value);
    const metadataSummary = this.summarizeMetadata(item.metadata_json);

    if (normalizedNewValue) {
      summaries.push(normalizedNewValue);
    }

    if (!normalizedNewValue && normalizedOldValue) {
      summaries.push('Valor previo: ' + normalizedOldValue);
    }

    if (metadataSummary) {
      summaries.push(metadataSummary);
    }

    return summaries.length > 0 ? summaries.join(' · ') : 'Sin detalle adicional';
  }

  private summarizeMetadata(rawMetadata?: string): string {
    const normalized = String(rawMetadata || '').trim();
    if (!normalized) {
      return '';
    }

    try {
      const parsed = JSON.parse(normalized);
      const added = Array.isArray(parsed?.added) && parsed.added.length > 0 ? 'Agregados: ' + parsed.added.join(', ') : '';
      const removed = Array.isArray(parsed?.removed) && parsed.removed.length > 0 ? 'Removidos: ' + parsed.removed.join(', ') : '';
      const changedFields = Array.isArray(parsed?.changed_fields) && parsed.changed_fields.length > 0 ? 'Campos: ' + parsed.changed_fields.join(', ') : '';

      return [added, removed, changedFields].filter((part) => part.length > 0).join(' · ');
    } catch {
      return this.normalizeText(normalized);
    }
  }

  private normalizeText(value?: string): string {
    const normalized = String(value || '').replace(/\s+/g, ' ').trim();
    if (!normalized) {
      return '';
    }

    return normalized.length > 180 ? normalized.slice(0, 177) + '...' : normalized;
  }

  private translateEntityType(entityType: string): string {
    switch (entityType) {
      case 'user':
        return 'Usuario';
      case 'role':
        return 'Roles';
      case 'event_role':
        return 'Roles por evento';
      case 'registration':
        return 'Inscripcion';
      case 'payment':
        return 'Pago';
      case 'auth':
        return 'Autenticacion';
      default:
        return entityType;
    }
  }

  private formatTimestamp(value?: string): string {
    const rawValue = String(value || '').trim();
    if (!rawValue) {
      return 'Sin fecha';
    }

    const date = new Date(rawValue.replace(' ', 'T'));
    if (Number.isNaN(date.getTime())) {
      return rawValue;
    }

    return new Intl.DateTimeFormat('es-MX', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    }).format(date);
  }
}