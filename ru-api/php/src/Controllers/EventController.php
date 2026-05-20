<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Repository/EventRepository.php';
require_once __DIR__ . '/../Repository/EventRegistrationRepository.php';
require_once __DIR__ . '/../Models/Event.php';

class EventController extends BaseController
{
    private $events;
    private $registrations;

    public function __construct()
    {
        $this->events = new EventRepository();
        $this->registrations = new EventRegistrationRepository();
    }

    public function list($request)
    {
        $year = isset($request['year']) && $request['year'] !== '' ? (int) $request['year'] : null;
        $active = isset($request['active']) && $request['active'] !== '' ? (int) $request['active'] : null;
        $limit = isset($request['limit']) ? (int) $request['limit'] : 100;
        $offset = isset($request['offset']) ? (int) $request['offset'] : 0;
        $viewSpec = $this->resolveEventViewSpec($request);

        $items = $this->events->findMany($year, $active, $limit, $offset);
        $data = array_map(function ($event) use ($viewSpec) {
            return $this->buildEventPayload($event, $viewSpec);
        }, $items);

        return $this->ok(array('events' => $data), 'events list');
    }

    public function detail($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $viewSpec = $this->resolveEventViewSpec($request);
        if ($eventId <= 0) {
            return $this->fail('event_id is required', 422);
        }

        $event = $this->events->findModelById($eventId);
        if (!$event) {
            return $this->fail('event not found', 404);
        }

        $eventArray = $this->buildEventPayload($event, $viewSpec);

        return $this->ok(array('event' => $eventArray), 'event found');
    }

    public function create($request)
    {
        $viewSpec = $this->resolveEventViewSpec($request);
        $event = $this->buildEventFromRequest($request);
        if (!$event) {
            return $this->fail('invalid event payload', 422);
        }

        if (empty($event->title)) {
            return $this->fail('title is required', 422);
        }

        $newId = $this->events->create($event);
        if (!$newId || (int) $newId <= 0) {
            return $this->fail('event could not be created', 500);
        }

        $legacyId = $this->events->getLegacyIdByEventId((int) $newId);
        if ($legacyId !== null) {
            $costos = $this->extractCostos($request);
            $this->events->replaceCostos((int) $legacyId, $costos);
        }

        $created = $this->events->findModelById((int) $newId);
        if (!$created) {
            return $this->fail('event created but not found', 500);
        }

        $eventArray = $this->buildEventPayload($created, $viewSpec);

        return $this->ok(array('event' => $eventArray), 'event created');
    }

    public function update($request)
    {
        $viewSpec = $this->resolveEventViewSpec($request);
        $eventId = isset($request['id']) ? (int) $request['id'] : (isset($request['event_id']) ? (int) $request['event_id'] : 0);
        if ($eventId <= 0) {
            return $this->fail('id is required', 422);
        }

        $existing = $this->events->findModelById($eventId);
        if (!$existing) {
            return $this->fail('event not found', 404);
        }

        $event = $this->buildEventFromRequest($request, $existing);
        if (!$event) {
            return $this->fail('invalid event payload', 422);
        }
        $event->id = $eventId;

        $updated = $this->events->update($event);
        if (!$updated) {
            return $this->fail('event could not be updated', 500);
        }

        $legacyId = $this->events->getLegacyIdByEventId($eventId);
        if ($legacyId !== null) {
            $costos = $this->extractCostos($request);
            $this->events->replaceCostos((int) $legacyId, $costos);
        }

        $reloaded = $this->events->findModelById($eventId);
        $eventArray = $this->buildEventPayload($reloaded ?: $event, $viewSpec);

        return $this->ok(array('event' => $eventArray), 'event updated');
    }

