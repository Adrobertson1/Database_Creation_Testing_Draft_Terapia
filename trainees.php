<?php require 'auth.php'; ?>
<?php
require 'db.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin', 'staff'])) {
  die("Access denied.");
}

$view = $_GET['view'] ?? 'active';
$where = "WHERE is_archived = " . ($view === 'archived' ? "1" : "0");
$params = [];

// Fetch course options
$courseOptions = $pdo->query("SELECT course_id, course_name FROM courses ORDER BY course_name")->fetchAll();

// Apply filters
if (!empty($_GET['name'])) {
  $where .= " AND (first_name LIKE ? OR surname LIKE ?)";
  $params[] = '%' . $_GET['name'] . '%';
  $params[] = '%' . $_GET['name'] . '%';
}
if (!empty($_GET['email'])) {
  $where .= " AND email LIKE ?";
  $params[] = '%' . $_GET['email'] . '%';
}
if (!empty($_GET['telephone'])) {
  $where .= " AND telephone LIKE ?";
  $params[] = '%' . $_GET['telephone'] . '%';
}
if (!empty($_GET['course'])) {
  $where .= " AND trainee_id IN (
    SELECT trainee_id FROM trainee_courses tc
    JOIN courses c ON tc.course_id = c.course_id
    WHERE c.course_name LIKE ?
  )";
  $params[] = '%' . $_GET['course'] . '%';
}

// Fetch trainees
$stmt = $pdo->prepare("SELECT * FROM trainees $where ORDER BY surname");
$stmt->execute($params);
$traineeList = $stmt->fetchAll();

