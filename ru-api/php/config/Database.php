<?php
/**
 * Database Configuration
 * 
 * @version 1.0
 * @author Neitan
 */

class DatabaseConfig
{
    private static $config = [
        'development' => [
            'host' => 'localhost',
            'user' => 'root',
            'password' => '',
            'database' => 'jucum_pachuca',
            'port' => 3306
        ],
        'production' => [
            'host' => getenv('DB_HOST') ?: 'localhost',
            'user' => getenv('DB_USER') ?: 'root',
            'password' => getenv('DB_PASSWORD') ?: '',
            'database' => getenv('DB_NAME') ?: 'jucum_pachuca',
            'port' => getenv('DB_PORT') ?: 3306
        ]
    ];

    /**
     * Get database configuration for specific environment
     * 
     * @param string $environment
     * @return array
     */
    public static function getConfig($environment = 'development')
    {
        return self::$config[$environment] ?? self::$config['development'];
    }

    /**
     * Get specific config value
     * 
     * @param string $key
     * @param string $environment
     * @return mixed
     */
    public static function get($key, $environment = 'development')
    {
        $config = self::getConfig($environment);
        return $config[$key] ?? null;
    }
}
?>
