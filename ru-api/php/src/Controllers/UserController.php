<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Repository/UserRepository.php';
require_once __DIR__ . '/../Repository/UserRoleRepository.php';
require_once __DIR__ . '/../Repository/EventRegistrationRepository.php';
require_once __DIR__ . '/../Repository/PaymentRepository.php';
require_once __DIR__ . '/../Repository/ActivityLogRepository.php';
require_once __DIR__ . '/../Services/AuthService.php';

class UserController extends BaseController
{
    private const MANAGED_GLOBAL_ROLES = array('admin', 'staff');

    private $users;
    private $authService;
    private $userRoles;
    private $eventRegistrations;
    private $payments;
    private $activityLog;

    public function __construct()
    {
        $this->users = new UserRepository();
        $this->authService = new AuthService();
        $this->userRoles = new UserRoleRepository();
        $this->eventRegistrations = new EventRegistrationRepository();
        $this->payments = new PaymentRepository();
        $this->activityLog = new ActivityLogRepository();
    }

    public function list($request)
    {
        $limit = isset($request['limit']) ? (int) $request['limit'] : 200;
        $offset = isset($request['offset']) ? (int) $request['offset'] : 0;
        $search = isset($request['search']) ? trim((string) $request['search']) : '';

        if ($limit <= 0) {
            $limit = 200;
        }

        if ($limit > 1000) {
            $limit = 1000;
        }

        if ($offset < 0) {
            $offset = 0;
        }

        $users = $this->users->findManageableUsers($limit, $offset, $search);
        $userIds = array();
        foreach ($users as $user) {
            $userIds[] = (int) $user->id;
        }

        $latestEventsByUserId = $this->eventRegistrations->findLatestEventSummaryByUserIds($userIds);
        $activeEventsByUserId = $this->eventRegistrations->findActiveEventSummariesByUserIds($userIds);
        $payload = array();

        foreach ($users as $user) {
            $userData = $user->toArray();
            $latestEvent = isset($latestEventsByUserId[(int) $user->id]) ? $latestEventsByUserId[(int) $user->id] : null;
            $activeEvents = isset($activeEventsByUserId[(int) $user->id]) ? $activeEventsByUserId[(int) $user->id] : array();
            $userData['roles'] = $this->userRoles->getRolesByUserId((int) $user->id);
            $userData['has_password'] = isset($user->password_hash) && trim((string) $user->password_hash) !== '';
            $userData['latest_event'] = $latestEvent;
            $userData['active_events'] = $activeEvents;
            $userData['is_registered_in_active_event'] = !empty($activeEvents);
            $userData['password'] = '';
            $payload[] = $userData;
        }

        return $this->ok(array(
            'users' => $payload,
            'pagination' => array(
                'limit' => $limit,
                'offset' => $offset,
                'count' => count($payload),
                'search' => $search,
            ),
        ), 'users listed');
    }

    public function history($request)
    {
        $limit = isset($request['limit']) ? (int) $request['limit'] : 200;
        $offset = isset($request['offset']) ? (int) $request['offset'] : 0;
        $search = isset($request['search']) ? trim((string) $request['search']) : '';

        if ($limit <= 0) {
            $limit = 200;
        }

        if ($limit > 1000) {
            $limit = 1000;
        }

        if ($offset < 0) {
            $offset = 0;
        }

        $users = $this->users->findUsersWithEventHistory($limit, $offset, $search);
        $userIds = array();
        foreach ($users as $user) {
            $userIds[] = (int) $user->id;
        }

        $latestEventsByUserId = $this->eventRegistrations->findLatestEventSummaryByUserIds($userIds);
        $historicalEventsByUserId = $this->eventRegistrations->findHistoricalEventSummariesByUserIds($userIds);
        $payload = array();
        $attendanceRank = 0;

        foreach ($users as $user) {
            $attendanceRank++;
            $userData = $user->toArray();
            $latestEvent = isset($latestEventsByUserId[(int) $user->id]) ? $latestEventsByUserId[(int) $user->id] : null;
            $eventHistory = isset($historicalEventsByUserId[(int) $user->id]) ? $historicalEventsByUserId[(int) $user->id] : array();
            $attendanceCount = isset($userData['attendance_count']) ? (int) $userData['attendance_count'] : count($eventHistory);
            $userData['attendance_count'] = $attendanceCount;
            $userData['attendance_rank'] = $attendanceRank;
            $userData['latest_event'] = $latestEvent;
            $userData['event_history'] = $eventHistory;
            $payload[] = $userData;
        }

        return $this->ok(array(
            'users' => $payload,
            'pagination' => array(
                'limit' => $limit,
                'offset' => $offset,
                'count' => count($payload),
                'search' => $search,
            ),
        ), 'users history listed');
    }

