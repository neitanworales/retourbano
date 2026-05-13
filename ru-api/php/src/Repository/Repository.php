<?php
/**
 * Base Repository Class
 * 
 * Provides common CRUD operations and patterns
 * 
 * @version 1.0
 * @author Neitan
 */

abstract class Repository
{
    protected $connection;
    protected $table;
    protected $primaryKey = 'id';

    /**
     * Initialize repository with database connection
     * 
     * @param Connection $connection
     */
    public function __construct(Connection $connection)
    {
        $this->connection = $connection;
    }

    /**
     * Find record by primary key
     * 
     * @param int|string $id
     * @return array|null
     */
    public function find($id)
    {
        $sql = "SELECT * FROM {$this->table} WHERE {$this->primaryKey} = ?";
        return $this->connection->fetchOne($sql, [$id]);
    }

    /**
     * Find all records
     * 
     * @param array $conditions
     * @param string $orderBy
     * @param int $limit
     * @param int $offset
     * @return array
     */
    public function findAll($conditions = [], $orderBy = '', $limit = null, $offset = 0)
    {
        $sql = "SELECT * FROM {$this->table}";

        if (!empty($conditions)) {
            $where = [];
            $params = [];
            foreach ($conditions as $key => $value) {
                $where[] = "{$key} = ?";
                $params[] = $value;
            }
            $sql .= " WHERE " . implode(" AND ", $where);
        }

        if (!empty($orderBy)) {
            $sql .= " ORDER BY {$orderBy}";
        }

        if ($limit !== null) {
            $sql .= " LIMIT ?";
            $params[] = $limit;
            if ($offset > 0) {
                $sql .= " OFFSET ?";
                $params[] = $offset;
            }
        }

        return $this->connection->fetchAll($sql, $params ?? []);
    }

    /**
     * Count records
     * 
     * @param array $conditions
     * @return int
     */
    public function count($conditions = [])
    {
        $sql = "SELECT COUNT(*) as total FROM {$this->table}";

        $params = [];
        if (!empty($conditions)) {
            $where = [];
            foreach ($conditions as $key => $value) {
                $where[] = "{$key} = ?";
                $params[] = $value;
            }
            $sql .= " WHERE " . implode(" AND ", $where);
        }

        $result = $this->connection->fetchOne($sql, $params);
        return $result['total'] ?? 0;
    }

    /**
     * Create new record
     * 
     * @param array $data
     * @return int|string Last insert ID
     */
    public function create($data)
    {
        $columns = array_keys($data);
        $placeholders = array_fill(0, count($columns), '?');
        $values = array_values($data);

        $sql = "INSERT INTO {$this->table} (" . implode(', ', $columns) . ") VALUES (" . implode(', ', $placeholders) . ")";

        return $this->connection->insert($sql, $values);
    }

    /**
     * Update record
     * 
     * @param int|string $id
     * @param array $data
     * @return int Affected rows
     */
    public function update($id, $data)
    {
        $set = [];
        $values = [];

        foreach ($data as $key => $value) {
            $set[] = "{$key} = ?";
            $values[] = $value;
        }

        $values[] = $id;

        $sql = "UPDATE {$this->table} SET " . implode(', ', $set) . " WHERE {$this->primaryKey} = ?";

        return $this->connection->update($sql, $values);
    }

    /**
     * Delete record
     * 
     * @param int|string $id
     * @return int Affected rows
     */
    public function delete($id)
    {
        $sql = "DELETE FROM {$this->table} WHERE {$this->primaryKey} = ?";
        return $this->connection->delete($sql, [$id]);
    }

    /**
     * Find by custom condition
     * 
     * @param string $field
     * @param string $operator
     * @param mixed $value
     * @return array|null
     */
    public function findBy($field, $operator, $value)
    {
        $sql = "SELECT * FROM {$this->table} WHERE {$field} {$operator} ?";
        return $this->connection->fetchOne($sql, [$value]);
    }

    /**
     * Find all by custom condition
     * 
     * @param string $field
     * @param string $operator
     * @param mixed $value
     * @return array
     */
    public function findAllBy($field, $operator, $value)
    {
        $sql = "SELECT * FROM {$this->table} WHERE {$field} {$operator} ?";
        return $this->connection->fetchAll($sql, [$value]);
    }

    /**
     * Execute raw query (use with caution)
     * 
     * @param string $sql
     * @param array $params
     * @return PDOStatement
     */
    public function query($sql, $params = [])
    {
        return $this->connection->execute($sql, $params);
    }
}
?>
