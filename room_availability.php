<?php require 'auth.php'; ?>
<?php
require 'db.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Room Availability</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="style.css">
  <link rel="stylesheet" href="assets/css/fontawesome.min.css">
  <link rel="stylesheet" href="assets/css/solid.min.css">
  <style>
    .main-content h2 {
      margin-bottom: 10px;
      font-size: 24px;
      color: #6a1b9a;
    }

    .main-content p {
      font-size: 16px;
      color: #555;
    }

    .iframe-wrapper {
      margin-top: 20px;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0,0,0,0.05);
      padding: 20px;
    }

    iframe {
      width: 100%;
      height: 1000px;
      border: none;
    }
  </style>
</head>
<body>
  <?php include 'header.php'; ?>
  <div class="dashboard-wrapper">
    <?php include 'sidebar.php'; ?>
    <div class="main-content">
      <h2>Room Availability & Booking</h2>
      <p>View live availability of rooms managed via Skedda. You can filter and book directly using the embedded calendar below.</p>
      <div class="iframe-wrapper">
        <iframe src="https://terapia.skedda.com/booking?embedded=true"></iframe>
      </div>
    </div>
  </div>
</body>
</html>