    public function detail($request)
    {
        $userId = isset($request['user_id']) ? (int) $request['user_id'] : 0;
        if ($userId <= 0) {
            return $this->fail('user_id is required', 422);
        }

        $user = $this->users->findModelById($userId);
        if (!$user) {
            return $this->fail('user not found', 404);
        }

        return $this->ok(array('user' => $user->toArray()), 'user found');
    }

    public function profile($request)
    {
        if (isset($request['auth_user']) && $request['auth_user']) {
            $userId = (int) $request['auth_user']->id;
            $roles = $this->userRoles->getRolesByUserId($userId);
            $profileData = array(
                'user' => $request['auth_user']->toArray(),
                'roles' => $roles,
                'has_password' => isset($request['auth_user']->password_hash) && trim((string) $request['auth_user']->password_hash) !== '',
            );

            if ($this->parseBoolean(isset($request['include_dashboard']) ? $request['include_dashboard'] : false)) {
                $profileData = array_merge($profileData, $this->buildDashboardProfileData($userId));
            }

            return $this->ok($profileData, 'profile found');
        }

        $token = isset($request['token']) ? trim($request['token']) : '';
        if ($token === '') {
            return $this->fail('token is required', 422);
        }

        $user = $this->authService->validateToken($token);
        if (!$user) {
            return $this->fail('invalid or expired token', 401);
        }

        $userId = (int) $user->id;
        $roles = $this->userRoles->getRolesByUserId($userId);
        $profileData = array(
            'user' => $user->toArray(),
            'roles' => $roles,
            'has_password' => isset($user->password_hash) && trim((string) $user->password_hash) !== '',
        );

        if ($this->parseBoolean(isset($request['include_dashboard']) ? $request['include_dashboard'] : false)) {
            $profileData = array_merge($profileData, $this->buildDashboardProfileData($userId));
        }

        return $this->ok($profileData, 'profile found');
    }

    public function updateProfile($request)
    {
        if (!isset($request['auth_user']) || !$request['auth_user']) {
            return $this->fail('unauthorized', 401);
        }

        $userId = (int) $request['auth_user']->id;
        $user = $this->users->findModelById($userId);
        if (!$user) {
            return $this->fail('user not found', 404);
        }

        $before = $user->toArray();
        $this->fillProfileFromRequest($user, $request);
        $saved = $this->users->update($user);
        if (!$saved) {
            return $this->fail('could not update profile', 500);
        }

        $this->activityLog->createEntry(
            $userId,
            'users.profile.update',
            $this->buildProfileActivitySummary($before),
            $this->buildProfileActivitySummary($user->toArray()),
            array(
                'actor_user_id' => $userId,
                'entity_type' => 'user',
                'entity_id' => $userId,
                'source' => 'api.v1.users',
                'metadata' => array('changed_fields' => $this->extractProfileChangedFields($before, $user->toArray())),
            )
        );

        return $this->ok(array(
            'user' => $user->toArray(),
            'roles' => $this->userRoles->getRolesByUserId($userId),
            'has_password' => isset($user->password_hash) && trim((string) $user->password_hash) !== '',
        ), 'profile updated');
    }

