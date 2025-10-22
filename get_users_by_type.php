<?php
require 'auth.php';
require 'db.php';

$type = $_GET['type'] ?? '';
$map = [
  'trainees' => ['trainee_id', 'first_name', 'surname'],
  'tutors' => ['tutor_id', 'first_name', 'surname'],
  'staff' => ['staff_id', 'first_name', 'surname'],
  'supervisors' => ['supervisor_id', 'first_name', 'surname']
];

if (!isset($map[$type])) {
  http_response_code(400);
  echo json_encode([]);
  exit;
}

$idField = $map[$type][0];
$nameFields = array_slice($map[$type], 1);
$nameConcat = implode(",' ',", array_map(fn($f) => "COALESCE($f,'')", $nameFields));

$stmt = $pdo->prepare("
  SELECT $idField AS id, CONCAT($nameConcat) AS name
  FROM $type
  WHERE is_archived = 0
  ORDER BY name ASC
");
$stmt->execute();
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);

header('Content-Type: application/json');
echo json_encode($users);