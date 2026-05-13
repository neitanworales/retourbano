<?php
/**
 * Campamento Repository
 * 
 * Data access layer for Campamento model
 * 
 * @version 1.0
 * @author Neitan
 */

class CampamentoRepository extends Repository
{
    protected $table = 'campamentos';
    protected $primaryKey = 'id';

    /**
     * Get active campamentos
     * 
     * @return array
     */
    public function getActive()
    {
        return $this->findAllBy('estado', '=', 'activo');
    }

    /**
     * Get campamentos by year
     * 
     * @param int $year
     * @return array
     */
    public function getByYear($year)
    {
        return $this->findAllBy('año', '=', $year);
    }

    /**
     * Get current year campamentos
     * 
     * @return array
     */
    public function getCurrentYear()
    {
        $currentYear = date('Y');
        return $this->getByYear($currentYear);
    }

    /**
     * Get campamento with user count
     * 
     * @param int $id
     * @return array|null
     */
    public function getWithUserCount($id)
    {
        $campamento = $this->find($id);

        if (!$campamento) {
            return null;
        }

        // Get user count
        $sql = "SELECT COUNT(*) as total FROM campamento_guerreros WHERE id_campamento = ?";
        $result = $this->connection->fetchOne($sql, [$id]);
        $campamento['usuarios_inscritos'] = $result['total'] ?? 0;

        // Calculate available spots
        $campamento['disponibles'] = max(0, $campamento['capacidad'] - $campamento['usuarios_inscritos']);

        return $campamento;
    }

    /**
     * Get campamentos by location
     * 
     * @param string $location
     * @return array
     */
    public function getByLocation($location)
    {
        return $this->findAllBy('ubicacion', '=', $location);
    }

    /**
     * Search campamentos
     * 
     * @param string $searchTerm
     * @return array
     */
    public function search($searchTerm)
    {
        $searchTerm = "%{$searchTerm}%";
        $sql = "SELECT * FROM {$this->table} WHERE nombre LIKE ? OR descripcion LIKE ? OR ubicacion LIKE ?";
        return $this->connection->fetchAll($sql, [$searchTerm, $searchTerm, $searchTerm]);
    }

    /**
     * Get campamentos within date range
     * 
     * @param string $startDate
     * @param string $endDate
     * @return array
     */
    public function getBetweenDates($startDate, $endDate)
    {
        $sql = "SELECT * FROM {$this->table} WHERE fecha_inicio >= ? AND fecha_fin <= ? ORDER BY fecha_inicio ASC";
        return $this->connection->fetchAll($sql, [$startDate, $endDate]);
    }
}
?>