    public function updateOwnPassword($request)
    {
        if (!isset($request['auth_user']) || !$request['auth_user']) {
            return $this->fail('unauthorized', 401);
        }

        $userId = (int) $request['auth_user']->id;
        $newPassword = isset($request['new_password']) ? (string) $request['new_password'] : '';

        if (trim($newPassword) === '') {
            return $this->fail('new_password is required', 422);
        }

        $ok = $this->authService->updatePassword($userId, $newPassword);
        if (!$ok) {
            return $this->fail('could not update password', 500);
        }

        $this->activityLog->createEntry($userId, 'users.password.update', null, 'Contrasena actualizada desde cuenta', array(
            'actor_user_id' => $userId,
            'entity_type' => 'user',
            'entity_id' => $userId,
            'source' => 'api.v1.users',
        ));

        return $this->ok(array('user_id' => $userId), 'password updated');
    }

    public function profileActivity($request)
    {
        if (!isset($request['auth_user']) || !$request['auth_user']) {
            return $this->fail('unauthorized', 401);
        }

        $userId = (int) $request['auth_user']->id;
        $limit = isset($request['limit']) ? (int) $request['limit'] : 10;
        $items = $this->activityLog->findLatestByUserId($userId, $limit);

        return $this->ok(array(
            'movements' => array_map(function ($item) {
                return $item->toArray();
            }, $items),
        ), 'profile activity found');
    }

    public function activityLog($request)
    {
        $limit = isset($request['limit']) ? (int) $request['limit'] : 100;
        $offset = isset($request['offset']) ? (int) $request['offset'] : 0;
        $search = isset($request['search']) ? trim((string) $request['search']) : '';
        $action = isset($request['action']) ? trim((string) $request['action']) : '';

        if ($limit <= 0) {
            $limit = 100;
        }

        if ($limit > 500) {
            $limit = 500;
        }

        if ($offset < 0) {
            $offset = 0;
        }

        $items = $this->activityLog->findDetailed($limit, $offset, $search, $action);
        $total = $this->activityLog->countDetailed($search, $action);
        $actions = $this->activityLog->listDistinctActions();

        $payload = array_map(function ($item) {
            $item['action_label'] = $this->getActivityActionLabel(isset($item['action']) ? $item['action'] : '');
            $item['actor_name'] = $this->getActivityUserLabel(
                isset($item['actor_display_name']) ? $item['actor_display_name'] : null,
                isset($item['actor_full_name']) ? $item['actor_full_name'] : null,
                isset($item['actor_email']) ? $item['actor_email'] : null
            );
            $item['affected_name'] = $this->getActivityUserLabel(
                isset($item['affected_display_name']) ? $item['affected_display_name'] : null,
                isset($item['affected_full_name']) ? $item['affected_full_name'] : null,
                isset($item['affected_email']) ? $item['affected_email'] : null
            );
            return $item;
        }, $items);

        return $this->ok(array(
            'items' => $payload,
            'filters' => array(
                'actions' => array_map(function ($actionName) {
                    return array(
                        'value' => $actionName,
                        'label' => $this->getActivityActionLabel($actionName),
                    );
                }, $actions),
            ),
            'pagination' => array(
                'limit' => $limit,
                'offset' => $offset,
                'count' => count($payload),
                'total' => $total,
                'search' => $search,
                'action' => $action,
            ),
        ), 'activity log listed');
    }

