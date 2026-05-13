<?php
/**
 * Database Connection Manager
 * 
 * Improved version with PDO instead of mysqli
 * Prevents SQL injection and provides better error handling
 * 
 * @version 2.0
 * @author Neitan
 */

class Connection
{
    private static $instance;
    private $pdo;
    private $host;
    private $user;
    private $password;
    private $database;
    private $port;

    /**
     * Private constructor to enforce singleton pattern
     * 
     * @param array $config
     */
    private function __construct($config = [])
    {
        $this->host = $config['host'] ?? 'localhost';
        $this->user = $config['user'] ?? 'root';
        $this->password = $config['password'] ?? '';
        $this->database = $config['database'] ?? 'jucum_pachuca';
        $this->port = $config['port'] ?? 3306;

        $this->connect();
    }

    /**
     * Get singleton instance
     * 
     * @param array $config
     * @return Connection
     */
    public static function getInstance($config = [])
    {
        if (self::$instance === null) {
            self::$instance = new self($config);
        }
        return self::$instance;
    }

    /**
     * Prevent cloning
     */
    private function __clone()
    {
    }

    /**
     * Establish PDO connection
     * 
     * @throws Exception
     */
    private function connect()
    {
        try {
            $dsn = "mysql:host={$this->host};port={$this->port};dbname={$this->database};charset=utf8mb4";
            $this->pdo = new PDO(
                $dsn,
                $this->user,
                $this->password,
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                ]
            );
        } catch (PDOException $e) {
            throw new Exception("Database connection failed: " . $e->getMessage());
        }
    }

    /**
     * Execute query with prepared statements (prevents SQL injection)
     * 
     * @param string $sql
     * @param array $params
     * @return PDOStatement
     */
    public function execute($sql, $params = [])
    {
        try {
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute($params);
            return $stmt;
        } catch (PDOException $e) {
            throw new Exception("Query execution failed: " . $e->getMessage());
        }
    }

    /**
     * Fetch single row
     * 
     * @param string $sql
     * @param array $params
     * @return array|null
     */
    public function fetchOne($sql, $params = [])
    {
        $stmt = $this->execute($sql, $params);
        return $stmt->fetch();
    }

    /**
     * Fetch all rows
     * 
     * @param string $sql
     * @param array $params
     * @return array
     */
    public function fetchAll($sql, $params = [])
    {
        $stmt = $this->execute($sql, $params);
        return $stmt->fetchAll();
    }

    /**
     * Insert record and return last insert ID
     * 
     * @param string $sql
     * @param array $params
     * @return int|string
     */
    public function insert($sql, $params = [])
    {
        $this->execute($sql, $params);
        return $this->pdo->lastInsertId();
    }

    /**
     * Update records
     * 
     * @param string $sql
     * @param array $params
     * @return int Number of affected rows
     */
    public function update($sql, $params = [])
    {
        $stmt = $this->execute($sql, $params);
        return $stmt->rowCount();
    }

    /**
     * Delete records
     * 
     * @param string $sql
     * @param array $params
     * @return int Number of affected rows
     */
    public function delete($sql, $params = [])
    {
        $stmt = $this->execute($sql, $params);
        return $stmt->rowCount();
    }

    /**
     * Begin transaction
     */
    public function beginTransaction()
    {
        $this->pdo->beginTransaction();
    }

    /**
     * Commit transaction
     */
    public function commit()
    {
        $this->pdo->commit();
    }

    /**
     * Rollback transaction
     */
    public function rollback()
    {
        $this->pdo->rollBack();
    }

    /**
     * Get PDO instance (for advanced usage)
     * 
     * @return PDO
     */
    public function getPDO()
    {
        return $this->pdo;
    }
}
?>
