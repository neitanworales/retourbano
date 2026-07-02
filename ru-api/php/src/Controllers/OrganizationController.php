<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Repository/OrganizationRepository.php';
require_once __DIR__ . '/../Models/Organization.php';

class OrganizationController extends BaseController
{
    private $organizations;

    public function __construct()
    {
        $this->organizations = new OrganizationRepository();
    }

    public function list($request)
    {
        $active = isset($request['active']) && $request['active'] !== '' ? (int) $request['active'] : null;
        $cityId = isset($request['city_id']) && $request['city_id'] !== '' ? (int) $request['city_id'] : null;
        $limit = isset($request['limit']) ? (int) $request['limit'] : 200;
        $offset = isset($request['offset']) ? (int) $request['offset'] : 0;

        $items = $this->organizations->findMany($active, $cityId, $limit, $offset);
        $data = array_map(function ($organization) {
            return $organization->toArray();
        }, $items);

        return $this->ok(array('organizations' => $data), 'organizations list');
    }

    public function create($request)
    {
        $organization = new Organization();
        $organization->legacy_city_id = $this->toNullableInt($request['legacy_city_id'] ?? null);
        $organization->city_id = $this->toNullableInt($request['city_id'] ?? null);
        $organization->name = $this->toNullableString($request['name'] ?? null);
        $organization->slug = $this->toNullableString($request['slug'] ?? null);
        $organization->legal_name = $this->toNullableString($request['legal_name'] ?? null);
        $organization->email = $this->toNullableString($request['email'] ?? null);
        $organization->phone = $this->toNullableString($request['phone'] ?? null);
        $organization->is_active = $this->toBooleanInt($request['is_active'] ?? 1);

        if (!$organization->name) {
            return $this->fail('name is required', 422);
        }

        if (!$organization->city_id || (int) $organization->city_id <= 0) {
            return $this->fail('city_id is required', 422);
        }

        if (!$organization->slug) {
            $organization->slug = $this->slugify($organization->name);
        }

        $newId = $this->organizations->create($organization);
        if (!$newId || (int) $newId <= 0) {
            return $this->fail('organization could not be created', 500);
        }

        $created = $this->organizations->findModelById((int) $newId);
        return $this->ok(array('organization' => $created ? $created->toArray() : null), 'organization created');
    }

    public function update($request)
    {
        $id = isset($request['id']) ? (int) $request['id'] : 0;
        if ($id <= 0) {
            return $this->fail('id is required', 422);
        }

        $existing = $this->organizations->findModelById($id);
        if (!$existing) {
            return $this->fail('organization not found', 404);
        }

        $name = $this->toNullableString($request['name'] ?? $existing->name);
        $slug = $this->toNullableString($request['slug'] ?? $existing->slug);
        $cityId = $this->toNullableInt($request['city_id'] ?? $existing->city_id);

        if (!$name) {
            return $this->fail('name is required', 422);
        }

        if (!$cityId || (int) $cityId <= 0) {
            return $this->fail('city_id is required', 422);
        }

        $existing->legacy_city_id = $this->toNullableInt($request['legacy_city_id'] ?? $existing->legacy_city_id);
        $existing->city_id = $cityId;
        $existing->name = $name;
        $existing->slug = $slug ?: $this->slugify($name);
        $existing->legal_name = $this->toNullableString($request['legal_name'] ?? $existing->legal_name);
        $existing->email = $this->toNullableString($request['email'] ?? $existing->email);
        $existing->phone = $this->toNullableString($request['phone'] ?? $existing->phone);
        $existing->is_active = $this->toBooleanInt($request['is_active'] ?? $existing->is_active);

        $ok = $this->organizations->update($existing);
        if (!$ok) {
            return $this->fail('organization could not be updated', 500);
        }

        $updated = $this->organizations->findModelById($id);
        return $this->ok(array('organization' => $updated ? $updated->toArray() : null), 'organization updated');
    }

    public function delete($request)
    {
        $id = isset($request['id']) ? (int) $request['id'] : 0;
        if ($id <= 0) {
            return $this->fail('id is required', 422);
        }

        $existing = $this->organizations->findModelById($id);
        if (!$existing) {
            return $this->fail('organization not found', 404);
        }

        $ok = $this->organizations->delete($id);
        if (!$ok) {
            return $this->fail('organization could not be deleted', 500);
        }

        return $this->ok(array('id' => $id), 'organization deleted');
    }

    private function toNullableInt($value)
    {
        if ($value === null || $value === '') {
            return null;
        }

        return (int) $value;
    }

    private function toNullableString($value)
    {
        if ($value === null) {
            return null;
        }

        $value = trim((string) $value);
        return $value === '' ? null : $value;
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

    private function slugify($value)
    {
        $value = strtolower(trim((string) $value));
        $value = preg_replace('/[^a-z0-9]+/', '-', $value);
        return trim((string) $value, '-');
    }
}
