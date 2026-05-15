<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Repository/EventRepository.php';
require_once __DIR__ . '/../Repository/EventRegistrationRepository.php';

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

        $items = $this->events->findMany($year, $active, $limit, $offset);
        $data = array_map(function ($event) {
            $eventArray = $event->toArray();
            $eventArray['configuracion'] = $this->events->getConfiguracion((int) $event->id);
            $eventArray['costos'] = $this->events->getCostos(isset($event->legacy_event_id) ? (int) $event->legacy_event_id : (int) $event->id);
            return $eventArray;
        }, $items);

        return $this->ok(array('events' => $data), 'events list');
    }

    public function detail($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        if ($eventId <= 0) {
            return $this->fail('event_id is required', 422);
        }

        $event = $this->events->findModelById($eventId);
        if (!$event) {
            return $this->fail('event not found', 404);
        }

        $eventArray = $event->toArray();
        $eventArray['configuracion'] = $this->events->getConfiguracion($eventId);
        $eventArray['costos'] = $this->events->getCostos(isset($event->legacy_event_id) ? (int) $event->legacy_event_id : $eventId);

        return $this->ok(array('event' => $eventArray), 'event found');
    }

    public function upcomingAvailability($request)
    {
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

            $row = $event->toArray();
            $row['is_registered'] = $isRegistered;
            $row['registration_id'] = $isRegistered ? (int) $registration->id : null;
            $row['registration_status'] = $isRegistered ? $registration->registration_status : null;
            $row['configuracion'] = $this->events->getConfiguracion((int) $event->id);
            $row['costos'] = $this->events->getCostos(isset($event->legacy_event_id) ? (int) $event->legacy_event_id : (int) $event->id);
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
}
