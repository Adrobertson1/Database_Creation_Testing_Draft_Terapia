<?php require 'auth.php'; ?>
<?php
require 'db.php';

if ($_SESSION['role'] === 'trainee') {
  die("Access denied.");
}

$success = '';
$error = '';
$previewTrainees = [];

$courseOptions = $pdo->query("SELECT course_id, course_name FROM courses ORDER BY course_name")->fetchAll(PDO::FETCH_ASSOC);
$moduleOptions = $pdo->query("SELECT module_id, module_name FROM modules ORDER BY module_name")->fetchAll(PDO::FETCH_ASSOC);
$intakeYears = $pdo->query("SELECT DISTINCT YEAR(start_date) AS intake_year FROM trainees WHERE start_date IS NOT NULL ORDER BY intake_year DESC")->fetchAll(PDO::FETCH_ASSOC);
$typeOptions = $pdo->query("SELECT type_id, type_name FROM assignment_types WHERE is_active = 1 ORDER BY type_name")->fetchAll(PDO::FETCH_ASSOC);

$assignableUsers = [];
if (in_array($_SESSION['role'], ['superuser', 'admin', 'staff'])) {
  $stmt = $pdo->prepare("
    SELECT user_id, username, email, role
    FROM users
    WHERE is_active = 1 AND role IN ('superuser', 'admin', 'staff')
    ORDER BY username
  ");
  $stmt->execute();
  $assignableUsers = $stmt->fetchAll(PDO::FETCH_ASSOC);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $stage = $_POST['stage'] ?? '';
  $course_id = $_POST['course_id'] ?? '';
  $module_id = $_POST['module_id'] ?? '';
  $intake_year = $_POST['intake_year'] ?? '';

  if ($course_id && $module_id && $intake_year) {
    $previewStmt = $pdo->prepare("
      SELECT t.trainee_id, t.first_name, t.surname
      FROM trainees t
      JOIN trainee_courses tc ON t.trainee_id = tc.trainee_id
      WHERE tc.course_id = ? AND t.module_id = ? AND YEAR(t.start_date) = ?
      ORDER BY t.surname, t.first_name
    ");
    $previewStmt->execute([$course_id, $module_id, $intake_year]);
    $previewTrainees = $previewStmt->fetchAll(PDO::FETCH_ASSOC);

    if ($stage === 'preview' && empty($previewTrainees)) {
      $error = "No trainees found in the selected course, module and year.";
    }
  }

  if ($stage === 'assign') {
    $type_id = $_POST['type_id'] ?? '';
    $assigned_date = $_POST['assigned_date'] ?? date('Y-m-d');
    $due_date = $_POST['due_date'] ?? '';
    $assigned_by = (!empty($_POST['assigned_by'])) ? $_POST['assigned_by'] : ($_SESSION['user_id'] ?? null);
    $description = trim($_POST['assignment_description'] ?? '');
    $instructions = trim($_POST['assignment_instructions'] ?? '');
    $notes = trim($_POST['assignment_notes'] ?? '');

    if ($type_id && $due_date && $assigned_by && $previewTrainees) {
      $assignment_id = null;
      $stmt = $pdo->prepare("
        SELECT assignment_id
        FROM assignments
        WHERE type_id = ?
        ORDER BY due_date DESC
        LIMIT 1
      ");
      $stmt->execute([$type_id]);
      $assignment_id = $stmt->fetchColumn();

      if (!$assignment_id) {
        $error = 'No assignment exists for the selected type. Please create one first.';
      } else {
        $assignStmt = $pdo->prepare("
          INSERT INTO trainee_assignments (
            trainee_id, assignment_id, type_id, assigned_date, due_date, status, assigned_by,
            assignment_notes, assignment_instructions, assignment_description
          ) VALUES (?, ?, ?, ?, ?, 'pending', ?, ?, ?, ?)
        ");
        foreach ($previewTrainees as $t) {
          $assignStmt->execute([
            $t['trainee_id'], $assignment_id, $type_id, $assigned_date, $due_date, $assigned_by,
            $notes, $instructions, $description
          ]);
        }
        $success = "Assignment successfully assigned to " . count($previewTrainees) . " trainees.";
        $previewTrainees = [];
      }
    } else {
      $error = "Missing assignment details or no matching trainees.";
    }
  }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Bulk Assignment</title>
  <link rel="stylesheet" href="style.css">
  <style>
    .main-content { padding: 40px; font-family: 'Inter', sans-serif; }
    .form-card {
      background: #fff;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      max-width: 800px;
      margin-bottom: 40px;
    }
    .form-card h2, .form-card h3 {
      color: #850069;
      font-family: 'Josefin Sans', sans-serif;
      margin-bottom: 20px;
    }
    .form-card label {
      display: block;
      margin-top: 15px;
      font-weight: bold;
    }
    .form-card select, .form-card input, .form-card textarea {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      border-radius: 6px;
      border: 1px solid #ccc;
      font-size: 16px;
    }
    .form-card button {
      margin-top: 20px;
      padding: 12px;
      background-color: #850069;
      color: white;
      border: none;
      border-radius: 6px;
      font-weight: bold;
      cursor: pointer;
      font-size: 18px;
    }
    .form-card button:hover { background-color: #BB9DC6; }
    .message { margin-bottom: 20px; font-weight: bold; text-align: center; }
    .message.success { color: #2e7d32; }
    .message.error { color: #d32f2f; }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      padding: 10px;
      border: 1px solid #ccc;
      text-align: left;
    }
    th {
      background-color: #f0e0f5;
    }
  </style>
</head>
<body>
<?php include 'header.php'; ?>
<div class="dashboard-wrapper">
  <?php include 'sidebar.php'; ?>
  <div class="main-content">
    <div class="form-card">
      <h2>Assign to Multiple Trainees</h2>
      <?php if ($success): ?><div class="message success"><?= htmlspecialchars($success) ?></div><?php endif; ?>
      <?php if ($error): ?><div class="message error"><?= htmlspecialchars($error) ?></div><?php endif; ?>

      <?php if (empty($previewTrainees)): ?>
        <form method="post">
          <input type="hidden" name="stage" value="preview">

          <label>Course:</label>
          <select name="course_id" required>
            <option value="">Select Course</option>
            <?php foreach ($courseOptions as $c): ?>
              <option value="<?= $c['course_id'] ?>"><?= htmlspecialchars($c['course_name']) ?></option>
            <?php endforeach; ?>
          </select>

          <label>Module:</label>
          <select name="module_id" required>
            <option value="">Select Module</option>
            <?php foreach ($moduleOptions as $m): ?>
              <option value="<?= $m['module_id'] ?>"><?= htmlspecialchars($m['module_name']) ?></option>
            <?php endforeach; ?>
          </select>

          <label>Intake Year:</label>
          <select name="intake_year" required>
            <option value="">Select Year</option>
            <?php foreach ($intakeYears as $y): ?>
              <option value="<?= $y['intake_year'] ?>"><?= $y['intake_year'] ?></option>
            <?php endforeach; ?>
          </select>

          <button type="submit">Preview Matching Trainees</button>
        </form>
      <?php else: ?>
        <h3>Matching Trainees</h3>
        <table>
          <thead><tr><th>Name</th><th>ID</th></tr></thead>
          <tbody>
            <?php foreach ($previewTrainees as $t): ?>
              <tr>
                <td><?= htmlspecialchars($t['surname'] . ', ' . $t['first_name']) ?></td>
                <td><?= htmlspecialchars($t['trainee_id']) ?></td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>

        <form method="post">
     <input type="hidden" name="stage" value="assign">
<input type="hidden" name="course_id" value="<?= htmlspecialchars($course_id) ?>">
<input type="hidden" name="module_id" value="<?= htmlspecialchars($module_id) ?>">
<input type="hidden" name="intake_year" value="<?= htmlspecialchars($intake_year) ?>">

<label>Assignment Type:</label>
<select name="type_id" required>
  <option value="">Select Type</option>
  <?php foreach ($typeOptions as $t): ?>
    <option value="<?= $t['type_id'] ?>"><?= htmlspecialchars($t['type_name']) ?></option>
  <?php endforeach; ?>
</select>

<label>Assigned Date:</label>
<input type="date" name="assigned_date" value="<?= date('Y-m-d') ?>" required>

<label>Due Date:</label>
<input type="date" name="due_date" required>

<label>Assignment Description:</label>
<textarea name="assignment_description" rows="4" placeholder="Brief overview of the assignment..."></textarea>

<label>Instructions:</label>
<textarea name="assignment_instructions" rows="4" placeholder="Step-by-step instructions or expectations..."></textarea>

<label>Additional Notes:</label>
<textarea name="assignment_notes" rows="3" placeholder="Any extra context or reminders..."></textarea>

<label>Assignee:</label>
<?php if (!empty($assignableUsers)): ?>
  <select name="assigned_by" required>
    <option value="">-- Choose --</option>
    <?php foreach ($assignableUsers as $user): ?>
      <option value="<?= $user['user_id'] ?>"
        <?= ($_SESSION['user_id'] ?? '') == $user['user_id'] ? 'selected' : '' ?>>
        <?= htmlspecialchars($user['username']) ?> (<?= htmlspecialchars($user['email']) ?>, <?= htmlspecialchars($user['role']) ?>)
      </option>
    <?php endforeach; ?>
  </select>
<?php else: ?>
  <input type="text" value="<?= htmlspecialchars($_SESSION['email'] ?? 'Current User') ?>" disabled>
  <input type="hidden" name="assigned_by" value="<?= $_SESSION['user_id'] ?? '' ?>">
<?php endif; ?>

<button type="submit">Confirm Assignment</button>
</form>
<?php endif; ?>
</div>
</div>
</div>
</body>
</html>