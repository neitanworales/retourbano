<?php
/**
 * Simple Router for API
 * 
 * Handles routing based on HTTP method and URL pattern
 * 
 * @version 1.0
 * @author Neitan
 */

class Router
{
    private $routes = [
        'GET' => [],
        'POST' => [],
        'PUT' => [],
        'DELETE' => [],
        'PATCH' => []
    ];

    private $currentMethod;
    private $currentPath;
    private $middlewares = [];

    /**
     * Register GET route
     * 
     * @param string $path
     * @param callable|string $handler
     * @return self
     */
    public function get($path, $handler)
    {
        return $this->registerRoute('GET', $path, $handler);
    }

    /**
     * Register POST route
     * 
     * @param string $path
     * @param callable|string $handler
     * @return self
     */
    public function post($path, $handler)
    {
        return $this->registerRoute('POST', $path, $handler);
    }

    /**
     * Register PUT route
     * 
     * @param string $path
     * @param callable|string $handler
     * @return self
     */
    public function put($path, $handler)
    {
        return $this->registerRoute('PUT', $path, $handler);
    }

    /**
     * Register DELETE route
     * 
     * @param string $path
     * @param callable|string $handler
     * @return self
     */
    public function delete($path, $handler)
    {
        return $this->registerRoute('DELETE', $path, $handler);
    }

    /**
     * Register PATCH route
     * 
     * @param string $path
     * @param callable|string $handler
     * @return self
     */
    public function patch($path, $handler)
    {
        return $this->registerRoute('PATCH', $path, $handler);
    }

    /**
     * Register route
     * 
     * @param string $method
     * @param string $path
     * @param callable|string $handler
     * @return self
     */
    private function registerRoute($method, $path, $handler)
    {
        $this->routes[$method][$path] = [
            'handler' => $handler,
            'middlewares' => $this->middlewares
        ];
        $this->middlewares = [];
        return $this;
    }

    /**
     * Add middleware to route
     * 
     * @param string|array $middlewares
     * @return self
     */
    public function middleware($middlewares)
    {
        if (is_string($middlewares)) {
            $this->middlewares[] = $middlewares;
        } elseif (is_array($middlewares)) {
            $this->middlewares = array_merge($this->middlewares, $middlewares);
        }
        return $this;
    }

    /**
     * Dispatch the request
     * 
     * @return void
     */
    public function dispatch()
    {
        $this->currentMethod = $_SERVER['REQUEST_METHOD'];
        $this->currentPath = $this->getCurrentPath();

        // Try to find matching route
        $route = $this->findRoute($this->currentMethod, $this->currentPath);

        if ($route) {
            $this->executeRoute($route);
        } else {
            $this->notFound();
        }
    }

    /**
     * Get current request path
     * 
     * @return string
     */
    private function getCurrentPath()
    {
        $path = $_SERVER['REQUEST_URI'];

        // Remove query string
        if (strpos($path, '?') !== false) {
            $path = substr($path, 0, strpos($path, '?'));
        }

        // Remove base path if needed
        $basePath = '/retourbano/ru-api/public';
        if (strpos($path, $basePath) === 0) {
            $path = substr($path, strlen($basePath));
        }

        return $path ?: '/';
    }

    /**
     * Find matching route
     * 
     * @param string $method
     * @param string $path
     * @return array|null
     */
    private function findRoute($method, $path)
    {
        if (!isset($this->routes[$method])) {
            return null;
        }

        // Exact match
        if (isset($this->routes[$method][$path])) {
            return $this->routes[$method][$path];
        }

        // Pattern match with parameters
        foreach ($this->routes[$method] as $pattern => $route) {
            if ($this->matchPattern($pattern, $path, $params)) {
                $_GET = array_merge($_GET, $params);
                return $route;
            }
        }

        return null;
    }

    /**
     * Match route pattern with parameters
     * 
     * @param string $pattern
     * @param string $path
     * @param array $params
     * @return bool
     */
    private function matchPattern($pattern, $path, &$params = [])
    {
        // Convert pattern to regex
        // /users/{id} -> /users/(?P<id>[0-9]+)
        $regex = preg_replace_callback('/{(\w+)}/', function ($matches) {
            return '(?P<' . $matches[1] . '>[^/]+)';
        }, $pattern);

        if (preg_match('#^' . $regex . '$#', $path, $matches)) {
            // Extract named groups
            foreach ($matches as $key => $value) {
                if (!is_numeric($key)) {
                    $params[$key] = $value;
                }
            }
            return true;
        }

        return false;
    }

    /**
     * Execute route handler
     * 
     * @param array $route
     * @return void
     */
    private function executeRoute($route)
    {
        try {
            // Run middlewares
            if (!empty($route['middlewares'])) {
                foreach ($route['middlewares'] as $middleware) {
                    $instance = new $middleware();
                    $instance->handle();
                }
            }

            // Call handler
            $handler = $route['handler'];

            if (is_string($handler)) {
                // Class@method format
                [$class, $method] = explode('@', $handler);
                $instance = new $class();
                $instance->$method();
            } elseif (is_callable($handler)) {
                call_user_func($handler);
            }
        } catch (AppException $e) {
            http_response_code($e->getHttpCode());
            echo json_encode($e->toArray());
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'code' => 500,
                'error' => 'INTERNAL_ERROR',
                'message' => APP_DEBUG ? $e->getMessage() : 'Internal server error'
            ]);
        }
    }

    /**
     * Handle 404 Not Found
     * 
     * @return void
     */
    private function notFound()
    {
        http_response_code(404);
        echo json_encode([
            'success' => false,
            'code' => 404,
            'error' => 'NOT_FOUND',
            'message' => 'Endpoint not found'
        ]);
    }
}
?>
