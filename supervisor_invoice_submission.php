<?php
require 'auth.php';
require 'db.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin', 'staff'])) {
  die("Access denied.");
}

$from = $_GET['from'] ?? '';
$to = $_GET['to'] ?? '';
$status = $_GET['status'] ?? '';
$supervisor = $_GET['supervisor'] ?? '';

$query = "
  SELECT i.id, i.invoice_name, i.start_date, i.end_date, i.file_path, i.status,
         u.username AS supervisor_name,
         GROUP_CONCAT(t.surname ORDER BY t.surname SEPARATOR ', ') AS trainees
  FROM supervisor_invoices i
  JOIN users u ON i.supervisor_id = u.user_id
  JOIN invoice_trainees it ON i.id = it.invoice_id
  JOIN trainees t ON it.trainee_id = t.trainee_id
  WHERE 1=1
";

$params = [];

if ($from && $to) {
  $query .= " AND i.start_date >= ? AND i.end_date <= ?";
  $params[] = $from;
  $params[] = $to;
}

if ($status) {
  $query .= " AND i.status = ?";
  $params[] = $status;
}

if ($supervisor) {
  $query .= " AND u.username = ?";
  $params[] = $supervisor;
}

$query .= " GROUP BY i.id ORDER BY i.submitted_at DESC";
$stmt = $pdo->prepare($query);
$stmt->execute($params);
$invoices = $stmt->fetchAll();

$supervisors = $pdo->query("SELECT DISTINCT username FROM users WHERE role = 'supervisor' ORDER BY username")->fetchAll();
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Supervisor Invoices</title>
  <link rel="stylesheet" href="style.css">
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background: #F5F5F5;
      padding: 40px;
    }
    h2 {
      color: #850069;
      font-family: 'Josefin Sans', sans-serif;
      margin-bottom: 20px;
    }
    form {
      margin-bottom: 30px;
    }
    label {
      font-weight: bold;
      margin-right: 10px;
    }
    input, select {
      padding: 6px;
      margin-right: 15px;
      border-radius: 4px;
      border: 1px solid #ccc;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
      background: #fff;
    }
    th, td {
      padding: 10px;
      border: 1px solid #ccc;
      vertical-align: top;
    }
    th {
      background-color: #850069;
      color: white;
    }
    tr:hover {
      background-color: #f0f0f0;
    }
    .btn {
      padding: 8px 16px;
      background-color: #850069;
      color: white;
      text-decoration: none;
      border-radius: 4px;
      font-weight: bold;
    }
    .btn:hover {
      background-color: #BB9DC6;
    }
  </style>
</head>
<body>
  <h2>Supervisor Invoice Review</h2>

  <form method="get">
    <label for="from">From:</label>
    <input type="date" name="from" id="from" value="<?= htmlspecialchars($from) ?>">

    <label for="to">To:</label>
    <input type="date" name="to" id="to" value="<?= htmlspecialchars($to) ?>">

    <label for="status">Status:</label>
    <select name="status" id="status">
      <option value="">All</option>
      <?php foreach (['Pending', 'Approved', 'Rejected'] as $s): ?>
        <option value="<?= $s ?>" <?= $status === $s ? 'selected' : '' ?>><?= $s ?></option>
      <?php endforeach; ?>
    </select>

    <label for="supervisor">Supervisor:</label>
    <select name="supervisor" id="supervisor">
      <option value="">All</option>
      <?php foreach ($supervisors as $sup): ?>
        <option value="<?= htmlspecialchars($sup['username']) ?>" <?= $supervisor === $sup['username'] ? 'selected' : '' ?>>
          <?= htmlspecialchars($sup['username']) ?>
        </option>
      <?php endforeach; ?>
    </select>

    <button type="submit" class="btn">Filter</button>
    <a href="export_invoices_csv.php" class="btn">Export CSV</a>
  </form>

  <table>
    <thead>
      <tr>
        <th>Invoice Name</th>
        <th>Supervisor</th>
        <th>Date Range</th>
        <th>Trainees</th>
        <th>Status</th>
        <th>File</th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($invoices as $inv): ?>
        <tr>
          <td><?= htmlspecialchars($inv['invoice_name']) ?></td>
          <td><?= htmlspecialchars($inv['supervisor_name']) ?></td>
          <td><?= htmlspecialchars($inv['start_date']) ?> to <?= htmlspecialchars($inv['end_date']) ?></td>
          <td><?= htmlspecialchars($inv['trainees']) ?></td>
          <td>
            <form method="post" action="update_invoice_status.php" style="margin:0;">
              <input type="hidden" name="invoice_id" value="<?= $inv['id'] ?>">
              <select name="status" onchange="this.form.submit()">
                <?php foreach (['Pending', 'Approved', 'Rejected'] as $s): ?>
                  <option value="<?= $s ?>" <?= $inv['status'] === $s ? 'selected' : '' ?>><?= $s ?></option>
                <?php endforeach; ?>
              </select>
            </form>
          </td>
          <td><a href="<?= htmlspecialchars($inv['file_path']) ?>" target="_blank" class="btn">Download</a></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</body>
</html>