    public function updateRoles($request)
    {
        $targetUserId = isset($request['user_id']) ? (int) $request['user_id'] : 0;
        if ($targetUserId <= 0) {
            return $this->fail('user_id is required', 422);
        }

        $targetUser = $this->users->findModelById($targetUserId);
        if (!$targetUser) {
            return $this->fail('user not found', 404);
        }

        $hasSyncPayload = isset($request['roles']);
        $requestedRoles = $this->extractRolesFromRequest($request, 'roles');
        $addRoles = $this->extractRolesFromRequest($request, 'add_roles');
        $removeRoles = $this->extractRolesFromRequest($request, 'remove_roles');

        $invalidRoles = $this->findUnsupportedRoles(array_merge($requestedRoles, $addRoles, $removeRoles), self::MANAGED_GLOBAL_ROLES);
        if (!empty($invalidRoles)) {
            return $this->fail('only admin and staff can be managed here', 422, array('roles' => $invalidRoles));
        }

        if ($hasSyncPayload) {
            $currentRoles = $this->userRoles->getRolesByUserId($targetUserId);
            $managedCurrentRoles = array_values(array_intersect($currentRoles, self::MANAGED_GLOBAL_ROLES));
            $toAdd = array_values(array_diff($requestedRoles, $managedCurrentRoles));
            $toRemove = array_values(array_diff($managedCurrentRoles, $requestedRoles));

            $added = $this->userRoles->addRoles($targetUserId, $toAdd);
            $removed = $this->userRoles->removeRoles($targetUserId, $toRemove);
        } else {
            if (empty($addRoles) && empty($removeRoles)) {
                return $this->fail('provide roles, add_roles, or remove_roles', 422);
            }

            $overlap = array_intersect($addRoles, $removeRoles);
            if (!empty($overlap)) {
                return $this->fail('the same role cannot be both added and removed', 422, array('roles' => array_values($overlap)));
            }

            $added = $this->userRoles->addRoles($targetUserId, $addRoles);
            $removed = $this->userRoles->removeRoles($targetUserId, $removeRoles);
        }

        $finalRoles = $this->userRoles->getRolesByUserId($targetUserId);
        sort($finalRoles);

        $actorId = isset($request['auth_user']) && isset($request['auth_user']->id) ? (int) $request['auth_user']->id : null;
        $this->activityLog->createEntry($targetUserId, 'users.roles.update', $managedCurrentRoles ?? array(), $finalRoles, array(
            'actor_user_id' => $actorId,
            'entity_type' => 'role',
            'entity_id' => $targetUserId,
            'source' => 'api.v1.users',
            'metadata' => array(
                'added' => $added,
                'removed' => $removed,
                'requested_roles' => $hasSyncPayload ? $requestedRoles : null,
                'add_roles' => !$hasSyncPayload ? $addRoles : null,
                'remove_roles' => !$hasSyncPayload ? $removeRoles : null,
            ),
        ));

        return $this->ok(array(
            'user_id' => $targetUserId,
            'roles' => $finalRoles,
            'added' => $added,
            'removed' => $removed,
        ), 'roles updated');
    }

