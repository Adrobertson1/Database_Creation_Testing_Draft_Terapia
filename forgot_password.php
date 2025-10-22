<?php
session_start();
require 'db.php';
require_once 'functions.php';

$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = trim($_POST['email']);
    $sources = [
        ['table' => 'users',       'id' => 'user_id'],
        ['table' => 'staff',       'id' => 'staff_id'],
        ['table' => 'trainees',    'id' => 'trainee_id'],
        ['table' => 'tutors',      'id' => 'tutor_id'],
        ['table' => 'supervisors', 'id' => 'supervisor_id']
    ];

    $found = null;

    foreach ($sources as $src) {
        $stmt = $pdo->prepare("SELECT {$src['id']} AS user_id FROM {$src['table']} WHERE email = :email LIMIT 1");
        $stmt->execute(['email' => $email]);
        $match = $stmt->fetch();
        if ($match) {
            $found = [
                'user_id' => $match['user_id'],
                'table_name' => $src['table']
            ];
            break;
        }
    }

    if ($found) {
        $token = bin2hex(random_bytes(32));
        $expires = date('Y-m-d H:i:s', strtotime('+30 minutes'));

        $stmt = $pdo->prepare("
            INSERT INTO password_resets (user_id, table_name, email, token, expires_at)
            VALUES (:user_id, :table_name, :email, :token, :expires_at)
        ");
        $stmt->execute([
            'user_id' => $found['user_id'],
            'table_name' => $found['table_name'],
            'email' => $email,
            'token' => $token,
            'expires_at' => $expires
        ]);

        $resetLink = "https://unfoully-binaural-lino.ngrok-free.app/trainee_app/reset_password.php?token=$token";
        mail($email, "Password Reset", "Click to reset your password: $resetLink");

        $success = "A reset link has been sent to your email.";
    } else {
        $error = "Email not found.";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Forgot Password</title>
  <link rel="stylesheet" href="style.css">
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background: #E6D6EC;
      color: #000;
    }
    .reset-container {
      max-width: 400px;
      margin: 80px auto;
      background: #fff;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      text-align: center;
    }
    .reset-container img.logo {
      display: block;
      margin: 0 auto 20px auto;
      max-width: 160px;
      height: auto;
    }
    .reset-container h2 {
      margin-bottom: 10px;
      color: #850069;
      font-family: 'Josefin Sans', sans-serif;
    }
    .reset-container p {
      margin-bottom: 20px;
      font-size: 15px;
      color: #444;
    }
    .reset-container input {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 16px;
    }
    .reset-container button {
      margin-top: 20px;
      padding: 12px;
      background-color: #850069;
      color: white;
      border: none;
      border-radius: 6px;
      font-weight: bold;
      cursor: pointer;
      width: 100%;
      font-family: 'Josefin Sans', serif;
      font-size: 18px;
    }
    .reset-container button:hover {
      background-color: #BB9DC6;
    }
    .message {
      margin-top: 15px;
      font-weight: bold;
    }
    .message.success {
      color: #388e3c;
    }
    .message.error {
      color: #d32f2f;
    }
  </style>
</head>
<body>
<div class="reset-container">
  <img src="Assets/logo.png" alt="Terapia Logo" class="logo">
  <h2>Forgot Password</h2>
  <p>Enter your email to receive a reset link</p>

  <?php if ($success): ?>
    <div class="message success"><?= htmlspecialchars($success) ?></div>
  <?php elseif ($error): ?>
    <div class="message error"><?= htmlspecialchars($error) ?></div>
  <?php endif; ?>

  <form method="post">
    <input type="email" name="email" placeholder="Email address" required>
    <button type="submit">Send Reset Link</button>
  </form>
</div>
</body>
</html>