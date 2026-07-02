<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Services/EventDashboardService.php';

class EventDashboardController extends BaseController
{
    private $dashboardService;

    public function __construct()
    {
        $this->dashboardService = new EventDashboardService();
    }

    public function getByEvent($request)
    {
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        if ($eventId <= 0) {
            return $this->fail('event_id is required', 422);
        }

        $result = $this->dashboardService->getByEvent($eventId);
        if (isset($result['error'])) {
            return $this->fail($result['error'], isset($result['code']) ? (int) $result['code'] : 400);
        }

        return $this->ok($result, 'event dashboard');
    }
}