    public function updateEventRoles($request)
    {
        $targetUserId = isset($request['user_id']) ? (int) $request['user_id'] : 0;
        $eventId = isset($request['event_id']) ? (int) $request['event_id'] : 0;
        if ($targetUserId <= 0 || $eventId <= 0) {
            return $this->fail('user_id and event_id are required', 422);
        }

        $targetUser = $this->users->findModelById($targetUserId);
        if (!$targetUser) {
            return $this->fail('user not found', 404);
        }

        $registration = $this->eventRegistrations->findByEventAndUser($eventId, $targetUserId);
        if (!$registration) {
            return $this->fail('event registration not found for user', 404);
        }

        $hasEventRolesPayload = isset($request['event_roles']);
        $eventRoles = $this->extractRolesFromRequest($request, 'event_roles');
        $hasEventStaffPayload = array_key_exists('event_is_staff', $request);
        $hasEventAdminPayload = array_key_exists('event_is_admin', $request);
        $hasEventPayload = $hasEventRolesPayload || $hasEventStaffPayload || $hasEventAdminPayload;

        $invalidEventRoles = $this->findUnsupportedRoles($eventRoles, self::MANAGED_GLOBAL_ROLES);
        if (!empty($invalidEventRoles)) {
            return $this->fail('event_roles only supports admin and staff', 422, array('roles' => $invalidEventRoles));
        }

        if (!$hasEventPayload) {
            return $this->fail('provide event_roles, event_is_staff, or event_is_admin', 422);
        }

        $isStaff = ((int) $registration->is_staff === 1) ? 1 : 0;
        $isAdmin = ((int) $registration->is_admin === 1) ? 1 : 0;

        if ($hasEventRolesPayload) {
            $isStaff = in_array('staff', $eventRoles, true) ? 1 : 0;
            $isAdmin = in_array('admin', $eventRoles, true) ? 1 : 0;
        }

        if ($hasEventStaffPayload) {
            $parsedStaff = $this->parseBoolean($request['event_is_staff']);
            if ($parsedStaff === null) {
                return $this->fail('event_is_staff must be boolean-like (true/false/1/0)', 422);
            }
            $isStaff = $parsedStaff ? 1 : 0;
        }

        if ($hasEventAdminPayload) {
            $parsedAdmin = $this->parseBoolean($request['event_is_admin']);
            if ($parsedAdmin === null) {
                return $this->fail('event_is_admin must be boolean-like (true/false/1/0)', 422);
            }
            $isAdmin = $parsedAdmin ? 1 : 0;
        }

        $affectedEventRows = $this->eventRegistrations->updateRolesByUserAndEvent($targetUserId, $eventId, $isStaff, $isAdmin);

        // Event-level changes must propagate to global role assignments.
        $shouldHaveStaffRole = $this->eventRegistrations->userHasAnyStaffRegistration($targetUserId);
        $shouldHaveAdminRole = $this->eventRegistrations->userHasAnyAdminRegistration($targetUserId);

        if ($shouldHaveStaffRole) {
            $this->userRoles->addRoles($targetUserId, array('staff'));
        } else {
            $this->userRoles->removeRoles($targetUserId, array('staff'));
        }

        if ($shouldHaveAdminRole) {
            $this->userRoles->addRoles($targetUserId, array('admin'));
        } else {
            $this->userRoles->removeRoles($targetUserId, array('admin'));
        }

        $finalRoles = $this->userRoles->getRolesByUserId($targetUserId);
        sort($finalRoles);

        $actorId = isset($request['auth_user']) && isset($request['auth_user']->id) ? (int) $request['auth_user']->id : null;
        $this->activityLog->createEntry($targetUserId, 'users.event_roles.update', array(
            'is_staff' => ((int) $registration->is_staff === 1) ? 1 : 0,
            'is_admin' => ((int) $registration->is_admin === 1) ? 1 : 0,
        ), array(
            'is_staff' => $isStaff,
            'is_admin' => $isAdmin,
            'global_roles' => $finalRoles,
        ), array(
            'actor_user_id' => $actorId,
            'entity_type' => 'role',
            'entity_id' => $targetUserId,
            'related_event_id' => $eventId,
            'related_registration_id' => (int) $registration->id,
            'source' => 'api.v1.users',
            'metadata' => array(
                'affected' => $affectedEventRows,
                'global_roles' => $finalRoles,
            ),
        ));

        return $this->ok(array(
            'user_id' => $targetUserId,
            'event_id' => $eventId,
            'event_registration' => array(
                'is_staff' => $isStaff,
                'is_admin' => $isAdmin,
                'affected' => $affectedEventRows,
            ),
            'roles' => $finalRoles,
        ), 'event roles updated');
    }

    public function updatePassword($request)
    {
        $targetUserId = isset($request['user_id']) ? (int) $request['user_id'] : 0;
        $newPassword = isset($request['new_password']) ? (string) $request['new_password'] : '';

        if ($targetUserId <= 0 || trim($newPassword) === '') {
            return $this->fail('user_id and new_password are required', 422);
        }

        $targetUser = $this->users->findModelById($targetUserId);
        if (!$targetUser) {
            return $this->fail('user not found', 404);
        }

        $ok = $this->authService->updatePassword($targetUserId, $newPassword);
        if (!$ok) {
            return $this->fail('could not update password', 500);
        }

        $actorId = isset($request['auth_user']) && isset($request['auth_user']->id) ? (int) $request['auth_user']->id : null;
        $message = $actorId && $actorId === $targetUserId
            ? 'Contrasena actualizada'
            : 'Contrasena actualizada por staff/admin';
        $this->activityLog->createEntry($targetUserId, 'users.password.update', null, $message, array(
            'actor_user_id' => $actorId,
            'entity_type' => 'user',
            'entity_id' => $targetUserId,
            'source' => 'api.v1.users',
        ));

        return $this->ok(array('user_id' => $targetUserId), 'password updated');
    }

