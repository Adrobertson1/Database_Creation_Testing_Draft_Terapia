<?php require 'auth.php'; ?>
<?php
require 'db.php';
include 'header.php';

$supervisor_id = $_GET['supervisor_id'] ?? null;
if (!$supervisor_id || !is_numeric($supervisor_id)) {
  die("Invalid supervisor ID.");
}

$stmt = $pdo->prepare("SELECT * FROM supervisors WHERE supervisor_id = ?");
$stmt->execute([$supervisor_id]);
$supervisor = $stmt->fetch();

if (!$supervisor) {
  die("Supervisor not found.");
}

$courseOptions = $pdo->query("SELECT course_id, course_name FROM courses ORDER BY course_name");
$moduleOptions = $pdo->query("SELECT module_id, module_name FROM modules ORDER BY year");

$assignedCoursesStmt = $pdo->prepare("SELECT course_id FROM supervisor_courses WHERE supervisor_id = ?");
$assignedCoursesStmt->execute([$supervisor_id]);
$assignedCourses = $assignedCoursesStmt->fetchAll(PDO::FETCH_COLUMN);

$assignedModulesStmt = $pdo->prepare("SELECT module_id FROM supervisor_modules WHERE supervisor_id = ?");
$assignedModulesStmt->execute([$supervisor_id]);
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
  $start_date = $_POST['start_date'] ?? $supervisor['start_date'];
  $new_password = $_POST['password'] ?? '';
  $profile_image = $supervisor['profile_image'];
  $course_ids = $_POST['course_ids'] ?? [];
  $module_ids = $_POST['module_ids'] ?? [];

  $address_line1 = trim($_POST['address_line1'] ?? '');
  $town_city = trim($_POST['town_city'] ?? '');
  $postcode = trim($_POST['postcode'] ?? '');
  $disability_status = trim($_POST['disability_status'] ?? '');
  $disability_type = trim($_POST['disability_type'] ?? '');
  $is_archived = isset($_POST['is_archived']) ? 1 : 0;

  $dbs_status = $_POST['dbs_status'] ?? 'Pending';
  $dbs_date = $_POST['dbs_date'] ?? null;
  $dbs_reference = $_POST['dbs_reference'] ?? '';
  $dbs_update_service = ($_POST['dbs_update_service'] ?? 'No') === 'Yes' ? 1 : 0;
  $dbs_expiry_date = $_POST['dbs_expiry_date'] ?? null;

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

      $params = [
        $first, $surname, $email, $role, $job_title, $start_date, $telephone,
        $profile_image, $address_line1, $town_city, $postcode,
        $disability_status, $disability_type, $is_archived,
        $dbs_status, $dbs_date, $dbs_reference, $dbs_update_service, $dbs_expiry_date,
        $supervisor_id
      ];

      if ($new_password) {
        if (!isValidPassword($new_password)) {
          $error = "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.";
        } else {
          $hashed = password_hash($new_password, PASSWORD_DEFAULT);
          array_splice($params, 3, 0, $hashed); // insert hashed password after email
          $stmt = $pdo->prepare("UPDATE supervisors SET first_name=?, surname=?, email=?, password=?, role=?, job_title=?, start_date=?, telephone=?, profile_image=?, address_line1=?, town_city=?, postcode=?, disability_status=?, disability_type=?, is_archived=?, dbs_status=?, dbs_date=?, dbs_reference=?, dbs_update_service=?, dbs_expiry_date=? WHERE supervisor_id=?");
          $stmt->execute($params);
        }
      } else {
        $stmt = $pdo->prepare("UPDATE supervisors SET first_name=?, surname=?, email=?, role=?, job_title=?, start_date=?, telephone=?, profile_image=?, address_line1=?, town_city=?, postcode=?, disability_status=?, disability_type=?, is_archived=?, dbs_status=?, dbs_date=?, dbs_reference=?, dbs_update_service=?, dbs_expiry_date=? WHERE supervisor_id=?");
        $stmt->execute($params);
      }

      $pdo->prepare("DELETE FROM supervisor_courses WHERE supervisor_id = ?")->execute([$supervisor_id]);
      foreach ($course_ids as $cid) {
        $pdo->prepare("INSERT INTO supervisor_courses (supervisor_id, course_id) VALUES (?, ?)")->execute([$supervisor_id, $cid]);
      }

      $pdo->prepare("DELETE FROM supervisor_modules WHERE supervisor_id = ?")->execute([$supervisor_id]);
      foreach ($module_ids as $mid) {
        $pdo->prepare("INSERT INTO supervisor_modules (supervisor_id, module_id) VALUES (?, ?)")->execute([$supervisor_id, $mid]);
      }

      $pdo->commit();
      $success = "Supervisor updated successfully.";
    } catch (PDOException $e) {
      $pdo->rollBack();
      $error = "Error updating supervisor: " . $e->getMessage();
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
  <title>Edit Supervisor</title>
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
      <h2>Edit Supervisor</h2>
      <?php if ($success): ?><div class="message success"><?= htmlspecialchars($success) ?></div><?php endif; ?>
      <?php if ($error): ?><div class="message error"><?= htmlspecialchars($error) ?></div><?php endif; ?>
      <form method="post" enctype="multipart/form-data">
        <label>First Name:</label>
        <input type="text" name="first_name" value="<?= htmlspecialchars($supervisor['first_name']) ?>" required>

        <label>Surname:</label>
        <input type="text" name="surname" value="<?= htmlspecialchars($supervisor['surname']) ?>" required>

        <label>Email:</label>
        <input type="email" name="email" value="<?= htmlspecialchars($supervisor['email']) ?>" required>

        <label>New Password (leave blank to keep current):</label>
        <input type="password" name="password">
        <small>Password must be at least 8 characters and include uppercase, lowercase, number, and special character.</small>

        <label>Role:</label>
        <select name="role" required>
          <option value="supervisor" <?= $supervisor['role'] === 'supervisor' ? 'selected' : '' ?>>Supervisor</option>
          <option value="staff" <?= $supervisor['role'] === 'staff' ? 'selected' : '' ?>>Staff</option>
          <option value="admin" <?= $supervisor['role'] === 'admin' ? 'selected' : '' ?>>Admin</option>
        </select>

        <label>Job Title:</label>
        <input type="text" name="job_title" value="<?= htmlspecialchars($supervisor['job_title']) ?>">

        <label>Start Date:</label>
        <input type="date" name="start_date" value="<?= htmlspecialchars($supervisor['start_date']) ?>">

        <label>Telephone:</label>
        <input type="text" name="telephone" value="<?= htmlspecialchars($supervisor['telephone']) ?>">

        <label>Address Line 1:</label>
        <input type="text" name="address_line1" value="<?= htmlspecialchars($supervisor['address_line1']) ?>">

        <label>Town/City:</label>
        <input type="text" name="town_city" value="<?= htmlspecialchars($supervisor['town_city']) ?>">

        <label>Postcode:</label>
        <input type="text" name="postcode" value="<?= htmlspecialchars($supervisor['postcode']) ?>">

        <label>Disability Status:</label>
        <input type="text" name="disability_status" value="<?= htmlspecialchars($supervisor['disability_status']) ?>">

        <label>Disability Type:</label>
        <input type="text" name="disability_type" value="<?= htmlspecialchars($supervisor['disability_type']) ?>">

        <label>DBS Status:</label>
        <select name="dbs_status">
          <option value="Pending" <?= $supervisor['dbs_status'] === 'Pending' ? 'selected' : '' ?>>Pending</option>
          <option value="Cleared" <?= $supervisor['dbs_status'] === 'Cleared' ? 'selected' : '' ?>>Cleared</option>
          <option value="Expired" <?= $supervisor['dbs_status'] === 'Expired' ? 'selected' : '' ?>>Expired</option>
        </select>

        <label>DBS Issue Date:</label>
        <input type="date" name="dbs_date" value="<?= htmlspecialchars($supervisor['dbs_date']) ?>">

        <label>DBS Reference Number:</label>
        <input type="text" name="dbs_reference" value="<?= htmlspecialchars($supervisor['dbs_reference']) ?>">

        <label>DBS Update Service:</label>
        <select name="dbs_update_service">
          <option value="No" <?= $supervisor['dbs_update_service'] == 0 ? 'selected' : '' ?>>No</option>
          <option value="Yes" <?= $supervisor['dbs_update_service'] == 1 ? 'selected' : '' ?>>Yes</option>
        </select>

        <label>DBS Expiry Date:</label>
        <input type="date" name="dbs_expiry_date" value="<?= htmlspecialchars($supervisor['dbs_expiry_date']) ?>">

        <label>Profile Image:</label>
        <input type="file" name="profile_image" accept="image/*">
        <?php if ($supervisor['profile_image']): ?>
          <img src="uploads/<?= htmlspecialchars($supervisor['profile_image']) ?>" alt="Current Image" class="preview-img">
        <?php endif; ?>

        <label>Assigned Courses:</label>
        <select name="course_ids[]" multiple>
          <?php
          $courseOptions->execute();
          while ($course = $courseOptions->fetch(PDO::FETCH_ASSOC)):
            $selected = in_array($course['course_id'], $assignedCourses) ? 'selected' : '';
          ?>
            <option value="<?= htmlspecialchars($course['course_id']) ?>" <?= $selected ?>>
              <?= htmlspecialchars($course['course_name']) ?>
            </option>
          <?php endwhile; ?>
        </select>
        <small>Hold Ctrl (Windows) or Cmd (Mac) to select multiple</small>

        <label>Assigned Modules:</label>
        <select name="module_ids[]" multiple>
          <?php
          $moduleOptions->execute();
          while ($module = $moduleOptions->fetch(PDO::FETCH_ASSOC)):
            $selected = in_array($module['module_id'], $assignedModules) ? 'selected' : '';
          ?>
            <option value="<?= htmlspecialchars($module['module_id']) ?>" <?= $selected ?>>
              <?= htmlspecialchars($module['module_name']) ?>
            </option>
          <?php endwhile; ?>
        </select>
        <small>Hold Ctrl (Windows) or Cmd (Mac) to select multiple</small>

        <label>
          <input type="checkbox" name="is_archived" <?= $supervisor['is_archived'] ? 'checked' : '' ?>> Archive this supervisor
        </label>

        <button type="submit">Update Supervisor</button>
      </form>
    </div>
  </div>
</div>
</body>
</html>