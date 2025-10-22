<?php require 'auth.php'; ?>
<?php
require 'db.php';
include 'header.php';

$tutor_id = $_GET['tutor_id'] ?? null;
if (!$tutor_id || !is_numeric($tutor_id)) {
  die("Invalid tutor ID.");
}

$stmt = $pdo->prepare("SELECT * FROM tutors WHERE tutor_id = ?");
$stmt->execute([$tutor_id]);
$tutor = $stmt->fetch();

if (!$tutor) {
  die("Tutor not found.");
}

$courseOptions = $pdo->query("SELECT course_id, course_name FROM courses ORDER BY course_name");
$moduleOptions = $pdo->query("SELECT module_id, module_name FROM modules ORDER BY year");

$assignedCoursesStmt = $pdo->prepare("SELECT course_id FROM tutor_courses WHERE tutor_id = ?");
$assignedCoursesStmt->execute([$tutor_id]);
$assignedCourses = $assignedCoursesStmt->fetchAll(PDO::FETCH_COLUMN);

$assignedModulesStmt = $pdo->prepare("SELECT module_id FROM tutor_modules WHERE tutor_id = ?");
$assignedModulesStmt->execute([$tutor_id]);
$assignedModules = $assignedModulesStmt->fetchAll(PDO::FETCH_COLUMN);

$success = '';
$error = '';