    public function resetPassword($request)
    {
        $targetUserId = isset($request['user_id']) ? (int) $request['user_id'] : 0;

        if ($targetUserId <= 0) {
            return $this->fail('user_id is required', 422);
        }

        $targetUser = $this->users->findModelById($targetUserId);
        if (!$targetUser) {
            return $this->fail('user not found', 404);
        }

        $ok = $this->authService->clearPassword($targetUserId);
        if (!$ok) {
            return $this->fail('could not reset password access', 500);
        }

        $actorId = isset($request['auth_user']) && isset($request['auth_user']->id) ? (int) $request['auth_user']->id : null;
        $this->activityLog->createEntry($targetUserId, 'users.password.reset_access', null, 'Acceso por contrasena reiniciado por staff/admin', array(
            'actor_user_id' => $actorId,
            'entity_type' => 'user',
            'entity_id' => $targetUserId,
            'source' => 'api.v1.users',
        ));

        return $this->ok(array('user_id' => $targetUserId), 'password access reset');
    }

    public function duplicates($request)
    {
        $duplicates = $this->users->findLegacyDuplicateEmails();
        $payload = array();

        foreach ($duplicates as $duplicate) {
            $email = isset($duplicate['email']) ? (string) $duplicate['email'] : '';
            $payload[] = array(
                'email' => $email,
                'count' => isset($duplicate['count']) ? (int) $duplicate['count'] : 0,
                'campamentos' => $this->normalizeLegacyAttendanceRows($this->users->findLegacyRegistrationsByEmail($email)),
                'tutorias' => $this->normalizeLegacyAttendanceRows($this->users->findLegacyTutorshipsByEmail($email)),
            );
        }

        return $this->ok(array('duplicates' => $payload), 'duplicate registrations listed');
    }

    public function updateTutorLink($request)
    {
        $legacyUserId = isset($request['legacy_user_id']) ? (int) $request['legacy_user_id'] : 0;
        $email = isset($request['email']) ? trim((string) $request['email']) : '';
        $emailTutor = isset($request['email_tutor']) ? trim((string) $request['email_tutor']) : '';

        if ($legacyUserId <= 0) {
            return $this->fail('legacy_user_id is required', 422);
        }

        $result = $this->users->updateLegacyTutorLink($legacyUserId, $email, $emailTutor);
        if (!$result['ok']) {
            return $this->fail('could not update tutor link', 500);
        }

        return $this->ok(array(
            'legacy_user_id' => $legacyUserId,
            'email' => $email,
            'email_tutor' => $emailTutor,
            'affected' => $result['affected'],
        ), 'tutor link updated');
    }

    private function parseBoolean($value)
    {
        if (is_bool($value)) {
            return $value;
        }

        if (is_int($value) || is_float($value)) {
            if ((int) $value === 1) {
                return true;
            }
            if ((int) $value === 0) {
                return false;
            }
            return null;
        }

        $normalized = strtolower(trim((string) $value));
        if (in_array($normalized, array('1', 'true', 'yes', 'on'), true)) {
            return true;
        }

        if (in_array($normalized, array('0', 'false', 'no', 'off'), true)) {
            return false;
        }

        return null;
    }

