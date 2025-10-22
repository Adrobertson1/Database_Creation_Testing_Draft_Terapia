<?php
require 'db.php';

$course_id = $_GET['course_id'] ?? '';
if ($course_id === '') {
  echo json_encode([]);
  exit;
}

$stmt = $pdo->prepare("SELECT module_id, module_name FROM modules WHERE course_id = ? ORDER BY module_name ASC");
$stmt->execute([$course_id]);
$modules = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($modules);