    public function delete($request)
    {
        $eventId = isset($request['id']) ? (int) $request['id'] : (isset($request['event_id']) ? (int) $request['event_id'] : 0);
        if ($eventId <= 0) {
            return $this->fail('id is required', 422);
        }

        $existing = $this->events->findModelById($eventId);
        if (!$existing) {
            return $this->fail('event not found', 404);
        }

        $legacyId = $this->events->getLegacyIdByEventId($eventId);
        if ($legacyId !== null) {
            $this->events->deleteCostosByLegacyEventId((int) $legacyId);
        }

        $deleted = $this->events->delete($eventId);
        if (!$deleted) {
            return $this->fail('event could not be deleted', 500);
        }

        return $this->ok(array('id' => $eventId), 'event deleted');
    }

    public function upcomingAvailability($request)
    {
        $viewSpec = $this->resolveEventViewSpec($request);
        if (!isset($request['auth_user']) || !isset($request['auth_user']->id)) {
            return $this->fail('authenticated user is required', 401);
        }

        $userId = (int) $request['auth_user']->id;
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        $limit = isset($request['limit']) ? (int) $request['limit'] : null;
        if ($limit !== null && $limit <= 0) {
            $limit = null;
        }

        if ($eventId > 0) {
            $singleEvent = $this->events->findModelById($eventId);
            if (!$singleEvent) {
                return $this->fail('event not found', 404);
            }
            $events = array($singleEvent);
        } else {
            $events = $this->events->findUpcomingActive($limit);
        }

        $items = array();
        $isRegisteredAny = false;

        foreach ($events as $event) {
            $registration = $this->registrations->findByEventAndUser((int) $event->id, $userId);
            $isRegistered = $registration !== null;
            if ($isRegistered) {
                $isRegisteredAny = true;
            }

            $row = $this->buildEventPayload($event, $viewSpec);
            $row['is_registered'] = $isRegistered;
            $row['registration_id'] = $isRegistered ? (int) $registration->id : null;
            $row['registration_status'] = $isRegistered ? $registration->registration_status : null;
            $items[] = $row;
        }

        if (empty($items)) {
            $message = 'No hay eventos activos proximos disponibles';
        } elseif ($eventId > 0 && $isRegisteredAny) {
            $message = 'Ya estas inscrito en este evento';
        } elseif ($eventId > 0 && !$isRegisteredAny) {
            $message = 'Aun no estas inscrito en este evento';
        } elseif ($isRegisteredAny) {
            $message = 'Ya estas inscrito en al menos un evento activo';
        } else {
            $message = 'Hay eventos activos disponibles y aun no estas inscrito';
        }

        return $this->ok(
            array(
                'inscrito' => $isRegisteredAny,
                'events' => $items,
            ),
            $message
        );
    }

