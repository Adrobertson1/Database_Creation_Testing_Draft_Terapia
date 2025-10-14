-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Oct 14, 2025 at 05:37 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `trainee_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sync_tutor_identity` ()   BEGIN
  -- Insert missing tutors into users
  INSERT INTO users (user_id, role, email)
  SELECT t.tutor_id, 'tutor', t.email
  FROM tutors t
  LEFT JOIN users u ON t.tutor_id = u.user_id
  WHERE t.user_id IS NULL AND u.user_id IS NULL;

  -- Update tutors.user_id to match tutor_id
  UPDATE tutors
  SET user_id = tutor_id
  WHERE user_id IS NULL;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `assignments`
--

CREATE TABLE `assignments` (
  `assignment_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `tutor_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `assignments`
--

INSERT INTO `assignments` (`assignment_id`, `course_id`, `tutor_id`, `title`, `description`, `due_date`, `type_id`) VALUES
(1, 1, 1, 'Dissertation: Trauma-Informed Practice', 'Extended research project on trauma-informed therapeutic models.', '2025-10-15', 8),
(2, 1, 1, 'Essay: Exploring Attachment Theory', 'Written response on attachment theory in child development.', '2025-10-10', 1),
(3, 1, 1, 'Portfolio: Therapeutic Techniques', 'Collection of work demonstrating progress in therapeutic methods.', '2025-10-12', 2),
(4, 1, 1, 'Reflective Journal: Week 1', 'Personal reflection on therapeutic practice during week 1.', '2025-10-14', 3),
(5, 1, 1, 'Presentation: Trauma-Informed Schools', 'Oral presentation on trauma-informed approaches in education.', '2025-10-16', 4),
(6, 1, 1, 'Client Audio: Session Review', 'Audio recording of client session for supervision.', '2025-10-18', 5),
(7, 1, 1, 'Client Artwork: Emotional Expression', 'Visual artwork produced by client exploring emotional themes.', '2025-10-20', 6),
(8, 1, 1, 'Mini Viva: Ethics in Practice', 'Short oral examination on ethical dilemmas in therapy.', '2025-10-22', 7),
(9, 1, 1, 'Dissertation: Trauma-Informed Practice', 'Extended written research project on trauma-informed therapeutic models.', '2025-10-24', 8),
(10, 1, 1, 'Other: Case Study Analysis', 'Any assignment type not listed above—case study on complex trauma.', '2025-10-26', 9),
(11, 1, 1, 'Essay: Exploring Attachment Theory', 'Written response on attachment theory in child development.', '2025-10-10', 1),
(12, 1, 1, 'Portfolio: Therapeutic Techniques', 'Collection of work demonstrating progress in therapeutic methods.', '2025-10-12', 2),
(13, 1, 1, 'Reflective Journal: Week 1', 'Personal reflection on therapeutic practice during week 1.', '2025-10-14', 3),
(14, 1, 1, 'Presentation: Trauma-Informed Schools', 'Oral presentation on trauma-informed approaches in education.', '2025-10-16', 4),
(15, 1, 1, 'Client Audio: Session Review', 'Audio recording of client session for supervision.', '2025-10-18', 5),
(16, 1, 1, 'Client Artwork: Emotional Expression', 'Visual artwork produced by client exploring emotional themes.', '2025-10-20', 6),
(17, 1, 1, 'Mini Viva: Ethics in Practice', 'Short oral examination on ethical dilemmas in therapy.', '2025-10-22', 7),
(18, 1, 1, 'Dissertation: Trauma-Informed Practice', 'Extended written research project on trauma-informed therapeutic models.', '2025-10-24', 8),
(19, 1, 1, 'Other: Case Study Analysis', 'Any assignment type not listed above—case study on complex trauma.', '2025-10-26', 9);

-- --------------------------------------------------------

--
-- Table structure for table `assignment_logs`
--

CREATE TABLE `assignment_logs` (
  `log_id` int(11) NOT NULL,
  `action` varchar(50) DEFAULT NULL,
  `assignment_id` int(11) DEFAULT NULL,
  `actor_id` int(11) DEFAULT NULL,
  `user_type` varchar(20) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `trainee_name` varchar(255) DEFAULT NULL,
  `assignment_type` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `assignment_logs`
--

INSERT INTO `assignment_logs` (`log_id`, `action`, `assignment_id`, `actor_id`, `user_type`, `timestamp`, `trainee_name`, `assignment_type`) VALUES
(1, 'deleted', 2, 1, 'superuser', '2025-09-15 22:06:57', NULL, NULL),
(2, 'deleted', 3, 1, 'superuser', '2025-09-15 22:09:27', NULL, NULL),
(3, 'deleted', 4, 1, 'superuser', '2025-09-15 22:09:55', NULL, NULL),
(4, 'deleted', 5, 1, 'superuser', '2025-09-15 22:17:58', 'Test1 Trainee', 'Client - Audio'),
(5, 'deleted', 10, 1, 'superuser', '2025-09-15 22:27:31', 'Test1 Trainee', 'Mini_Viva'),
(6, 'deleted', 6, 1, 'superuser', '2025-09-15 22:27:33', 'Test1 Trainee', 'Presentation'),
(7, 'deleted', 7, 1, 'superuser', '2025-09-15 22:27:36', 'Test1 Trainee', 'Client - Artwork'),
(8, 'deleted', 14, 1, 'superuser', '2025-09-15 23:31:11', 'Geron TESTINGTRAINEE', 'Client - Audio'),
(9, 'course_deleted', 14, 1, 'superuser', '2025-09-19 09:07:17', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `assignment_submissions`
--

CREATE TABLE `assignment_submissions` (
  `submission_id` int(11) NOT NULL,
  `assignment_id` int(11) NOT NULL,
  `trainee_id` varchar(8) NOT NULL,
  `submitted_date` date NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('submitted','graded','late') DEFAULT 'submitted',
  `grade` varchar(10) DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `score_percent` decimal(5,2) DEFAULT NULL,
  `pass_status` enum('Pass','Fail') DEFAULT NULL,
  `feedback_text` text DEFAULT NULL,
  `feedback_file` varchar(255) DEFAULT NULL,
  `graded_by` int(11) DEFAULT NULL,
  `graded_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `assignment_submissions`
--

INSERT INTO `assignment_submissions` (`submission_id`, `assignment_id`, `trainee_id`, `submitted_date`, `file_path`, `notes`, `status`, `grade`, `feedback`, `score_percent`, `pass_status`, `feedback_text`, `feedback_file`, `graded_by`, `graded_at`) VALUES
(1, 8, 'PSJ2UC5H', '2025-09-23', 'uploads/add_safeguarding.txt', NULL, 'graded', NULL, 'TEST_Submission_Trainee_1', 65.00, 'Pass', '', NULL, 1, '2025-09-23 23:24:00'),
(2, 6, 'BW4Q86I3', '2025-09-23', 'uploads/add_safeguarding.txt', NULL, 'graded', NULL, 'Trainee_4_Test_Submission_Assignment', 64.00, 'Pass', 'Good', NULL, 1, '2025-09-23 23:20:20'),
(3, 6, 'BW4Q86I3', '2025-09-23', 'uploads/add_safeguarding.txt', NULL, 'submitted', NULL, 'Trainee_4_Test_Submission_Assignment', NULL, NULL, NULL, NULL, NULL, NULL),
(4, 6, 'BW4Q86I3', '2025-09-23', 'uploads/MA DISSERTATION Tracing Trauma From the Home Through the Ghetto, to the Camp and to Liberation..pdf', NULL, 'submitted', NULL, 'Essay Test', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Stand-in structure for view `assignment_tracker`
-- (See below for the actual view)
--
CREATE TABLE `assignment_tracker` (
`assignment_id` int(11)
,`trainee_id` varchar(8)
,`trainee_name` varchar(101)
,`type_name` varchar(100)
,`assigned_date` date
,`due_date` date
,`status` enum('pending','submitted','graded')
,`assigned_by` varchar(100)
,`created_at` datetime
,`updated_at` datetime
);

-- --------------------------------------------------------

--
-- Table structure for table `assignment_types`
--

CREATE TABLE `assignment_types` (
  `type_id` int(11) NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `assignment_types`
--

INSERT INTO `assignment_types` (`type_id`, `type_name`, `description`, `is_active`) VALUES
(1, 'Essay', 'Written response on a topic or theme', 1),
(2, 'Portfolio', 'Collection of work demonstrating progress or competency', 1),
(3, 'Reflective Journal', 'Personal reflection on therapeutic practice', 1),
(4, 'Presentation', 'Oral or visual presentation of a topic', 1),
(5, 'Client - Audio', 'Audio recording of client session or interaction', 1),
(6, 'Client - Artwork', 'Visual artwork produced by or about a client', 1),
(7, 'Mini_Viva', 'Short oral examination or discussion', 1),
(8, 'Dissertation', 'Extended written research project', 1),
(9, 'Other', 'Any assignment type not listed above', 1);

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `table_name` varchar(100) DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  `action_detail` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `details` text DEFAULT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`log_id`, `user_id`, `role`, `action_type`, `table_name`, `record_id`, `action_detail`, `ip_address`, `timestamp`, `details`, `staff_id`, `action`) VALUES
(1, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:00:29', NULL, 1, 'logout'),
(2, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:00:37', NULL, 1, 'logout'),
(3, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:12:41', NULL, 1, 'logout'),
(4, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:12:49', NULL, 5, 'logout'),
(5, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:29:56', NULL, 5, 'logout'),
(6, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:36:52', NULL, 1, 'logout'),
(7, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:37:54', NULL, 6, 'logout'),
(8, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:42:37', NULL, 1, 'logout'),
(9, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:42:50', NULL, 7, 'logout'),
(10, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:45:25', NULL, 1, 'logout'),
(11, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:46:29', NULL, 8, 'logout'),
(12, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:49:36', NULL, 1, 'logout'),
(13, NULL, 'superuser', 'system', NULL, NULL, 'Assigned tutor ID 1 to trainee ID 12', '::1', '2025-09-16 19:52:21', NULL, 1, 'assign_tutor'),
(14, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-16 19:52:58', NULL, 1, 'logout'),
(15, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-17 17:00:50', NULL, 1, 'logout'),
(16, NULL, 'superuser', 'system', NULL, NULL, 'Created Tutorial event for user ID 1', '::1', '2025-09-17 17:26:41', NULL, 1, 'add_event'),
(17, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-18 11:50:18', NULL, 1, 'logout'),
(18, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-18 16:27:24', NULL, 1, 'logout'),
(19, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-18 16:28:34', NULL, 1, 'logout'),
(20, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 13:24:20', NULL, 1, 'logout'),
(21, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 13:26:41', NULL, 1, 'logout'),
(22, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 13:33:30', NULL, 1, 'logout'),
(24, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 14:02:32', NULL, 1, 'logout'),
(25, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 14:15:56', NULL, 1, 'logout'),
(26, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 14:22:23', NULL, 1, 'logout'),
(27, 3, 'tutor', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 14:31:44', NULL, NULL, 'logout'),
(28, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 15:17:57', NULL, 1, 'logout'),
(29, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 15:19:05', NULL, 5, 'logout'),
(30, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 15:20:46', NULL, 5, 'logout'),
(31, NULL, 'superuser', 'system', NULL, NULL, 'Assigned tutor ID 3 to trainee ID PSJ2UC5H', '::1', '2025-09-19 17:00:28', NULL, 1, 'assign_tutor'),
(32, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-19 18:24:06', NULL, 1, 'logout'),
(33, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-22 16:02:29', NULL, 1, 'logout'),
(34, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-22 16:08:46', NULL, 1, 'logout'),
(35, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for alex@terapia.co.uk', '::1', '2025-09-22 16:08:51', NULL, NULL, NULL),
(36, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-22 16:08:58', NULL, NULL, NULL),
(37, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 14:42:01', NULL, NULL, NULL),
(38, NULL, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 14:42:45', NULL, 1, 'logout'),
(40, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 14:44:02', NULL, NULL, NULL),
(41, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 14:44:54', NULL, NULL, NULL),
(42, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for trainee4@terapia.co.uk', '::1', '2025-09-23 16:14:06', NULL, NULL, NULL),
(43, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 16:14:14', NULL, NULL, NULL),
(44, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for alex@terapia.co.uk', '::1', '2025-09-23 16:45:32', NULL, NULL, NULL),
(45, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 16:45:44', NULL, NULL, NULL),
(46, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 18:09:35', NULL, NULL, 'logout'),
(47, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 18:09:51', NULL, NULL, NULL),
(48, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 18:13:20', NULL, NULL, 'logout'),
(49, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 18:13:26', NULL, NULL, NULL),
(50, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 18:43:40', NULL, NULL, NULL),
(51, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:05:39', NULL, NULL, NULL),
(52, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:14:20', NULL, NULL, 'logout'),
(53, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:14:29', NULL, NULL, NULL),
(54, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:14:49', NULL, NULL, 'logout'),
(55, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:19:53', NULL, NULL, NULL),
(56, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:19:55', NULL, NULL, 'logout'),
(57, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:20:03', NULL, NULL, NULL),
(58, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:20:05', NULL, NULL, 'logout'),
(59, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:22:42', NULL, NULL, NULL),
(60, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:22:44', NULL, NULL, 'logout'),
(61, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:22:51', NULL, NULL, NULL),
(62, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:22:52', NULL, NULL, 'logout'),
(63, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:24:36', NULL, NULL, NULL),
(64, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:24:38', NULL, NULL, 'logout'),
(65, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:26:21', NULL, NULL, NULL),
(66, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:26:22', NULL, NULL, 'logout'),
(67, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:26:27', NULL, NULL, NULL),
(68, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:32:01', NULL, NULL, 'logout'),
(69, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:34:35', NULL, NULL, NULL),
(70, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:52:48', NULL, NULL, 'logout'),
(71, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:53:01', NULL, NULL, NULL),
(72, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:53:36', NULL, NULL, 'logout'),
(73, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:55:08', NULL, NULL, NULL),
(74, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 21:56:37', NULL, NULL, 'logout'),
(75, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 21:56:43', NULL, NULL, NULL),
(76, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 22:00:28', NULL, NULL, 'logout'),
(77, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 22:00:40', NULL, NULL, NULL),
(78, 1, 'superuser', 'system', NULL, NULL, 'Quick exit triggered', '::1', '2025-09-23 22:02:04', NULL, NULL, 'logout'),
(79, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 22:02:13', NULL, NULL, NULL),
(80, 1, 'superuser', 'system', NULL, NULL, 'Quick exit triggered', '::1', '2025-09-23 22:03:54', NULL, NULL, 'logout'),
(81, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 22:04:04', NULL, NULL, NULL),
(82, 0, 'trainee', 'system', NULL, NULL, 'Quick exit triggered', '::1', '2025-09-23 22:04:07', NULL, NULL, 'logout'),
(83, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 22:05:33', NULL, NULL, NULL),
(84, 1, 'superuser', 'system', NULL, NULL, 'Graded submission ID 1 with 80% (Pass)', '::1', '2025-09-23 22:12:43', NULL, NULL, 'grade_submission'),
(85, 1, 'superuser', 'system', NULL, NULL, 'Graded submission ID 1 with 40% (Fail)', '::1', '2025-09-23 22:15:18', NULL, NULL, 'grade_submission'),
(86, 1, 'superuser', 'system', NULL, NULL, 'Graded submission ID 2 with 64% (Pass)', '::1', '2025-09-23 22:20:20', NULL, NULL, 'grade_submission'),
(87, 1, 'superuser', 'system', NULL, NULL, 'Graded submission ID 1 with 65% (Pass)', '::1', '2025-09-23 22:24:00', NULL, NULL, 'grade_submission'),
(88, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 22:36:21', NULL, NULL, 'logout'),
(89, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 22:36:28', NULL, NULL, NULL),
(90, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 22:45:20', NULL, NULL, 'logout'),
(91, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 22:45:25', NULL, NULL, NULL),
(92, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-23 22:54:07', NULL, NULL, 'logout'),
(93, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-23 22:54:14', NULL, NULL, NULL),
(94, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-24 08:25:28', NULL, NULL, NULL),
(95, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-24 09:37:40', NULL, NULL, NULL),
(96, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-24 09:57:39', NULL, NULL, 'logout'),
(97, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-24 14:57:52', NULL, NULL, NULL),
(98, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-24 14:58:31', NULL, NULL, 'logout'),
(99, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-24 14:58:42', NULL, NULL, NULL),
(100, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-24 16:23:52', NULL, NULL, NULL),
(101, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-24 17:37:54', NULL, NULL, NULL),
(102, 1, 'superuser', 'system', NULL, NULL, 'Quick exit triggered', '::1', '2025-09-24 17:38:25', NULL, NULL, 'logout'),
(103, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-24 19:52:23', NULL, NULL, 'logout'),
(104, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-24 19:52:44', NULL, NULL, NULL),
(105, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-24 20:16:08', NULL, NULL, 'logout'),
(106, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-24 20:16:14', NULL, NULL, NULL),
(107, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-24 21:05:43', NULL, NULL, 'logout'),
(108, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-25 11:27:01', NULL, NULL, NULL),
(109, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-25 11:27:01', NULL, NULL, NULL),
(110, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-25 13:16:18', NULL, NULL, NULL),
(111, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-25 13:26:39', NULL, NULL, 'logout'),
(112, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-25 13:26:46', NULL, NULL, NULL),
(113, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-25 13:46:18', NULL, NULL, 'logout'),
(114, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-25 13:46:33', NULL, NULL, NULL),
(115, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-25 13:47:03', NULL, NULL, 'logout'),
(116, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-25 13:47:09', NULL, NULL, NULL),
(117, 0, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-25 13:59:32', NULL, NULL, 'logout'),
(118, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-25 13:59:38', NULL, NULL, NULL),
(119, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-25 17:16:23', NULL, NULL, NULL),
(120, 13, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-25 18:31:24', NULL, NULL, 'logout'),
(121, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-25 18:31:35', NULL, NULL, NULL),
(122, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-26 11:47:53', NULL, NULL, 'logout'),
(123, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-26 11:48:05', NULL, NULL, NULL),
(124, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-26 12:01:27', NULL, NULL, NULL),
(125, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-26 13:49:07', NULL, NULL, 'logout'),
(126, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-26 13:49:14', NULL, NULL, NULL),
(127, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-26 13:52:06', NULL, NULL, 'logout'),
(128, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-26 13:52:13', NULL, NULL, NULL),
(129, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-26 14:18:30', NULL, NULL, 'logout'),
(130, 6, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-26 14:19:04', NULL, NULL, NULL),
(131, 6, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-26 14:19:09', NULL, NULL, 'logout'),
(132, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-26 14:19:17', NULL, NULL, NULL),
(133, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-26 14:39:11', NULL, NULL, 'logout'),
(134, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-26 14:39:19', NULL, NULL, NULL),
(135, 13, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-26 14:39:34', NULL, NULL, 'logout'),
(136, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-26 14:39:40', NULL, NULL, NULL),
(137, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-26 15:48:08', NULL, NULL, NULL),
(138, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-27 13:07:50', NULL, NULL, NULL),
(139, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-09-27 13:08:18', NULL, NULL, 'logout'),
(140, 6, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-28 09:39:21', NULL, NULL, NULL),
(141, 6, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-28 10:42:05', NULL, NULL, NULL),
(142, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-28 19:38:34', NULL, NULL, NULL),
(143, 7, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-29 15:45:05', NULL, NULL, NULL),
(144, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-29 17:26:56', NULL, NULL, NULL),
(145, 7, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-30 11:54:13', NULL, NULL, NULL),
(146, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-30 13:00:38', NULL, NULL, NULL),
(147, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-30 13:23:30', NULL, NULL, NULL),
(148, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-30 14:25:45', NULL, NULL, NULL),
(149, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-09-30 16:29:03', NULL, NULL, NULL),
(150, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-01 11:27:01', NULL, NULL, NULL),
(151, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for alex@terapia.co.uk', '::1', '2025-10-01 13:57:51', NULL, NULL, NULL),
(152, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-01 13:58:05', NULL, NULL, NULL),
(153, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-01 14:01:27', NULL, NULL, NULL),
(154, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-01 17:53:24', NULL, NULL, NULL),
(155, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-01 21:13:46', NULL, NULL, 'logout'),
(156, 3, 'tutor', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-01 21:13:53', NULL, NULL, NULL),
(157, 3, 'tutor', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-01 21:22:12', NULL, NULL, 'logout'),
(158, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-01 21:22:17', NULL, NULL, NULL),
(159, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-01 21:27:53', NULL, NULL, 'logout'),
(160, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for tutor_5_test@terapia.co.uk', '::1', '2025-10-01 21:28:05', NULL, NULL, NULL),
(161, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for tutor_5_test@terapia.co.uk', '::1', '2025-10-01 21:28:16', NULL, NULL, NULL),
(162, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for tutor_5_test@terapia.co.uk', '::1', '2025-10-01 21:28:25', NULL, NULL, NULL),
(163, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for tutor_5_test@terapia.co.uk', '::1', '2025-10-01 21:28:38', NULL, NULL, NULL),
(164, 3, 'tutor', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-01 21:28:50', NULL, NULL, NULL),
(165, 3, 'tutor', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-01 21:29:25', NULL, NULL, 'logout'),
(166, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for trainee5@terapia.co.uk', '::1', '2025-10-01 21:29:40', NULL, NULL, NULL),
(167, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for trainee5@terapia.co.uk', '::1', '2025-10-01 21:29:53', NULL, NULL, NULL),
(168, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-01 21:30:04', NULL, NULL, NULL),
(169, 13, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-01 21:30:25', NULL, NULL, 'logout'),
(170, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-01 21:30:31', NULL, NULL, NULL),
(171, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 07:29:50', NULL, NULL, NULL),
(172, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 07:37:56', NULL, NULL, NULL),
(173, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-02 07:39:03', NULL, NULL, 'logout'),
(174, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 07:39:13', NULL, NULL, NULL),
(175, 6, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 10:00:45', NULL, NULL, NULL),
(176, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 10:04:51', NULL, NULL, NULL),
(177, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-02 10:27:29', NULL, NULL, 'logout'),
(178, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for supervisor4@terapia.co.uk', '::1', '2025-10-02 10:27:43', NULL, NULL, NULL),
(179, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for supervisor5@terapia.co.uk', '::1', '2025-10-02 10:27:56', NULL, NULL, NULL),
(180, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for supervisor2@terapia.co.uk', '::1', '2025-10-02 10:28:06', NULL, NULL, NULL),
(181, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for tutor_4_test@terapia.co.uk', '::1', '2025-10-02 10:28:21', NULL, NULL, NULL),
(182, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 10:28:26', NULL, NULL, NULL),
(183, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-02 10:29:03', NULL, NULL, 'logout'),
(184, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for supervisor5@terapia.co.uk', '::1', '2025-10-02 10:29:09', NULL, NULL, NULL),
(185, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for supervisor5@terapia.co.uk', '::1', '2025-10-02 10:29:17', NULL, NULL, NULL),
(186, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 10:29:26', NULL, NULL, NULL),
(187, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-02 11:05:31', NULL, NULL, 'logout'),
(188, 15, 'tutor', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 11:05:37', NULL, NULL, NULL),
(189, 15, 'tutor', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-02 11:06:47', NULL, NULL, 'logout'),
(190, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 11:06:52', NULL, NULL, NULL),
(191, 8, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 12:49:35', NULL, NULL, NULL),
(192, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 13:16:52', NULL, NULL, NULL),
(193, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-02 13:22:07', NULL, NULL, 'logout'),
(194, 11, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 13:22:16', NULL, NULL, NULL),
(195, 11, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-02 13:27:12', NULL, NULL, 'logout'),
(196, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 13:27:18', NULL, NULL, NULL),
(197, 11, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 14:30:10', NULL, NULL, NULL),
(198, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 19:00:29', NULL, NULL, NULL),
(199, 1, 'superuser', 'system', NULL, NULL, 'Quick exit triggered', '::1', '2025-10-02 19:09:54', NULL, NULL, 'logout'),
(200, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 19:10:20', NULL, NULL, NULL),
(201, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 19:16:55', NULL, NULL, NULL),
(202, 1, 'superuser', 'system', NULL, NULL, 'Created Meeting event for user ID 13', '::1', '2025-10-02 19:20:48', NULL, NULL, 'add_event'),
(203, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-02 19:21:40', NULL, NULL, 'logout'),
(204, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-02 19:21:51', NULL, NULL, NULL),
(205, 13, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-02 19:22:29', NULL, NULL, 'logout'),
(206, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for nuggets@test.com', '::1', '2025-10-02 19:24:54', NULL, NULL, NULL),
(207, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for nuggets@test.com', '::1', '2025-10-02 19:37:38', NULL, NULL, NULL),
(208, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 12:30:23', NULL, NULL, NULL),
(209, 13, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 12:31:41', NULL, NULL, 'logout'),
(210, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 13:53:18', NULL, NULL, 'logout'),
(211, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 13:58:38', NULL, NULL, NULL),
(212, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 13:59:51', NULL, NULL, 'logout'),
(213, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 14:06:31', NULL, NULL, NULL),
(214, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 14:21:23', NULL, NULL, 'logout'),
(215, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 14:21:28', NULL, NULL, NULL),
(216, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 14:24:42', NULL, NULL, 'logout'),
(217, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 14:24:50', NULL, NULL, NULL),
(218, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 14:24:56', NULL, NULL, NULL),
(219, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 14:25:07', NULL, NULL, NULL),
(220, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 14:47:48', NULL, NULL, 'logout'),
(221, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 14:47:55', NULL, NULL, NULL),
(222, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 14:48:06', NULL, NULL, NULL),
(223, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 15:00:42', NULL, NULL, 'logout'),
(224, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 15:00:47', NULL, NULL, NULL),
(225, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 15:02:57', NULL, NULL, 'logout'),
(226, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 15:03:02', NULL, NULL, NULL),
(227, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 15:08:05', NULL, NULL, 'logout'),
(228, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 15:08:10', NULL, NULL, NULL),
(229, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 15:10:24', NULL, NULL, NULL),
(230, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 15:41:01', NULL, NULL, 'logout'),
(231, 12, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 15:41:12', NULL, NULL, NULL),
(232, 12, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 15:43:15', NULL, NULL, 'logout'),
(233, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 15:43:21', NULL, NULL, NULL),
(234, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 15:55:28', NULL, NULL, 'logout'),
(235, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-03 17:20:16', 'Password reset via token', NULL, 'password_reset'),
(236, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for alex@terapia.co.uk', '::1', '2025-10-03 16:20:24', NULL, NULL, NULL),
(237, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for alex@terapia.co.uk', '::1', '2025-10-03 16:20:31', NULL, NULL, NULL),
(238, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-03 17:28:10', 'Password reset via token', NULL, 'password_reset'),
(239, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 16:28:29', NULL, NULL, NULL),
(240, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 16:36:31', NULL, NULL, 'logout'),
(241, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-03 17:43:18', 'Password reset via token', NULL, 'password_reset'),
(242, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 16:43:35', NULL, NULL, NULL),
(243, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-03 16:47:52', NULL, NULL, 'logout'),
(244, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-03 17:54:56', 'Password reset via token', NULL, 'password_reset'),
(245, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 16:55:14', NULL, NULL, NULL),
(246, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 17:04:47', NULL, NULL, NULL),
(247, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 17:43:26', NULL, NULL, NULL),
(248, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 18:33:53', NULL, NULL, NULL),
(249, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 19:16:32', NULL, NULL, NULL),
(250, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-03 19:27:34', NULL, NULL, NULL),
(251, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-04 19:17:04', NULL, NULL, NULL),
(252, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-04 22:15:53', NULL, NULL, NULL),
(253, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-04 23:02:21', NULL, NULL, NULL),
(254, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-05 19:58:48', NULL, NULL, NULL),
(255, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-06 12:00:05', NULL, NULL, NULL),
(256, 7, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-06 15:56:45', NULL, NULL, NULL),
(257, 11, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-06 16:18:00', NULL, NULL, NULL),
(258, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-06 19:58:15', NULL, NULL, NULL),
(259, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-07 13:16:21', NULL, NULL, NULL),
(260, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-07 14:31:06', NULL, NULL, NULL),
(261, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-07 14:57:55', NULL, NULL, 'logout'),
(262, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-07 14:58:01', NULL, NULL, NULL),
(263, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-07 19:24:13', NULL, NULL, NULL),
(264, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-08 17:19:14', NULL, NULL, NULL),
(265, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-08 17:33:20', NULL, NULL, 'logout'),
(266, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-09 14:21:28', NULL, NULL, NULL),
(267, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-09 19:02:06', NULL, NULL, NULL),
(268, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-10 16:40:29', NULL, NULL, NULL),
(269, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-10 17:12:51', NULL, NULL, 'logout'),
(270, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for trainee7@terapia.co.uk', '::1', '2025-10-10 17:12:59', NULL, NULL, NULL),
(271, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-10 17:13:07', NULL, NULL, NULL),
(272, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-10 17:20:22', NULL, NULL, 'logout'),
(273, 50, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-10 17:20:30', NULL, NULL, NULL),
(274, 20, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-10 17:20:33', NULL, NULL, 'logout'),
(275, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for alex@terapia.co.uk', '::1', '2025-10-10 17:20:40', NULL, NULL, NULL),
(276, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for alex@terapia.co.uk', '::1', '2025-10-10 17:20:47', NULL, NULL, NULL),
(277, 1, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-10 18:21:47', 'Password reset via token', NULL, 'password_reset'),
(278, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-10 17:22:02', NULL, NULL, NULL),
(279, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-10 17:25:30', NULL, NULL, 'logout'),
(280, NULL, NULL, 'login_failed', NULL, NULL, 'Failed login attempt for alex@terapia.co.uk', '::1', '2025-10-10 17:25:33', NULL, NULL, NULL),
(281, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-10 17:28:36', NULL, NULL, NULL),
(282, 13, 'superuser', 'unlock', NULL, NULL, 'Manual unlock by admin', '::1', '2025-10-10 17:32:40', NULL, NULL, NULL),
(283, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-10 17:39:34', NULL, NULL, 'logout'),
(284, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-10 17:40:03', NULL, NULL, NULL),
(285, 13, 'superuser', 'unlock', NULL, NULL, 'Manual unlock by admin', '::1', '2025-10-10 17:40:08', NULL, NULL, NULL),
(286, 13, 'superuser', 'password_reset', NULL, NULL, 'Manual password reset by admin', '::1', '2025-10-10 17:41:33', NULL, NULL, NULL),
(287, 1, 'superuser', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-10 17:41:41', NULL, NULL, 'logout'),
(288, 0, 'trainee', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-10 17:41:47', NULL, NULL, NULL),
(289, 13, 'trainee', 'system', NULL, NULL, 'User logged out', '::1', '2025-10-10 17:41:49', NULL, NULL, 'logout'),
(290, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-10 18:40:40', NULL, NULL, NULL),
(291, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-11 12:13:53', NULL, NULL, NULL),
(292, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-14 14:39:23', NULL, NULL, NULL),
(293, 1, 'superuser', 'login', NULL, NULL, 'Successful login', '::1', '2025-10-14 14:41:01', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `course_name` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `level` varchar(50) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `duration` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_id`, `course_name`, `description`, `level`, `start_date`, `end_date`, `duration`, `is_active`) VALUES
(1, 'MA in Child and Adolescent Psychotherapy and Counselling', 'Postgraduate training in therapeutic work with children and adolescents', 'Postgraduate', '2025-10-01', '2026-07-15', '1 year', 1),
(2, 'MA Conversion Course', 'Bridge course for qualified professionals entering psychotherapy training', 'Postgraduate', '2025-10-01', '2026-04-30', '9 months', 1),
(3, 'Foundation Year', 'Introductory year for those exploring therapeutic careers', 'Foundation', '2025-09-15', '2026-06-30', '10 months', 1),
(4, 'Supervision Training', 'Professional development for supervisors in therapeutic settings', 'Professional', '2025-11-01', '2026-03-15', '5 months', 1),
(5, 'Introduction to Therapeutic Work with Children', 'Short course in child-focused therapeutic approaches', 'Short Course', '2025-10-15', '2026-01-30', '14 weeks', 1),
(6, 'Accrediting Route to UKCP Register', 'Structured pathway for UKCP accreditation', 'Accreditation', '2025-10-01', '2026-08-01', '11 months', 1),
(7, 'Other', 'Custom or non-standard course offering', 'Flexible', '2025-09-01', '2026-07-01', 'Flexible', 1);

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `grade_id` int(11) NOT NULL,
  `submission_id` int(11) DEFAULT NULL,
  `tutor_id` int(11) DEFAULT NULL,
  `grade` varchar(50) DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `graded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `group_members`
--

CREATE TABLE `group_members` (
  `group_id` int(11) NOT NULL,
  `trainee_id` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `login_activity`
--

CREATE TABLE `login_activity` (
  `activity_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` varchar(50) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `login_time` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login_activity`
--

INSERT INTO `login_activity` (`activity_id`, `user_id`, `role`, `email`, `ip_address`, `user_agent`, `login_time`) VALUES
(1, 1, 'superuser', NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:19:53'),
(2, 0, 'trainee', NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:20:03'),
(3, 1, 'superuser', NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:22:42'),
(4, 0, 'trainee', NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:22:51'),
(5, 0, 'trainee', NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:24:36'),
(6, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:26:21'),
(7, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:26:27'),
(8, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:34:35'),
(9, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:53:01'),
(10, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:55:08'),
(11, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 21:56:43'),
(12, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 22:00:40'),
(13, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 22:02:13'),
(14, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 22:04:04'),
(15, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 22:05:33'),
(16, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 22:36:28'),
(17, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 22:45:25'),
(18, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-23 22:54:14'),
(19, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-24 08:25:28'),
(20, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-24 09:37:40'),
(21, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-24 14:57:52'),
(22, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-24 14:58:42'),
(23, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-24 16:23:52'),
(24, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-24 17:37:54'),
(25, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-24 19:52:44'),
(26, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-24 20:16:14'),
(27, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-25 11:27:01'),
(28, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-25 11:27:01'),
(29, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-25 13:16:18'),
(30, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-25 13:26:46'),
(31, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-25 13:46:33'),
(32, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-25 13:47:09'),
(33, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-25 13:59:38'),
(34, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-25 17:16:23'),
(35, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-25 18:31:35'),
(36, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-26 11:48:05'),
(37, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-26 12:01:27'),
(38, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-26 13:49:14'),
(39, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-26 13:52:13'),
(40, 6, 'superuser', 'kiran@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-26 14:19:04'),
(41, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-26 14:19:17'),
(42, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-26 14:39:19'),
(43, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-26 14:39:40'),
(44, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-26 15:48:08'),
(45, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-27 13:07:50'),
(46, 6, 'superuser', 'kiran@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-28 09:39:21'),
(47, 6, 'superuser', 'kiran@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-28 10:42:05'),
(48, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-28 19:38:34'),
(49, 7, 'superuser', 'leigh@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-29 15:45:05'),
(50, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-29 17:26:56'),
(51, 7, 'superuser', 'leigh@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-30 11:54:13'),
(52, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-09-30 13:00:38'),
(53, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-30 13:23:30'),
(54, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-30 14:25:45'),
(55, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-09-30 16:29:03'),
(56, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-01 11:27:01'),
(57, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-01 13:58:05'),
(58, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-01 14:01:27'),
(59, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-01 17:53:24'),
(60, 3, 'tutor', 'tutor_3_test@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-01 21:13:53'),
(61, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-01 21:22:17'),
(62, 3, 'tutor', 'tutor_3_test@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-01 21:28:50'),
(63, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-01 21:30:04'),
(64, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-01 21:30:31'),
(65, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-02 07:29:50'),
(66, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-02 07:37:56'),
(67, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-02 07:39:13'),
(68, 6, 'superuser', 'kiran@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-02 10:00:45'),
(69, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-02 10:04:51'),
(70, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-02 10:28:26'),
(71, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-02 10:29:26'),
(72, 15, 'tutor', 'tutor_6_test@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-02 11:05:37'),
(73, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-02 11:06:52'),
(74, 8, 'superuser', 'sacha@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-10-02 12:49:35'),
(75, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-02 13:16:52'),
(76, 11, 'superuser', 'emma@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-02 13:22:16'),
(77, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-02 13:27:18'),
(78, 11, 'superuser', 'emma@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-10-02 14:30:10'),
(79, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-02 19:00:29'),
(80, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-02 19:10:20'),
(81, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-02 19:16:55'),
(82, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-02 19:21:51'),
(83, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-10-03 12:30:23'),
(84, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 13:58:38'),
(85, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 14:06:31'),
(86, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 14:21:28'),
(87, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 14:24:50'),
(88, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 14:24:56'),
(89, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 14:25:07'),
(90, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 14:47:55'),
(91, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 14:48:06'),
(92, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 15:00:47'),
(93, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 15:03:02'),
(94, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 15:08:10'),
(95, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 15:10:24'),
(96, 12, 'superuser', 'maggie@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 15:41:12'),
(97, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 15:43:21'),
(98, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 16:28:29'),
(99, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 16:43:35'),
(100, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-03 16:55:14'),
(101, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-03 17:04:47'),
(102, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-03 17:43:26'),
(103, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-03 18:33:53'),
(104, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-03 19:16:32'),
(105, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-03 19:27:34'),
(106, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-04 19:17:04'),
(107, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-04 22:15:53'),
(108, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-04 23:02:21'),
(109, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-05 19:58:48'),
(110, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-06 12:00:05'),
(111, 7, 'superuser', 'leigh@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-06 15:56:45'),
(112, 11, 'superuser', 'emma@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-10-06 16:18:00'),
(113, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '2025-10-06 19:58:15'),
(114, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-07 13:16:21'),
(115, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-07 14:31:06'),
(116, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-07 14:58:01'),
(117, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-07 19:24:13'),
(118, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-08 17:19:14'),
(119, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-09 14:21:28'),
(120, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-09 19:02:06'),
(121, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-10 16:40:29'),
(122, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-10 17:13:07'),
(123, 50, 'trainee', 'trainee8@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-10 17:20:30'),
(124, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-10 17:22:02'),
(125, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-10 17:28:36'),
(126, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-10 17:40:03'),
(127, 0, 'trainee', 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-10 17:41:47'),
(128, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-10 18:40:40'),
(129, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Mobile Safari/537.36', '2025-10-11 12:13:53'),
(130, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-14 14:39:23'),
(131, 1, 'superuser', 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '2025-10-14 14:41:01');

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

CREATE TABLE `login_attempts` (
  `attempt_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `success` tinyint(1) NOT NULL DEFAULT 0,
  `reason` text DEFAULT NULL,
  `attempt_time` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login_attempts`
--

INSERT INTO `login_attempts` (`attempt_id`, `username`, `ip_address`, `user_agent`, `success`, `reason`, `attempt_time`) VALUES
(1, 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-01 13:57:51'),
(2, 'tutor_5_test@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-01 21:28:05'),
(3, 'tutor_5_test@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-01 21:28:16'),
(4, 'tutor_5_test@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-01 21:28:25'),
(5, 'tutor_5_test@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-01 21:28:38'),
(6, 'trainee5@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-01 21:29:40'),
(7, 'trainee5@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-01 21:29:53'),
(8, 'supervisor4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-02 10:27:43'),
(9, 'supervisor5@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-02 10:27:56'),
(10, 'supervisor2@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-02 10:28:06'),
(11, 'tutor_4_test@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-02 10:28:21'),
(12, 'supervisor5@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-02 10:29:09'),
(13, 'supervisor5@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-02 10:29:17'),
(14, 'nuggets@test.com', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-02 19:24:54'),
(15, 'nuggets@test.com', '::1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-02 19:37:38'),
(16, 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-03 16:20:24'),
(17, 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-03 16:20:31'),
(18, 'trainee7@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-10 17:12:59'),
(19, 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-10 17:20:40'),
(20, 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-10 17:20:47'),
(21, 'alex@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Invalid credentials or archived account', '2025-10-10 17:25:33'),
(22, 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Incorrect password', '2025-10-10 17:28:10'),
(23, 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Incorrect password', '2025-10-10 17:28:14'),
(24, 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Incorrect password', '2025-10-10 17:28:19'),
(25, 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Incorrect password', '2025-10-10 17:28:22'),
(26, 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Incorrect password', '2025-10-10 17:28:26'),
(27, 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Incorrect password', '2025-10-10 17:39:39'),
(28, 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Incorrect password', '2025-10-10 17:39:42'),
(29, 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Incorrect password', '2025-10-10 17:39:48'),
(30, 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Incorrect password', '2025-10-10 17:39:52'),
(31, 'trainee4@terapia.co.uk', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 0, 'Incorrect password', '2025-10-10 17:39:55');

-- --------------------------------------------------------

--
-- Table structure for table `modules`
--

CREATE TABLE `modules` (
  `module_id` int(11) NOT NULL,
  `module_name` varchar(255) NOT NULL,
  `course_id` int(11) NOT NULL,
  `year` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `modules`
--

INSERT INTO `modules` (`module_id`, `module_name`, `course_id`, `year`) VALUES
(15, 'Module A: Core Training', 2, 1),
(16, 'Module B: Individual Course', 2, 2),
(17, 'Module 1: Child Development, Toddler Observation & Clinical Foundations', 1, 1),
(18, 'Module 2: Clinical Practice, Parent-Infant Observation & Ethics', 1, 2),
(19, 'Module 3: Psychopathology, Advanced Therapeutic Practice & Research', 1, 3),
(20, 'Module 4: Trauma, Diversity-Informed Practice & Integration', 1, 4),
(21, 'Foundation Year 1', 3, 1),
(22, 'Introduction Module (5 Days)', 5, 1),
(23, 'Individual Supervision (25 hours)', 4, 1),
(24, 'Group Supervision (25 Hours)', 4, 1),
(25, 'Other (Non-Standard) Module', 7, 1),
(26, 'First Stage', 6, 1),
(27, 'Second Stage', 6, 2),
(28, 'Third Stage', 6, 3),
(29, 'Fourth Stage', 6, 4);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `password_resets`
--

INSERT INTO `password_resets` (`id`, `user_id`, `email`, `token`, `expires_at`, `created_at`) VALUES
(1, 1, '', '04224eecf48f123bbbc9bde5aefafcf142760a9ed14b26da38f8983dcc3fcf1e', '2025-10-03 18:14:46', '2025-10-03 15:14:46'),
(2, 1, '', 'cfd621300be89237daaee5902c0f9e74076ce2c4f4a7f4fed55d2db8c6af0bca', '2025-10-03 18:18:13', '2025-10-03 15:18:13'),
(5, 1, '', 'cb52d098190973fb74372f1bed21c1c3349464ca3f56a17036728254e87f2e93', '2025-10-03 18:36:35', '2025-10-03 15:36:35'),
(6, 1, '', '07742637e849fc10f04945dc06d9ccb4aed333b5b0df7f9d8f400905093c9ce5', '2025-10-03 18:36:40', '2025-10-03 15:36:40'),
(7, 1, '', 'b8415c49e2a57e68a1e50a5cfa7909c641dc434147d877f799ce5594cef048d2', '2025-10-03 18:38:58', '2025-10-03 15:38:58'),
(8, 1, '', '883f6904c37c0ba406eb4fa608dd2f88d18c86722000125fe0e703d1bbf8622c', '2025-10-03 18:39:02', '2025-10-03 15:39:02'),
(9, 1, '', 'cc152e3e4fe99112dc125586c0f2467d1da96f57f624db6b4a9fe0ab485080f3', '2025-10-03 18:39:11', '2025-10-03 15:39:11'),
(11, 1, '', '903d5cd1cfba5c6d8a1e97e750c9cf89f0e65f526f0182800c935a15f5420e65', '2025-10-03 18:47:59', '2025-10-03 15:47:59');

-- --------------------------------------------------------

--
-- Table structure for table `role_audit_log`
--

CREATE TABLE `role_audit_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `previous_role` varchar(50) DEFAULT NULL,
  `new_role` varchar(50) DEFAULT NULL,
  `changed_by` int(11) NOT NULL,
  `change_reason` text DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `ip_address` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_audit_log`
--

INSERT INTO `role_audit_log` (`id`, `user_id`, `previous_role`, `new_role`, `changed_by`, `change_reason`, `timestamp`, `ip_address`) VALUES
(1, 9, 'admin', 'staff', 1, 'Role updated via edit_staff', '2025-09-23 21:49:53', '::1');

-- --------------------------------------------------------

--
-- Table structure for table `safeguarding_change_log`
--

CREATE TABLE `safeguarding_change_log` (
  `log_id` int(11) NOT NULL,
  `record_id` int(11) NOT NULL,
  `changed_by` varchar(100) NOT NULL,
  `change_summary` text NOT NULL,
  `changed_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `safeguarding_change_log`
--

INSERT INTO `safeguarding_change_log` (`log_id`, `record_id`, `changed_by`, `change_summary`, `changed_at`) VALUES
(1, 2, 'Alex Superuser', '', '2025-09-23 18:29:02');

-- --------------------------------------------------------

--
-- Table structure for table `safeguarding_concern_types`
--

CREATE TABLE `safeguarding_concern_types` (
  `concern_id` int(11) NOT NULL,
  `record_id` int(11) NOT NULL,
  `concern_type` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `safeguarding_concern_types`
--

INSERT INTO `safeguarding_concern_types` (`concern_id`, `record_id`, `concern_type`) VALUES
(1, 2, 'Professional conduct/boundary issue');

-- --------------------------------------------------------

--
-- Table structure for table `safeguarding_terapiapersonnel_records`
--

CREATE TABLE `safeguarding_terapiapersonnel_records` (
  `record_id` int(11) NOT NULL,
  `record_date` date NOT NULL,
  `record_time` time NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `completed_by` varchar(100) NOT NULL,
  `job_title` varchar(100) DEFAULT NULL,
  `individual_name` varchar(100) NOT NULL,
  `individual_role` varchar(50) NOT NULL,
  `department` varchar(100) DEFAULT NULL,
  `contact_details` varchar(255) DEFAULT NULL,
  `incident_datetime` varchar(50) DEFAULT NULL,
  `incident_location` varchar(255) DEFAULT NULL,
  `concern_categories` text DEFAULT NULL,
  `concern_other_detail` text DEFAULT NULL,
  `observation` text DEFAULT NULL,
  `evidence` text DEFAULT NULL,
  `spoken_to` text DEFAULT NULL,
  `children_involved` text DEFAULT NULL,
  `escalated` text DEFAULT NULL,
  `urgent_steps` text DEFAULT NULL,
  `raiser_name` varchar(100) DEFAULT NULL,
  `raiser_role` varchar(100) DEFAULT NULL,
  `raiser_contact` varchar(255) DEFAULT NULL,
  `dsl_informed` text DEFAULT NULL,
  `dsl_name` varchar(100) DEFAULT NULL,
  `dsl_action` text DEFAULT NULL,
  `referral_datetime` varchar(50) DEFAULT NULL,
  `external_outcome` text DEFAULT NULL,
  `ongoing_monitoring` text DEFAULT NULL,
  `support_required` text DEFAULT NULL,
  `review_date` date DEFAULT NULL,
  `signoff_name` varchar(100) DEFAULT NULL,
  `signoff_signature` varchar(100) DEFAULT NULL,
  `signoff_datetime` varchar(50) DEFAULT NULL,
  `reviewer_name` varchar(100) DEFAULT NULL,
  `reviewer_signature` varchar(100) DEFAULT NULL,
  `review_date_reviewed` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `safeguarding_terapiapersonnel_records`
--

INSERT INTO `safeguarding_terapiapersonnel_records` (`record_id`, `record_date`, `record_time`, `location`, `completed_by`, `job_title`, `individual_name`, `individual_role`, `department`, `contact_details`, `incident_datetime`, `incident_location`, `concern_categories`, `concern_other_detail`, `observation`, `evidence`, `spoken_to`, `children_involved`, `escalated`, `urgent_steps`, `raiser_name`, `raiser_role`, `raiser_contact`, `dsl_informed`, `dsl_name`, `dsl_action`, `referral_datetime`, `external_outcome`, `ongoing_monitoring`, `support_required`, `review_date`, `signoff_name`, `signoff_signature`, `signoff_datetime`, `reviewer_name`, `reviewer_signature`, `review_date_reviewed`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, '2025-09-22', '14:28:00', 'The Bothy', 'Alexander Robertson', 'Therapeutic Services Director', 'Trainee_3_Test', 'Trainee', 'Module 2', 'Trainee3@terapia.co.uk', '21/09/2025 16:00', 'Trainee 3 School', 'Professional conduct/boundary issue', NULL, 'TRAINEE 3 TEST', 'SENCO for TRAINEE 3 TEST', 'No', 'YES', 'YES', 'Terapia DSL Informed', 'Supervisor_2_Test', 'Individual Supervisor', 'supervisor2@terapia.co.uk', 'Yes - Supervisor 2', 'Sacha Richardson', 'Monitored, Referral to external safeguarding authority', '22/09/2025 - 09:22', 'Awaiting Update', 'No', 'No', '2025-09-22', 'Alexander Robertson', 'A.Robertson', '22/09/2025 14:38', 'N/A', 'N.A', '22/09/2025', '2025-09-22 13:37:46', '2025-09-22 13:37:46', NULL, NULL),
(2, '2025-09-23', '17:04:00', 'The Bothy - NW3 4QE', 'Trainee 4 Test', 'Trainee4', 'Trainee_3', 'Trainee', 'Trainee', '00000000000', '23/09/2025 16:00', 'The Bothy - G3', 'Professional conduct/boundary issue', '', 'Trainee 3 Did X', 'No', 'No', 'No', 'Yes', 'No', 'Trainee 4', 'Trainee', '00088877766', '', '', '', '', '', '', '', '0000-00-00', '', '', '', '', '', '', '2025-09-23 17:12:04', '2025-09-23 17:29:02', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `session_attendance`
--

CREATE TABLE `session_attendance` (
  `session_id` int(11) NOT NULL,
  `trainee_id` varchar(8) NOT NULL,
  `attended` tinyint(1) DEFAULT 0,
  `comments` text DEFAULT NULL,
  `marked_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `session_phrase_log`
--

CREATE TABLE `session_phrase_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `phrase` text NOT NULL,
  `assigned_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `session_phrase_log`
--

INSERT INTO `session_phrase_log` (`id`, `user_id`, `phrase`, `assigned_at`) VALUES
(1, 1, '“Love is the voice under all silences. E. E. Cummings”,', '2025-09-26 14:04:16'),
(3, 1, '“Everything can change, but not the language that we carry inside us. Italo Calvino”,', '2025-09-26 14:19:17'),
(4, 13, '“It was the best of times, it was the worst of times. Charles Dickens”,', '2025-09-26 14:39:19'),
(5, 1, '“You can’t get away from yourself by moving from one place to another. Ernest Hemingway”,', '2025-09-26 14:39:40'),
(6, 1, '“We are all apprentices in a craft where no one ever becomes a master. Ernest Hemingway”,', '2025-09-26 15:48:08'),
(7, 1, '“The old order changeth, yielding place to new. Alfred Tennyson”,', '2025-09-27 13:07:51'),
(10, 1, '“I shut my eyes and all the world drops dead. Sylvia Plath”,', '2025-09-28 19:38:34'),
(12, 1, '“Look well into thyself. Marcus Aurelius”,', '2025-09-29 17:26:56'),
(14, 1, '“Man is the only creature who refuses to be what he is. Albert Camus”,', '2025-09-30 13:00:38'),
(15, 1, '“A classic is a book that has never finished saying what it has to say. Italo Calvino”,', '2025-09-30 13:23:30'),
(16, 1, '“The soul unto itself is an imperial friend. Emily Dickinson”,', '2025-09-30 14:25:45'),
(17, 1, '“The soul becomes dyed with the color of its thoughts. Marcus Aurelius”,', '2025-09-30 16:29:03'),
(18, 1, '“I care for myself. The more solitary, the more friendless, the more unsustained I am, the more I will respect myself. Charlotte Brontë”,', '2025-10-01 11:27:01'),
(19, 1, '“The tygers of wrath are wiser than the horses of instruction. William Blake”,', '2025-10-01 13:58:05'),
(20, 1, '“It takes courage to grow up and become who you really are. E. E. Cummings”,', '2025-10-01 14:01:27'),
(21, 1, '“Science is the belief in the ignorance of experts. J. B. S. Haldane”,', '2025-10-01 17:53:24'),
(22, 3, '“From hell’s heart I stab at thee. Herman Melville”,', '2025-10-01 21:13:53'),
(23, 1, '“The man who does not read good books has no advantage over the man who cannot read them. Mark Twain”,', '2025-10-01 21:22:17'),
(24, 3, '“It does not matter how slowly you go as long as you do not stop. Confucius”,', '2025-10-01 21:28:50'),
(25, 13, '“Love must be learned, and learned again. Katherine Anne Porter”,', '2025-10-01 21:30:04'),
(26, 1, '“Every atom belonging to me as good belongs to you. Walt Whitman”,', '2025-10-01 21:30:31'),
(27, 1, '“Who looks outside, dreams; who looks inside, awakes. Carl Jung”,', '2025-10-02 07:29:50'),
(28, 1, '“Success is counted sweetest by those who ne’er succeed. Emily Dickinson”,', '2025-10-02 07:39:13'),
(30, 1, '“The impediment to action advances action. Marcus Aurelius”,', '2025-10-02 10:04:51'),
(31, 1, '“I grow old … I grow old … I shall wear the bottoms of my trousers rolled. T. S. Eliot”,', '2025-10-02 10:28:26'),
(32, 1, '“Happiness is not a goal; it is a by-product. Eleanor Roosevelt”,', '2025-10-02 10:29:26'),
(33, 15, '“Long is the way and hard, that out of Hell leads up to light. John Milton”,', '2025-10-02 11:05:37'),
(34, 1, '“Annihilate but space and time. Andrew Marvell”,', '2025-10-02 11:06:52'),
(36, 1, '“I wandered lonely as a cloud. William Wordsworth”,', '2025-10-02 13:16:52'),
(38, 1, '“There are people, who the more you do for them, the less they will do for themselves. Jane Austen”,', '2025-10-02 13:27:18'),
(40, 1, '“The innocent and the beautiful have no enemy but time. W. B. Yeats”,', '2025-10-02 19:00:29'),
(41, 1, '“A pound of pluck is worth a ton of luck. James A. Garfield”,', '2025-10-02 19:10:20'),
(42, 1, '“Trailing clouds of glory do we come. William Wordsworth”,', '2025-10-02 19:16:55'),
(43, 13, '“That is not dead which can eternal lie. H. P. Lovecraft”,', '2025-10-02 19:21:51'),
(44, 13, '“Exuberance is beauty. William Blake”,', '2025-10-03 12:30:24'),
(45, 1, '“I grow old … I grow old … I shall wear the bottoms of my trousers rolled. T. S. Eliot”,', '2025-10-03 13:58:38'),
(46, 1, '“Think where man’s glory most begins and ends. W. B. Yeats”,', '2025-10-03 14:06:31'),
(47, 1, '“The chief duty of government is to keep the peace. James A. Garfield”,', '2025-10-03 14:21:28'),
(48, 1, '“Never confuse movement with action. Ernest Hemingway”,', '2025-10-03 14:25:07'),
(49, 1, '“Faith is taking the first step even when you don’t see the whole staircase. Martin Luther King Jr.”,', '2025-10-03 14:48:06'),
(50, 1, '“From hell’s heart I stab at thee. Herman Melville”,', '2025-10-03 15:00:47'),
(51, 1, '“Vanity and pride are different things. Jane Austen”,', '2025-10-03 15:03:02'),
(52, 1, '“There is nothing more deceptive than an obvious fact. Arthur Conan Doyle”,', '2025-10-03 15:08:10'),
(53, 1, '“Never confuse movement with action. Ernest Hemingway”,', '2025-10-03 15:10:25'),
(55, 1, '“Do I dare disturb the universe? T. S. Eliot”,', '2025-10-03 15:43:21'),
(56, 1, '“Love what you do and do what you love. Ray Bradbury”,', '2025-10-03 16:28:29'),
(57, 1, '“The soul is born old but grows young. Oscar Wilde”,', '2025-10-03 16:43:35'),
(58, 1, '“Blessed are the hearts that can bend; they shall never be broken. Albert Camus”,', '2025-10-03 16:55:14'),
(59, 1, '“I celebrate myself, and sing myself. Walt Whitman”,', '2025-10-03 17:04:47'),
(60, 1, '“He\'s more myself than I am. Emily Brontë”,', '2025-10-03 17:43:26'),
(61, 1, '“The most wasted of all days is one without laughter. E. E. Cummings”,', '2025-10-03 18:33:53'),
(62, 1, '“A man without ethics is a wild beast loosed upon this world. Albert Camus”,', '2025-10-03 19:16:32'),
(63, 1, '“I am two fools, I know, for loving, and for saying so. John Donne”,', '2025-10-04 19:17:04'),
(64, 1, '“Courage is grace under pressure. Ernest Hemingway”,', '2025-10-04 22:15:53'),
(65, 1, '“I too am not a bit tamed. Walt Whitman”,', '2025-10-04 23:02:21'),
(66, 1, '“I am not what happened to me, I am what I choose to become. Carl Jung”,', '2025-10-05 19:58:48'),
(67, 1, '“Love is the voice under all silences. E. E. Cummings”,', '2025-10-06 12:00:05'),
(70, 1, '“The world breaks everyone, and afterward, many are strong at the broken places. Ernest Hemingway”,', '2025-10-06 19:58:15'),
(71, 1, '“I am not afraid of storms, for I am learning how to sail my ship. Louisa May Alcott”,', '2025-10-07 13:16:21'),
(72, 1, '“That is not dead which can eternal lie. H. P. Lovecraft”,', '2025-10-07 14:31:06'),
(73, 1, '“Have a heart that never hardens, and a temper that never tires. Charles Dickens”,', '2025-10-07 14:58:01'),
(74, 1, '“Desire makes everything blossom. Marcel Proust”,', '2025-10-07 19:24:13'),
(75, 1, '“No one is useless in this world who lightens the burden of it to anyone else. Charles Dickens”,', '2025-10-08 17:19:15'),
(76, 1, '“The important thing is not to stop questioning. Albert Einstein”,', '2025-10-09 14:21:28'),
(77, 1, '“There is no folly of the beast of the earth which is not infinitely outdone by the madness of men. Herman Melville”,', '2025-10-09 19:02:06'),
(78, 1, '“Love, all alike, no season knows nor clime. John Donne”,', '2025-10-10 16:40:29'),
(79, 1, '“We live, as we dream—alone. Joseph Conrad”,', '2025-10-10 17:13:07'),
(80, 20, '“Unhallowed blasphemies were spoken. H. P. Lovecraft”,', '2025-10-10 17:20:30'),
(81, 1, '“More than kisses, letters mingle souls. John Donne”,', '2025-10-10 17:22:02'),
(82, 1, '“The only real ending is death. Katherine Anne Porter”,', '2025-10-10 17:28:36'),
(83, 1, '“Our greatest glory is not in never falling, but in rising every time we fall. Confucius”,', '2025-10-10 17:40:03'),
(84, 13, '“The end of wisdom is to dream high enough not to lose the dream in the seeking of it. William Faulkner”,', '2025-10-10 17:41:47'),
(85, 1, '“The only real voyage of discovery consists not in seeking new landscapes but in having new eyes. Marcel Proust”,', '2025-10-10 18:40:40'),
(86, 1, '“Dwell on the beauty of life. Marcus Aurelius”,', '2025-10-11 12:13:53'),
(87, 1, '“The most effective way to destroy people is to deny and obliterate their own understanding of their history. George Orwell”,', '2025-10-14 14:39:23'),
(88, 1, '“Terror made me cruel. Emily Brontë”,', '2025-10-14 14:41:01');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staff_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(100) NOT NULL,
  `start_date` date DEFAULT NULL,
  `job_title` varchar(100) DEFAULT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `dbs_update_service` tinyint(1) DEFAULT 0,
  `dbs_status` varchar(20) DEFAULT NULL,
  `dbs_date` date DEFAULT NULL,
  `dbs_reference` varchar(50) DEFAULT NULL,
  `is_archived` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staff_id`, `first_name`, `surname`, `email`, `username`, `password`, `role`, `start_date`, `job_title`, `telephone`, `profile_image`, `dbs_update_service`, `dbs_status`, `dbs_date`, `dbs_reference`, `is_archived`) VALUES
(1, 'Alex', 'Superuser', 'alex@terapia.co.uk', 'alex', '$2y$10$5.34J6y37YTaXnI/lvuL.OVPmU5ARH6KCZ4JqsXQ433ZXMoPe54Sy', 'superuser', '2025-09-15', 'System Admin', '07000 000001', 'uploads/1757966969_Pingu.jpg', 1, 'Approved', '2025-09-23', '00000000000', 0),
(2, 'Alex', 'Robertson', 'alexander.r.obertson89@gmail.com', '', '', 'admin', '2025-09-16', 'TSD', NULL, NULL, 0, NULL, NULL, NULL, 1),
(5, 'Bozena', 'Merrick', 'bozena@terapia.co.uk', 'bozena', '$2y$10$7pKKuOjF/YuUmPKAw7QDre66/bqOgw2F9Mge6UkYMPPS1BeT7qrji', 'superuser', '2000-01-01', 'CEO', '', 'uploads/1758047435_Bozena_Merrick.jpg', 1, 'Approved', '2024-01-01', '10000000000', 0),
(6, 'Kiran', 'Rehinsi', 'kiran@terapia.co.uk', 'kiran', '$2y$10$bQhG15yHVpdp5l85BFyfXey2bGHelHH8aSRWKHA/OdyuCfjl3uLYS', 'superuser', '2025-09-16', 'Director of Training', '', 'uploads/1759049886_kiran-e1707317712807.jpg', 1, 'Approved', '2025-01-01', '999999999', 0),
(7, 'Leigh', 'Norburn', 'leigh@terapia.co.uk', 'leigh', '$2y$10$IeNFujan2iD4nqZ40woZUORhL57snxm71SMmcZlB6g7W/fkKY9JDW', 'superuser', '2025-04-01', 'School Services Coordinator', '', 'uploads/1758048095_Leigh_Norburn.jpg', 1, 'Approved', '2025-04-01', '888888888', 0),
(8, 'Sacha', 'Richardson', 'sacha@terapia.co.uk', 'sacha', '$2y$10$xegz9b6alJ3NVRfbxr2mXuEphf1BFanmPpohpP4cJhrs4pGL6Ljz6', 'superuser', '2020-10-01', 'Clinical Lead', '', 'uploads/1758048323_Sacha_Richardson.jpg', 1, 'Approved', '2025-01-01', '77777777777', 0),
(9, 'Admin_1', 'Admin_1_TEST', 'Admin1@terapia.co.uk', 'Admin1', '$2y$10$iwbWpF/RJvC61s5lzMAsduoMVr0rYeBM6TxrL7t2tnsQQo0884Rhe', 'staff', '2025-09-22', 'Admin_1_Test', '99900077766', 'uploads/1758660572_Admin_1.jpg', 1, 'Approved', '2025-09-19', '0000003333', 0),
(10, 'Admin_2', 'Test_Admin_2', 'Admin2@terapia.co.uk', 'Admin2', '$2y$10$IejNgUdQDbTfc8dD8GkJOePF7uVPvObc7QdH112OPc34z0.y5hv9G', 'admin', '2025-09-22', 'Admin_2_Test', '77778889990', '1758555080_Admin_2.webp', 0, 'Expired', '2022-01-01', '888866644', 0),
(11, 'Emma', 'Beattie', 'emma@terapia.co.uk', 'emma', '$2y$10$52g/4BMZre5rQFRCq02o9e1.j4VqTkw4beaI/PlsfsNsKlXEOVBpi', 'superuser', '2025-10-02', 'Academic Co-ordinator', '020 8201 6101', '', 1, 'Approved', '2025-10-02', '00009996678', 0),
(12, 'Maggie', 'Docherty', 'maggie@terapia.co.uk', 'maggie', '$2y$10$.iXDkuRY6EGsCwUFInmyF.grfTWXO1E6OexB04JHYAfdiqppOzLam', 'superuser', '2025-10-03', 'PA to CEO and Clinical Director', 'PA to CEO and Clinic', '1759502457_Maggie_Docherty.jpg', 1, 'Approved', '2024-01-01', '11100088866', 0);

-- --------------------------------------------------------

--
-- Table structure for table `submissions`
--

CREATE TABLE `submissions` (
  `submission_id` int(11) NOT NULL,
  `assignment_id` int(11) DEFAULT NULL,
  `trainee_id` int(11) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `submission_audit_log`
--

CREATE TABLE `submission_audit_log` (
  `log_id` int(11) NOT NULL,
  `submission_id` int(11) NOT NULL,
  `graded_by` int(11) NOT NULL,
  `score_percent` decimal(5,2) DEFAULT NULL,
  `pass_status` enum('Pass','Fail') DEFAULT NULL,
  `feedback_text` text DEFAULT NULL,
  `feedback_file` varchar(255) DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `submission_audit_log`
--

INSERT INTO `submission_audit_log` (`log_id`, `submission_id`, `graded_by`, `score_percent`, `pass_status`, `feedback_text`, `feedback_file`, `timestamp`) VALUES
(1, 1, 1, 65.00, 'Pass', '', NULL, '2025-09-23 23:24:00');

-- --------------------------------------------------------

--
-- Table structure for table `supervision_attendance`
--

CREATE TABLE `supervision_attendance` (
  `attendance_id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `trainee_id` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attended` tinyint(1) DEFAULT 0,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supervision_attendance`
--

INSERT INTO `supervision_attendance` (`attendance_id`, `session_id`, `trainee_id`, `attended`, `updated_by`, `updated_at`, `notes`) VALUES
(1, 11, 'PSJ2UC5H', 0, 1, '2025-10-03 12:02:22', NULL),
(2, 11, '3JFYB8ZR', 0, 1, '2025-10-03 12:02:22', NULL),
(3, 12, 'PSJ2UC5H', 0, 1, '2025-10-03 12:05:36', NULL),
(4, 12, '3JFYB8ZR', 0, 1, '2025-10-03 12:05:36', NULL),
(5, 16, 'PSJ2UC5H', 1, 1, '2025-10-03 12:20:27', 'TEST Individual Session Creation Trainee 1_\r\n\r\nUpdated 03/10/2025'),
(6, 17, 'BW4Q86I3', 0, 1, '2025-10-03 12:29:15', NULL),
(7, 18, 'BW4Q86I3', 0, 1, '2025-10-03 12:31:19', NULL),
(8, 19, 'BW4Q86I3', 0, 1, '2025-10-03 12:45:40', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `supervision_audit_log`
--

CREATE TABLE `supervision_audit_log` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `trainee_id` varchar(20) NOT NULL,
  `session_id` int(11) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `old_value` text DEFAULT NULL,
  `new_value` text DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `supervision_groups`
--

CREATE TABLE `supervision_groups` (
  `group_id` int(11) NOT NULL,
  `module_number` int(11) NOT NULL,
  `module_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `group_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `group_option` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supervisor_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `group_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supervision_groups`
--

INSERT INTO `supervision_groups` (`group_id`, `module_number`, `module_title`, `group_type`, `group_option`, `supervisor_id`, `created_at`, `group_notes`) VALUES
(1, 2, 'General Supervision Group', 'General Supervision Group', 'TEST Iteration 1/A', 8, '2025-09-18 14:53:56', NULL),
(2, 2, 'Parent and Baby Observation Group', 'Parent and Baby Observation Group', 'A', 5, '2025-09-19 20:45:05', NULL),
(3, 1, 'Toddler Observation', 'Toddler Observation', 'TEST Group B', 6, '2025-09-24 19:53:16', NULL),
(4, 0, 'Individual Supervision', NULL, 'N/A', 1, '2025-10-03 12:18:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `supervision_group_trainees`
--

CREATE TABLE `supervision_group_trainees` (
  `group_id` int(11) NOT NULL,
  `trainee_id` varchar(255) NOT NULL,
  `assigned_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `supervision_group_trainees`
--

INSERT INTO `supervision_group_trainees` (`group_id`, `trainee_id`, `assigned_at`) VALUES
(1, '3JFYB8ZR', '2025-09-19 09:08:02'),
(1, 'PSJ2UC5H', '2025-09-18 16:39:12'),
(3, 'BW4Q86I3', '2025-09-30 13:24:37');

-- --------------------------------------------------------

--
-- Table structure for table `supervision_sessions`
--

CREATE TABLE `supervision_sessions` (
  `session_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `session_date` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `session_type` enum('individual','group') NOT NULL DEFAULT 'group',
  `supervisor_id` int(11) DEFAULT NULL,
  `session_time` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supervision_sessions`
--

INSERT INTO `supervision_sessions` (`session_id`, `group_id`, `session_date`, `notes`, `created_at`, `session_type`, `supervisor_id`, `session_time`) VALUES
(1, 3, '2025-09-30 00:00:00', 'Group Session 2', '2025-09-24 20:28:40', 'group', NULL, NULL),
(2, 3, '2025-09-30 00:00:00', NULL, '2025-09-24 20:30:00', 'group', NULL, NULL),
(3, 3, '2025-09-30 00:00:00', NULL, '2025-09-24 20:30:32', 'group', NULL, NULL),
(4, 3, '2025-09-30 00:00:00', NULL, '2025-09-24 20:32:18', 'group', NULL, NULL),
(5, 3, '2025-09-30 00:00:00', NULL, '2025-09-24 20:34:52', 'group', NULL, NULL),
(6, 3, '2025-09-30 00:00:00', NULL, '2025-09-24 20:36:18', 'group', NULL, NULL),
(7, 3, '2025-10-01 00:00:00', NULL, '2025-09-24 20:43:18', 'group', NULL, NULL),
(8, 3, '2025-10-09 00:00:00', NULL, '2025-09-24 20:52:30', 'group', NULL, NULL),
(9, 2, '2025-09-26 14:00:00', NULL, '2025-09-25 13:23:22', 'group', NULL, NULL),
(10, 2, '2025-09-27 15:00:00', NULL, '2025-09-25 13:47:01', 'group', NULL, NULL),
(11, 1, '2025-10-30 00:00:00', 'TEST Group Attendance Tracker Per Trainee', '2025-10-03 12:02:22', 'group', 1, '11:00:00'),
(12, 1, '2025-10-27 00:00:00', 'TEST Group Attendance Tracker Per Trainee_TEST TWO', '2025-10-03 12:05:36', 'group', 1, '11:00:00'),
(16, 4, '2025-10-03 00:00:00', 'TEST Individual Session Creation Trainee 1_', '2025-10-03 12:20:27', 'individual', 1, '14:30:00'),
(17, 4, '2025-10-03 00:00:00', 'TestIndividualSessionTrainee3', '2025-10-03 12:29:15', 'individual', 1, '15:00:00'),
(18, 3, '2025-10-03 00:00:00', 'TESTTRAINEE4GROUPTRACKING', '2025-10-03 12:31:19', 'group', 1, '16:00:00'),
(19, 3, '2025-10-03 00:00:00', 'TESTTRAINEE4GROUPTRACKING', '2025-10-03 12:45:40', 'group', 1, '16:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `supervision_session_notes`
--

CREATE TABLE `supervision_session_notes` (
  `id` int(11) NOT NULL,
  `session_id` varchar(20) DEFAULT NULL,
  `trainee_id` varchar(20) DEFAULT NULL,
  `supervisor_id` varchar(20) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `supervision_session_trainees`
--

CREATE TABLE `supervision_session_trainees` (
  `id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `trainee_id` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supervision_session_trainees`
--

INSERT INTO `supervision_session_trainees` (`id`, `session_id`, `trainee_id`) VALUES
(1, 12, 'PSJ2UC5H'),
(2, 12, '3JFYB8ZR'),
(3, 16, 'PSJ2UC5H'),
(4, 17, 'BW4Q86I3'),
(5, 18, 'BW4Q86I3'),
(6, 19, 'BW4Q86I3');

-- --------------------------------------------------------

--
-- Table structure for table `supervisors`
--

CREATE TABLE `supervisors` (
  `supervisor_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `surname_prefix` varchar(20) DEFAULT NULL,
  `surname` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('supervisor','staff','admin') NOT NULL DEFAULT 'supervisor',
  `is_archived` tinyint(1) DEFAULT 0,
  `job_title` varchar(100) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `address_line1` varchar(255) DEFAULT NULL,
  `town_city` varchar(100) DEFAULT NULL,
  `postcode` varchar(20) DEFAULT NULL,
  `disability_status` varchar(100) DEFAULT NULL,
  `disability_type` varchar(100) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dbs_status` varchar(50) DEFAULT 'Pending',
  `dbs_date` date DEFAULT NULL,
  `dbs_reference` varchar(100) DEFAULT NULL,
  `dbs_update_service` tinyint(1) DEFAULT 0,
  `dbs_expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `supervisors`
--

INSERT INTO `supervisors` (`supervisor_id`, `first_name`, `surname_prefix`, `surname`, `email`, `password`, `role`, `is_archived`, `job_title`, `start_date`, `telephone`, `address_line1`, `town_city`, `postcode`, `disability_status`, `disability_type`, `profile_image`, `created_at`, `updated_at`, `dbs_status`, `dbs_date`, `dbs_reference`, `dbs_update_service`, `dbs_expiry_date`) VALUES
(1, 'Jane', NULL, 'Supervisor', 'jane.supervisor@example.com', 'securehashedpassword', 'supervisor', 0, 'Senior Mentor', '2025-09-01', '07700900123', NULL, NULL, NULL, NULL, NULL, '1759235149_Jane_Supervisor.jpg', '2025-09-15 21:37:43', '2025-09-30 12:25:49', 'Pending', NULL, NULL, 0, NULL),
(3, 'Supervisor_2', NULL, 'TEST Supervisor_2', 'supervisor2@terapia.co.uk', '$2y$10$AdRg5QV3xO9Iw3aQROnZnOC5fL3et8fHLodutBFKVuNoos2UUV64O', 'supervisor', 0, 'Password123$', '2021-06-06', '00000077222', 'Supervisor_2_Test', 'Supervisor_2_Test', 'N3 3QE', '', '', 'uploads/68d142a242d4c_Supervisor_2.jpg', '2025-09-22 12:35:46', '2025-10-02 09:23:38', 'Pending', NULL, NULL, 0, NULL),
(4, 'Supervisor_4', NULL, 'Supervisor_4_Test', 'supervisor4@terapia.co.uk', '$2y$10$SIflBXbFij69vxEWtvh8wusxqCzHcOUTD41wjpfyjCbDPzADorjri', 'supervisor', 1, 'Module 4 Supervisor', '2025-09-24', '00006664443', 'Supervisor_4_Test', 'Inverness', 'IV4 8HG', 'N/A', 'Sight', 'uploads/68d40d8a8fa16_Supervisor_4.jpeg', '2025-09-24 15:26:02', '2025-09-24 15:26:24', 'Pending', NULL, NULL, 0, NULL),
(6, 'Supervisor_5', NULL, 'TESTING_SUPERVISOR5', 'supervisor5@terapia.co.uk', '$2y$10$G.apH8xu.yq6Sv.j7/ffG.64vFC2L9VOnbEKFDp.mTFvdLxR4J8ES', 'supervisor', 0, 'Supervisor - Module 3', '2025-10-01', '99977766655', 'Supervisor_5_Test', 'Bristol', 'SW1 9HH', 'N/A', '', '1759336521_Supervisor_5.jpeg', '2025-10-01 16:34:44', '2025-10-02 09:28:58', 'Pending', NULL, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `supervisor_courses`
--

CREATE TABLE `supervisor_courses` (
  `supervisor_course_id` int(11) NOT NULL,
  `supervisor_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supervisor_courses`
--

INSERT INTO `supervisor_courses` (`supervisor_course_id`, `supervisor_id`, `course_id`, `assigned_at`) VALUES
(4, 6, 2, '2025-10-02 09:28:58');

-- --------------------------------------------------------

--
-- Table structure for table `supervisor_modules`
--

CREATE TABLE `supervisor_modules` (
  `supervisor_module_id` int(11) NOT NULL,
  `supervisor_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supervisor_modules`
--

INSERT INTO `supervisor_modules` (`supervisor_module_id`, `supervisor_id`, `module_id`, `assigned_at`) VALUES
(4, 6, 16, '2025-10-02 09:28:58');

-- --------------------------------------------------------

--
-- Table structure for table `trainees`
--

CREATE TABLE `trainees` (
  `trainee_id` varchar(8) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `individual_supervisor` int(11) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `is_archived` tinyint(1) DEFAULT 0,
  `date_of_birth` date DEFAULT NULL,
  `disability_status` varchar(100) DEFAULT NULL,
  `disability_type` varchar(100) DEFAULT NULL,
  `town_city` varchar(100) DEFAULT NULL,
  `postcode` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `trainee_code` varchar(20) DEFAULT NULL,
  `address_line1` varchar(255) DEFAULT NULL,
  `telephone` varchar(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `supervisor_id` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `dbs_expiry_date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `module_type` varchar(255) DEFAULT NULL,
  `dbs_status` varchar(50) DEFAULT 'Pending',
  `dbs_issue_date` date DEFAULT NULL,
  `dbs_reference_number` varchar(100) DEFAULT NULL,
  `dbs_update_service` enum('Yes','No') DEFAULT 'No',
  `mdx_id` varchar(50) DEFAULT NULL,
  `emergency_contact_name` varchar(100) DEFAULT NULL,
  `emergency_contact_number` varchar(20) DEFAULT NULL,
  `personal_email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trainees`
--

INSERT INTO `trainees` (`trainee_id`, `first_name`, `surname`, `individual_supervisor`, `email`, `is_archived`, `date_of_birth`, `disability_status`, `disability_type`, `town_city`, `postcode`, `password`, `profile_image`, `trainee_code`, `address_line1`, `telephone`, `course_id`, `supervisor_id`, `start_date`, `dbs_expiry_date`, `user_id`, `module_id`, `module_type`, `dbs_status`, `dbs_issue_date`, `dbs_reference_number`, `dbs_update_service`, `mdx_id`, `emergency_contact_name`, `emergency_contact_number`, `personal_email`) VALUES
('3JFYB8ZR', 'TraineeTEST2', 'SecondTraineeTEST', 1, 'trainee2test@test.com', 1, '2000-01-01', 'No', '', 'Leicester', 'L1165', '$2y$10$63suuRSxEqPvd35rfaW/JuzW5LFFS8DxIeA/CXmBVCHUKMcj/dtNW', NULL, 'TRN-2025-002', 'Trainee 2 Leicester', '99999888888', NULL, 1, '2025-09-22', NULL, 14, NULL, NULL, 'Pending', NULL, NULL, 'No', NULL, NULL, NULL, NULL),
('50B79496', 'Trainee_8_TEST', 'Trainee_8', NULL, 'trainee8@terapia.co.uk', 0, '1989-12-22', 'No', '', 'Leeds', 'L1 7GG', '$2y$10$E2mfkk8ch6WhmoOKMjiNNebW9Q8conQuHKewiD4gAjb2XQNgiDibq', 'uploads/1760113214_Trainee_8.jpg', NULL, 'Trainee_8_Test', '77766655544', 6, NULL, '2025-10-10', '2027-10-10', 20, 27, NULL, 'Cleared', '2025-10-09', 'JJJYYY88', 'Yes', 'T7GGG', 'Trainee 8 Mum', '777222555433', 'TSETTrainee8@test.com'),
('6HBZNJPS', 'Trainee_5_TEST', 'Trainee_5', NULL, 'trainee5@terapia.co.uk', 0, '1999-04-04', 'No', '', 'Newcastle', 'NE1 7GG', '$2y$10$F4nmOhYpod88nHtDc0m4aunwH95vbMMfT/OSAUk/6buQ50fT8S/Gm', 'uploads/1759246153_Trainee_5.jpg', 'TRN-2025-005', 'Trainee_5_Test', '00099988877', 1, 6, '2023-01-01', '0000-00-00', NULL, 18, NULL, 'Pending', '0000-00-00', '', 'No', '00005fg', '', '', ''),
('91A34609', 'Trainee_7_TEST', 'Trainee_7', NULL, 'trainee7@terapia.co.uk', 0, '1999-07-13', 'No', '', 'Totnes', 'EX1 8GG', '$2y$10$ol9a0wtWxze2z9hUfOQVk.S0iqUmc1vsTYitg1QKG9v6XvGosSrBi', 'uploads/1760026688_Trainee_7.jpg', NULL, 'Trainee_7_Test', '00077766655', 5, NULL, '2025-10-09', '2026-01-10', NULL, 22, NULL, 'Cleared', '2024-10-10', '777666444', 'Yes', '', 'Trainee 7 Mum', '00099977766', 'TSETTrainee7@test.com'),
('BW4Q86I3', 'Trainee_4_Test', 'TEST_Trainee_4', 3, 'trainee4@terapia.co.uk', 0, '2003-08-30', 'Yes', 'Visual', 'York', 'Y1 7FV', '$2y$10$Vp59siIlcNrgQhj1Z/J.T.am/Vv.o/gyaPBI1DIsoa2YFH2wNMWte', 'uploads/1758545252_Trainee_4.jpg', 'TRN-2025-004', 'Trainee_4_Test', '07813334567', 4, 1, '2025-10-07', '0000-00-00', 13, 24, NULL, 'Pending', '0000-00-00', '', 'No', '886655G', 'Trainee 4 Dad', '00099988865', 'trainee4@test.com'),
('PSJ2UC5H', 'Trainee1', 'Number1', 3, 'testtrainee1@test.com', 0, '1980-12-22', 'No', '', 'Sheffield', 'S11NG', '$2y$10$1rebzsCQi/rcf2r3Ohnlb.3KhL399ot4ZT3L287/6GR6KWBypQ6Li', 'uploads/1758543598_Trainee_1.jpg', 'TRN-2025-001', '49 Test Trainee Road', '01322434432', 1, 3, '2025-08-16', '0000-00-00', 16, 20, NULL, 'Pending', '0000-00-00', '', 'No', 'EGA09ADR', NULL, NULL, NULL),
('X48L3V6O', 'Trainee_3_Test', 'TEST_Trainee_3', 1, 'trainee3@terapia.co.uk', 0, '2006-10-22', 'No', '', 'Ashford', 'AS67 5FF', '$2y$10$3Gt10unhF4.s.lmSyqmwfef5/PLx2.1a0/Ur60kUhc5CSUlEyGyV2', 'uploads/1758544937_Trainee_3.jpg', 'TRN-2025-003', 'Trainee_3_Test', '11111000000', 5, 1, '2025-10-02', '0000-00-00', 17, 22, NULL, 'Pending', '0000-00-00', '', 'No', 'TEST665544MDX', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `trainees_history`
--

CREATE TABLE `trainees_history` (
  `history_id` int(11) NOT NULL,
  `trainee_id` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `previous_module_id` int(11) NOT NULL,
  `new_module_id` int(11) NOT NULL,
  `changed_at` datetime DEFAULT current_timestamp(),
  `changed_by` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trainees_history`
--

INSERT INTO `trainees_history` (`history_id`, `trainee_id`, `previous_module_id`, `new_module_id`, `changed_at`, `changed_by`) VALUES
(1, '6HBZNJPS', 19, 20, '2025-10-09 16:50:11', 'system'),
(2, 'PSJ2UC5H', 18, 19, '2025-10-09 17:01:49', 'system'),
(3, 'PSJ2UC5H', 19, 20, '2025-10-09 17:04:54', 'system'),
(4, '6HBZNJPS', 17, 18, '2025-10-10 16:55:03', 'system');

-- --------------------------------------------------------

--
-- Table structure for table `trainee_assignments`
--

CREATE TABLE `trainee_assignments` (
  `id` int(11) NOT NULL,
  `trainee_id` varchar(8) NOT NULL,
  `assignment_id` int(11) DEFAULT NULL,
  `type_id` int(11) NOT NULL,
  `assigned_date` date NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('pending','submitted','graded') DEFAULT 'pending',
  `assigned_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `assignment_notes` text DEFAULT NULL,
  `assignment_instructions` text DEFAULT NULL,
  `assignment_description` text DEFAULT NULL,
  `submitted_file` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trainee_assignments`
--

INSERT INTO `trainee_assignments` (`id`, `trainee_id`, `assignment_id`, `type_id`, `assigned_date`, `due_date`, `status`, `assigned_by`, `created_at`, `updated_at`, `assignment_notes`, `assignment_instructions`, `assignment_description`, `submitted_file`) VALUES
(3, '3JFYB8ZR', 6, 1, '2025-09-18', '2025-09-25', 'pending', 1, '2025-09-18 23:25:10', '2025-09-23 16:20:27', NULL, NULL, NULL, NULL),
(4, 'PSJ2UC5H', 6, 2, '2025-09-17', '2025-09-24', 'submitted', 4, '2025-09-18 23:25:10', '2025-09-23 16:20:27', NULL, NULL, NULL, NULL),
(5, '3JFYB8ZR', 6, 7, '5555-01-01', '6666-03-30', 'pending', 1, '2025-09-18 23:27:23', '2025-09-23 16:20:27', NULL, NULL, NULL, NULL),
(6, 'BW4Q86I3', NULL, 1, '2025-09-01', '2025-09-15', 'pending', NULL, '2025-09-23 22:33:30', '2025-09-23 22:33:30', NULL, NULL, NULL, NULL),
(7, '3JFYB8ZR', 6, 8, '2025-09-19', '2027-03-03', 'pending', 3, '2025-09-19 14:31:43', '2025-09-23 16:20:27', NULL, NULL, NULL, NULL),
(8, 'PSJ2UC5H', NULL, 3, '2025-09-05', '2025-09-20', 'pending', NULL, '2025-09-23 22:33:30', '2025-09-23 22:33:30', NULL, NULL, NULL, NULL),
(9, '3JFYB8ZR', 6, 9, '2025-09-19', '2025-09-26', 'pending', 1, '2025-09-19 18:24:33', '2025-09-23 16:20:27', NULL, NULL, NULL, NULL),
(10, 'PSJ2UC5H', 6, 8, '2025-09-23', '2025-09-30', 'pending', 1, '2025-09-23 14:45:29', '2025-09-23 16:20:27', 'MHRA Referencing', '4,000 words,', 'Test Dissertation Assignment', NULL),
(11, 'PSJ2UC5H', 6, 3, '2025-09-23', '2025-09-23', 'pending', 1, '2025-09-23 15:10:32', '2025-09-23 16:20:27', 'MHRA', 'Test Assignment', 'TEST Assignment', NULL),
(12, 'PSJ2UC5H', 8, 7, '2025-09-23', '2025-09-24', 'pending', 1, '2025-09-23 15:31:28', '2025-09-23 15:31:28', 'TEST999', 'TEST999', 'TEST999', NULL),
(13, 'BW4Q86I3', 6, 5, '2025-09-23', '2025-09-23', 'pending', 1, '2025-09-23 16:13:35', '2025-09-23 16:13:35', 'Trainee_4_Assignment', 'Trainee_4_Assignment', 'Trainee_4_Assignment', NULL),
(14, '6HBZNJPS', 18, 8, '2025-10-01', '2025-10-30', 'pending', 3, '2025-10-01 21:19:36', '2025-10-01 21:19:36', 'Yessir', 'TEST For Trainee 5', 'TEST For Trainee 5', NULL),
(15, 'PSJ2UC5H', 10, 9, '2025-10-07', '2026-09-30', 'pending', 1, '2025-10-07 15:05:35', '2025-10-07 15:05:35', 'TEST Group Assignment', 'TEST Group Assignment', 'TEST Group Assignment', NULL),
(16, '6HBZNJPS', 10, 9, '2025-10-07', '2026-09-30', 'pending', 1, '2025-10-07 15:05:35', '2025-10-07 15:05:35', 'TEST Group Assignment', 'TEST Group Assignment', 'TEST Group Assignment', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `trainee_courses`
--

CREATE TABLE `trainee_courses` (
  `id` int(11) NOT NULL,
  `trainee_id` varchar(8) DEFAULT NULL,
  `course_id` int(11) NOT NULL,
  `assigned_at` datetime DEFAULT current_timestamp(),
  `status_flag` varchar(20) DEFAULT 'green',
  `enrolment_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trainee_courses`
--

INSERT INTO `trainee_courses` (`id`, `trainee_id`, `course_id`, `assigned_at`, `status_flag`, `enrolment_date`) VALUES
(17, 'PSJ2UC5H', 1, '2025-09-22 13:32:13', 'green', '2025-09-22'),
(18, '3JFYB8ZR', 4, '2025-09-22 13:32:41', 'green', '2025-09-22'),
(19, 'X48L3V6O', 3, '2025-09-22 13:42:17', 'green', '2024-08-01'),
(20, 'BW4Q86I3', 5, '2025-09-22 13:47:32', 'green', '2020-12-01'),
(21, '6HBZNJPS', 1, '2025-09-30 16:28:25', 'green', '2025-09-30'),
(22, '91A34609', 5, '2025-10-09 17:20:47', 'Active', '2025-10-09');

-- --------------------------------------------------------

--
-- Table structure for table `trainee_course_enrollments`
--

CREATE TABLE `trainee_course_enrollments` (
  `enrollment_id` int(11) NOT NULL,
  `trainee_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `expected_finish_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trainee_logs`
--

CREATE TABLE `trainee_logs` (
  `log_id` int(11) NOT NULL,
  `trainee_id` int(11) NOT NULL,
  `action_type` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `performed_by` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trainee_logs`
--

INSERT INTO `trainee_logs` (`log_id`, `trainee_id`, `action_type`, `description`, `timestamp`, `performed_by`) VALUES
(1, 1, 'course_added', 'Assigned course: MA Conversion Course', '2025-09-15 22:12:00', 'superuser'),
(2, 0, 'course_added', 'Assigned course: MA Conversion Course', '2025-09-19 09:07:27', 'superuser'),
(3, 0, 'course_added', 'Assigned course: MA in Child and Adolescent Psychotherapy and Counselling', '2025-09-22 13:32:13', 'superuser'),
(4, 3, 'course_added', 'Assigned course: Supervision Training', '2025-09-22 13:32:41', 'superuser'),
(5, 6, 'Module Progression', 'Advanced to module ID 19', '2025-10-08 15:42:54', 'system'),
(6, 6, 'Module Progression', 'Advanced to module ID 20', '2025-10-09 16:50:11', 'system'),
(7, 0, 'Module Progression', 'Advanced to module ID 19', '2025-10-09 17:01:49', 'system'),
(8, 0, 'Module Progression', 'Advanced to module ID 20', '2025-10-09 17:04:54', 'system'),
(9, 6, 'Module Progression', 'Advanced to module ID 18', '2025-10-10 16:55:03', 'system');

-- --------------------------------------------------------

--
-- Table structure for table `trainee_portfolio`
--

CREATE TABLE `trainee_portfolio` (
  `portfolio_id` int(11) NOT NULL,
  `trainee_id` varchar(8) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `uploaded_at` datetime DEFAULT current_timestamp(),
  `category` varchar(100) DEFAULT NULL,
  `linked_assignment_id` int(11) DEFAULT NULL,
  `linked_skill` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trainee_progress_log`
--

CREATE TABLE `trainee_progress_log` (
  `log_id` int(11) NOT NULL,
  `trainee_id` varchar(8) NOT NULL,
  `metric_type` varchar(50) DEFAULT NULL,
  `metric_value` decimal(5,2) DEFAULT NULL,
  `recorded_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trainee_supervision_groups`
--

CREATE TABLE `trainee_supervision_groups` (
  `id` int(11) NOT NULL,
  `trainee_id` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trainee_supervisors`
--

CREATE TABLE `trainee_supervisors` (
  `trainee_id` varchar(8) NOT NULL,
  `supervisor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trainee_tutor`
--

CREATE TABLE `trainee_tutor` (
  `tutor_id` int(11) NOT NULL,
  `trainee_id` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trainee_tutors`
--

CREATE TABLE `trainee_tutors` (
  `id` int(11) NOT NULL,
  `trainee_id` varchar(8) NOT NULL,
  `tutor_id` int(11) NOT NULL,
  `assigned_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trainee_tutors`
--

INSERT INTO `trainee_tutors` (`id`, `trainee_id`, `tutor_id`, `assigned_date`) VALUES
(1, '12', 1, '2025-09-16'),
(2, 'PSJ2UC5H', 3, '2025-09-19');

-- --------------------------------------------------------

--
-- Table structure for table `tutors`
--

CREATE TABLE `tutors` (
  `tutor_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  `job_title` varchar(100) DEFAULT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `dbs_update_service` tinyint(1) DEFAULT 0,
  `is_archived` tinyint(1) DEFAULT 0,
  `date_of_birth` date DEFAULT NULL,
  `disability_status` varchar(10) DEFAULT NULL,
  `disability_type` varchar(255) DEFAULT NULL,
  `address_line1` varchar(255) DEFAULT NULL,
  `town_city` varchar(100) DEFAULT NULL,
  `postcode` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `dbs_status` varchar(50) DEFAULT 'Pending',
  `dbs_date` date DEFAULT NULL,
  `dbs_reference` varchar(100) DEFAULT NULL,
  `dbs_expiry_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tutors`
--

INSERT INTO `tutors` (`tutor_id`, `user_id`, `first_name`, `surname`, `email`, `role`, `job_title`, `telephone`, `start_date`, `profile_image`, `dbs_update_service`, `is_archived`, `date_of_birth`, `disability_status`, `disability_type`, `address_line1`, `town_city`, `postcode`, `password`, `dbs_status`, `dbs_date`, `dbs_reference`, `dbs_expiry_date`) VALUES
(1, 1, 'Tutor1', 'Tutor1TEST', 'tutor_1test@terapia.co.uk', 'tutor', 'TUTOR_TEST1', '00000777777', '2025-09-16', '1758048505_Pingu.jpg', 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL),
(2, 2, 'TUTOR_2', 'TESTING_Tutor2', 'tutor2test@test.com', 'tutor', 'TUTOR_TEST2', '22222288888', '2025-09-19', NULL, 0, 0, '1987-10-22', 'No', '', 'TUTOR_2 TEST', 'Nottingham', 'N12 5GG', '$2y$10$V3g0HBY7Ej5YOkU72NfsZ.YuFtWPrQ8b1MTYI9W7X0abSh5W16DdK', 'Pending', '0000-00-00', '', '0000-00-00'),
(3, 3, 'TUTOR_3', 'TESTING_Tutor3', 'tutor_3_test@terapia.co.uk', 'tutor', 'TUTOR_TEST3', '99999997777', '2025-09-19', NULL, 0, 0, '1970-01-01', 'No', '', 'TUTOR_3 TEST', 'Bath', 'BA1 5FF', '$2y$10$E.RnsfABvM.4MqSiHIVGv.do2EErSrbo1BFA9cTq4AiQuxs.Wq5sy', 'Pending', NULL, NULL, NULL),
(15, 19, 'TUTOR_6', 'TESTING_Tutor6', 'tutor_6_test@terapia.co.uk', 'tutor', 'TUTOR_TEST6', '11188877766', '2025-10-01', NULL, 1, 0, '2005-08-04', 'No', '', 'TUTOR_6 TEST', 'Inverness', 'IV7 9GG', '$2y$10$n8bi/yqgKd8ncTdSaQ3NK.5rTVpLCxuzhbHKB29EXjvVNeZHcFmwu', 'Cleared', '2024-01-01', '77766655544', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tutor_courses`
--

CREATE TABLE `tutor_courses` (
  `tutor_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `assigned_date` date DEFAULT curdate(),
  `assigned_by` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutor_courses`
--

INSERT INTO `tutor_courses` (`tutor_id`, `course_id`, `assigned_date`, `assigned_by`, `notes`, `created_at`) VALUES
(2, 3, '2025-10-03', NULL, NULL, '2025-10-03 17:14:29'),
(2, 5, '2025-10-03', NULL, NULL, '2025-10-03 17:14:29'),
(3, 2, '2025-10-01', NULL, NULL, '2025-10-01 17:24:31'),
(15, 1, '2025-10-01', NULL, NULL, '2025-10-01 17:20:48');

-- --------------------------------------------------------

--
-- Table structure for table `tutor_feedback`
--

CREATE TABLE `tutor_feedback` (
  `feedback_id` int(11) NOT NULL,
  `trainee_id` varchar(8) NOT NULL,
  `tutor_id` int(11) NOT NULL,
  `feedback_date` date NOT NULL,
  `notes` text DEFAULT NULL,
  `alert_flag` enum('none','safeguarding','performance','attendance') DEFAULT 'none',
  `resolved` tinyint(1) DEFAULT 0,
  `follow_up_date` date DEFAULT NULL,
  `resolution_notes` text DEFAULT NULL,
  `resolution_date` date DEFAULT NULL,
  `resolution_outcome` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutor_modules`
--

CREATE TABLE `tutor_modules` (
  `tutor_module_id` int(11) NOT NULL,
  `tutor_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutor_modules`
--

INSERT INTO `tutor_modules` (`tutor_module_id`, `tutor_id`, `module_id`, `assigned_at`) VALUES
(2, 15, 17, '2025-10-01 16:20:48'),
(3, 3, 15, '2025-10-01 16:24:31'),
(4, 2, 15, '2025-10-03 16:14:29');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('staff','tutor','trainee','admin','supervisor') NOT NULL,
  `is_archived` tinyint(1) DEFAULT 0,
  `email` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `failed_attempts` int(11) DEFAULT 0,
  `account_locked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `role`, `is_archived`, `email`, `is_active`, `failed_attempts`, `account_locked`) VALUES
(1, 'alex', '$2y$10$0.TxkAA.j.lOoXttK6DYOOMJOI7HJcFe7ehhz0/1yi/4BBnR1BoF.', '', 0, 'alex@terapia.co.uk', 1, 0, 0),
(2, 'johndoe', 'securehashedpassword', 'trainee', 0, 'john.doe@example.com', 1, 0, 0),
(3, '', '', 'tutor', 0, 'tutor_3_test@terapia.co.uk', 1, 0, 0),
(4, 'tutor_1test@terapia.co.uk', '$2y$10$Rr/2nQ0W.AuAam7kWa3jUeA9pN6BrV5EtKrfLfNFwhXaqe1qnmVPS', 'tutor', 0, NULL, 1, 0, 0),
(13, 'Trainee_4_Test', '[hashed_password]', 'trainee', 0, 'trainee4@terapia.co.uk', 1, 0, 0),
(14, 'trainee2test', '$2y$10$63suuRSxEqPvd35rfaW/JuzW5LFFS8DxIeA/CXmBVCH...', 'trainee', 0, 'trainee2test@test.com', 1, 0, 0),
(15, 'trainee4', '$2y$10$LlVUucJpzh2ITT6Lp2maNOiwaEnVb7yU4zBQnRDGq.e...', 'trainee', 0, 'trainee4@terapia.co.uk', 1, 0, 0),
(16, 'testtrainee1', '$2y$10$1rebzsCQi/rcf2r3Ohnlb.3KhL399ot4ZT3L287/6GR...', 'trainee', 0, 'testtrainee1@test.com', 1, 0, 0),
(17, 'trainee3', '$2y$10$3Gt10unhF4.s.lmSyqmwfef5/PLx2.1a0/Ur60kUhc5...', 'trainee', 0, 'trainee3@terapia.co.uk', 1, 0, 0),
(19, NULL, '', 'tutor', 0, 'tutor_6_test@terapia.co.uk', 1, 0, 0),
(20, 'trainee8@terapia.co.uk', '$2y$10$wH3eRwi9I9OSMCHhHZqn6.ZJfy22vJ/4veBXghBau4O806qdYSvIO', 'trainee', 0, 'trainee8@terapia.co.uk', 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_calendar_events`
--

CREATE TABLE `user_calendar_events` (
  `event_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `event_date` datetime DEFAULT NULL,
  `created_by` enum('staff','tutor','admin') DEFAULT 'staff',
  `event_type` varchar(50) DEFAULT 'General',
  `color_code` varchar(10) DEFAULT '#BB9DC6',
  `recurrence` varchar(20) DEFAULT 'none',
  `recurrence_group_id` varchar(36) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_calendar_events`
--

INSERT INTO `user_calendar_events` (`event_id`, `user_id`, `title`, `description`, `event_date`, `created_by`, `event_type`, `color_code`, `recurrence`, `recurrence_group_id`, `notes`) VALUES
(1, 1, 'TEST', 'TET', '2025-09-16 09:00:00', '', 'Tutorial', '#FBBC05', 'none', NULL, NULL),
(3, 13, 'Supervision Session – Module 1', NULL, '2025-10-09 00:00:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'TEST SET 2'),
(4, 13, 'Supervision Session – Module 2', NULL, '2025-09-26 14:00:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'Session 3'),
(6, 13, 'Supervision Session – Module 2', NULL, '2025-09-27 15:00:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'Auto-added from group supervision'),
(7, 13, 'Test Entry ', 'Test Entry for Trainee 4', '2025-11-05 10:00:00', '', 'Meeting', '#EA4335', 'none', NULL, NULL),
(8, 16, 'Supervision Session – Module 2', NULL, '2025-10-30 11:00:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'TEST Group Attendance Tracker Per Trainee'),
(9, 14, 'Supervision Session – Module 2', NULL, '2025-10-30 11:00:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'TEST Group Attendance Tracker Per Trainee'),
(10, 16, 'Supervision Session – Module 2', NULL, '2025-10-27 11:00:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'TEST Group Attendance Tracker Per Trainee_TEST TWO'),
(11, 14, 'Supervision Session – Module 2', NULL, '2025-10-27 11:00:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'TEST Group Attendance Tracker Per Trainee_TEST TWO'),
(12, 16, 'Individual Supervision Session', NULL, '2025-10-03 14:30:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'TEST Individual Session Creation Trainee 1_'),
(13, 13, 'Individual Supervision Session', NULL, '2025-10-03 15:00:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'TestIndividualSessionTrainee3'),
(14, 13, 'Supervision Session – Module 1', NULL, '2025-10-03 16:00:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'TESTTRAINEE4GROUPTRACKING'),
(15, 13, 'Supervision Session – Module 1', NULL, '2025-10-03 16:00:00', 'staff', 'General', '#BB9DC6', 'none', NULL, 'TESTTRAINEE4GROUPTRACKING');

-- --------------------------------------------------------

--
-- Structure for view `assignment_tracker`
--
DROP TABLE IF EXISTS `assignment_tracker`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `assignment_tracker`  AS SELECT `ta`.`id` AS `assignment_id`, `ta`.`trainee_id` AS `trainee_id`, concat(`t`.`first_name`,' ',`t`.`surname`) AS `trainee_name`, `at`.`type_name` AS `type_name`, `ta`.`assigned_date` AS `assigned_date`, `ta`.`due_date` AS `due_date`, `ta`.`status` AS `status`, `u`.`username` AS `assigned_by`, `ta`.`created_at` AS `created_at`, `ta`.`updated_at` AS `updated_at` FROM (((`trainee_assignments` `ta` join `trainees` `t` on(`ta`.`trainee_id` = `t`.`trainee_id`)) join `assignment_types` `at` on(`ta`.`type_id` = `at`.`type_id`)) left join `users` `u` on(`ta`.`assigned_by` = `u`.`user_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `tutor_id` (`tutor_id`);

--
-- Indexes for table `assignment_logs`
--
ALTER TABLE `assignment_logs`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `assignment_submissions`
--
ALTER TABLE `assignment_submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `assignment_id` (`assignment_id`),
  ADD KEY `trainee_id` (`trainee_id`),
  ADD KEY `graded_by` (`graded_by`);

--
-- Indexes for table `assignment_types`
--
ALTER TABLE `assignment_types`
  ADD PRIMARY KEY (`type_id`);

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD KEY `idx_course_name` (`course_name`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`grade_id`),
  ADD UNIQUE KEY `submission_id` (`submission_id`),
  ADD KEY `tutor_id` (`tutor_id`);

--
-- Indexes for table `group_members`
--
ALTER TABLE `group_members`
  ADD PRIMARY KEY (`group_id`,`trainee_id`),
  ADD KEY `trainee_id` (`trainee_id`);

--
-- Indexes for table `login_activity`
--
ALTER TABLE `login_activity`
  ADD PRIMARY KEY (`activity_id`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`attempt_id`);

--
-- Indexes for table `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`module_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `role_audit_log`
--
ALTER TABLE `role_audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `changed_by` (`changed_by`);

--
-- Indexes for table `safeguarding_change_log`
--
ALTER TABLE `safeguarding_change_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `record_id` (`record_id`);

--
-- Indexes for table `safeguarding_concern_types`
--
ALTER TABLE `safeguarding_concern_types`
  ADD PRIMARY KEY (`concern_id`),
  ADD KEY `record_id` (`record_id`);

--
-- Indexes for table `safeguarding_terapiapersonnel_records`
--
ALTER TABLE `safeguarding_terapiapersonnel_records`
  ADD PRIMARY KEY (`record_id`),
  ADD KEY `idx_record_date` (`record_date`),
  ADD KEY `idx_individual_role` (`individual_role`),
  ADD KEY `idx_concern_categories` (`concern_categories`(768)),
  ADD KEY `idx_review_date` (`review_date`);

--
-- Indexes for table `session_attendance`
--
ALTER TABLE `session_attendance`
  ADD PRIMARY KEY (`session_id`,`trainee_id`),
  ADD KEY `session_attendance_ibfk_2` (`trainee_id`);

--
-- Indexes for table `session_phrase_log`
--
ALTER TABLE `session_phrase_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staff_id`);

--
-- Indexes for table `submissions`
--
ALTER TABLE `submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `assignment_id` (`assignment_id`),
  ADD KEY `trainee_id` (`trainee_id`);

--
-- Indexes for table `submission_audit_log`
--
ALTER TABLE `submission_audit_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `submission_id` (`submission_id`),
  ADD KEY `graded_by` (`graded_by`);

--
-- Indexes for table `supervision_attendance`
--
ALTER TABLE `supervision_attendance`
  ADD PRIMARY KEY (`attendance_id`),
  ADD KEY `session_id` (`session_id`),
  ADD KEY `trainee_id` (`trainee_id`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `supervision_audit_log`
--
ALTER TABLE `supervision_audit_log`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `supervision_groups`
--
ALTER TABLE `supervision_groups`
  ADD PRIMARY KEY (`group_id`),
  ADD KEY `supervisor_id` (`supervisor_id`);

--
-- Indexes for table `supervision_group_trainees`
--
ALTER TABLE `supervision_group_trainees`
  ADD PRIMARY KEY (`group_id`,`trainee_id`),
  ADD KEY `idx_trainee_id` (`trainee_id`);

--
-- Indexes for table `supervision_sessions`
--
ALTER TABLE `supervision_sessions`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `group_id` (`group_id`);

--
-- Indexes for table `supervision_session_notes`
--
ALTER TABLE `supervision_session_notes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `supervision_session_trainees`
--
ALTER TABLE `supervision_session_trainees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `session_id` (`session_id`),
  ADD KEY `trainee_id` (`trainee_id`);

--
-- Indexes for table `supervisors`
--
ALTER TABLE `supervisors`
  ADD PRIMARY KEY (`supervisor_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `supervisor_courses`
--
ALTER TABLE `supervisor_courses`
  ADD PRIMARY KEY (`supervisor_course_id`),
  ADD KEY `supervisor_id` (`supervisor_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `supervisor_modules`
--
ALTER TABLE `supervisor_modules`
  ADD PRIMARY KEY (`supervisor_module_id`),
  ADD KEY `supervisor_id` (`supervisor_id`),
  ADD KEY `module_id` (`module_id`);

--
-- Indexes for table `trainees`
--
ALTER TABLE `trainees`
  ADD PRIMARY KEY (`trainee_id`),
  ADD UNIQUE KEY `mdx_id` (`mdx_id`),
  ADD KEY `idx_surname` (`surname`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `fk_trainee_supervisor` (`supervisor_id`),
  ADD KEY `fk_individual_supervisor` (`individual_supervisor`),
  ADD KEY `fk_module_id` (`module_id`);

--
-- Indexes for table `trainees_history`
--
ALTER TABLE `trainees_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `trainee_id` (`trainee_id`);

--
-- Indexes for table `trainee_assignments`
--
ALTER TABLE `trainee_assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `trainee_id` (`trainee_id`),
  ADD KEY `type_id` (`type_id`),
  ADD KEY `assigned_by` (`assigned_by`);

--
-- Indexes for table `trainee_courses`
--
ALTER TABLE `trainee_courses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `idx_trainee_course` (`trainee_id`,`course_id`);

--
-- Indexes for table `trainee_course_enrollments`
--
ALTER TABLE `trainee_course_enrollments`
  ADD PRIMARY KEY (`enrollment_id`),
  ADD KEY `trainee_id` (`trainee_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `trainee_logs`
--
ALTER TABLE `trainee_logs`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `trainee_portfolio`
--
ALTER TABLE `trainee_portfolio`
  ADD PRIMARY KEY (`portfolio_id`),
  ADD KEY `trainee_id` (`trainee_id`);

--
-- Indexes for table `trainee_progress_log`
--
ALTER TABLE `trainee_progress_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `trainee_id` (`trainee_id`);

--
-- Indexes for table `trainee_supervision_groups`
--
ALTER TABLE `trainee_supervision_groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `trainee_supervision_groups_ibfk_1` (`trainee_id`);

--
-- Indexes for table `trainee_supervisors`
--
ALTER TABLE `trainee_supervisors`
  ADD PRIMARY KEY (`trainee_id`,`supervisor_id`),
  ADD KEY `supervisor_id` (`supervisor_id`);

--
-- Indexes for table `trainee_tutor`
--
ALTER TABLE `trainee_tutor`
  ADD PRIMARY KEY (`tutor_id`,`trainee_id`),
  ADD KEY `trainee_id` (`trainee_id`);

--
-- Indexes for table `trainee_tutors`
--
ALTER TABLE `trainee_tutors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `trainee_id` (`trainee_id`),
  ADD KEY `tutor_id` (`tutor_id`);

--
-- Indexes for table `tutors`
--
ALTER TABLE `tutors`
  ADD PRIMARY KEY (`tutor_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Indexes for table `tutor_courses`
--
ALTER TABLE `tutor_courses`
  ADD PRIMARY KEY (`tutor_id`,`course_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `fk_assigned_by_user` (`assigned_by`);

--
-- Indexes for table `tutor_feedback`
--
ALTER TABLE `tutor_feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `trainee_id` (`trainee_id`),
  ADD KEY `tutor_id` (`tutor_id`);

--
-- Indexes for table `tutor_modules`
--
ALTER TABLE `tutor_modules`
  ADD PRIMARY KEY (`tutor_module_id`),
  ADD KEY `tutor_id` (`tutor_id`),
  ADD KEY `module_id` (`module_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `user_calendar_events`
--
ALTER TABLE `user_calendar_events`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `assignment_logs`
--
ALTER TABLE `assignment_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `assignment_submissions`
--
ALTER TABLE `assignment_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `assignment_types`
--
ALTER TABLE `assignment_types`
  MODIFY `type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=294;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `grade_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login_activity`
--
ALTER TABLE `login_activity`
  MODIFY `activity_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- AUTO_INCREMENT for table `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `attempt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `modules`
--
ALTER TABLE `modules`
  MODIFY `module_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `role_audit_log`
--
ALTER TABLE `role_audit_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `safeguarding_change_log`
--
ALTER TABLE `safeguarding_change_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `safeguarding_concern_types`
--
ALTER TABLE `safeguarding_concern_types`
  MODIFY `concern_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `safeguarding_terapiapersonnel_records`
--
ALTER TABLE `safeguarding_terapiapersonnel_records`
  MODIFY `record_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `session_phrase_log`
--
ALTER TABLE `session_phrase_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `staff_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `submissions`
--
ALTER TABLE `submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `submission_audit_log`
--
ALTER TABLE `submission_audit_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `supervision_attendance`
--
ALTER TABLE `supervision_attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `supervision_audit_log`
--
ALTER TABLE `supervision_audit_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supervision_groups`
--
ALTER TABLE `supervision_groups`
  MODIFY `group_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `supervision_sessions`
--
ALTER TABLE `supervision_sessions`
  MODIFY `session_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `supervision_session_notes`
--
ALTER TABLE `supervision_session_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supervision_session_trainees`
--
ALTER TABLE `supervision_session_trainees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `supervisors`
--
ALTER TABLE `supervisors`
  MODIFY `supervisor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `supervisor_courses`
--
ALTER TABLE `supervisor_courses`
  MODIFY `supervisor_course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `supervisor_modules`
--
ALTER TABLE `supervisor_modules`
  MODIFY `supervisor_module_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `trainees_history`
--
ALTER TABLE `trainees_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `trainee_assignments`
--
ALTER TABLE `trainee_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `trainee_courses`
--
ALTER TABLE `trainee_courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `trainee_course_enrollments`
--
ALTER TABLE `trainee_course_enrollments`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trainee_logs`
--
ALTER TABLE `trainee_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `trainee_portfolio`
--
ALTER TABLE `trainee_portfolio`
  MODIFY `portfolio_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trainee_progress_log`
--
ALTER TABLE `trainee_progress_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trainee_supervision_groups`
--
ALTER TABLE `trainee_supervision_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `trainee_tutors`
--
ALTER TABLE `trainee_tutors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tutors`
--
ALTER TABLE `tutors`
  MODIFY `tutor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tutor_feedback`
--
ALTER TABLE `tutor_feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutor_modules`
--
ALTER TABLE `tutor_modules`
  MODIFY `tutor_module_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `user_calendar_events`
--
ALTER TABLE `user_calendar_events`
  MODIFY `event_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignments`
--
ALTER TABLE `assignments`
  ADD CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `assignments_ibfk_2` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`tutor_id`) ON DELETE CASCADE;

--
-- Constraints for table `assignment_submissions`
--
ALTER TABLE `assignment_submissions`
  ADD CONSTRAINT `assignment_submissions_ibfk_1` FOREIGN KEY (`graded_by`) REFERENCES `staff` (`staff_id`);

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`tutor_id`) ON DELETE CASCADE;

--
-- Constraints for table `group_members`
--
ALTER TABLE `group_members`
  ADD CONSTRAINT `group_members_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `supervision_groups` (`group_id`);

--
-- Constraints for table `role_audit_log`
--
ALTER TABLE `role_audit_log`
  ADD CONSTRAINT `role_audit_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `staff` (`staff_id`),
  ADD CONSTRAINT `role_audit_log_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `staff` (`staff_id`);

--
-- Constraints for table `safeguarding_change_log`
--
ALTER TABLE `safeguarding_change_log`
  ADD CONSTRAINT `safeguarding_change_log_ibfk_1` FOREIGN KEY (`record_id`) REFERENCES `safeguarding_terapiapersonnel_records` (`record_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `safeguarding_concern_types`
--
ALTER TABLE `safeguarding_concern_types`
  ADD CONSTRAINT `safeguarding_concern_types_ibfk_1` FOREIGN KEY (`record_id`) REFERENCES `safeguarding_terapiapersonnel_records` (`record_id`) ON DELETE CASCADE;

--
-- Constraints for table `session_attendance`
--
ALTER TABLE `session_attendance`
  ADD CONSTRAINT `session_attendance_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `supervision_sessions` (`session_id`);

--
-- Constraints for table `session_phrase_log`
--
ALTER TABLE `session_phrase_log`
  ADD CONSTRAINT `session_phrase_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `submissions`
--
ALTER TABLE `submissions`
  ADD CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`assignment_id`) ON DELETE CASCADE;

--
-- Constraints for table `submission_audit_log`
--
ALTER TABLE `submission_audit_log`
  ADD CONSTRAINT `submission_audit_log_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `assignment_submissions` (`submission_id`),
  ADD CONSTRAINT `submission_audit_log_ibfk_2` FOREIGN KEY (`graded_by`) REFERENCES `staff` (`staff_id`);

--
-- Constraints for table `supervision_attendance`
--
ALTER TABLE `supervision_attendance`
  ADD CONSTRAINT `supervision_attendance_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `supervision_sessions` (`session_id`),
  ADD CONSTRAINT `supervision_attendance_ibfk_2` FOREIGN KEY (`trainee_id`) REFERENCES `trainees` (`trainee_id`),
  ADD CONSTRAINT `supervision_attendance_ibfk_3` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `supervision_groups`
--
ALTER TABLE `supervision_groups`
  ADD CONSTRAINT `supervision_groups_ibfk_1` FOREIGN KEY (`supervisor_id`) REFERENCES `staff` (`staff_id`);

--
-- Constraints for table `supervision_sessions`
--
ALTER TABLE `supervision_sessions`
  ADD CONSTRAINT `supervision_sessions_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `supervision_groups` (`group_id`);

--
-- Constraints for table `supervision_session_trainees`
--
ALTER TABLE `supervision_session_trainees`
  ADD CONSTRAINT `supervision_session_trainees_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `supervision_sessions` (`session_id`),
  ADD CONSTRAINT `supervision_session_trainees_ibfk_2` FOREIGN KEY (`trainee_id`) REFERENCES `trainees` (`trainee_id`);

--
-- Constraints for table `supervisor_courses`
--
ALTER TABLE `supervisor_courses`
  ADD CONSTRAINT `supervisor_courses_ibfk_1` FOREIGN KEY (`supervisor_id`) REFERENCES `supervisors` (`supervisor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `supervisor_courses_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `supervisor_modules`
--
ALTER TABLE `supervisor_modules`
  ADD CONSTRAINT `supervisor_modules_ibfk_1` FOREIGN KEY (`supervisor_id`) REFERENCES `supervisors` (`supervisor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `supervisor_modules_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `modules` (`module_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `trainees`
--
ALTER TABLE `trainees`
  ADD CONSTRAINT `fk_individual_supervisor` FOREIGN KEY (`individual_supervisor`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_module_id` FOREIGN KEY (`module_id`) REFERENCES `modules` (`module_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_trainee_supervisor` FOREIGN KEY (`supervisor_id`) REFERENCES `supervisors` (`supervisor_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `trainees_ibfk_1` FOREIGN KEY (`supervisor_id`) REFERENCES `supervisors` (`supervisor_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `trainees_ibfk_2` FOREIGN KEY (`supervisor_id`) REFERENCES `supervisors` (`supervisor_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `trainees_history`
--
ALTER TABLE `trainees_history`
  ADD CONSTRAINT `trainees_history_ibfk_1` FOREIGN KEY (`trainee_id`) REFERENCES `trainees` (`trainee_id`);

--
-- Constraints for table `trainee_assignments`
--
ALTER TABLE `trainee_assignments`
  ADD CONSTRAINT `trainee_assignments_ibfk_2` FOREIGN KEY (`type_id`) REFERENCES `assignment_types` (`type_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `trainee_assignments_ibfk_3` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `trainee_courses`
--
ALTER TABLE `trainee_courses`
  ADD CONSTRAINT `fk_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_trainee` FOREIGN KEY (`trainee_id`) REFERENCES `trainees` (`trainee_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `trainee_courses_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);

--
-- Constraints for table `trainee_course_enrollments`
--
ALTER TABLE `trainee_course_enrollments`
  ADD CONSTRAINT `trainee_course_enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;

--
-- Constraints for table `trainee_supervision_groups`
--
ALTER TABLE `trainee_supervision_groups`
  ADD CONSTRAINT `trainee_supervision_groups_ibfk_1` FOREIGN KEY (`trainee_id`) REFERENCES `trainees` (`trainee_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `trainee_supervision_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `supervision_groups` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `trainee_supervisors`
--
ALTER TABLE `trainee_supervisors`
  ADD CONSTRAINT `trainee_supervisors_ibfk_2` FOREIGN KEY (`supervisor_id`) REFERENCES `supervisors` (`supervisor_id`);

--
-- Constraints for table `trainee_tutor`
--
ALTER TABLE `trainee_tutor`
  ADD CONSTRAINT `trainee_tutor_ibfk_1` FOREIGN KEY (`tutor_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `trainee_tutors`
--
ALTER TABLE `trainee_tutors`
  ADD CONSTRAINT `trainee_tutors_ibfk_2` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`tutor_id`);

--
-- Constraints for table `tutors`
--
ALTER TABLE `tutors`
  ADD CONSTRAINT `fk_tutor_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `tutors_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `tutor_courses`
--
ALTER TABLE `tutor_courses`
  ADD CONSTRAINT `fk_assigned_by_user` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `tutor_courses_ibfk_1` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`tutor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tutor_courses_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tutor_feedback`
--
ALTER TABLE `tutor_feedback`
  ADD CONSTRAINT `tutor_feedback_ibfk_2` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`tutor_id`);

--
-- Constraints for table `tutor_modules`
--
ALTER TABLE `tutor_modules`
  ADD CONSTRAINT `tutor_modules_ibfk_1` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`tutor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tutor_modules_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `modules` (`module_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_calendar_events`
--
ALTER TABLE `user_calendar_events`
  ADD CONSTRAINT `user_calendar_events_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