function isValidPassword($password) {
  return preg_match('/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/', $password);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $first = trim($_POST['first_name'] ?? '');
  $surname = trim($_POST['surname'] ?? '');
  $email = trim($_POST['email'] ?? '');
  $role = strtolower(trim($_POST['role'] ?? ''));
  $job_title = trim($_POST['job_title'] ?? '');
  $telephone = trim($_POST['telephone'] ?? '');
  $start_date = $_POST['start_date'] ?? $tutor['start_date'];
  $new_password = $_POST['password'] ?? '';
  $profile_image = $tutor['profile_image'];
  $course_ids = $_POST['course_ids'] ?? [];
  $module_ids = $_POST['module_ids'] ?? [];

  $dbs_status = $_POST['dbs_status'] ?? 'Pending';
  $dbs_date = $_POST['dbs_date'] ?? '';
  $dbs_reference = $_POST['dbs_reference'] ?? '';
  $dbs_update_service = ($_POST['dbs_update_service'] ?? 'No') === 'Yes' ? 1 : 0;
  $dbs_expiry_date = $_POST['dbs_expiry_date'] ?? '';

  if (!empty($_FILES['profile_image']['name'])) {
    $target_dir = "uploads/";
    if (!is_dir($target_dir)) {
      mkdir($target_dir, 0755, true);
    }
    $filename = basename($_FILES["profile_image"]["name"]);
    $safeName = preg_replace("/[^a-zA-Z0-9.\-_]/", "", $filename);
    $target_file = $target_dir . time() . "_" . $safeName;
    if (move_uploaded_file($_FILES["profile_image"]["tmp_name"], $target_file)) {
      $profile_image = basename($target_file);
    }
  }

  if ($first && $surname && $email && $role) {
    try {
      $pdo->beginTransaction();

      if ($new_password) {
        if (!isValidPassword($new_password)) {
          $error = "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.";
        } else {
          $hashed = password_hash($new_password, PASSWORD_DEFAULT);
          $stmt = $pdo->prepare("UPDATE tutors SET first_name=?, surname=?, email=?, password=?, role=?, job_title=?, start_date=?, telephone=?, profile_image=?, dbs_status=?, dbs_date=?, dbs_reference=?, dbs_update_service=?, dbs_expiry_date=? WHERE tutor_id=?");
          $stmt->execute([$first, $surname, $email, $hashed, $role, $job_title, $start_date, $telephone, $profile_image, $dbs_status, $dbs_date, $dbs_reference, $dbs_update_service, $dbs_expiry_date, $tutor_id]);
        }
      } else {
        $stmt = $pdo->prepare("UPDATE tutors SET first_name=?, surname=?, email=?, role=?, job_title=?, start_date=?, telephone=?, profile_image=?, dbs_status=?, dbs_date=?, dbs_reference=?, dbs_update_service=?, dbs_expiry_date=? WHERE tutor_id=?");
        $stmt->execute([$first, $surname, $email, $role, $job_title, $start_date, $telephone, $profile_image, $dbs_status, $dbs_date, $dbs_reference, $dbs_update_service, $dbs_expiry_date, $tutor_id]);
      }

      $pdo->prepare("DELETE FROM tutor_courses WHERE tutor_id = ?")->execute([$tutor_id]);
      foreach ($course_ids as $cid) {
        $pdo->prepare("INSERT INTO tutor_courses (tutor_id, course_id) VALUES (?, ?)")->execute([$tutor_id, $cid]);
      }

      $pdo->prepare("DELETE FROM tutor_modules WHERE tutor_id = ?")->execute([$tutor_id]);
      foreach ($module_ids as $mid) {
        $pdo->prepare("INSERT INTO tutor_modules (tutor_id, module_id) VALUES (?, ?)")->execute([$tutor_id, $mid]);
      }

      $pdo->commit();
      $success = "Tutor updated successfully.";
    } catch (PDOException $e) {
      $pdo->rollBack();
      $error = "Error updating tutor: " . $e->getMessage();
    }
  } else {
    $error = "Please fill in all required fields.";
  }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Tutor</title>
  <link rel="stylesheet" href="style.css">
  <style>
    body { font-family: 'Inter', sans-serif; background: #E6D6EC; margin: 0; }
    .dashboard-wrapper { display: flex; }
    .main-content { flex: 1; padding: 40px; }
    .form-card {
      background: #fff;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      max-width: 700px;
      margin-bottom: 40px;
    }
    .form-card h2 {
      color: #850069;
      font-family: 'Josefin Sans', sans-serif;
      margin-bottom: 20px;
    }
    .form-card label {
      display: block;
      margin-top: 15px;
      font-weight: bold;
    }
    .form-card input, .form-card select {
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
      font-family: 'Josefin Sans', serif;
      font-size: 18px;
    }
    .form-card button:hover {
      background-color: #BB9DC6;
    }
    .message {
      margin-bottom: 20px;
      font-weight: bold;
      text-align: center;
    }
    .message.success { color: #2e7d32; }
    .message.error { color: #d32f2f; }
    small { color: #555; display: block; margin-top: 5px; }
    .preview-img {
      margin-top: 10px;
      width: 60px;
      height: 60px;
      border-radius: 50%;
      object-fit: cover;
      border: 1px solid #ccc;
    }
  </style>
</head>
<body>
<div class="dashboard-wrapper">
  <?php include 'sidebar.php'; ?>
  <div class="main-content">
    <div class="form-card">
      <h2>Edit Tutor</h2>
      <?php if ($success): ?><div class="message success"><?= htmlspecialchars($success) ?></div><?php endif; ?>
      <?php if ($error): ?><div class="message error"><?= htmlspecialchars($error) ?></div><?php endif; ?>
      <form method="post" enctype="multipart/form-data">
        <label>First Name:</label>
        <input type="text" name="first_name" value="<?= htmlspecialchars($tutor['first_name']) ?>" required>

        <label>Surname:</label>
        <input type="text" name="surname" value="<?= htmlspecialchars($tutor['surname']) ?>" required>

        <label>Email:</label>
        <input type="email" name="email" value="<?= htmlspecialchars($tutor['email']) ?>" required>

        <label>New Password (leave blank to keep current):</label>
        <input type="password" name="password">
        <small>Password must be at least 8 characters and include uppercase, lowercase, number, and special character.</small>

        <label>Role:</label>
        <select name="role" required>
          <option value="tutor" <?= $tutor['role'] === 'tutor' ? 'selected' : '' ?>>Tutor</option>
          <option value="staff" <?= $tutor['role'] === 'staff' ? 'selected' : '' ?>>Staff</option>
          <option value="admin" <?= $tutor['role'] === 'admin' ? 'selected' : '' ?>>Admin</option>
        </select>

        <label>Job Title:</label>
        <input type="text" name="job_title" value="<?= htmlspecialchars($tutor['job_title']) ?>">

        <label>Start Date:</label>
        <input type="date" name="start_date" value="<?= htmlspecialchars($tutor['start_date']) ?>">

        <label>Telephone:</label>
        <input type="text" name="telephone" value="<?= htmlspecialchars($tutor['telephone']) ?>">

        <label>DBS Status:</label>
        <select name="dbs_status">
          <option value="Pending" <?= $tutor['dbs_status'] === 'Pending' ? 'selected' : '' ?>>Pending</option>
          <option value="Cleared" <?= $tutor['dbs_status'] === 'Cleared' ? 'selected' : '' ?>>Cleared</option>
          <option value="Expired" <?= $tutor['dbs_status'] === 'Expired' ? 'selected' : '' ?>>Expired</option>
        </select>

        <label>DBS Issue Date:</label>
        <input type="date" name="dbs_date" value="<?= htmlspecialchars($tutor['dbs_date'] ?? '') ?>">

        <label>DBS Reference Number:</label>
        <input type="text" name="dbs_reference" value="<?= htmlspecialchars($tutor['dbs_reference'] ?? '') ?>">

        <label>DBS Update Service:</label>
        <select name="dbs_update_service">
          <option value="No" <?= $tutor['dbs_update_service'] == 0 ? 'selected' : '' ?>>No</option>
          <option value="Yes" <?= $tutor['dbs_update_service'] == 1 ? 'selected' : '' ?>>Yes</option>
        </select>

        <label>DBS Expiry Date:</label>
        <input type="date" name="dbs_expiry_date" value="<?= htmlspecialchars($tutor['dbs_expiry_date'] ?? '') ?>">

        <label>Profile Image:</label>
        <input type="file" name="profile_image" accept="image/*">
        <?php if ($tutor['profile_image']): ?>
          <img src="uploads/<?= htmlspecialchars($tutor['profile_image']) ?>" alt="Current Image" class="preview-img">
        <?php endif; ?>

        <label>Assigned Courses:</label>
        <select name="course_ids[]" multiple>
          <?php
          if ($courseOptions) {
            while ($course = $courseOptions->fetch(PDO::FETCH_ASSOC)):
              $selected = in_array($course['course_id'], $assignedCourses) ? 'selected' : '';
          ?>
            <option value="<?= htmlspecialchars($course['course_id']) ?>" <?= $selected ?>>
              <?= htmlspecialchars($course['course_name']) ?>
            </option>
          <?php
            endwhile;
          }
          ?>
        </select>
        <small>Hold Ctrl (Windows) or Cmd (Mac) to select multiple</small>

        <label>Assigned Modules:</label>
        <select name="module_ids[]" multiple>
          <?php
          if ($moduleOptions) {
            while ($module = $moduleOptions->fetch(PDO::FETCH_ASSOC)):
              $selected = in_array($module['module_id'], $assignedModules) ? 'selected' : '';
          ?>
            <option value="<?= htmlspecialchars($module['module_id']) ?>" <?= $selected ?>>
              <?= htmlspecialchars($module['module_name']) ?>
            </option>
          <?php
            endwhile;
          }
          ?>
        </select>
        <small>Hold Ctrl (Windows) or Cmd (Mac) to select multiple</small>

        <button type="submit">Update Tutor</button>
      </form>
    </div>
  </div>
</div>
</body>
</html>