    private function buildEventFromRequest($request, $existing = null)
    {
        $event = $existing ?: new Event();

        $event->legacy_event_id = $this->toNullableInt($this->readField($request, array('legacy_event_id')));
        $event->organization_id = $this->toNullableInt($this->readField($request, array('organization_id')));
        $event->city_id = $this->toNullableInt($this->readField($request, array('city_id')));
        $event->event_year = $this->toNullableInt($this->readField($request, array('event_year', 'year')));
        $event->title = $this->toNullableString($this->readField($request, array('title', 'titulo')));
        $event->start_at = $this->toNullableDateTime($this->readField($request, array('start_at', 'fecha_inicio')));
        $event->end_at = $this->toNullableDateTime($this->readField($request, array('end_at', 'fecha_termino')));
        $event->is_active = $this->toBooleanInt($this->readField($request, array('is_active', 'activo')));
        $event->max_registrations = $this->toNullableInt($this->readField($request, array('max_registrations', 'maximo_inscr')));
        $event->threshold = $this->toNullableInt($this->readField($request, array('threshold', 'umbral')));
        $event->registration_deadline = $this->toNullableDateTime($this->readField($request, array('registration_deadline', 'fecha_maxima')));
        $event->registration_open_at = $this->toNullableDateTime($this->readField($request, array('registration_open_at', 'fecha_apertura')));
        $event->price_mxn = $this->toNullableFloat($this->readField($request, array('price_mxn', 'costoMX')));
        $event->price_usd = $this->toNullableFloat($this->readField($request, array('price_usd', 'costoUSD')));
        $event->minimum_payment_mxn = $this->toNullableFloat($this->readField($request, array('minimum_payment_mxn', 'pago_minimoMX')));
        $event->bank_name = $this->toNullableString($this->readField($request, array('bank_name', 'banco')));
        $event->bank_account = $this->toNullableString($this->readField($request, array('bank_account', 'cuenta')));
        $event->bank_clabe = $this->toNullableString($this->readField($request, array('bank_clabe', 'clabe')));
        $event->account_holder = $this->toNullableString($this->readField($request, array('account_holder', 'titularCuenta')));
        $event->contact_phone_1 = $this->toNullableString($this->readField($request, array('contact_phone_1', 'contacto1')));
        $event->contact_phone_2 = $this->toNullableString($this->readField($request, array('contact_phone_2', 'contacto2')));
        $event->contact_email = $this->toNullableString($this->readField($request, array('contact_email', 'email_contacto')));
        $event->arrival_place = $this->toNullableString($this->readField($request, array('arrival_place', 'llegada_lugar')));
        $event->arrival_coordinates = $this->toNullableString($this->readField($request, array('arrival_coordinates', 'llegada_coordenadas')));
        $event->arrival_note = $this->toNullableString($this->readField($request, array('arrival_note', 'llegada_nota')));
        $event->departure_place = $this->toNullableString($this->readField($request, array('departure_place', 'salida_lugar')));
        $event->departure_coordinates = $this->toNullableString($this->readField($request, array('departure_coordinates', 'salida_coordenadas')));
        $event->departure_note = $this->toNullableString($this->readField($request, array('departure_note', 'salida_nota')));
        $event->cost_notes = $this->toNullableString($this->readField($request, array('cost_notes', 'notas_costos')));

        return $event;
    }

    private function extractCostos($request)
    {
        $costos = $this->readField($request, array('costos'));
        if (!is_array($costos)) {
            return array();
        }

        $normalized = array();
        foreach ($costos as $costo) {
            if (!is_array($costo)) {
                continue;
            }

            $normalized[] = array(
                'descripcion' => isset($costo['descripcion']) ? trim((string) $costo['descripcion']) : '',
                'divisa' => isset($costo['divisa']) ? trim((string) $costo['divisa']) : 'MXN',
                'cantidad' => isset($costo['cantidad']) ? (float) $costo['cantidad'] : 0,
                'incluye' => isset($costo['incluye']) ? $costo['incluye'] : array(),
            );
        }

        return $normalized;
    }

    private function readField($request, $keys)
    {
        foreach ($keys as $key) {
            if (isset($request[$key])) {
                return $request[$key];
            }
        }

        return null;
    }

    private function toNullableString($value)
    {
        if ($value === null) {
            return null;
        }

        $value = trim((string) $value);
        return $value === '' ? null : $value;
    }

    private function toNullableInt($value)
    {
        if ($value === null || $value === '') {
            return null;
        }

        return (int) $value;
    }

    private function toNullableFloat($value)
    {
        if ($value === null || $value === '') {
            return null;
        }

        return (float) $value;
    }

    private function toNullableDateTime($value)
    {
        if ($value === null || $value === '') {
            return null;
        }

        $stringValue = trim((string) $value);
        if ($stringValue === '') {
            return null;
        }

        $normalized = str_replace('T', ' ', $stringValue);
        if (strlen($normalized) === 16) {
            $normalized .= ':00';
        }

        return $normalized;
    }

    private function toBooleanInt($value)
    {
        if ($value === null || $value === '') {
            return 0;
        }

        if (is_bool($value)) {
            return $value ? 1 : 0;
        }

        if ((string) $value === '1' || strtolower((string) $value) === 'true') {
            return 1;
        }

        return 0;
    }

