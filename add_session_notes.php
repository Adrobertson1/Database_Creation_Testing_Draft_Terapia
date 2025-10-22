<?php require 'auth.php'; ?>
<?php
require 'db.php';

if (!in_array($_SESSION['role'], ['superuser', 'admin', 'staff', 'supervisor'])) {
    die("Access denied.");
}

$session_id = $_GET['session_id'] ?? '';
$trainee_id = $_GET['trainee_id'] ?? '';

if (!$session_id || !$trainee_id) {
    die("Missing session or trainee ID.");
}

// Fetch session details
$sessionStmt = $pdo->prepare("
  SELECT s.session_date, s.session_time, s.session_type,
         t.first_name AS trainee_first, t.surname AS trainee_surname
  FROM supervision_sessions s
  JOIN supervision_session_trainees st ON s.session_id = st.session_id
  JOIN trainees t ON st.trainee_id = t.trainee_id
  WHERE s.session_id = ? AND t.trainee_id = ?
  LIMIT 1
");
$sessionStmt->execute([$session_id, $trainee_id]);
$session = $sessionStmt->fetch();

if (!$session) {
    die("Session not found or trainee not linked.");
}

// Handle new note submission
$success = false;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['add_note'])) {
        $notes = trim($_POST['notes']);
        if ($notes !== '') {
            $insertStmt = $pdo->prepare("
              INSERT INTO supervision_session_notes (session_id, trainee_id, supervisor_id, notes)
              VALUES (?, ?, ?, ?)
            ");
            $insertStmt->execute([$session_id, $trainee_id, $_SESSION['user_id'], $notes]);
            $success = true;
        }
    }

    // Handle edit
    if (isset($_POST['edit_note_id'])) {
        $note_id = $_POST['edit_note_id'];
        $updated = trim($_POST['edited_notes']);

        // Check if user is allowed to edit
        $checkStmt = $pdo->prepare("
          SELECT supervisor_id FROM supervision_session_notes
          WHERE id = ? AND trainee_id = ? AND session_id = ?
        ");
        $checkStmt->execute([$note_id, $trainee_id, $session_id]);
        $noteOwner = $checkStmt->fetchColumn();

        if ($noteOwner && ($noteOwner == $_SESSION['user_id'] || in_array($_SESSION['role'], ['superuser', 'admin', 'staff']))) {
            $updateStmt = $pdo->prepare("
              UPDATE supervision_session_notes
              SET notes = ?
              WHERE id = ?
            ");
            $updateStmt->execute([$updated, $note_id]);
            $success = true;
        }
    }

    // Handle delete
    if (isset($_POST['delete_note_id'])) {
        $note_id = $_POST['delete_note_id'];

        // Check if user is allowed to delete
        $checkStmt = $pdo->prepare("
          SELECT supervisor_id FROM supervision_session_notes
          WHERE id = ? AND trainee_id = ? AND session_id = ?
        ");
        $checkStmt->execute([$note_id, $trainee_id, $session_id]);
        $noteOwner = $checkStmt->fetchColumn();

        if ($noteOwner && ($noteOwner == $_SESSION['user_id'] || in_array($_SESSION['role'], ['superuser', 'admin', 'staff']))) {
            $deleteStmt = $pdo->prepare("
              DELETE FROM supervision_session_notes
              WHERE id = ?
            ");
            $deleteStmt->execute([$note_id]);
            $success = true;
        }
    }
}

// Fetch existing notes
$notesStmt = $pdo->prepare("
  SELECT n.id, n.notes, n.created_at, n.supervisor_id,
         s.first_name AS supervisor_first, s.surname AS supervisor_surname
  FROM supervision_session_notes n
  LEFT JOIN supervisors s ON n.supervisor_id = s.supervisor_id
  WHERE n.session_id = ? AND n.trainee_id = ?
  ORDER BY n.created_at DESC
");
$notesStmt->execute([$session_id, $trainee_id]);
$existingNotes = $notesStmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Session Notes for <?= htmlspecialchars($session['trainee_first'] . ' ' . $session['trainee_surname']) ?></title>
  <link rel="stylesheet" href="style.css">
  <style>
    body { font-family: 'Inter', sans-serif; background: #f4f4f4; padding: 40px; }
    h2 { color: #6a1b9a; font-family: 'Josefin Sans', sans-serif; }
    .form-box, .notes-box { background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); max-width: 700px; margin-bottom: 30px; }
    label { font-weight: bold; display: block; margin-bottom: 8px; }
    textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-family: 'Inter', sans-serif; }
    button { margin-top: 10px; padding: 8px 14px; background-color: #6a1b9a; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; }
    button:hover { background-color: #4a148c; }
    .success-box { background-color: #dff0d8; border-left: 6px solid #3c763d; padding: 16px; margin-bottom: 20px; border-radius: 6px; }
    .btn-back { display: inline-block; margin-top: 20px; padding: 8px 14px; background-color: #6a1b9a; color: white; border-radius: 4px; text-decoration: none; }
    .btn-back:hover { background-color: #4a148c; }
    .note-entry { margin-bottom: 20px; border-bottom: 1px solid #ccc; padding-bottom: 10px; }
    .note-meta { font-size: 14px; color: #555; margin-bottom: 6px; }
    .note-text { margin-bottom: 10px; }
  </style>
</head>
<body>
  <h2>Session Notes for <?= htmlspecialchars($session['trainee_first'] . ' ' . $session['trainee_surname']) ?></h2>

  <div class="form-box">
    <p><strong>Session Date:</strong> <?= date('Y-m-d', strtotime($session['session_date'])) ?></p>
    <p><strong>Time:</strong> <?= date('H:i', strtotime($session['session_time'])) ?></p>
    <p><strong>Type:</strong> <?= ucfirst($session['session_type']) ?></p>

    <?php if ($success): ?>
      <div class="success-box">✅ Changes saved successfully.</div>
    <?php endif; ?>

    <form method="post">
      <label for="notes">Add New Note</label>
      <textarea name="notes" rows="6" required></textarea>
      <button type="submit" name="add_note">Save Note</button>
    </form>
  </div>

  <?php if ($existingNotes): ?>
    <div class="notes-box">
      <h3>Existing Notes</h3>
      <?php foreach ($existingNotes as $note): ?>
        <div class="note-entry">
          <div class="note-meta">
            <?= date('Y-m-d H:i', strtotime($note['created_at'])) ?> —
            <?= htmlspecialchars($note['supervisor_first'] . ' ' . $note['supervisor_surname']) ?>
          </div>
          <div class="note-text"><?= nl2br(htmlspecialchars($note['notes'])) ?></div>

          <?php
            $canEdit = ($_SESSION['user_id'] === $note['supervisor_id']) || in_array($_SESSION['role'], ['superuser', 'admin', 'staff']);
          ?>

          <?php if ($canEdit): ?>
            <form method="post" style="margin-top:10px;">
              <input type="hidden" name="edit_note_id" value="<?= $note['id'] ?>">
              <textarea name="edited_notes" rows="4"><?= htmlspecialchars($note['notes']) ?></textarea>
              <button type="submit">Update</button>
            </form>

            <form method="post" style="margin-top:10px;">
              <input type="hidden" name="delete_note_id" value="<?= $note['id'] ?>">
              <button type="submit" onclick="return confirm('Delete this note?')">Delete</button>
            </form>
          <?php endif; ?>
        </div>
      <?php endforeach; ?>
    </div>
  <?php endif; ?>

<a href="view_supervision_attendance.php?trainee_id=<?= urlencode($trainee_id) ?>" class="btn-back">← Back to Attendance</a>