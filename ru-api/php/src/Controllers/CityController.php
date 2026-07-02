<?php

require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../Repository/CityRepository.php';
require_once __DIR__ . '/../Models/City.php';

class CityController extends BaseController
{
    private $cities;

    public function __construct()
    {
        $this->cities = new CityRepository();
    }

    public function list($request)
    {
        $active = isset($request['active']) && $request['active'] !== '' ? (int) $request['active'] : null;
        $limit = isset($request['limit']) ? (int) $request['limit'] : 200;
        $offset = isset($request['offset']) ? (int) $request['offset'] : 0;

        $items = $this->cities->findMany($active, $limit, $offset);
        $data = array_map(function ($city) {
            return $city->toArray();
        }, $items);

        return $this->ok(array('cities' => $data), 'cities list');
    }

    public function create($request)
    {
        $city = new City();
        $city->legacy_city_id = $this->toNullableInt($request['legacy_city_id'] ?? null);
        $city->name = $this->toNullableString($request['name'] ?? null);
        $city->slug = $this->toNullableString($request['slug'] ?? null);
        $city->is_active = $this->toBooleanInt($request['is_active'] ?? 1);

        if (!$city->name) {
            return $this->fail('name is required', 422);
        }

        if (!$city->slug) {
            $city->slug = $this->slugify($city->name);
        }

        $newId = $this->cities->create($city);
        if (!$newId || (int) $newId <= 0) {
            return $this->fail('city could not be created', 500);
        }

        $created = $this->cities->findModelById((int) $newId);
        return $this->ok(array('city' => $created ? $created->toArray() : null), 'city created');
    }

    public function update($request)
    {
        $id = isset($request['id']) ? (int) $request['id'] : 0;
        if ($id <= 0) {
            return $this->fail('id is required', 422);
        }

        $existing = $this->cities->findModelById($id);
        if (!$existing) {
            return $this->fail('city not found', 404);
        }

        $name = $this->toNullableString($request['name'] ?? $existing->name);
        $slug = $this->toNullableString($request['slug'] ?? $existing->slug);

        if (!$name) {
            return $this->fail('name is required', 422);
        }

        $existing->legacy_city_id = $this->toNullableInt($request['legacy_city_id'] ?? $existing->legacy_city_id);
        $existing->name = $name;
        $existing->slug = $slug ?: $this->slugify($name);
        $existing->is_active = $this->toBooleanInt($request['is_active'] ?? $existing->is_active);

        $ok = $this->cities->update($existing);
        if (!$ok) {
            return $this->fail('city could not be updated', 500);
        }

        $updated = $this->cities->findModelById($id);
        return $this->ok(array('city' => $updated ? $updated->toArray() : null), 'city updated');
    }

    public function delete($request)
    {
        $id = isset($request['id']) ? (int) $request['id'] : 0;
        if ($id <= 0) {
            return $this->fail('id is required', 422);
        }

        $existing = $this->cities->findModelById($id);
        if (!$existing) {
            return $this->fail('city not found', 404);
        }

        $ok = $this->cities->delete($id);
        if (!$ok) {
            return $this->fail('city could not be deleted', 500);
        }

        return $this->ok(array('id' => $id), 'city deleted');
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