    private function resolveEventViewSpec($request)
    {
        $raw = null;

        if (isset($request['view']) && trim((string) $request['view']) !== '') {
            $raw = trim((string) $request['view']);
        } elseif (isset($request['projection']) && trim((string) $request['projection']) !== '') {
            $raw = trim((string) $request['projection']);
        } elseif (isset($request['fields']) && trim((string) $request['fields']) !== '') {
            $raw = trim((string) $request['fields']);
        } else {
            $headerView = isset($_SERVER['HTTP_X_EVENT_VIEW']) ? trim((string) $_SERVER['HTTP_X_EVENT_VIEW']) : '';
            $headerFields = isset($_SERVER['HTTP_X_EVENT_FIELDS']) ? trim((string) $_SERVER['HTTP_X_EVENT_FIELDS']) : '';
            if ($headerView !== '') {
                $raw = $headerView;
            } elseif ($headerFields !== '') {
                $raw = $headerFields;
            }
        }

        if ($raw === null || $raw === '') {
            return array('mode' => 'FULL', 'fields' => array());
        }

        $upper = strtoupper($raw);
        if ($upper === 'FULL') {
            return array('mode' => 'FULL', 'fields' => array());
        }
        if ($upper === 'SUMMARY' || $upper === 'STANDARD') {
            return array('mode' => 'SUMMARY', 'fields' => array());
        }
        if ($upper === 'BASIC' || $upper === 'MINIMAL' || $upper === 'MINI') {
            return array('mode' => 'BASIC', 'fields' => array());
        }

        $fields = array_values(array_filter(array_map(function ($item) {
            return trim((string) $item);
        }, explode(',', $raw)), function ($item) {
            return $item !== '';
        }));

        if (empty($fields)) {
            return array('mode' => 'FULL', 'fields' => array());
        }

        return array('mode' => 'CUSTOM', 'fields' => $fields);
    }

    private function buildEventPayload($event, $viewSpec)
    {
        $eventArray = is_object($event) && method_exists($event, 'toArray')
            ? $event->toArray()
            : (array) $event;

        $eventId = isset($eventArray['id']) ? (int) $eventArray['id'] : 0;
        $legacyEventId = isset($eventArray['legacy_event_id']) && (int) $eventArray['legacy_event_id'] > 0
            ? (int) $eventArray['legacy_event_id']
            : $eventId;

        $mode = isset($viewSpec['mode']) ? $viewSpec['mode'] : 'FULL';
        $fields = isset($viewSpec['fields']) && is_array($viewSpec['fields']) ? $viewSpec['fields'] : array();

        if ($mode === 'FULL') {
            $eventArray['configuracion'] = $this->events->getConfiguracion($eventId);
            $eventArray['costos'] = $this->events->getCostos($legacyEventId);
            return $eventArray;
        }

        $basicFields = array('id', 'organization_id', 'city_id', 'event_year', 'title', 'start_at', 'end_at', 'is_active', 'city_label');
        $summaryFields = array(
            'id', 'organization_id', 'city_id', 'event_year', 'title', 'start_at', 'end_at', 'is_active',
            'max_registrations', 'threshold', 'registration_open_at', 'registration_deadline',
            'price_mxn', 'price_usd', 'minimum_payment_mxn', 'city_label'
        );

        if ($mode === 'BASIC') {
            return $this->pickEventFields($eventArray, $basicFields);
        }

        if ($mode === 'SUMMARY') {
            return $this->pickEventFields($eventArray, $summaryFields);
        }

        $payload = $this->pickEventFields($eventArray, $fields);
        if (in_array('configuracion', $fields, true)) {
            $payload['configuracion'] = $this->events->getConfiguracion($eventId);
        }
        if (in_array('costos', $fields, true)) {
            $payload['costos'] = $this->events->getCostos($legacyEventId);
        }

        return $payload;
    }

    private function pickEventFields($eventArray, $fields)
    {
        $payload = array();
        foreach ($fields as $field) {
            if (array_key_exists($field, $eventArray)) {
                $payload[$field] = $eventArray[$field];
            }
        }
        return $payload;
    }
}
