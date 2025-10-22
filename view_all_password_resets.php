<?php require 'auth.php'; ?>
<?php
require 'db.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin', 'staff'])) {
  die("Access denied.");
}

// Build dynamic filter conditions
$conditions = ["action_type = 'password_reset'"];
$params = [];
$filtersApplied = false;

if (!empty($_GET['from'])) {
  $conditions[] = "timestamp >= :from";
  $params[':from'] = $_GET['from'] . " 00:00:00";
  $filtersApplied = true;
}
if (!empty($_GET['to'])) {
  $conditions[] = "timestamp <= :to";
  $params[':to'] = $_GET['to'] . " 23:59:59";
  $filtersApplied = true;
}
if (!empty($_GET['role'])) {
  $conditions[] = "role = :role";
  $params[':role'] = $_GET['role'];
  $filtersApplied = true;
}

$whereClause = "WHERE " . implode(" AND ", $conditions);
$limitClause = $filtersApplied ? "" : "LIMIT 100";

// Fetch password reset events
$stmt = $pdo->prepare("
  SELECT log_id, user_id, role, ip_address, timestamp, details
  FROM audit_log
  $whereClause
  ORDER BY timestamp DESC
  $limitClause
");
$stmt->execute($params);
$records = $stmt->fetchAll(PDO::FETCH_ASSOC);

// CSV export
if (isset($_GET['export']) && $_GET['export'] === 'csv') {
  header('Content-Type: text/csv');
  header('Content-Disposition: attachment; filename=password_resets.csv');
  header('Pragma: no-cache');
  header('Expires: 0');

  $output = fopen('php://output', 'w');
  fputcsv($output, ['Timestamp', 'User ID', 'Role', 'IP Address', 'Method']);
  foreach ($records as $r) {
    fputcsv($output, [
      $r['timestamp'],
      $r['user_id'] ?? '—',
      $r['role'] ?? '—',
      $r['ip_address'] ?? '—',
      $r['details'] ?? '—'
    ]);
  }
  fclose($output);
  exit;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Password Reset Events</title>
  <link rel="stylesheet" href="style.css">
  <style>
    .main-content { padding: 40px; max-width: 1200px; margin: auto; }
    .log-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    .log-table th, .log-table td {
      padding: 10px;
      border-bottom: 1px solid #ccc;
      vertical-align: top;
    }
    .log-table th {
      background-color: #6a1b9a;
      color: white;
    }
    .btn, .filter-btn {
      display: inline-block;
      padding: 8px 16px;
      background-color: #6a1b9a;
      color: white;
      text-decoration: none;
      border-radius: 4px;
      font-weight: bold;
      margin-right: 10px;
      margin-bottom: 20px;
    }
    .btn:hover, .filter-btn:hover {
      background-color: #4a148c;
    }
    .filter-form {
      margin-bottom: 20px;
    }
    .filter-form label {
      margin-right: 10px;
      font-weight: bold;
    }
    .filter-form input, .filter-form select {
      margin-right: 20px;
      padding: 6px;
    }
    .details-cell {
      max-width: 400px;
      white-space: pre-wrap;
      word-wrap: break-word;
    }
    .no-results {
      font-style: italic;
      color: #777;
    }
    .filter-note {
      font-style: italic;
      margin-bottom: 10px;
      color: #444;
    }
  </style>
</head>
<body>
<?php include 'header.php'; ?>
<div class="dashboard-wrapper">
  <?php include 'sidebar.php'; ?>
  <div class="main-content">
    <h2>Password Reset Events</h2>

    <form method="get" class="filter-form">
      <label for="from">From:</label>
      <input type="date" name="from" id="from" value="<?= htmlspecialchars($_GET['from'] ?? '') ?>">

      <label for="to">To:</label>
      <input type="date" name="to" id="to" value="<?= htmlspecialchars($_GET['to'] ?? '') ?>">

      <label for="role">User Role:</label>
      <select name="role" id="role">
        <option value="">All</option>
        <option value="superuser" <?= ($_GET['role'] ?? '') === 'superuser' ? 'selected' : '' ?>>Superuser</option>
        <option value="admin" <?= ($_GET['role'] ?? '') === 'admin' ? 'selected' : '' ?>>Admin</option>
        <option value="staff" <?= ($_GET['role'] ?? '') === 'staff' ? 'selected' : '' ?>>Staff</option>
      </select>

      <button type="submit" class="filter-btn">Apply Filters</button>
      <a href="view_all_password_resets.php?<?= http_build_query(array_merge($_GET, ['export' => 'csv'])) ?>" class="btn">Export CSV</a>
    </form>

    <p class="filter-note">
      <?= $filtersApplied ? 'Showing filtered password reset events.' : 'Showing the most recent 100 password reset events. Apply filters to refine.' ?>
    </p>

    <?php if (count($records) === 0): ?>
      <p class="no-results">No password reset events found.</p>
    <?php else: ?>
      <table class="log-table">
        <thead>
          <tr>
            <th>Timestamp</th>
            <th>User ID</th>
            <th>Role</th>
            <th>IP Address</th>
            <th>Method</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($records as $r): ?>
            <tr>
              <td><?= htmlspecialchars($r['timestamp']) ?></td>
              <td><?= htmlspecialchars($r['user_id'] ?? '—') ?></td>
              <td><?= htmlspecialchars($r['role'] ?? '—') ?></td>
              <td><?= htmlspecialchars($r['ip_address'] ?? '—') ?></td>
              <td class="details-cell"><?= htmlspecialchars($r['details'] ?? '—') ?></td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    <?php endif; ?>
  </div>
</div>
</body>
</html>