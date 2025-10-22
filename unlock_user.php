<?php
require 'auth.php';
require 'db.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin'])) {
    die("Access denied.");
}

$trainee_id = $_POST['trainee_id'] ?? '';
$staff_id = $_POST['staff_id'] ?? '';

// Validate input
if (!$trainee_id || !ctype_digit($trainee_id)) {
    $log = $pdo->prepare("
        INSERT INTO login_attempts (username, ip_address, user_agent, success, reason)
        VALUES (:username, :ip, :agent, 0, :reason)
    ");
    $log->execute([
        'username' => 'unlock_attempt',
        'ip' => $_SERVER['REMOTE_ADDR'],
        'agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',
        'reason' => 'Invalid or missing trainee_id during unlock'
    ]);
    die("Invalid unlock request.");
}

// Attempt unlock across all tables
$tables = [
    ['name' => 'users',       'id' => 'user_id'],
    ['name' => 'staff',       'id' => 'staff_id'],
    ['name' => 'trainees',    'id' => 'trainee_id'],
    ['name' => 'tutors',      'id' => 'tutor_id'],
    ['name' => 'supervisors', 'id' => 'supervisor_id']
];

$unlocked_table = null;

foreach ($tables as $table) {
    $stmt = $pdo->prepare("
        UPDATE {$table['name']}
        SET failed_attempts = 0, account_locked = 0
        WHERE {$table['id']} = :id
    ");
    $stmt->execute(['id' => $trainee_id]);

    if ($stmt->rowCount() > 0) {
        $unlocked_table = $table['name'];
        break;
    }
}

if (!$unlocked_table) {
    $log = $pdo->prepare("
        INSERT INTO login_attempts (username, ip_address, user_agent, success, reason)
        VALUES (:username, :ip, :agent, 0, :reason)
    ");
    $log->execute([
        'username' => 'unlock_attempt',
        'ip' => $_SERVER['REMOTE_ADDR'],
        'agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',
        'reason' => 'Unlock attempted but no matching user found'
    ]);
    die("Unlock failed: user not found.");
}

// Log successful unlock to audit_log
$audit = $pdo->prepare("
    INSERT INTO audit_log (
        user_id, role, action_type, table_name, record_id, staff_id,
        action_detail, ip_address, action
    ) VALUES (
        :user_id, :role, 'account_unlock', :table_name, :record_id, :staff_id,
        'Account unlocked by admin', :ip_address, 'update'
    )
");
$audit->execute([
    'user_id' => $_SESSION['user_id'],
    'role' => $_SESSION['role'],
    'table_name' => $unlocked_table,
    'record_id' => $trainee_id,
    'staff_id' => $staff_id,
    'ip_address' => $_SERVER['REMOTE_ADDR'],
    'action' => 'update'
]);

// Redirect with confirmation
header("Location: view_staff.php?id=" . urlencode($staff_id) . "&unlocked=1");
exit;
?>