// CSV Export
if (isset($_GET['export']) && $_GET['export'] === 'csv') {
  header('Content-Type: text/csv');
  header('Content-Disposition: attachment; filename=trainee_export.csv');
  header('Pragma: no-cache');
  header('Expires: 0');

  $output = fopen('php://output', 'w');
  fputcsv($output, [
    'trainee_id', 'first_name', 'surname', 'individual_supervisor', 'email', 'is_archived',
    'date_of_birth', 'disability_status', 'disability_type', 'town_city', 'postcode',
    'profile_image', 'trainee_code', 'address_line1', 'telephone', 'course_id',
    'supervisor_id', 'start_date', 'dbs_expiry_date', 'user_id', 'module_id',
    'module_type', 'dbs_status', 'dbs_issue_date', 'dbs_reference_number', 'dbs_update_service'
  ]);

  foreach ($traineeList as $t) {
    fputcsv($output, [
      $t['trainee_id'], $t['first_name'], $t['surname'], $t['individual_supervisor'], $t['email'],
      $t['is_archived'], $t['date_of_birth'], $t['disability_status'], $t['disability_type'],
      $t['town_city'], $t['postcode'], $t['profile_image'], $t['trainee_code'], $t['address_line1'],
      $t['telephone'], $t['course_id'], $t['supervisor_id'], $t['start_date'], $t['dbs_expiry_date'],
      $t['user_id'], $t['module_id'], $t['module_type'], $t['dbs_status'], $t['dbs_issue_date'],
      $t['dbs_reference_number'], $t['dbs_update_service']
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
  <title>Manage Trainees</title>
  <link rel="stylesheet" href="style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    .main-content { padding: 40px; }
    .top-actions {
      display: flex;
      flex-direction: column;
      gap: 20px;
      margin-bottom: 30px;
    }
    .tab-buttons {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }
    .tab-buttons a {
      padding: 8px 16px;
      border-radius: 4px;
      font-weight: bold;
      text-decoration: none;
      border: 1px solid #ccc;
      background-color: #f0f0f0;
      color: #333;
    }
    .tab-buttons .btn-active {
      background-color: #6a1b9a;
      color: white;
      border-color: #6a1b9a;
    }
    .tab-buttons .btn-archived {
      background-color: #9e9e9e;
      color: white;
      border-color: #9e9e9e;
    }
    .action-buttons {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }
    .btn-sm {
      padding: 8px 14px;
      font-size: 14px;
      border-radius: 4px;
      text-decoration: none;
      font-weight: bold;
      display: inline-block;
      border: 1px solid #ccc;
      background-color: #f9f9f9;
      color: #333;
    }
    .btn-sm i {
      margin-right: 6px;
    }
    .btn-active {
      background-color: #6a1b9a;
      color: white;
      border-color: #6a1b9a;
    }
    .btn-default {
      background-color: #f0f0f0;
      color: #333;
    }
    .btn-edit {
      background-color: #1976d2;
      color: white;
      border-color: #1976d2;
    }
    .btn-archive {
      background-color: #f57c00;
      color: white;
      border-color: #f57c00;
    }
    .btn-restore {
      background-color: #388e3c;
      color: white;
      border-color: #388e3c;
    }
    .search-form {
      margin-bottom: 30px;
    }
    .search-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 12px;
    }
    .search-grid input,
    .search-grid select {
      padding: 10px;
      border-radius: 4px;
      border: 1px solid #ccc;
      font-size: 14px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
      table-layout: fixed;
    }
    th, td {
      padding: 12px;
      border-bottom: 1px solid #ccc;
      text-align: left;
      vertical-align: middle;
      word-wrap: break-word;
    }
    th {
      background-color: #6a1b9a;
      color: white;
    }
    .thumbnail {
      width: 50px;
      height: 50px;
      object-fit: cover;
      border-radius: 4px;
      border: 1px solid #ccc;
    }
    .message-success {
      background-color: #e0f7e9;
      color: #2e7d32;
      padding: 10px;
      margin-bottom: 20px;
      border-left: 5px solid #2e7d32;
    }
    .message-warning {
      background-color: #fff3cd;
      color: #856404;
      padding: 10px;
      margin-bottom: 20px;
      border-left: 5px solid #856404;
    }
  </style>
</head>
<body>
<?php include 'header.php'; ?>
<div class="dashboard-wrapper">
  <?php include 'sidebar.php'; ?>
  <div class="main-content">
    <h2>Registered Trainees</h2>

    <?php if ($_GET['restored'] ?? '' === '1'): ?>
      <div class="message-success">✅ Trainee successfully restored.</div>
    <?php endif; ?>
    <?php if ($_GET['archived'] ?? '' === '1'): ?>
      <div class="message-warning">🗂️ Trainee successfully archived.</div>
    <?php endif; ?>

    <div class="top-actions">
      <div class="tab-buttons">
        <a href="?view=active" class="<?= $view === 'active' ? 'btn-active' : 'btn-default' ?>">Active Trainees</a>
        <a href="?view=archived" class="<?= $view === 'archived' ? 'btn-archived' : 'btn-default' ?>">Archived Trainees</a>
      </div>
      <div class="action-buttons">
        <a href="add_trainee.php" class="btn-sm btn-active"><i class="fas fa-user-plus"></i> Add New Trainee</a>
        <a href="bulk_upload_trainees.php" class="btn-sm btn-default"><i class="fas fa-file-upload"></i> Bulk Upload Trainees</a>
        <a href="Uploads/trainee_template.csv" class="btn-sm btn-default" download><i class="fas fa-download"></i> Download CSV Template</a>
        <a href="trainees.php?export=csv&view=<?= htmlspecialchars($view) ?>" class="btn-sm btn-default"><i class="fas fa-download"></i> Export All Trainees (CSV)</a>
      </div>
    </div>
        <table>
      <thead>
        <tr>
          <th>Photo</th>
          <th>Name</th>
          <th>Email</th>
          <th>Telephone</th>
          <th>Start Date</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($traineeList as $t): ?>
          <tr>
            <td>
              <?php
              $imagePath = $t['profile_image'];
              if (!empty($imagePath) && file_exists($imagePath)) {
                echo '<img src="' . htmlspecialchars($imagePath) . '" alt="Photo" class="thumbnail">';
              } else {
                echo '<span style="color:#999;">No image</span>';
              }
              ?>
            </td>
            <td>
              <a href="view_trainee.php?id=<?= $t['trainee_id'] ?>">
                <?= htmlspecialchars($t['first_name'] . ' ' . $t['surname']) ?>
              </a>
            </td>
            <td><?= htmlspecialchars($t['email'] ?? '—') ?></td>
            <td><?= htmlspecialchars($t['telephone'] ?? '—') ?></td>
            <td><?= htmlspecialchars($t['start_date'] ?? '—') ?></td>
            <td>
              <?php if ($view === 'active'): ?>
                <a href="edit_trainee.php?trainee_id=<?= $t['trainee_id'] ?>" class="btn-sm btn-edit">
                  <i class="fas fa-edit"></i> Edit
                </a>
                <form method="post" action="archived_trainee.php" style="display:inline;" onsubmit="return confirm('Archive this trainee?');">
                  <input type="hidden" name="trainee_id" value="<?= $t['trainee_id'] ?>">
                  <button type="submit" class="btn-sm btn-archive">
                    <i class="fas fa-box-archive"></i> Archive
                  </button>
                </form>
              <?php else: ?>
                <form method="post" action="restore_trainee.php" style="display:inline;" onsubmit="return confirm('Restore this trainee?');">
                  <input type="hidden" name="trainee_id" value="<?= $t['trainee_id'] ?>">
                  <button type="submit" class="btn-sm btn-restore">
                    <i class="fas fa-rotate-left"></i> Restore
                  </button>
                </form>
              <?php endif; ?>
            </td>
          </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>