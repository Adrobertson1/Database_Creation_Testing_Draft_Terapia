<?php require 'auth.php'; ?>
<?php
require 'db.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin', 'staff'])) {
  die("Access denied.");
}

$filterFields = [
  'trainees' => ['first_name', 'surname', 'email', 'disability_status', 'course_id', 'module_id'],
  'trainee_assignments' => ['status', 'assigned_date', 'due_date', 'type_id'],
  'assignment_submissions' => ['score_percent', 'submitted_at'],
  'tutor_feedback' => ['alert_flag', 'feedback_date'],
  'trainee_logs' => ['action_type', 'timestamp'],
  'trainees_history' => ['changed_at', 'previous_module_id', 'new_module_id'],
  'supervision_attendance' => ['session_type', 'attended'],
  'audit_log' => ['action_type', 'timestamp'],
  'login_activity' => ['ip_address', 'timestamp'],
  'role_audit_log' => ['role_changed', 'changed_by'],
  'users' => ['username', 'role', 'is_archived', 'is_active', 'account_locked']
];

$userOptions = [];
if (isset($_GET['user_type']) && $_GET['user_type'] === 'trainees') {
  $stmt = $pdo->query("SELECT trainee_id, first_name, surname FROM trainees ORDER BY surname");
  $userOptions = $stmt->fetchAll();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Generate Reports</title>
  <link rel="stylesheet" href="style.css">
  <style>
    .report-buttons {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-top: 30px;
      margin-bottom: 20px;
    }
    .btn {
      display: inline-block;
      padding: 8px 16px;
      background-color: #6a1b9a;
      color: white;
      text-decoration: none;
      border-radius: 4px;
      font-weight: bold;
    }
    .btn:hover {
      background-color: #4a148c;
    }
    #advanced-report-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    #advanced-report-table th, #advanced-report-table td {
      padding: 10px;
      border: 1px solid #ccc;
      text-align: left;
      vertical-align: top;
    }
    #advanced-report-table th {
      background-color: #6a1b9a;
      color: white;
    }
    #advanced-report-table tbody tr:hover {
      background-color: #f5f5f5;
    }
    .domain-section {
      margin-top: 20px;
    }
    .domain-section label {
      font-weight: bold;
      display: block;
      margin-bottom: 6px;
    }
  </style>
