<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Repository/EventRepository.php';

class EventController extends BaseController
{
    private $events;

    public function __construct()
    {
        $this->events = new EventRepository();
    }

    public function list($request)
    {
        $year = isset($request['year']) && $request['year'] !== '' ? (int) $request['year'] : null;
        $active = isset($request['active']) && $request['active'] !== '' ? (int) $request['active'] : null;
        $limit = isset($request['limit']) ? (int) $request['limit'] : 100;
        $offset = isset($request['offset']) ? (int) $request['offset'] : 0;

        $items = $this->events->findMany($year, $active, $limit, $offset);
        $data = array_map(function ($event) {
            return $event->toArray();
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

        return $this->ok(array('event' => $event->toArray()), 'event found');
    }
}