    private function normalizeLegacyAttendanceRows($rows)
    {
        return array_map(function ($row) {
            return array(
                'guerreroID' => isset($row['guerreroID']) ? (int) $row['guerreroID'] : null,
                'id' => isset($row['id']) ? (int) $row['id'] : null,
                'id_guerrero' => isset($row['id_guerrero']) ? (int) $row['id_guerrero'] : null,
                'id_campamento' => isset($row['id_campamento']) ? (int) $row['id_campamento'] : null,
                'nick' => isset($row['nick']) ? $row['nick'] : null,
                'nombre' => isset($row['nombre']) ? $row['nombre'] : null,
                'email' => isset($row['email']) ? $row['email'] : null,
                'email_tutor' => isset($row['email_tutor']) ? $row['email_tutor'] : null,
            );
        }, (array) $rows);
    }

    private function findUnsupportedRoles($roles, $allowedRoles)
    {
        $normalizedAllowedRoles = array_values(array_unique(array_map(function ($role) {
            return strtolower(trim((string) $role));
        }, (array) $allowedRoles)));

        $normalizedRoles = array_values(array_unique(array_map(function ($role) {
            return strtolower(trim((string) $role));
        }, (array) $roles)));

        return array_values(array_diff($normalizedRoles, $normalizedAllowedRoles));
    }

    private function extractRolesFromRequest($request, $key)
    {
        if (!isset($request[$key])) {
            return array();
        }

        $value = $request[$key];
        if (!is_array($value)) {
            $value = explode(',', (string) $value);
        }

        $roles = array();
        foreach ($value as $role) {
            $normalized = strtolower(trim((string) $role));
            if ($normalized === '') {
                continue;
            }

            if (!preg_match('/^[a-z0-9_-]+$/', $normalized)) {
                continue;
            }

            $roles[] = $normalized;
        }

        return array_values(array_unique($roles));
    }

    private function fillProfileFromRequest($user, $request)
    {
        $stringFields = array(
            'full_name' => array('full_name', 'nombre'),
            'display_name' => array('display_name', 'nick'),
            'birth_date' => array('birth_date', 'fechaNac'),
            'gender' => array('gender', 'sexo'),
            'shirt_size' => array('shirt_size', 'talla'),
            'coming_from' => array('coming_from', 'vienesDe'),
            'email' => array('email'),
            'whatsapp' => array('whatsapp'),
            'phone' => array('phone', 'telefono'),
            'allergies' => array('allergies', 'alergias'),
            'guardian_phone' => array('guardian_phone', 'tutorTelefono'),
            'guardian_name' => array('guardian_name', 'tutorNombre'),
            'guardian_email' => array('guardian_email', 'emailTutor'),
            'facebook' => array('facebook'),
            'instagram' => array('instagram'),
            'church' => array('church', 'iglesia'),
            'medications' => array('medications', 'medicamentos'),
        );

        foreach ($stringFields as $property => $aliases) {
            foreach ($aliases as $key) {
                if (array_key_exists($key, $request)) {
                    $value = trim((string) $request[$key]);
                    $user->{$property} = $value === '' ? null : $value;
                    break;
                }
            }
        }

        if (array_key_exists('age', $request) || array_key_exists('edad', $request)) {
            $rawAge = array_key_exists('age', $request) ? $request['age'] : $request['edad'];
            $user->age = $rawAge === null || $rawAge === '' ? null : (int) $rawAge;
        }
    }

    private function buildDashboardProfileData($userId)
    {
        $registrations = $this->eventRegistrations->findByUser($userId, 200, 0, true);
        $activeRegistrations = array();
        $historicalRegistrations = array();

        foreach ($registrations as $registration) {
            $item = $registration->toArray();
            $item = $this->attachPaymentsToRegistrationItem($item);

            if (!empty($item['is_active'])) {
                $activeRegistrations[] = $item;
            } else {
                $historicalRegistrations[] = $item;
            }
        }

        return array(
            'active_registrations' => $activeRegistrations,
            'historical_registrations' => $historicalRegistrations,
        );
    }

