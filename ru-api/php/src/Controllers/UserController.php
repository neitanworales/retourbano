<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Repository/UserRepository.php';
require_once __DIR__ . '/../Repository/UserRoleRepository.php';
require_once __DIR__ . '/../Services/AuthService.php';

class UserController extends BaseController
{
    private $users;
    private $authService;
    private $userRoles;

    public function __construct()
    {
        $this->users = new UserRepository();
        $this->authService = new AuthService();
        $this->userRoles = new UserRoleRepository();
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
            return $this->ok(array(
                'user' => $request['auth_user']->toArray(),
                'roles' => $roles
            ), 'profile found');
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
        return $this->ok(array(
            'user' => $user->toArray(),
            'roles' => $roles
        ), 'profile found');
    }
}
