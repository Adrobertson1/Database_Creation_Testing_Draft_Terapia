<?php require 'auth.php'; ?>
<?php
require 'db.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin', 'staff', 'supervisor'])) {
    die("Access denied.");
}

$showArchived = isset($_GET['archived']) && $_GET['archived'] === '1';

$traineeStmt = $pdo->prepare("
  SELECT t.trainee_id, t.first_name, t.surname, t.is_archived,
         ind_sup.first_name AS ind_first, ind_sup.surname AS ind_surname,
         sg.module_number, sg.module_title,
         grp_sup.first_name AS grp_first, grp_sup.surname AS grp_surname,
         c.course_name,
         m.module_name AS current_module
  FROM trainees t
  LEFT JOIN supervisors ind_sup ON t.supervisor_id = ind_sup.supervisor_id
  LEFT JOIN supervision_group_trainees sgt ON t.trainee_id = sgt.trainee_id
  LEFT JOIN supervision_groups sg ON sgt.group_id = sg.group_id
  LEFT JOIN supervisors grp_sup ON sg.supervisor_id = grp_sup.supervisor_id
  LEFT JOIN trainee_courses tc ON t.trainee_id = tc.trainee_id
  LEFT JOIN courses c ON tc.course_id = c.course_id
  LEFT JOIN modules m ON t.module_id = m.module_id
  WHERE t.is_archived = :archived
  ORDER BY t.surname, t.first_name
");
$traineeStmt->execute(['archived' => $showArchived ? 1 : 0]);
$trainees = $traineeStmt->fetchAll();

$attendanceMap = [];

$attendanceStmt = $pdo->prepare("
  SELECT s.session_type,
         COUNT(*) AS total,
         SUM(CASE WHEN a.attended = 1 THEN 1 ELSE 0 END) AS attended
  FROM supervision_sessions s
  JOIN supervision_session_trainees st ON s.session_id = st.session_id
  LEFT JOIN supervision_attendance a ON s.session_id = a.session_id AND a.trainee_id = ?
  WHERE st.trainee_id = ? AND s.session_date <= CURDATE()
  GROUP BY s.session_type
");

function getStatusFlag($percent) {
  if ($percent >= 80) return ['flag' => 'green', 'label' => '✓'];
  if ($percent >= 60) return ['flag' => 'amber', 'label' => '⚠'];
  return ['flag' => 'red', 'label' => '✗'];
}

foreach ($trainees as $t) {
  $attendanceStmt->execute([$t['trainee_id'], $t['trainee_id']]);
  $rows = $attendanceStmt->fetchAll(PDO::FETCH_ASSOC);

  $percentIndividual = 0;
  $percentGroup = 0;

  foreach ($rows as $row) {
    if ($row['session_type'] === 'individual') {
      $percentIndividual = $row['total'] ? round(($row['attended'] / $row['total']) * 100) : 0;
    }
    if ($row['session_type'] === 'group') {
      $percentGroup = $row['total'] ? round(($row['attended'] / $row['total']) * 100) : 0;
    }
  }

  $attendanceMap[$t['trainee_id']] = [
    'individual' => $percentIndividual,
    'group' => $percentGroup,
    'individual_status' => getStatusFlag($percentIndividual),
    'group_status' => getStatusFlag($percentGroup)
  ];
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Supervision Attendance Dashboard</title>
  <link rel="stylesheet" href="style.css">
  <style>
    .layout-wrapper {
      display: flex;
      align-items: flex-start;
      min-height: 100vh;
      background: #f4f4f4;
    }
    .main-content {
      flex-grow: 1;
      padding: 40px;
      font-family: 'Inter', sans-serif;
    }
    h2 {
      color: #6a1b9a;
      font-family: 'Josefin Sans', sans-serif;
    }
    .toggle-links {
      margin-bottom: 20px;
    }
    .toggle-links a {
      margin-right: 20px;
      font-weight: bold;
      color: #6a1b9a;
      text-decoration: none;
    }
    .toggle-links a:hover {
      text-decoration: underline;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }
    th, td {
      padding: 10px;
      border: 1px solid #ccc;
      vertical-align: middle;
    }
    th {
      background-color: #6a1b9a;
      color: white;
    }
    .btn {
      display: inline-block;
      padding: 8px 14px;
      background-color: #6a1b9a;
      color: white;
      border-radius: 4px;
      text-decoration: none;
      font-size: 14px;
      line-height: 1.4;
      text-align: center;
    }
    .btn:hover {
      background-color: #4a148c;
    }
    .trainee-link {
      font-weight: bold;
      color: #6a1b9a;
      text-decoration: none;
    }
    .trainee-link:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <?php include 'header.php'; ?>
  <div class="layout-wrapper">
    <?php include 'sidebar.php'; ?>

    <div class="main-content">
      <h2>Supervision Attendance Dashboard</h2>

      <div class="toggle-links">
        <a href="?archived=0" <?= !$showArchived ? 'style="text-decoration:underline;"' : '' ?>>Active Trainees</a>
        <a href="?archived=1" <?= $showArchived ? 'style="text-decoration:underline;"' : '' ?>>Archived Trainees</a>
      </div>

      <?php if ($trainees): ?>
        <table>
          <thead>
            <tr>
              <th>Trainee</th>
              <th>Course</th>
              <th>Current Module</th>
              <th>Individual Supervisor</th>
              <th>Group</th>
              <th>Group Supervisor</th>
              <th>Ind. Attendance</th>
              <th>Group Attendance</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <?php foreach ($trainees as $t): ?>
              <?php
                $att = $attendanceMap[$t['trainee_id']] ?? [
                  'individual' => 0,
                  'group' => 0,
                  'individual_status' => ['flag'=>'grey','label'=>'–'],
                  'group_status' => ['flag'=>'grey','label'=>'–']
                ];
              ?>
              <tr>
                <td>
                  <a href="view_trainee.php?id=<?= urlencode($t['trainee_id']) ?>" class="trainee-link">
                    <?= htmlspecialchars($t['surname'] . ', ' . $t['first_name']) ?>
                  </a>
                </td>
                <td><?= htmlspecialchars($t['course_name'] ?? '—') ?></td>
                <td><?= htmlspecialchars($t['current_module'] ?? '—') ?></td>
                <td><?= htmlspecialchars($t['ind_first'] . ' ' . $t['ind_surname']) ?></td>
                <td><?= htmlspecialchars($t['module_number'] . ' — ' . $t['module_title']) ?></td>
                <td><?= htmlspecialchars($t['grp_first'] . ' ' . $t['grp_surname']) ?></td>
                <td><?= $att['individual'] ?>%</td>
                <td><?= $att['group'] ?>%</td>
                <td>
                  <span style="color:<?= $att['individual_status']['flag'] ?>"><?= $att['individual_status']['label'] ?></span> /
                  <span style="color:<?= $att['group_status']['flag'] ?>"><?= $att['group_status']['label'] ?></span>
                </td>
                <td>
                  <a href="view_supervision_attendance.php?trainee_id=<?= urlencode($t['trainee_id']) ?>" class="btn">View Attendance</a>
                </td>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      <?php else: ?>
        <p>No trainees found.</p>
      <?php endif; ?>
    </div>
  </div>
</body>
</html>