    private function buildProfileActivitySummary($profile)
    {
        if (!is_array($profile)) {
            return null;
        }

        $fields = array(
            'full_name' => isset($profile['full_name']) ? $profile['full_name'] : null,
            'display_name' => isset($profile['display_name']) ? $profile['display_name'] : null,
            'email' => isset($profile['email']) ? $profile['email'] : null,
            'phone' => isset($profile['phone']) ? $profile['phone'] : null,
            'whatsapp' => isset($profile['whatsapp']) ? $profile['whatsapp'] : null,
            'church' => isset($profile['church']) ? $profile['church'] : null,
            'guardian_name' => isset($profile['guardian_name']) ? $profile['guardian_name'] : null,
            'guardian_phone' => isset($profile['guardian_phone']) ? $profile['guardian_phone'] : null,
            'guardian_email' => isset($profile['guardian_email']) ? $profile['guardian_email'] : null,
        );

        return json_encode($fields, JSON_UNESCAPED_UNICODE);
    }

    private function extractProfileChangedFields($before, $after)
    {
        $changed = array();
        $tracked = array('full_name', 'display_name', 'email', 'phone', 'whatsapp', 'church', 'guardian_name', 'guardian_phone', 'guardian_email');

        foreach ($tracked as $field) {
            $beforeValue = isset($before[$field]) ? (string) $before[$field] : '';
            $afterValue = isset($after[$field]) ? (string) $after[$field] : '';
            if ($beforeValue !== $afterValue) {
                $changed[] = $field;
            }
        }

        return $changed;
    }

    private function getActivityUserLabel($displayName, $fullName, $email)
    {
        $displayName = trim((string) $displayName);
        $fullName = trim((string) $fullName);
        $email = trim((string) $email);

        if ($displayName !== '') {
            return $displayName;
        }

        if ($fullName !== '') {
            return $fullName;
        }

        if ($email !== '') {
            return $email;
        }

        return 'Sistema';
    }

    private function getActivityActionLabel($action)
    {
        switch (trim((string) $action)) {
            case 'auth.login':
                return 'Inicio de sesion';
            case 'auth.logout':
                return 'Cierre de sesion';
            case 'auth.password_reset':
                return 'Contrasena restablecida con token';
            case 'users.profile.update':
                return 'Perfil actualizado';
            case 'users.password.update':
                return 'Contrasena actualizada';
            case 'users.password.reset_access':
                return 'Acceso por contrasena reiniciado';
            case 'users.roles.update':
                return 'Roles globales actualizados';
            case 'users.event_roles.update':
                return 'Roles por evento actualizados';
            case 'users.registration_profile_update':
                return 'Perfil actualizado desde inscripcion';
            case 'registrations.create':
                return 'Inscripcion creada';
            case 'registrations.reenrollment.create':
                return 'Reinscripcion creada';
            case 'registrations.update':
                return 'Inscripcion actualizada';
            case 'registrations.status_update':
                return 'Estatus de inscripcion actualizado';
            case 'registrations.delete':
                return 'Inscripcion eliminada';
            case 'payments.create':
                return 'Pago registrado';
            case 'payments.update':
                return 'Pago actualizado';
            case 'payments.delete':
                return 'Pago eliminado';
            default:
                return trim((string) $action) !== '' ? trim((string) $action) : 'Movimiento';
        }
    }

    private function attachPaymentsToRegistrationItem($item)
    {
        if (!is_array($item) || !isset($item['registration_id'])) {
            $item['pagos'] = array();
            $item['pagado'] = 0.0;
            return $item;
        }

        $registrationId = (int) $item['registration_id'];
        if ($registrationId <= 0) {
            $item['pagos'] = array();
            $item['pagado'] = 0.0;
            return $item;
        }

        $payments = $this->payments->findByRegistrationId($registrationId);
        $paymentRows = array_map(function ($payment) {
            return $payment->toArray();
        }, $payments);

        $item['pagos'] = $paymentRows;
        $item['pagado'] = array_reduce($paymentRows, function ($total, $payment) {
            $amount = isset($payment['amount']) ? (float) $payment['amount'] : 0;
            return $total + $amount;
        }, 0.0);

        return $item;
    }
}
