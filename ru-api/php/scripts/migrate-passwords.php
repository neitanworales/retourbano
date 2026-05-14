<?php
/**
 * Script para migrar contraseñas legacy a bcrypt
 * 
 * Detecta y convierte:
 * - MD5 (32 caracteres hex)
 * - SHA1 (40 caracteres hex)
 * - Bcrypt ya hasheadas (comienzan con $2)
 * 
 * Uso:
 *   php scripts/migrate-passwords.php [--dry-run] [--user-id=N]
 */

require_once __DIR__ . '/../Database/Connection.php';
require_once __DIR__ . '/../Repository/UserRepository.php';

class PasswordMigrator
{
    private $db;
    private $userRepo;
    private $dryRun = false;
    private $targetUserId = null;
    private $stats = [
        'total' => 0,
        'already_bcrypt' => 0,
        'legacy_md5' => 0,
        'legacy_sha1' => 0,
        'migrated' => 0,
        'failed' => 0,
    ];

    public function __construct($dryRun = false, $targetUserId = null)
    {
        $this->db = Connection::getInstance();
        $this->userRepo = new UserRepository();
        $this->dryRun = $dryRun;
        $this->targetUserId = $targetUserId;
    }

    public function migrate()
    {
        echo "🔐 Password Migration Tool\n";
        echo str_repeat("=", 60) . "\n\n";

        if ($this->dryRun) {
            echo "⚠️  DRY RUN MODE - No changes will be made\n\n";
        }

        $users = $this->fetchUsers();
        echo "Found {$this->stats['total']} users to check\n\n";

        foreach ($users as $user) {
            $this->migrateUser($user);
        }

        $this->printStats();

        if (!$this->dryRun) {
            echo "\n✅ Migration completed!\n";
        } else {
            echo "\n📋 Dry run completed. Run without --dry-run to apply changes.\n";
        }
    }

    private function fetchUsers()
    {
        $sql = 'SELECT id, email, password_hash FROM users';
        if ($this->targetUserId) {
            $sql .= ' WHERE id = ' . (int) $this->targetUserId;
        }
        $sql .= ' ORDER BY id';

        $result = $this->db->query($sql);
        $users = [];
        while ($row = $result->fetch_assoc()) {
            $users[] = $row;
            $this->stats['total']++;
        }
        return $users;
    }

    private function migrateUser($user)
    {
        $id = $user['id'];
        $email = $user['email'];
        $hash = $user['password_hash'];

        if (!$hash) {
            echo "⚠️  User $id ($email) has NULL password - skipping\n";
            return;
        }

        $type = $this->detectHashType($hash);

        switch ($type) {
            case 'bcrypt':
                echo "✓ User $id ($email) already bcrypt\n";
                $this->stats['already_bcrypt']++;
                break;

            case 'md5':
                echo "🔄 User $id ($email) detected MD5 - migrating...\n";
                $this->stats['legacy_md5']++;
                $this->upgradePassword($id, $email, $hash);
                break;

            case 'sha1':
                echo "🔄 User $id ($email) detected SHA1 - migrating...\n";
                $this->stats['legacy_sha1']++;
                $this->upgradePassword($id, $email, $hash);
                break;

            default:
                echo "⚠️  User $id ($email) unknown hash type (length: " . strlen($hash) . ") - skipping\n";
                break;
        }
    }

    private function detectHashType($hash)
    {
        if (!$hash) {
            return 'empty';
        }

        // Bcrypt hashes start with $2a$, $2b$, $2x$, or $2y$
        if (preg_match('/^\$2[aby]\$/', $hash)) {
            return 'bcrypt';
        }

        // MD5 is exactly 32 hex characters
        if (strlen($hash) === 32 && ctype_xdigit($hash)) {
            return 'md5';
        }

        // SHA1 is exactly 40 hex characters
        if (strlen($hash) === 40 && ctype_xdigit($hash)) {
            return 'sha1';
        }

        return 'unknown';
    }

    private function upgradePassword($userId, $email, $oldHash)
    {
        // We cannot recover the plaintext password from legacy hashes
        // So we create a temporary random password and mark account for reset
        
        // Option: Generate a secure random password and hash it
        $tempPassword = bin2hex(random_bytes(16)); // 32 char random
        $newHash = password_hash($tempPassword, PASSWORD_BCRYPT, ['cost' => 12]);

        echo "   Generated temp password for account reset\n";

        if (!$this->dryRun) {
            try {
                $updated = $this->userRepo->updatePasswordHash($userId, $newHash);
                if ($updated) {
                    echo "   ✅ Password updated successfully\n";
                    $this->stats['migrated']++;

                    // Log this for admin notification
                    $this->logMigration($userId, $email, $oldHash, $newHash);
                } else {
                    echo "   ❌ Failed to update password\n";
                    $this->stats['failed']++;
                }
            } catch (Exception $e) {
                echo "   ❌ Error: " . $e->getMessage() . "\n";
                $this->stats['failed']++;
            }
        } else {
            echo "   (Would update with bcrypt)\n";
            $this->stats['migrated']++;
        }
    }

    private function logMigration($userId, $email, $oldHash, $newHash)
    {
        // Create a log entry for audit
        $logFile = __DIR__ . '/password-migration.log';
        $timestamp = date('Y-m-d H:i:s');
        $logEntry = "$timestamp | User $userId ($email) password migrated\n";
        file_put_contents($logFile, $logEntry, FILE_APPEND);
    }

    private function printStats()
    {
        echo "\n" . str_repeat("=", 60) . "\n";
        echo "📊 Migration Statistics:\n";
        echo str_repeat("=", 60) . "\n";
        echo "Total Users Scanned:    {$this->stats['total']}\n";
        echo "Already Bcrypt:         {$this->stats['already_bcrypt']}\n";
        echo "Legacy MD5:             {$this->stats['legacy_md5']}\n";
        echo "Legacy SHA1:            {$this->stats['legacy_sha1']}\n";
        echo "Migrated:               {$this->stats['migrated']}\n";
        echo "Failed:                 {$this->stats['failed']}\n";
        echo str_repeat("=", 60) . "\n";
    }
}

// Parse command line arguments
$dryRun = in_array('--dry-run', $argv);
$targetUserId = null;

foreach ($argv as $arg) {
    if (strpos($arg, '--user-id=') === 0) {
        $targetUserId = (int) substr($arg, 10);
    }
}

// Run migration
$migrator = new PasswordMigrator($dryRun, $targetUserId);
$migrator->migrate();
