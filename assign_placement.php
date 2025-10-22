<?php
require_once 'auth.php';
require_once 'db.php';
include 'header.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin', 'staff'])) {
  die("Access denied.");
}

$success = false;
$error = '';
$trainee_id = $_POST['trainee_id'] ?? '';
$placement_id = $_POST['placement_id'] ?? '';
$start_date = $_POST['start_date'] ?? '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  if ($trainee_id && $placement_id && $start_date) {
    $stmt = $pdo->prepare("
      INSERT INTO trainee_placements (trainee_id, placement_id, start_date)
      VALUES (?, ?, ?)
    ");
    $stmt->execute([$trainee_id, $placement_id, $start_date]);
    $success = true;
  } else {
    $error = 'All fields are required.';
  }
}

// Fetch trainees
$trainees = $pdo->query("
  SELECT trainee_id, CONCAT(first_name, ' ', surname) AS full_name
  FROM trainees
  WHERE is_archived = 0
  ORDER BY surname
")->fetchAll();

// Fetch placement settings
$placements = $pdo->query("
  SELECT id, name FROM placement_settings ORDER BY name
")->fetchAll();

// Fetch placement history
$history = $pdo->query("
  SELECT tp.start_date, ps.name AS placement_name,
         t.trainee_id, CONCAT(t.first_name, ' ', t.surname) AS trainee_name
  FROM trainee_placements tp
  JOIN placement_settings ps ON tp.placement_id = ps.id
  JOIN trainees t ON tp.trainee_id = t.trainee_id
  ORDER BY tp.start_date DESC
")->fetchAll();
?>

<div class="dashboard-wrapper">
  <?php include 'sidebar.php'; ?>
  <div class="main-content">
    <h2>Assign Placement</h2>

    <?php if ($success): ?>
      <div class="message-success">✅ Placement successfully assigned.</div>
    <?php elseif ($error): ?>
      <div class="error-list"><?= htmlspecialchars($error) ?></div>
    <?php endif; ?>

    <form method="post" class="report-filter-form">
      <div class="grid">
        <div>
          <label for="trainee_id">Trainee:</label>
          <select name="trainee_id" id="trainee_id" required>
            <option value="">-- Select Trainee --</option>
            <?php foreach ($trainees as $t): ?>
              <option value="<?= $t['trainee_id'] ?>" <?= $trainee_id == $t['trainee_id'] ? 'selected' : '' ?>>
                <?= htmlspecialchars($t['full_name']) ?>
              </option>
            <?php endforeach; ?>
          </select>
        </div>

        <div>
          <label for="placement_id">Placement Setting:</label>
          <select name="placement_id" id="placement_id" required>
            <option value="">-- Select Placement Setting --</option>
            <?php foreach ($placements as $p): ?>
              <option value="<?= $p['id'] ?>" <?= $placement_id == $p['id'] ? 'selected' : '' ?>>
                <?= htmlspecialchars($p['name']) ?>
              </option>
            <?php endforeach; ?>
          </select>
        </div>

        <div>
          <label for="start_date">Start Date:</label>
          <input type="date" id="start_date" name="start_date" value="<?= htmlspecialchars($start_date) ?>" required>
        </div>

        <div>
          <button type="submit">Assign Placement</button>
          <a href="placements_dashboard.php" class="btn-reset">Cancel</a>
        </div>
      </div>
    </form>

    <h3 style="margin-top: 40px;">Placement Allocation History</h3>
    <table class="trainee-table">
      <thead>
        <tr>
          <th>Trainee</th>
          <th>Placement</th>
          <th>Start Date</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($history as $entry): ?>
          <tr>
            <td>
              <a href="view_trainee.php?id=<?= $entry['trainee_id'] ?>">
                <?= htmlspecialchars($entry['trainee_name']) ?>
              </a>
            </td>
            <td><?= htmlspecialchars($entry['placement_name']) ?></td>
            <td><?= htmlspecialchars($entry['start_date']) ?></td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>