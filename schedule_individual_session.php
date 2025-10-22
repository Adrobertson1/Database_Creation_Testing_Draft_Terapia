<?php require 'auth.php'; ?>
<?php
require 'db.php';

$role = strtolower($_SESSION['role'] ?? '');
$user_id = $_SESSION['user_id'] ?? null;

if (!in_array($role, ['superuser', 'admin', 'staff', 'supervisor'])) {
    die("Access denied.");
}

$preselected_id = $_GET['trainee_id'] ?? '';

// Dynamically fetch group_id for 'Individual Supervision'
$groupStmt = $pdo->prepare("
  SELECT group_id FROM supervision_groups
  WHERE module_number = 'IND' LIMIT 1
");
$groupStmt->execute();
$individual_group_id = $groupStmt->fetchColumn();

if (!$individual_group_id) {
    die("Error: 'Individual Supervision' group not found. Please create it in supervision_groups.");
}

// Fetch trainees assigned to this supervisor or visible to admin/staff
$traineeStmt = $pdo->prepare("
  SELECT DISTINCT t.trainee_id, t.first_name, t.surname
  FROM trainees t
  JOIN supervision_group_trainees sgt ON t.trainee_id = sgt.trainee_id
  JOIN supervision_groups sg ON sgt.group_id = sg.group_id
  WHERE t.is_archived = 0 AND (
    :role IN ('superuser', 'admin', 'staff') OR sg.supervisor_id = :user_id
  )
  ORDER BY t.surname
");
$traineeStmt->execute([
  'role' => $role,
  'user_id' => $user_id
]);
$trainees = $traineeStmt->fetchAll();

$success = false;
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['schedule_session'])) {
    $session_date = $_POST['session_date'] ?? '';
    $session_time = $_POST['session_time'] ?? '';
    $trainee_id = $_POST['trainee_id'] ?? '';
    $notes = $_POST['notes'] ?? '';
    $notify = isset($_POST['notify_trainee']) ? true : false;

    if ($session_date && $session_time && $trainee_id) {
        // Insert session
        $stmt = $pdo->prepare("
          INSERT INTO supervision_sessions (group_id, session_date, session_time, session_type, notes, supervisor_id)
          VALUES (?, ?, ?, 'individual', ?, ?)
        ");
        $stmt->execute([$individual_group_id, $session_date, $session_time, $notes, $user_id]);
        $session_id = $pdo->lastInsertId();

        // Link trainee to session
        $linkStmt = $pdo->prepare("
          INSERT INTO supervision_session_trainees (session_id, trainee_id)
          VALUES (?, ?)
        ");
        $linkStmt->execute([$session_id, $trainee_id]);

        // Insert attendance record
        $attendanceStmt = $pdo->prepare("
          INSERT INTO supervision_attendance (session_id, trainee_id, attended, updated_by, updated_at)
          VALUES (?, ?, 0, ?, NOW())
        ");
        $attendanceStmt->execute([$session_id, $trainee_id, $user_id]);

        // Notify trainee via calendar
        if ($notify) {
            $calendarStmt = $pdo->prepare("
              INSERT INTO user_calendar_events (user_id, title, event_date, notes)
              SELECT user_id, ?, ?, ? FROM trainees WHERE trainee_id = ?
            ");
            $calendarStmt->execute([
                "Individual Supervision Session",
                "$session_date $session_time",
                $notes,
                $trainee_id
            ]);
        }

        $success = true;
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Schedule Individual Session</title>
  <link rel="stylesheet" href="style.css">
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background: #E6D6EC;
      color: #000;
    }
    .dashboard-wrapper {
      display: flex;
      flex-direction: row;
    }
    .main-content {
      flex: 1;
      padding: 40px;
    }
    .form-card {
      max-width: 600px;
      background: #fff;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    h2 {
      color: #850069;
      font-family: 'Josefin Sans', sans-serif;
    }
    label {
      display: block;
      margin-top: 16px;
      font-weight: bold;
    }
    input, textarea, select {
      width: 100%;
      padding: 8px;
      margin-top: 6px;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-family: 'Inter', sans-serif;
    }
    button {
      margin-top: 20px;
      padding: 10px 16px;
      background-color: #6a1b9a;
      color: white;
      border: none;
      border-radius: 6px;
      font-weight: bold;
      cursor: pointer;
    }
    button:hover {
      background-color: #BB9DC6;
    }
    .success-box {
      background-color: #dff0d8;
      border-left: 6px solid #3c763d;
      padding: 16px;
      margin-bottom: 20px;
      border-radius: 6px;
    }
    .alert-message {
      color: #d32f2f;
      font-weight: bold;
      margin: 20px 0;
    }
  </style>
</head>
<body>
<?php include 'header.php'; ?>
<div class="dashboard-wrapper">
  <?php include 'sidebar.php'; ?>
  <div class="main-content">
    <div class="form-card">
      <h2>Schedule Individual Supervision Session</h2>

      <?php if ($success): ?>
        <div class="success-box">
          ✅ Individual session scheduled successfully.
        </div>
      <?php endif; ?>

      <div class="alert-message">
        Please ensure the trainee is aware of the session time and location.
      </div>

      <form method="post">
        <label for="trainee_id">Select Trainee</label>
        <select name="trainee_id" required>
          <option value="">-- Choose Trainee --</option>
          <?php foreach ($trainees as $t): ?>
            <option value="<?= $t['trainee_id'] ?>" <?= $t['trainee_id'] === $preselected_id ? 'selected' : '' ?>>
              <?= htmlspecialchars($t['surname'] . ', ' . $t['first_name']) ?>
            </option>
          <?php endforeach; ?>
        </select>

        <label for="session_date">Date</label>
        <input type="date" name="session_date" required>

        <label for="session_time">Time</label>
        <input type="time" name="session_time" required>

        <label for="notes">Optional Notes (used only for calendar)</label>
        <textarea name="notes" rows="4"></textarea>

        <label>
          <input type="checkbox" name="notify_trainee" value="1" checked>
          Notify trainee via calendar
        </label>

        <button type="submit" name="schedule_session">Schedule Session</button>
      </form>
    </div>
  </div>
</div>
</body>
</html>