<div class="sidebar-banner">
  <style>
    .sidebar-banner {
      width: 260px;
      height: 100vh;
      overflow-y: auto;
      background-color: #f8f9fa;
      border-right: 1px solid #ddd;
      padding: 20px;
      box-sizing: border-box;
      font-family: 'Segoe UI', sans-serif;
    }

    .sidebar-banner h3 {
      font-size: 20px;
      margin-bottom: 8px;
      color: #6a1b9a;
      text-align: center;
    }

    .role-label {
      font-size: 13px;
      color: #6a1b9a;
      margin-bottom: 20px;
      text-align: center;
    }

    .menu-section {
      display: flex;
      flex-direction: column;
      gap: 20px;
    }

    .sidebar-section h4 {
      font-size: 14px;
      text-transform: uppercase;
      color: #6a1b9a;
      margin-bottom: 8px;
      margin-top: 0;
    }

    .sidebar-section a {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 6px 10px;
      text-decoration: none;
      color: #6a1b9a;
      border-radius: 4px;
      transition: background 0.2s ease;
      font-size: 14px;
    }

    .sidebar-section a:hover {
      background-color: #e0d7ec;
      color: #4a148c;
    }

    .sidebar-section a.active {
      background-color: #d1c4e9;
      font-weight: bold;
    }

    .sidebar-section hr {
      margin: 12px 0;
      border: none;
      border-top: 1px solid #ddd;
    }

    .sidebar-section i {
      width: 18px;
      text-align: center;
    }
  </style>

  <?php $currentPage = basename($_SERVER['PHP_SELF']); ?>
  <h3>Dashboard Menu</h3>
  <div class="role-label">Logged in as: <?= ucfirst($_SESSION['role']) ?></div>
  <div class="menu-section">

    <div class="sidebar-section">
      <a href="dashboard.php" class="<?= $currentPage === 'dashboard.php' ? 'active' : '' ?>">
        <i class="fas fa-tachometer-alt"></i> Dashboard
      </a>
      <a href="calendar.php" class="<?= $currentPage === 'calendar.php' ? 'active' : '' ?>">
        <i class="fas fa-calendar-alt"></i> My Calendar
      </a>
      <a href="add_event.php" class="<?= $currentPage === 'add_event.php' ? 'active' : '' ?>">
        <i class="fas fa-plus-circle"></i> Add Calendar Event
      </a>
    </div>
    <?php if ($_SESSION['role'] === 'superuser'): ?>
  <div class="sidebar-section">
    <h4>Personnel</h4>
    <a href="trainees.php" class="<?= $currentPage === 'trainees.php' ? 'active' : '' ?>"><i class="fas fa-users"></i> Manage Trainees</a>
    <a href="tutors.php" class="<?= $currentPage === 'tutors.php' ? 'active' : '' ?>"><i class="fas fa-chalkboard-teacher"></i> Manage Tutors</a>
    <a href="staff.php" class="<?= $currentPage === 'staff.php' ? 'active' : '' ?>"><i class="fas fa-user-tie"></i> Manage Staff</a>
    <a href="supervisors.php" class="<?= $currentPage === 'supervisors.php' ? 'active' : '' ?>"><i class="fas fa-user-shield"></i> Manage Supervisors</a>
    <a href="manage_admins.php" class="<?= $currentPage === 'manage_admins.php' ? 'active' : '' ?>"><i class="fas fa-user-shield"></i> Manage Admins</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Courses</h4>
    <a href="courses.php" class="<?= $currentPage === 'courses.php' ? 'active' : '' ?>"><i class="fas fa-book"></i> Manage Courses</a>
    <a href="course_dashboard.php" class="<?= $currentPage === 'course_dashboard.php' ? 'active' : '' ?>"><i class="fas fa-chalkboard"></i> Course Dashboard</a>
    <a href="progress_trainee.php" class="<?= $currentPage === 'progress_trainee.php' ? 'active' : '' ?>"><i class="fas fa-route"></i> Trainee Course Progression</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Assignments</h4>
    <a href="assign_to_trainee.php" class="<?= $currentPage === 'assign_to_trainee.php' ? 'active' : '' ?>"><i class="fas fa-plus-circle"></i> Assign to Trainee</a>
    <a href="view_all_assignments.php" class="<?= $currentPage === 'view_all_assignments.php' ? 'active' : '' ?>"><i class="fas fa-tasks"></i> Manage Assignments</a>
    <a href="assignment_submissions.php" class="<?= $currentPage === 'assignment_submissions.php' ? 'active' : '' ?>"><i class="fas fa-marker"></i> Grade Submissions</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Supervision</h4>
    <a href="supervision_attendance_dashboard.php" class="<?= $currentPage === 'supervision_attendance_dashboard.php' ? 'active' : '' ?>"><i class="fas fa-user-check"></i> Attendance Dashboard</a>
    <a href="supervisor_allocations.php" class="<?= $currentPage === 'supervisor_allocations.php' ? 'active' : '' ?>"><i class="fas fa-user-tag"></i> Supervisor/Trainee Allocation</a>
    <a href="supervision_groups.php" class="<?= $currentPage === 'supervision_groups.php' ? 'active' : '' ?>"><i class="fas fa-users-cog"></i> Supervision Groups</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Rooms & Spaces</h4>
    <a href="room_availability.php" class="<?= $currentPage === 'room_availability.php' ? 'active' : '' ?>"><i class="fas fa-door-open"></i> Rooms & Spaces (Skedda)</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Safeguarding</h4>
    <a href="add_safeguarding.php" class="<?= $currentPage === 'add_safeguarding.php' ? 'active' : '' ?>"><i class="fas fa-shield-alt"></i> Log Safeguarding</a>
    <a href="alerts_dashboard.php" class="<?= $currentPage === 'alerts_dashboard.php' ? 'active' : '' ?>"><i class="fas fa-exclamation-triangle"></i> Unresolved Alerts</a>
    <a href="safeguarding_summary.php" class="<?= $currentPage === 'safeguarding_summary.php' ? 'active' : '' ?>"><i class="fas fa-chart-bar"></i> Summary Dashboard</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Reports</h4>
    <a href="generate_reports.php" class="<?= $currentPage === 'generate_reports.php' ? 'active' : '' ?>"><i class="fas fa-file-alt"></i> Generate Reports</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Account</h4>
    <a href="edit_staff.php?staff_id=<?= $_SESSION['user_id'] ?>" class="<?= $currentPage === 'edit_staff.php' ? 'active' : '' ?>"><i class="fas fa-user-cog"></i> Edit My Account</a>
    <a href="logout.php"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <hr>
  </div>
  <?php elseif ($_SESSION['role'] === 'staff' || $_SESSION['role'] === 'supervisor'): ?>
  <div class="sidebar-section">
    <h4>Assignments</h4>
    <a href="assign_to_trainee.php" class="<?= $currentPage === 'assign_to_trainee.php' ? 'active' : '' ?>"><i class="fas fa-plus-circle"></i> Assign to Trainee</a>
    <a href="view_all_assignments.php" class="<?= $currentPage === 'view_all_assignments.php' ? 'active' : '' ?>"><i class="fas fa-tasks"></i> Manage Assignments</a>
    <a href="assignment_submissions.php" class="<?= $currentPage === 'assignment_submissions.php' ? 'active' : '' ?>"><i class="fas fa-marker"></i> Grade Submissions</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Supervision</h4>
    <a href="supervision_attendance_dashboard.php" class="<?= $currentPage === 'supervision_attendance_dashboard.php' ? 'active' : '' ?>"><i class="fas fa-user-check"></i> Attendance Dashboard</a>
    <a href="supervisor_allocations.php" class="<?= $currentPage === 'supervisor_allocations.php' ? 'active' : '' ?>"><i class="fas fa-user-tag"></i> Supervisor/Trainee Allocation</a>
    <a href="supervision_groups.php" class="<?= $currentPage === 'supervision_groups.php' ? 'active' : '' ?>"><i class="fas fa-users-cog"></i> Supervision Groups</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Safeguarding</h4>
    <a href="add_safeguarding.php" class="<?= $currentPage === 'add_safeguarding.php' ? 'active' : '' ?>"><i class="fas fa-shield-alt"></i> Log Safeguarding</a>
    <a href="alerts_dashboard.php" class="<?= $currentPage === 'alerts_dashboard.php' ? 'active' : '' ?>"><i class="fas fa-exclamation-triangle"></i> Unresolved Alerts</a>
    <a href="safeguarding_summary.php" class="<?= $currentPage === 'safeguarding_summary.php' ? 'active' : '' ?>"><i class="fas fa-chart-bar"></i> Summary Dashboard</a>
    <hr>
  </div>

