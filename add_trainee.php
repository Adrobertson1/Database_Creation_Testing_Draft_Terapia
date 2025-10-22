<?php require 'auth.php'; ?>
<?php
require 'db.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin', 'staff'])) {
    die("Access denied.");
}

// Generate unique trainee_id
function generateTraineeID($pdo) {
    do {
        $id = strtoupper(bin2hex(random_bytes(4))); // 8-char hex
        $stmt = $pdo->prepare("SELECT COUNT(*) FROM trainees WHERE trainee_id = ?");
        $stmt->execute([$id]);
    } while ($stmt->fetchColumn() > 0);
    return $id;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    $trainee_id = generateTraineeID($pdo);
}

$courseOptions = $pdo->query("SELECT course_id, course_name FROM courses ORDER BY course_name");

$moduleListStmt = $pdo->query("SELECT module_id, module_name, course_id FROM modules ORDER BY year");
$moduleList = [];
while ($mod = $moduleListStmt->fetch()) {
    $moduleList[$mod['course_id']][] = [
        'id' => $mod['module_id'],
        'name' => $mod['module_name']
    ];
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $trainee_id = $_POST['trainee_id'] ?? '';
    $mdx_id = $_POST['mdx_id'] ?? '';
    $first_name = $_POST['first_name'] ?? '';
    $surname = $_POST['surname'] ?? '';
    $email = $_POST['email'] ?? '';
    $telephone = $_POST['telephone'] ?? '';
    $course_id = $_POST['course_id'] ?? '';
    $module_id = $_POST['module_id'] ?? '';
    $date_of_birth = $_POST['date_of_birth'] ?? '';
    $disability_status = $_POST['disability_status'] ?? 'No';
    $disability_type = $_POST['disability_type'] ?? '';
    $town_city = $_POST['town_city'] ?? '';
    $postcode = $_POST['postcode'] ?? '';
    $address_line1 = $_POST['address_line1'] ?? '';
    $start_date = $_POST['start_date'] ?? '';
    $dbs_expiry_date = $_POST['dbs_expiry_date'] ?? '';
    $dbs_status = $_POST['dbs_status'] ?? 'Pending';
    $dbs_issue_date = $_POST['dbs_issue_date'] ?? '';
    $dbs_reference_number = $_POST['dbs_reference_number'] ?? '';
    $dbs_update_service = $_POST['dbs_update_service'] ?? 'No';
    $password = $_POST['password'] ?? '';
    $emergency_contact_name = $_POST['emergency_contact_name'] ?? '';
    $emergency_contact_number = $_POST['emergency_contact_number'] ?? '';
    $personal_email = $_POST['personal_email'] ?? '';

    $profileImagePath = '';
    if (!empty($_FILES['profile_image']['name'])) {
        $targetDir = "uploads/";
        $fileName = basename($_FILES['profile_image']['name']);
        $safeName = preg_replace("/[^a-zA-Z0-9.\-_]/", "", $fileName);
        $profileImagePath = $targetDir . time() . "_" . $safeName;
        if (!move_uploaded_file($_FILES['profile_image']['tmp_name'], $profileImagePath)) {
            $error = 'Failed to upload profile image.';
        }
    }
        if (empty($course_id)) {
        $error = 'Please select a course.';
    } elseif (empty($module_id)) {
        $error = 'Please select a module.';
    } elseif (empty($email)) {
        $error = 'Email is required.';
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error = 'Invalid email format.';
    } elseif (!preg_match('/^\d{11}$/', $telephone)) {
        $error = 'Telephone number must be 11 digits.';
    } elseif (empty($password)) {
        $error = 'Password is required.';
    } elseif (!$error) {
        // Insert into users table first
        $userInsert = $pdo->prepare("
          INSERT INTO users (username, password, role, email)
          VALUES (?, ?, ?, ?)
        ");
        $userInsert->execute([
          $email,
          password_hash($password, PASSWORD_DEFAULT),
          'trainee',
          $email
        ]);
        $user_id = $pdo->lastInsertId();

        // Insert into trainees table
        $insertStmt = $pdo->prepare("
            INSERT INTO trainees (
                user_id, trainee_id, mdx_id, first_name, surname, email, telephone, course_id, module_id,
                date_of_birth, disability_status, disability_type, town_city, postcode,
                address_line1, start_date, dbs_expiry_date, dbs_status, dbs_issue_date,
                dbs_reference_number, dbs_update_service, password, profile_image,
                emergency_contact_name, emergency_contact_number, personal_email, is_archived
            ) VALUES (
                ?, ?, ?, ?, ?, ?, ?, ?, ?,
                ?, ?, ?, ?, ?,
                ?, ?, ?, ?, ?, ?,
                ?, ?, ?, ?, ?, ?, 0
            )
        ");

        $params = [
            $user_id,
            $trainee_id, $mdx_id, $first_name, $surname, $email, $telephone, $course_id, $module_id,
            $date_of_birth, $disability_status, $disability_type, $town_city, $postcode,
            $address_line1, $start_date, $dbs_expiry_date, $dbs_status, $dbs_issue_date,
            $dbs_reference_number, $dbs_update_service,
            password_hash($password, PASSWORD_DEFAULT),
            $profileImagePath,
            $emergency_contact_name, $emergency_contact_number, $personal_email
        ];

        $insertStmt->execute($params);

        header("Location: view_trainee.php?id=" . urlencode($trainee_id));
        exit;
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Add New Trainee</title>
  <link rel="stylesheet" href="style.css">
    <style>
    .form-box {
      background: #f9f9f9;
      padding: 20px;
      border-radius: 8px;
      max-width: 600px;
      margin-bottom: 30px;
      border: 1px solid #ccc;
    }
    .form-box label {
      display: block;
      margin-bottom: 6px;
      font-weight: bold;
    }
    .form-box input,
    .form-box select {
      width: 100%;
      padding: 8px;
      margin-bottom: 15px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    .form-box input[readonly] {
      background-color: #eee;
      color: #555;
    }
    .form-box button {
      padding: 10px 16px;
      background-color: #6a1b9a;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .form-box button:hover {
      background-color: #8e24aa;
    }
    .error-message {
      color: #d32f2f;
      font-weight: bold;
      margin-bottom: 15px;
    }
  </style>
</head>
<body>
<?php include 'header.php'; ?>
<div class="dashboard-wrapper">
  <?php include 'sidebar.php'; ?>
  <div class="main-content">
    <h2>Add New Trainee</h2>
    <div class="form-box">
      <?php if ($error): ?>
        <div class="error-message"><?= htmlspecialchars($error) ?></div>
      <?php endif; ?>
      <form method="post" enctype="multipart/form-data">
        <label for="trainee_id">Trainee ID:</label>
        <input type="text" name="trainee_id" id="trainee_id" value="<?= htmlspecialchars($trainee_id) ?>" readonly>

        <label for="mdx_id">MDX ID (optional):</label>
        <input type="text" name="mdx_id" id="mdx_id" pattern="[a-zA-Z0-9]{3,20}" title="Alphanumeric, 3–20 characters">

        <label for="first_name">First Name:</label>
        <input type="text" name="first_name" id="first_name" required>

        <label for="surname">Surname:</label>
        <input type="text" name="surname" id="surname" required>

        <label for="email">Email:</label>
        <input type="email" name="email" id="email" required>

        <label for="personal_email">Personal Email:</label>
        <input type="email" name="personal_email" id="personal_email">

        <label for="telephone">Telephone:</label>
        <input type="text" name="telephone" id="telephone" required>

        <label for="emergency_contact_name">Emergency Contact Name:</label>
        <input type="text" name="emergency_contact_name" id="emergency_contact_name">

        <label for="emergency_contact_number">Emergency Contact Number:</label>
        <input type="text" name="emergency_contact_number" id="emergency_contact_number">

        <label for="course_id">Course:</label>
        <select name="course_id" id="course_id" required onchange="updateModules()">
          <option value="">-- Choose a course --</option>
          <?php while ($course = $courseOptions->fetch()): ?>
            <option value="<?= $course['course_id'] ?>"><?= htmlspecialchars($course['course_name']) ?></option>
          <?php endwhile; ?>
        </select>

        <label for="module_id">Module:</label>
        <select name="module_id" id="module_id" required>
          <option value="">-- Choose a module --</option>
        </select>

        <label for="date_of_birth">Date of Birth:</label>
        <input type="date" name="date_of_birth" id="date_of_birth">

        <label for="disability_status">Disability Status:</label>
        <select name="disability_status" id="disability_status">
          <option value="No">No</option>
          <option value="Yes">Yes</option>
        </select>

        <label for="disability_type">Disability Type (if applicable):</label>
        <input type="text" name="disability_type" id="disability_type">

        <label for="town_city">Town/City:</label>
        <input type="text" name="town_city" id="town_city">

        <label for="postcode">Postcode:</label>
        <input type="text" name="postcode" id="postcode">

        <label for="address_line1">First Line of Address:</label>
        <input type="text" name="address_line1" id="address_line1">

        <label for="start_date">Start Date:</label>
        <input type="date" name="start_date" id="start_date">

        <label for="dbs_expiry_date">DBS Expiry Date:</label>
        <input type="date" name="dbs_expiry_date" id="dbs_expiry_date">

        <label for="dbs_status">DBS Status:</label>
        <select name="dbs_status" id="dbs_status">
          <option value="Pending">Pending</option>
          <option value="Cleared">Cleared</option>
          <option value="Expired">Expired</option>
        </select>

        <label for="dbs_issue_date">DBS Issue Date:</label>
        <input type="date" name="dbs_issue_date" id="dbs_issue_date">

        <label for="dbs_reference_number">DBS Reference Number:</label>
        <input type="text" name="dbs_reference_number" id="dbs_reference_number">

        <label for="dbs_update_service">DBS Update Service:</label>
        <select name="dbs_update_service" id="dbs_update_service">
          <option value="No">No</option>
          <option value="Yes">Yes</option>
        </select>

        <label for="password">Set Password:</label>
        <input type="password" name="password" id="password" required>

        <label for="profile_image">Profile Picture:</label>
        <input type="file" name="profile_image" id="profile_image" accept="image/*">

        <button type="submit">Create Trainee</button>
      </form>
    </div>
  </div>
</div>

<script>
const moduleMap = <?= json_encode($moduleList) ?>;

function updateModules() {
  const courseSelect = document.getElementById('course_id');
  const moduleSelect = document.getElementById('module_id');
  const selectedCourseId = courseSelect.value;

  moduleSelect.innerHTML = '<option value="">-- Choose a module --</option>';

  if (moduleMap[selectedCourseId]) {
    moduleMap[selectedCourseId].forEach(mod => {
      const option = document.createElement('option');
      option.value = mod.id;
      option.textContent = mod.name;
      moduleSelect.appendChild(option);
    });
  }
}

window.onload = updateModules;
</script>
</body>
</html>