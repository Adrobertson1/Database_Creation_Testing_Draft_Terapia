<?php require 'auth.php'; ?>
<?php
require 'db.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin'])) {
  die("Access denied.");
}

$errors = [];

$courseOptions = $pdo->query("SELECT course_id, course_name FROM courses ORDER BY course_name");
$moduleOptions = $pdo->query("SELECT module_id, module_name FROM modules ORDER BY year");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $first_name = trim($_POST['first_name']);
  $surname = trim($_POST['surname']);
  $email = trim($_POST['email']);
  $password = $_POST['password'];
  $job_title = trim($_POST['job_title']);
  $start_date = $_POST['start_date'] ?? null;
  $telephone = trim($_POST['telephone']);
  $address_line1 = trim($_POST['address_line1']);
  $town_city = trim($_POST['town_city']);
  $postcode = trim($_POST['postcode']);
  $disability_status = trim($_POST['disability_status']);
  $disability_type = trim($_POST['disability_type']);
  $is_archived = isset($_POST['is_archived']) ? 1 : 0;
  $course_ids = $_POST['course_ids'] ?? [];
  $module_ids = $_POST['module_ids'] ?? [];

  $dbs_status = $_POST['dbs_status'] ?? 'Pending';
  $dbs_date = $_POST['dbs_date'] ?? null;
  $dbs_reference = $_POST['dbs_reference'] ?? '';
  $dbs_update_service = ($_POST['dbs_update_service'] ?? 'No') === 'Yes' ? 1 : 0;
  $dbs_expiry_date = $_POST['dbs_expiry_date'] ?? null;

  if (!$first_name || !$surname || !$email || !$password) {
    $errors[] = "First name, surname, email, and password are required.";
  }

  $profile_image = null;
  if (!empty($_FILES['profile_image']['name'])) {
    $target_dir = "uploads/";
    $filename = uniqid() . "_" . basename($_FILES["profile_image"]["name"]);
    $target_file = $target_dir . $filename;

    if (move_uploaded_file($_FILES["profile_image"]["tmp_name"], $target_file)) {
      $profile_image = $target_file;
    } else {
      $errors[] = "Failed to upload profile image.";
    }
  }

  if (empty($errors)) {
    try {
      $pdo->beginTransaction();

      $hashed_password = password_hash($password, PASSWORD_DEFAULT);

      $stmt = $pdo->prepare("
        INSERT INTO supervisors (
          first_name, surname, email, password, role, job_title, start_date,
          telephone, address_line1, town_city, postcode,
          disability_status, disability_type, profile_image, is_archived,
          dbs_status, dbs_date, dbs_reference, dbs_update_service, dbs_expiry_date
        ) VALUES (
          ?, ?, ?, ?, 'supervisor', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
          ?, ?, ?, ?, ?
        )
      ");

      $stmt->execute([
        $first_name, $surname, $email, $hashed_password, $job_title, $start_date,
        $telephone, $address_line1, $town_city, $postcode,
        $disability_status, $disability_type, $profile_image, $is_archived,
        $dbs_status, $dbs_date, $dbs_reference, $dbs_update_service, $dbs_expiry_date
      ]);

      $supervisor_id = $pdo->lastInsertId();

      foreach ($course_ids as $cid) {
        $pdo->prepare("INSERT INTO supervisor_courses (supervisor_id, course_id) VALUES (?, ?)")
            ->execute([$supervisor_id, $cid]);
      }

      foreach ($module_ids as $mid) {
        $pdo->prepare("INSERT INTO supervisor_modules (supervisor_id, module_id) VALUES (?, ?)")
            ->execute([$supervisor_id, $mid]);
      }

      $pdo->commit();
      header("Location: supervisors.php");
      exit;
    } catch (PDOException $e) {
      $pdo->rollBack();
      $errors[] = "Database error: " . $e->getMessage();
    }
  }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Add Supervisor</title>
  <link rel="stylesheet" href="style.css">
  <style>
    form {
      max-width: 700px;
      margin: 40px auto;
      background: #fff;
      padding: 20px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    label {
      display: block;
      margin-top: 15px;
      font-weight: bold;
    }
    input, select {
      width: 100%;
      padding: 8px;
      margin-top: 5px;
    }
    button {
      margin-top: 20px;
      padding: 10px 16px;
      background-color: #1976d2;
      color: white;
      border: none;
      border-radius: 4px;
      font-size: 1em;
    }
    button:hover {
      background-color: #0d47a1;
    }
    .error {
      color: red;
      margin-top: 10px;
    }
    small {
      color: #555;
      display: block;
      margin-top: 5px;
    }
  </style>
</head>
<body>
<?php include 'header.php'; ?>
<div class="dashboard-wrapper">
  <?php include 'sidebar.php'; ?>
  <div class="main-content">
    <h2>Add New Supervisor</h2>

    <?php if (!empty($errors)): ?>
      <div class="error">
        <ul>
          <?php foreach ($errors as $e): ?>
            <li><?= htmlspecialchars($e) ?></li>
          <?php endforeach; ?>
        </ul>
      </div>
    <?php endif; ?>

    <form method="post" enctype="multipart/form-data">
      <label>First Name</label>
      <input type="text" name="first_name" required>

      <label>Surname</label>
      <input type="text" name="surname" required>

      <label>Email</label>
      <input type="email" name="email" required>

      <label>Password</label>
      <input type="password" name="password" required>

      <label>Job Title</label>
      <input type="text" name="job_title">

      <label>Start Date</label>
      <input type="date" name="start_date">

      <label>Telephone</label>
      <input type="text" name="telephone">

      <label>Address Line 1</label>
      <input type="text" name="address_line1">

      <label>Town/City</label>
      <input type="text" name="town_city">

      <label>Postcode</label>
      <input type="text" name="postcode">

      <label>Disability Status</label>
      <input type="text" name="disability_status">

      <label>Disability Type</label>
      <input type="text" name="disability_type">

      <label>DBS Status</label>
      <select name="dbs_status">
        <option value="Pending">Pending</option>
        <option value="Cleared">Cleared</option>
        <option value="Expired">Expired</option>
      </select>

      <label>DBS Issue Date</label>
      <input type="date" name="dbs_date">

      <label>DBS Reference Number</label>
      <input type="text" name="dbs_reference">

      <label>DBS Update Service</label>
      <select name="dbs_update_service">
        <option value="No">No</option>
        <option value="Yes">Yes</option>
      </select>

      <label>DBS Expiry Date</label>
      <input type="date" name="dbs_expiry_date">

      <label>Profile Image</label>
      <input type="file" name="profile_image">

      <label>Assign Courses</label>
      <select name="course_ids[]" multiple>
        <?php while ($course = $courseOptions->fetch(PDO::FETCH_ASSOC)): ?>
          <option value="<?= htmlspecialchars($course['course_id']) ?>">
            <?= htmlspecialchars($course['course_name']) ?>
          </option>
        <?php endwhile; ?>
      </select>
      <small>Hold Ctrl (Windows) or Cmd (Mac) to select multiple</small>

      <label>Assign Modules</label>
      <select name="module_ids[]" multiple>
        <?php while ($module = $moduleOptions->fetch(PDO::FETCH_ASSOC)): ?>
          <option value="<?= htmlspecialchars($module['module_id']) ?>">
            <?= htmlspecialchars($module['module_name']) ?>
          </option>
        <?php endwhile; ?>
      </select>
      <small>Hold Ctrl (Windows) or Cmd (Mac) to select multiple</small>

      <label>
        <input type="checkbox" name="is_archived"> Archive this supervisor
      </label>

      <button type="submit">Add Supervisor</button>
    </form>
  </div>
</div>
</body>
</html>