<?php elseif ($_SESSION['role'] === 'tutor'): ?>
  <div class="sidebar-section">
    <h4>Assignments</h4>
    <a href="assign_to_trainee.php" class="<?= $currentPage === 'assign_to_trainee.php' ? 'active' : '' ?>"><i class="fas fa-plus-circle"></i> Assign to Trainee</a>
    <a href="view_all_assignments.php" class="<?= $currentPage === 'view_all_assignments.php' ? 'active' : '' ?>"><i class="fas fa-tasks"></i> Manage Assignments</a>
    <a href="assignment_submissions.php" class="<?= $currentPage === 'assignment_submissions.php' ? 'active' : '' ?>"><i class="fas fa-marker"></i> Grade Submissions</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Supervision</h4>
    <a href="supervision_attendance_dashboard.php" class="<?= $currentPage === 'supervision_attendance_dashboard.php' ? 'active' : '' ?>"><i class="fas fa-user-check"></i> Attendance Dashboard</a>
    <a href="supervisor_allocations.php" class="<?= $currentPage === 'supervisor_allocations.php' ? 'active' : '' ?>"><i class="fas fa-user-tag"></i> Supervisor/Trainee Allocation</a>
    <a href="supervision_groups.php" class="<?= $currentPage === 'supervision_groups.php' ? 'active' : '' ?>"><i class="fas fa-users-cog"></i> View Supervision Groups</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Safeguarding</h4>
    <a href="add_safeguarding.php" class="<?= $currentPage === 'add_safeguarding.php' ? 'active' : '' ?>"><i class="fas fa-shield-alt"></i> Log Safeguarding</a>
    <hr>
  </div>
  <?php elseif ($_SESSION['role'] === 'trainee'): ?>
  <div class="sidebar-section">
    <h4>Assignments</h4>
    <a href="assignments.php" class="<?= $currentPage === 'assignments.php' ? 'active' : '' ?>"><i class="fas fa-file-alt"></i> My Assignments</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <a href="courses.php" class="<?= $currentPage === 'courses.php' ? 'active' : '' ?>"><i class="fas fa-book-reader"></i> My Courses</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Supervision</h4>
    <a href="supervision_attendance_dashboard.php" class="<?= $currentPage === 'supervision_attendance_dashboard.php' ? 'active' : '' ?>"><i class="fas fa-user-check"></i> Attendance Dashboard</a>
    <a href="supervision_groups.php" class="<?= $currentPage === 'supervision_groups.php' ? 'active' : '' ?>"><i class="fas fa-users-cog"></i> My Supervision Groups</a>
    <a href="view_individual_trainee_supervisor.php" class="<?= $currentPage === 'view_individual_trainee_supervisor.php' ? 'active' : '' ?>"><i class="fas fa-user-tag"></i> My Individual Supervisor</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Safeguarding</h4>
    <a href="add_safeguarding.php" class="<?= $currentPage === 'add_safeguarding.php' ? 'active' : '' ?>"><i class="fas fa-shield-alt"></i> Log Safeguarding</a>
    <hr>
  </div>

  <div class="sidebar-section">
    <h4>Rooms & Spaces</h4>
    <a href="room_availability.php" class="<?= $currentPage === 'room_availability.php' ? 'active' : '' ?>"><i class="fas fa-door-open"></i> Rooms & Spaces (Skedda)</a>
    <hr>
  </div>
<?php endif; ?>
  </div>
</div>