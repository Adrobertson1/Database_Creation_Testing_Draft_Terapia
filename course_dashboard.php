<?php require 'auth.php'; ?>
<?php
require 'db.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin', 'staff'])) {
  die("Access denied.");
}

// Fetch all courses
$courseSummaryStmt = $pdo->query("
  SELECT course_id, course_name
  FROM courses
  ORDER BY course_name
");
$courseSummary = $courseSummaryStmt->fetchAll(PDO::FETCH_ASSOC);

// Preload module-level trainee counts per course
$courseModules = [];

foreach ($courseSummary as $course) {
  $courseId = $course['course_id'];

  $moduleStmt = $pdo->prepare("
    SELECT m.module_id, m.module_name,
      (SELECT COUNT(*) FROM trainees t
       WHERE t.course_id = ? AND t.module_id = m.module_id AND t.is_archived = 0) AS active_count,
      (SELECT COUNT(*) FROM trainees t
       WHERE t.course_id = ? AND t.module_id = m.module_id AND t.is_archived = 1) AS archived_count
    FROM modules m
    WHERE m.course_id = ?
    ORDER BY m.year
  ");
  $moduleStmt->execute([$courseId, $courseId, $courseId]);
  $courseModules[$courseId] = $moduleStmt->fetchAll(PDO::FETCH_ASSOC);
}

// Fetch unassigned trainees
$unassignedStmt = $pdo->query("
  SELECT trainee_id, first_name, surname, email
  FROM trainees
  WHERE trainee_id NOT IN (
    SELECT trainee_id FROM trainee_courses
  )
  ORDER BY surname, first_name
");
$unassignedTrainees = $unassignedStmt->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Course Dashboard</title>
  <link rel="stylesheet" href="style.css">
  <style>
    .dashboard-section { margin-bottom: 30px; }
    .course-summary-table, .module-table, .unassigned-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
    }
    th, td {
      padding: 10px;
      border-bottom: 1px solid #ccc;
      text-align: left;
    }
    th { background-color: #6a1b9a; color: white; }
    .btn-sm {
      padding: 6px 12px;
      font-size: 14px;
      border-radius: 4px;
      text-decoration: none;
      display: inline-block;
      border: none;
      cursor: pointer;
    }
    .btn-view { background-color: #4CAF50; color: white; }
    .btn-toggle { background-color: #6a1b9a; color: white; margin-top: 20px; }
    .course-details { display: none; }
    .course-details.active { display: table-row; }
    .module-table a {
      color: #6a1b9a;
      font-weight: bold;
      text-decoration: none;
    }
    .module-table a:hover {
      text-decoration: underline;
    }
    #unassignedContainer { display: none; margin-top: 20px; }
  </style>
  <script>
    function toggleDetails(courseId) {
      const row = document.getElementById('details-' + courseId);
      row.classList.toggle('active');
    }
    function toggleUnassigned() {
      const container = document.getElementById('unassignedContainer');
      container.style.display = (container.style.display === 'none') ? 'block' : 'none';
    }
  </script>
</head>
<body>
<?php include 'header.php'; ?>
<div class="dashboard-wrapper">
  <?php include 'sidebar.php'; ?>
  <div class="main-content">
    <h2>Course Dashboard</h2>

    <div class="dashboard-section">
      <h3>📊 Course Summary</h3>
      <table class="course-summary-table">
        <thead>
          <tr>
            <th>Course Name</th>
            <th>View</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($courseSummary as $course):
            $cid = $course['course_id'];
            $modules = $courseModules[$cid];
          ?>
            <tr>
              <td><?= htmlspecialchars($course['course_name']) ?></td>
              <td><button class="btn-sm btn-view" onclick="toggleDetails(<?= $cid ?>)">View</button></td>
            </tr>
            <tr id="details-<?= $cid ?>" class="course-details">
              <td colspan="2">
                <?php if ($modules): ?>
                  <table class="module-table">
                    <thead>
                      <tr>
                        <th>Module Name</th>
                        <th>Active Trainees</th>
                        <th>Archived Trainees</th>
                      </tr>
                    </thead>
                    <tbody>
                      <?php foreach ($modules as $m): ?>
                        <tr>
                          <td><?= htmlspecialchars($m['module_name']) ?></td>
                          <td>
                            <a href="module_trainees.php?course_id=<?= $cid ?>&module_id=<?= $m['module_id'] ?>&type=active">
                              <?= $m['active_count'] ?>
                            </a>
                          </td>
                          <td>
                            <a href="module_trainees.php?course_id=<?= $cid ?>&module_id=<?= $m['module_id'] ?>&type=archived">
                              <?= $m['archived_count'] ?>
                            </a>
                          </td>
                        </tr>
                      <?php endforeach; ?>
                    </tbody>
                  </table>
                <?php else: ?>
                  <p>No modules found for this course.</p>
                <?php endif; ?>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>

      <button class="btn-sm btn-toggle" onclick="toggleUnassigned()">Show Unassigned Trainees</button>

      <div id="unassignedContainer">
        <h3>🚫 Unassigned Trainees</h3>
        <?php if ($unassignedTrainees): ?>
          <table class="unassigned-table">
            <thead>
              <tr>
                <th>Trainee ID</th>
                <th>Name</th>
                <th>Email</th>
              </tr>
            </thead>
            <tbody>
              <?php foreach ($unassignedTrainees as $t): ?>
                <tr>
                  <td><?= htmlspecialchars($t['trainee_id']) ?></td>
                  <td><?= htmlspecialchars($t['first_name'] . ' ' . $t['surname']) ?></td>
                  <td><?= htmlspecialchars($t['email']) ?></td>
                </tr>
              <?php endforeach; ?>
            </tbody>
          </table>
        <?php else: ?>
          <p>No unassigned trainees found.</p>
        <?php endif; ?>
      </div>
    </div>
  </div>
</div>
</body>
</html>