<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (!isset($_SESSION['initiated']) || $_SESSION['initiated'] !== 1) {
    header("Location: login.php");
    exit;
}
?>