</head>
<body>
<?php include 'header.php'; ?>
<div class="dashboard-wrapper">
  <?php include 'sidebar.php'; ?>
  <div class="main-content">
    <h2>Generate Reports</h2>
        <div class="report-buttons">
      <a href="view_all_trainee_records.php" class="btn" target="_blank">All Trainee Records</a>
      <a href="view_all_tutor_records.php" class="btn" target="_blank">All Tutor Records</a>
      <a href="view_all_staff_records.php" class="btn" target="_blank">All Staff Records</a>
      <a href="view_all_supervisor_records.php" class="btn" target="_blank">All Supervisor Records</a>
      <a href="view_course_assignments.php" class="btn" target="_blank">Course Assignments</a>
      <a href="view_all_assignment_records.php" class="btn" target="_blank">Assignment Records</a>
      <a href="view_all_supervision_groups.php" class="btn" target="_blank">Supervision Groups</a>
      <a href="view_all_supervisor_allocations.php" class="btn" target="_blank">Supervisor Allocations</a>
      <a href="view_all_safeguarding_records.php" class="btn" target="_blank">Safeguarding Reports</a>
    </div>

    <div class="report-buttons">
      <a href="view_audit_log.php" class="btn" target="_blank">Audit Log</a>
      <a href="view_all_unlock_events.php" class="btn" target="_blank">Account Unlocks</a>
      <a href="view_all_password_resets.php" class="btn" target="_blank">Password Resets</a>
      <a href="view_dbs_pending.php" class="btn" target="_blank">DBS Pending</a>
      <a href="view_locked_accounts.php" class="btn" target="_blank">Locked Accounts</a>
      <a href="report_progression_logs.php" class="btn" target="_blank">Trainee Progression Logs</a>
    </div>

    <hr>
    <h3>📊 Advanced Report Generator</h3>
    <form method="get" id="advanced-report-form">
      <label for="user_type"><strong>User Type:</strong></label>
      <select name="user_type" id="user_type" required>
        <option value="">Select</option>
        <option value="trainees" <?= ($_GET['user_type'] ?? '') === 'trainees' ? 'selected' : '' ?>>Trainee</option>
        <option value="tutors" <?= ($_GET['user_type'] ?? '') === 'tutors' ? 'selected' : '' ?>>Tutor</option>
        <option value="staff" <?= ($_GET['user_type'] ?? '') === 'staff' ? 'selected' : '' ?>>Staff</option>
        <option value="supervisors" <?= ($_GET['user_type'] ?? '') === 'supervisors' ? 'selected' : '' ?>>Supervisor</option>
      </select>

      <div id="domain_panels" style="margin-top:20px;">
        <?php
        $domainGroups = [
          'trainees' => ['trainees', 'trainee_assignments', 'assignment_submissions', 'trainee_logs', 'trainees_history', 'supervision_attendance'],
          'tutors' => ['tutor_feedback', 'tutor_modules'],
          'staff' => ['audit_log', 'login_activity', 'role_audit_log'],
          'supervisors' => ['supervision_attendance', 'trainees_history']
        ];
        $selectedType = $_GET['user_type'] ?? '';
        if (isset($domainGroups[$selectedType])) {
          foreach ($domainGroups[$selectedType] as $domain) {
            echo "<label><input type='checkbox' name='domains[]' value='$domain'> $domain</label>";
          }
        }
        ?>
      </div>

      <div id="user_selector" style="margin-top:20px;">
        <?php if (($selectedType ?? '') === 'trainees'): ?>
          <label for="user_id"><strong>Select Trainee:</strong></label>
          <select name="user_id" id="user_id">
            <option value="">All</option>
            <?php foreach ($userOptions as $user): ?>
              <option value="<?= htmlspecialchars($user['trainee_id']) ?>">
                <?= htmlspecialchars($user['surname'] . ', ' . $user['first_name']) ?>
              </option>
            <?php endforeach; ?>
          </select>
        <?php endif; ?>
      </div>

      <div style="margin-top:20px;">
        <button type="submit" class="btn">Generate Report</button>
      </div>
    </form>
        <?php
    if (!empty($_GET['user_type']) && !empty($_GET['domains'])) {
      $selectedDomains = $_GET['domains'];
      $userType = $_GET['user_type'];

      echo "<h3>Report for <strong>" . htmlspecialchars($userType) . "</strong></h3>";

      foreach ($selectedDomains as $domain) {
        echo "<div class='domain-section'>";
        echo "<label>" . htmlspecialchars($domain) . "</label>";

        $query = "SELECT * FROM `$domain`";
        $conditions = [];

        if (isset($filterFields[$domain])) {
          foreach ($filterFields[$domain] as $field) {
            if (!empty($_GET[$field])) {
              $conditions[] = "`$field` = :$field";
            }
          }
        }

        if (!empty($_GET['user_id']) && $domain === 'trainees') {
          $conditions[] = "`trainee_id` = :user_id";
        }

        if (!empty($conditions)) {
          $query .= " WHERE " . implode(" AND ", $conditions);
        }

        try {
          $stmt = $pdo->prepare($query);

          foreach ($filterFields[$domain] ?? [] as $field) {
            if (!empty($_GET[$field])) {
              $stmt->bindValue(":$field", $_GET[$field]);
            }
          }

          if (!empty($_GET['user_id']) && $domain === 'trainees') {
            $stmt->bindValue(":user_id", $_GET['user_id']);
          }

          $stmt->execute();
          $rows = $stmt->fetchAll();

          if ($rows && count($rows)) {
            echo "<table id='advanced-report-table'><thead><tr>";
            foreach ($rows[0] as $col => $val) {
              if (stripos($col, 'password') === false) {
                echo "<th>" . htmlspecialchars($col) . "</th>";
              }
            }
            echo "</tr></thead><tbody>";

            foreach ($rows as $row) {
              echo "<tr>";
              foreach ($row as $col => $val) {
                if (stripos($col, 'password') === false) {
                  echo "<td>" . htmlspecialchars($val) . "</td>";
                }
              }
              echo "</tr>";
            }

            echo "</tbody></table>";
          } else {
            echo "<p>No records found.</p>";
          }
        } catch (PDOException $e) {
          echo "<p>Error fetching data from $domain: " . htmlspecialchars($e->getMessage()) . "</p>";
        }

        echo "</div>";
      }
    }
    ?>
  </div> <!-- end main-content -->
</div> <!-- end dashboard-wrapper -->
<?php include __DIR__ . '/footer.php'; ?>
</body>
</html>