<?php
require 'auth.php'; // Handles session start, timeout, and login enforcement

date_default_timezone_set('Europe/London');
$dbVersion = '0.2';

// Assign session phrase if not already set
if (!isset($_SESSION['session_phrase'])) {
    $phraseFile = 'assets/data/phrases.txt';
    if (file_exists($phraseFile)) {
        $phrases = file($phraseFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        if ($phrases) {
            $selectedPhrase = $phrases[array_rand($phrases)];
            $_SESSION['session_phrase'] = $selectedPhrase;

            try {
                $pdo = new PDO('mysql:host=localhost;port=3307;dbname=trainee_db', 'root', '', [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
                ]);
                $stmt = $pdo->prepare("INSERT INTO session_phrase_log (user_id, phrase, assigned_at) VALUES (?, ?, NOW())");
                $stmt->execute([$_SESSION['user_id'], $selectedPhrase]);
            } catch (PDOException $e) {
                error_log("Phrase logging failed: " . $e->getMessage());
            }
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Terapia – Trainee Database</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="style.css">
  <link rel="stylesheet" href="assets/css/sidebar.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;600&display=swap');

    .header-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: linear-gradient(to right, #6a1b9a, #7b1fa2);
      color: white;
      padding: 10px 20px;
      border-bottom: 1px solid #F3EAF5;
    }
    .header-left {
      display: flex;
      align-items: center;
    }
    .logo-box {
      background-color: #F3EAF5;
      padding: 6px;
      border-radius: 6px;
    }
    .logo-box img {
      height: 40px;
      vertical-align: middle;
    }
    .header-title-block {
      display: flex;
      flex-direction: column;
      margin-left: 10px;
      color: #F3EAF5;
      font-family: 'Josefin Sans', sans-serif;
    }
    .header-title {
      font-size: 1.8em;
      font-weight: 600;
      letter-spacing: 0.5px;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
    }
    .session-phrase-inline {
      font-size: 12px;
      margin-top: 10px;
      line-height: 1.3;
      font-style: italic;
      color: #F3EAF5;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
    }
    .header-right {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      text-align: right;
      flex-grow: 1;
    }
    .header-info {
      font-size: 13px;
      line-height: 1.4;
      margin-bottom: 6px;
    }
    .welcome-text {
      font-weight: 500;
      font-size: 14px;
    }
    .role-badge {
      background-color: #F3EAF5;
      color: #6a1b9a;
      font-size: 12px;
      padding: 2px 6px;
      border-radius: 12px;
      margin-left: 6px;
      font-weight: 600;
    }
    .meta-text {
      font-size: 12px;
      color: #e0e0e0;
    }
    .header-actions {
      display: flex;
      justify-content: space-between;
      width: 100%;
      max-width: 300px;
    }
    .logout-link,
    .quick-exit-link {
      color: white;
      text-decoration: none;
      font-weight: bold;
      font-size: 16px;
      padding: 6px 12px;
      border-radius: 4px;
      display: inline-block;
    }
    .logout-link {
      background-color: #4a148c;
    }
    .logout-link:hover {
      background-color: #7b1fa2;
      text-decoration: none;
    }
    .quick-exit-link {
      background-color: #d32f2f;
    }
    .quick-exit-link:hover {
      background-color: #b71c1c;
      text-decoration: none;
    }
  </style>
</head>
<body>
<div class="header-bar">
  <div class="header-left">
    <a href="dashboard.php" style="text-decoration: none;">
      <div class="logo-box">
        <img src="assets/logo.png" alt="Logo">
      </div>
    </a>
    <div class="header-title-block">
      <span class="header-title"><u>Terapia – Trainee Database</u></span>
      <?php if (isset($_SESSION['session_phrase'])): ?>
        <span class="session-phrase-inline">
          <em><strong>Your Unique Session Phrase:</strong><br>
          <?= htmlspecialchars($_SESSION['session_phrase']) ?></em>
        </span>
      <?php endif; ?>
    </div>
  </div>
  <div class="header-right">
    <div class="header-info">
      <span class="welcome-text">
        Welcome, <?= htmlspecialchars($_SESSION['name'] ?? 'User') ?>
        <span class="role-badge"><?= ucfirst($_SESSION['role'] ?? 'Guest') ?></span>
      </span><br>
      <span class="meta-text" title="Europe/London timezone">
        🕒 <strong>Local Time:</strong> <span id="liveClock">Loading…</span>
      </span><br>
      <span class="meta-text"><strong>DB Version:</strong> <?= htmlspecialchars($dbVersion) ?></span>
    </div>
    <div class="header-actions">
      <div class="quick-exit-wrapper">
        <a href="logout.php?quick_exit=1" class="quick-exit-link">Quick Exit</a>
      </div>
      <div class="logout-wrapper">
        <a href="logout.php" class="logout-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
      </div>
    </div>
  </div>
</div>

<?php if (isset($_SESSION['initiated']) && $_SESSION['initiated'] === true): ?>
  <?php include 'timeout_warning.php'; ?>
<?php endif; ?>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    function updateClock() {
      const now = new Date();
      const options = {
        weekday: 'long',
        day: 'numeric',
        month: 'long',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        hour12: false,
        timeZone: 'Europe/London'
      };
      const formatted = new Intl.DateTimeFormat('en-GB', options).format(now);
      const clockEl = document.getElementById('liveClock');
      if (clockEl) {
        clockEl.textContent = formatted;
      }
    }

    updateClock(); // Initial call
    setInterval(updateClock, 60000); // Update every minute
  });
</script>
</body>
</html>