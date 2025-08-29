-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 29, 2025 at 03:32 PM
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
-- Database: `mccgisv3`
--

-- --------------------------------------------------------

--
-- Table structure for table `assignments`
--

CREATE TABLE `assignments` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `course` varchar(10) NOT NULL,
  `year` int(11) NOT NULL,
  `section` varchar(10) NOT NULL,
  `ay_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assignments`
--

INSERT INTO `assignments` (`id`, `teacher_id`, `subject_id`, `course`, `year`, `section`, `ay_id`) VALUES
(1, 73, 80, 'BSIT', 1, 'Northeast', 25),
(2, 73, 80, 'BSIT', 1, 'Southeast', 25),
(3, 73, 80, 'BSIT', 1, 'East', 25),
(4, 89, 100, 'BSIT', 2, 'Southeast', 25),
(5, 89, 100, 'BSIT', 2, 'Northeast', 25),
(6, 89, 100, 'BSIT', 2, 'Southwest', 25),
(7, 89, 100, 'BSIT', 2, 'Northwest', 25),
(8, 89, 100, 'BSIT', 2, 'West', 25),
(9, 77, 101, 'BSIT', 2, 'East', 25),
(10, 77, 101, 'BSIT', 2, 'West', 25),
(11, 77, 101, 'BSIT', 2, 'North', 25),
(12, 77, 101, 'BSIT', 2, 'South', 25),
(13, 77, 101, 'BSIT', 2, 'Northeast', 25),
(14, 80, 97, 'BSIT', 2, 'Northeast', 25),
(15, 80, 97, 'BSIT', 2, 'Southeast', 25),
(16, 80, 97, 'BSIT', 2, 'Northwest', 25),
(17, 80, 97, 'BSIT', 2, 'Southwest', 25),
(18, 80, 97, 'BSIT', 2, 'East', 25),
(19, 112, 81, 'BSIT', 1, 'Southeast', 25),
(20, 112, 81, 'BSIT', 1, 'Northeast', 25),
(21, 112, 81, 'BSIT', 1, 'West', 25),
(22, 112, 81, 'BSIT', 1, 'East', 25),
(23, 113, 79, 'BSIT', 1, 'Southwest', 25),
(24, 113, 79, 'BSIT', 1, 'Northeast', 25),
(25, 113, 79, 'BSIT', 1, 'Southeast', 25),
(26, 113, 79, 'BSIT', 1, 'North', 25),
(27, 113, 79, 'BSIT', 1, 'South', 25),
(28, 113, 79, 'BSIT', 1, 'East', 25),
(29, 113, 79, 'BSIT', 1, 'West', 25),
(30, 106, 98, 'BSIT', 2, 'Southwest', 25),
(31, 106, 98, 'BSIT', 2, 'Northwest', 25),
(32, 106, 98, 'BSIT', 2, 'South', 25),
(33, 106, 98, 'BSIT', 2, 'North', 25),
(34, 106, 98, 'BSIT', 2, 'West', 25),
(35, 107, 129, 'BSIT', 4, 'West', 25),
(36, 107, 129, 'BSIT', 4, 'North', 25),
(37, 107, 129, 'BSIT', 4, 'East', 25),
(38, 108, 98, 'BSIT', 2, 'Northeast', 25),
(39, 108, 98, 'BSIT', 2, 'East', 25),
(40, 108, 98, 'BSIT', 2, 'Southeast', 25),
(41, 110, 81, 'BSIT', 1, 'Southwest', 25),
(42, 100, 99, 'BSIT', 2, 'West', 25),
(43, 100, 99, 'BSIT', 2, 'South', 25),
(44, 100, 99, 'BSIT', 2, 'North', 25),
(45, 100, 99, 'BSIT', 2, 'East', 25),
(46, 100, 99, 'BSIT', 2, 'Southwest', 25);

-- --------------------------------------------------------

--
-- Table structure for table `ay`
--

CREATE TABLE `ay` (
  `id` int(11) NOT NULL,
  `academicyear` varchar(15) DEFAULT NULL,
  `semester` varchar(20) DEFAULT NULL,
  `display` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ay`
--

INSERT INTO `ay` (`id`, `academicyear`, `semester`, `display`) VALUES
(1, '2024-2025', '2', 0),
(10, '2024-2025', '1', 0),
(22, '2024-2025', '3', 0),
(25, '2025-2026', '1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `class`
--

CREATE TABLE `class` (
  `id` int(11) NOT NULL,
  `name` varchar(25) DEFAULT NULL,
  `course` varchar(5) DEFAULT NULL,
  `year` varchar(2) DEFAULT NULL,
  `section` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `class`
--

INSERT INTO `class` (`id`, `name`, `course`, `year`, `section`) VALUES
(1, 'BSIT 1-North', 'BSIT', '1', 'North'),
(3, 'BSIT 1-West', 'BSIT', '1', 'West'),
(4, 'BSIT 1-South', 'BSIT', '1', 'South'),
(5, 'BSIT 1-Northeast', 'BSIT', '1', 'Northeast'),
(6, 'BSIT 1-Northwest', 'BSIT', '1', 'Northwest'),
(7, 'BSIT 1-Southeast', 'BSIT', '1', 'Southeast'),
(8, 'BSIT 1-Southwest', 'BSIT', '1', 'Southwest'),
(9, 'BSIT 2-North', 'BSIT', '2', 'North'),
(10, 'BSIT 2-East', 'BSIT', '2', 'East'),
(11, 'BSIT 2-West', 'BSIT', '2', 'West'),
(12, 'BSIT 2-South', 'BSIT', '2', 'South'),
(13, 'BSIT 2-Northeast', 'BSIT', '2', 'Northeast'),
(14, 'BSIT 2-Northwest', 'BSIT', '2', 'Northwest'),
(15, 'BSIT 2-Southeast', 'BSIT', '2', 'Southeast'),
(16, 'BSIT 2-Southwest', 'BSIT', '2', 'Southwest'),
(17, 'BSIT 3-North', 'BSIT', '3', 'North'),
(18, 'BSIT 3-East', 'BSIT', '3', 'East'),
(19, 'BSIT 3-West', 'BSIT', '3', 'West'),
(20, 'BSIT 3-South', 'BSIT', '3', 'South'),
(21, 'BSIT 3-Northeast', 'BSIT', '3', 'Northeast'),
(22, 'BSIT 3-Northwest', 'BSIT', '3', 'Northwest'),
(23, 'BSIT 3-Southeast', 'BSIT', '3', 'Southeast'),
(24, 'BSIT 3-Southwest', 'BSIT', '3', 'Southwest'),
(25, 'BSIT 4-North', 'BSIT', '4', 'North'),
(26, 'BSIT 4-East', 'BSIT', '4', 'East'),
(28, 'BSIT 4-South', 'BSIT', '4', 'South'),
(29, 'BSIT 4-Northeast', 'BSIT', '4', 'Northeast'),
(30, 'BSIT 4-Northwest', 'BSIT', '4', 'Northwest'),
(31, 'BSIT 4-Southeast', 'BSIT', '4', 'Southeast'),
(32, 'BSIT 4-Southwest', 'BSIT', '4', 'Southwest'),
(33, 'BSIT 4-West', 'BSIT', '4', 'West'),
(35, 'BSBA 2-A', 'BSBA', '2', 'A'),
(36, 'BSHM 3-C', 'BSHM', '3', 'C'),
(37, 'BSED 2-Spanish', 'BSED', '2', 'Spanish'),
(38, 'BEED 3-Mandarin', 'BEED', '3', 'Mandarin'),
(42, 'BSIT 1-East', 'BSIT', '1', 'East');

-- --------------------------------------------------------

--
-- Table structure for table `class_student`
--

CREATE TABLE `class_student` (
  `id` int(11) NOT NULL,
  `student_id` varchar(11) DEFAULT NULL,
  `class_id` varchar(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `joined_on` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `curriculums`
--

CREATE TABLE `curriculums` (
  `id` int(11) NOT NULL,
  `curriculum` int(11) NOT NULL,
  `display` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `curriculums`
--

INSERT INTO `curriculums` (`id`, `curriculum`, `display`) VALUES
(1, 0, 0),
(2, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `id` int(11) NOT NULL,
  `student_id` varchar(20) NOT NULL,
  `subject_id` varchar(20) NOT NULL,
  `teacher_id` varchar(20) NOT NULL,
  `course` varchar(10) NOT NULL,
  `year` varchar(10) NOT NULL,
  `section` varchar(10) NOT NULL,
  `midterm` decimal(5,2) DEFAULT NULL,
  `final` decimal(5,2) DEFAULT NULL,
  `overall` decimal(5,2) DEFAULT NULL,
  `ay_id` int(11) NOT NULL,
  `submitted` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_data`
--

CREATE TABLE `grades_data` (
  `id` int(11) NOT NULL,
  `grade_component_id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  `score` decimal(5,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_submissions`
--

CREATE TABLE `grades_submissions` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `course` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `section` varchar(50) NOT NULL,
  `ay_id` int(11) NOT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `status` enum('pending','submitted','approved','rejected') NOT NULL DEFAULT 'pending',
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grade_components`
--

CREATE TABLE `grade_components` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  `course` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `section` varchar(50) NOT NULL,
  `ay_id` int(11) DEFAULT NULL,
  `component_type` enum('quiz','attendance','performance','exam') NOT NULL,
  `term` enum('midterm','final') DEFAULT NULL,
  `component_index` int(11) NOT NULL DEFAULT 1,
  `hps` decimal(5,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instructor_class`
--

CREATE TABLE `instructor_class` (
  `id` int(11) NOT NULL,
  `instructor_id` varchar(11) DEFAULT NULL,
  `class_id` varchar(11) DEFAULT NULL,
  `subject_id` varchar(11) DEFAULT NULL,
  `assigned_on` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `irregstudentsubject`
--

CREATE TABLE `irregstudentsubject` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `irregstudentsubject`
--

INSERT INTO `irregstudentsubject` (`id`, `student_id`, `subject_id`) VALUES
(33, 1850, 7),
(34, 1850, 28),
(35, 1850, 6);

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `id` int(5) NOT NULL,
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `fullname` varchar(30) DEFAULT NULL,
  `level` varchar(15) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`id`, `username`, `password`, `fullname`, `level`, `created_at`, `updated_at`) VALUES
(1, 'hasan', '$2y$10$uCTJLeRNRuG3Ux4k0LRBoOccuz6E8PnpppeQIMv7hq65hOfbjxh8q', 'Hasan Mangubat', 'admin', '2025-07-03 10:42:42', '2025-07-09 02:45:06'),
(2, 'tc', '$2y$12$o7cvzZGf3zzVj1jvV.fHQ.5wVLtyyY3sjIo/BYSax2IBH/ujtjkMa', 'Kurt Bryan Alegre', 'teacher', '2025-07-03 10:42:42', '2025-07-03 04:56:58'),
(3, 'st', '$2y$12$bnNWgQs8HCj5VB/BFfFbru/En8nzejzbuhvkQJ9tiCFvdywC6ssCC', 'Charles Dumabok', 'student', '2025-07-03 10:42:42', '2025-07-03 06:39:34'),
(10, '20001234', '$2y$10$SqoYiDzBAnwfd41hn0BJNeewXPjC7DtsXfXIEoBlXJoB2T1R0I4fy', 'Juniel Marfa', 'teacher', '2025-07-04 02:04:26', '2025-07-09 03:58:21'),
(11, '9999-9999', '$2y$10$SKe33RJ5jZtQ1.lFzTQkaOY6qkEl1VprMqGqlckKG3txyQHeBT76G', 'Hasan  Syed', 'student', '2025-07-06 05:35:15', '2025-08-25 09:47:27'),
(12, '1111-1111', '$2y$12$K2rZeSgENzLF.R.y.EFppOkuxmFXjm7CRBM0sgmlkIBGEoT2HBnxe', 'Irregular Student Test', 'student', '2025-07-06 10:04:25', '2025-07-11 01:22:01'),
(24, '12341234', '$2y$12$kg/37piMrVzZFaeOjxN7MeMeu0YkIo49k9ImBzrSWm7UOGkv943uO', 'Registrar Cruz', 'registrar', '2025-08-17 08:51:09', '2025-08-17 08:52:12'),
(25, '20259999', '$2y$12$txAph4CGnpHaGtfLlKbRi.ajq8HApidv7lxDgqQtOH4w1FrgDSBlK', 'Sheena Arda', 'teacher', '2025-08-21 14:26:46', '2025-08-21 14:26:46'),
(26, '20259998', '$2y$12$mQeN7sSHcxDgM0FFu6V7zuQTvrqYzRyAQTd8BqfP3gFglwbl3bh8u', 'Kent Peter Medallo', 'teacher', '2025-08-21 14:31:58', '2025-08-21 14:31:58'),
(27, '77226658', '$2y$12$FznFkPjQUQgFGgvMRScTy.F3aYU58/fGrWry8rI7DYFpOAgCe1t.i', 'Vicente Layao', 'teacher', '2025-08-28 07:15:14', '2025-08-28 07:15:14'),
(28, '89891286', '$2y$12$4cQSSG1t.RWL6c7a6a9Sdud8XifYmVH3F8r26yAuY19gafXKfD5EW', 'Mary Ann Sisdoyro', 'teacher', '2025-08-28 07:15:50', '2025-08-28 07:15:50'),
(29, '91203812', '$2y$12$ijEDCafAjknNXVXfcwE3tOYgHnG47bFhvGVJxLnbUr7FpncmE8f0C', 'Elmer Lasala', 'teacher', '2025-08-28 07:16:43', '2025-08-28 07:16:43'),
(30, '93564562', '$2y$12$6hpfyCa7RtzMYFbk62J6w.0bMTKlrcfdJEY5BQPGdTMbZJHPpUGgC', 'Cheska Marie Jumantoc', 'teacher', '2025-08-28 07:17:32', '2025-08-28 07:17:32'),
(31, '82435782', '$2y$12$N0p0c.AT0Vgp21Swq33Ls.XFAWi4KLpj.1BTIzR80Y2N.77Hlstte', 'Jose Quiamco', 'teacher', '2025-08-28 07:19:56', '2025-08-28 07:19:56'),
(32, '44444928', '$2y$12$dd5JRIanjEF4C5HGruDdzeO7SOsy9GW03VM5OBVaQIbfycmjUdCKq', 'Glinford Buncal', 'teacher', '2025-08-28 07:20:25', '2025-08-28 07:20:25');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `id` int(11) NOT NULL,
  `studid` varchar(50) NOT NULL,
  `fname` varchar(100) NOT NULL,
  `lname` varchar(100) NOT NULL,
  `mname` varchar(50) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `course` varchar(6) DEFAULT NULL,
  `year` varchar(50) NOT NULL,
  `section` varchar(50) NOT NULL,
  `semester` varchar(50) NOT NULL,
  `ay` varchar(100) NOT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `regular` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`id`, `studid`, `fname`, `lname`, `mname`, `email`, `course`, `year`, `section`, `semester`, `ay`, `gender`, `regular`) VALUES
(301, '2021-1235', 'MERBETH', 'POLLOSO', 'GERBABUENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(716, '2023-1303', 'REYJANE', 'YBAÑEZ', 'MONAHAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(890, '2023-0611', 'GIAN CHRISTOPHER', 'ABANID', 'CENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(891, '2023-0512', 'DAVE', 'ALAGBAN', 'ALMOCERA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(892, '2023-0524', 'JOHN LLOYD', 'ALAMO', 'ESCARAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(893, '2023-0481', 'WENIFREDO', 'ALO', 'BORJA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(894, '2023-1300', 'KYLE ANTHONY', 'BANTILAN', 'CAHUTAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(895, '2023-0604', 'MYROE', 'BAYON-ON', 'FERNANDEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(896, '2023-0387', 'ALJUN', 'CARATAO', 'ALMOHALLAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(897, '2023-0413', 'CARL JAY', 'CENA', 'BALONGOY', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(898, '2023-0880', 'ROWEL', 'COMESSION', 'SOLLANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(899, '2023-1190', 'RALF', 'CUEVA', 'FRANCISCO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(900, '2023-0298', 'RICHARD', 'DARUCA', 'HERMOCILLA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(901, '2023-0763', 'ADRIAN', 'FORROSUELO', 'FERNANDEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(902, '2023-0893', 'GIOVERT JOHN', 'GIDAYAWAN', 'KAQUILALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(903, '2023-1550', 'ROGER', 'GIDUQUIO', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(904, '2023-0509', 'RJ', 'ILOSORIO', 'BALIBAGOSO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(905, '2023-1554', 'KIM JUNE', 'ILUSTRISIMO', 'ESCALECAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(906, '2023-1418', 'ZED LAURENCE', 'LLAGOSO', 'CANALES', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(907, '2023-0901', 'JIMBOY', 'MARABE', 'ADORNA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(908, '2023-0976', 'JAHAZIEL REY', 'OCSO', 'SALINAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(909, '2023-0472', 'OLIVER', 'OFIASA', 'RAYCO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(910, '2023-0601', 'JAKE BRYLLE', 'PANTALEON', 'DOMENICE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(911, '2023-0628', 'MENGIE', 'PATALINGHOG', 'VILLACERAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(912, '2023-0871', 'KENT JAMEL', 'REBUSIT', 'GIDUCOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(913, '2023-0486', 'JOHN VINCENT', 'RECREO', 'BACOMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(914, '2023-0293', 'JEROW', 'SANTILLAN', 'ALOBA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(915, '2023-0614', 'JAYVEN', 'SEVILLA', 'GALVAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(916, '2023-0615', 'ALJUN', 'TAMPOS', 'BAYON-ON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(917, '2023-0616', 'ALVIN PAUL', 'TAMPOS', 'BAYON-ON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(918, '2023-1545', 'REMARK', 'TAMPOS', ' ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(919, '2023-0885', 'DOMINIC GABRIEL', 'TAYONG', 'VILLACARLOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(920, '2023-0359', 'MIKE STEPHEN', 'TEDOSO', 'DELOS SANTOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(921, '2023-0285', 'ROGELIO', 'TRADIO', 'DOBLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(922, '2023-0388', 'ADAN', 'VISAGAR', 'CALVARIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(923, '2023-1292', 'JANESSA EUNICE', 'ABIO', 'COGAL', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(924, '2023-0882', 'ERNALYN', 'BACOLOD', 'MONTANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(925, '2023-0518', 'RECASIS ANN', 'ENGUITO', 'GILBUENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(926, '2023-1004', 'ALMA FE', 'FARIOLEN', 'BATUHAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(927, '2023-0089', 'ROSE ANN', 'FORROSUELO', 'VILLAESTER', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(928, '2023-0519', 'JESIEREE', 'LAWAAN', 'ILLUT', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(929, '2023-0335', 'GERALDIN', 'PASIGAY', 'DESABILLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(930, '2023-0909', 'NOVA MAE', 'RESUENA', 'BATUIGAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(931, '2023-1295', 'MARY KHATE ANTONINA', 'SEVILLA', 'BOLTRON ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(932, '2023-0642', 'MEAKYLA', 'TORRES', 'ROBIATO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(933, '2023-0483', 'JHANA RICA', 'VILLACERAN', 'SEDURIFA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(934, '2023-0635', 'JUDEN CRIS', 'ABELLO', 'DESCARTIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(935, '2023-0120', 'LAWRENCE ', 'ACOSTA', 'TARA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(936, '2023-1395', 'RUBEN', 'ALMODIEL', 'LAYAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(937, '2023-0975', 'RAFFY', 'BASILAN', 'YONGSON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(938, '2023-1105', 'ARCHIE', 'BILLONES', 'ROQUE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(939, '2023-0034', 'JUPITER', 'BOTILLA', 'ESTENZO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(940, '2023-1006', 'JOSHUA', 'BUTASLAC', 'PEDROZA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(941, '2023-1186', 'KENT JASPER', 'DESQUITADO', 'MIRARZA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(942, '2023-1230', 'JOSEPH', 'ENERO', 'CATANPATAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(943, '2023-0913', 'RONALD', ' FERNANDEZ JR.', 'MATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(944, '2023-1394', 'JAN HENSER', 'ILLUT', 'SARRAGA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(945, '2023-0605', 'MARK JAY', 'ILOSORIO', 'PELLAZO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(946, '2023-0479', 'ELCID', 'JUMAWAN', 'MONTEBON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(947, '2023-0001', 'NESMARC', 'LUNOD', 'AGAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(948, '2023-0326', 'REYMART', 'MALINAO', 'MEDALLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(949, '2023-0737', 'PRINCE CEDRICK', 'MANSUETO', 'DEO ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(950, '2023-1311', 'GABRIMAR', 'MASPARA', 'SEVILLENO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(951, '2023-0568', 'CARL DEXTER', 'MASULA', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(952, '2023-0017', 'ALVIN JAKE', 'MATA', 'CLERIGO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(953, '2023-0544', 'DENIEL', 'MENDOZA', 'LASALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(954, '2023-0714', 'JERSON', 'OMAC', 'DE LA CRUZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(955, '2023-0981', 'ELEUTERIO', 'PACALDO', 'ILLUT', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(956, '2023-0960', 'DEJAY', 'PARDILLO', 'BARRO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(957, '2023-0009', 'MIGUEL', 'PLASENCIA', 'CARABUENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(958, '2023-0963', 'MARK VINCENT', 'RABUSA', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(959, '2023-1099', 'MITCH LOURENCE', 'SANTILLAN', 'ABELLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(960, '2023-1315', 'KURT BENEDICT', 'SAYNO', 'MARABE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(961, '2023-0680', 'ARVIN ', 'SEVILLENO', 'ALMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(962, '2023-1310', 'JOHN GABRIEL', 'TOYCO', 'HEQUILAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(963, '2023-0421', 'MARKNEL', 'UMBAO', 'GRANDE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(964, '2023-0268', 'HILBERT', 'VILLACARLOS', 'CANOY', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(965, '2023-0231', 'MARY JANE', 'BATINDAAN', 'PASTORITE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(966, '2023-0485', 'JONALYN', 'COLUMNA', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(967, '2023-0756', 'MARY JANE', 'LAWAS', 'CABRERA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(968, '2023-0965', 'AIZA', ' MORADAS', 'ESGANA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(969, '2023-0956', 'MARY GRACE', 'MULLE', 'DESPI', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(970, '2023-0306', 'JENAMIE', 'PARAGSA', 'BULA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(971, '2023-0636', 'ELJOY', 'PASIGAY', 'POSTERO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(972, '2023-1296', 'FRANCIS NICOLE ', 'PASTOR', 'MARTUS ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(973, '2023-1398', 'KRISTEL', 'RAYCO', 'LAYAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(974, '2023-0338', 'KHRISNA MAE', 'SACNAHON', 'ARIOLA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(975, '2023-0340', 'MERIAM', 'SALINAS', 'ESCALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(976, '2023-0517', 'IRENE JOYCE', 'SEVILLEJO', 'VILLACARLOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(977, '2023-1234', 'JISEN', 'YASE', 'ARRANCHADO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(978, '2023-0329', 'JOHN FAVE', 'ARRANGUEZ', 'MARFA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(980, '2023-0360', 'LORENCE', 'CARATAO', 'DELA CRUZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(981, '2023-0450', 'MARIO JR. ', 'CENA', 'DESPABELADERO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(982, '2023-1218', 'JOHN RIC', 'CHAVEZ', 'PASPE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(983, '2023-1145', 'JOHN PAUL ', 'DARUCA', 'SARABIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(984, '2023-1122', 'EDMUND', ' DERDER', 'MORADAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(985, '2023-0391', 'EDGAR', 'ESPINA', ' ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(986, '2023-1240', 'ERIC', 'GILLANA', 'DACAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(987, '2023-0134', 'LOUIE JAY', 'ILUSTRISIMO', 'OFIASA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(988, '2023-0008', 'JOHN DAVE', 'MARU', ' ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(989, '2023-0447', 'JOSHUA', 'MATA', 'BATU-IGAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(990, '2023-0474', 'RYAN JAKE', 'MURIRA', 'ARRIESGADO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(991, '2023-0473', 'ALOUWIN', 'PACILAN', 'BATUHAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(992, '2023-0294', '.MARIO', ' PALAY JR', 'GIGANTO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(993, '2023-1317', 'JOHNRYL', 'PASTORITE0', 'SENDON ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(994, '2023-0397', 'ROYET', 'PEPITO', 'ROYET', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(995, '2023-0020', 'RYNALD REE', 'PONCE', 'NEPANGUE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(996, '2023-0969', 'MATTHEW EARL', 'ROSALES', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(997, '2023-1108', 'SHAQUIEL DANIEL', 'UMANDAP', 'GANELO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(998, '2023-0510', 'JOHN DEE', 'VILLARINO', 'TECSON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(999, '2023-0132', 'JEALOU', 'ABELLANOSA', 'LAPE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1000, '2023-0166', 'FRENZY FAYA', 'CUEVA', 'CARMELO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1001, '2023-0291', 'MICHELLE', 'DENILA', ' ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1002, '2023-0679', 'MICHELLE', 'DERDER', 'BANQUE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1003, '2023-0042', 'JENALYN', 'DESABILLE', 'ALOLOD', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1004, '2023-1225', 'JOHN ANTHONY', 'ABELLO', 'BAYON-ON', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1005, '2023-0531', 'CLARK HARRIS', 'ABRIL', 'CARTAJENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1006, '2023-0487', 'LEO', 'ALOLOD', 'PAVIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1007, '2023-0980', 'RONEL', 'ALOLOD', 'CHAVEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1008, '2023-0288', 'MARY ANN', 'DESCARTIN', 'OFRIL', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1009, '2023-1226', 'SANDRO', 'BARANGGAN', 'CHAVEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1010, '2023-0545', 'ROJAN MAY', 'DESUYO', 'NUYAD', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1011, '2023-0321', 'LESLIE KAY', 'ESPINA', 'CARMELOTES', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1012, '2023-0161', 'RAIZA MAE', 'GIDACAN', 'VILLACAMPA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1013, '2023-0287', 'MARY GRACE', 'ILOSORIO', 'ILLUT', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1014, '2023-1481', 'KRISTINE MAE', 'MANGGIRAN', ' ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1015, '2023-0370', 'LYNLYN', 'MANZANARES', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1016, '2023-1417', 'REAN', 'MATA', 'MAGAPAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1017, '2023-0078', 'RENGEL', 'NIEDO', 'ATIENZA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1018, '2023-0131', 'ZHAENA MAE', 'OFIASA', 'PANDACAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1019, '2023-0529', 'MYLEN', 'OMANGAYON', 'BAUTRO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1020, '2023-0482', 'EMILINDA', 'PACINIO', 'LAYAOG', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1021, '2023-0292', 'ANGELINE', 'PALAY', 'GIGANTO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1022, '2023-0402', 'HEZEL', 'PASICARAN', 'DESCARTIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1023, '2023-1246', 'JESSA', 'PLACENCIA', 'MARANDE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1024, '2023-0281', 'ANALYN', 'SOLITARIO', 'ALOYAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1025, '2023-1154', 'ANN MARIE', 'SULLA', ' ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1026, '2023-1084', 'JULIO', 'BARUC JR.', 'HISTA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1027, '2023-0717', 'RONNIE', 'BATALION', 'CABALLERO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1028, '2023-1595', 'RACHEL ANN', 'UY', 'DELOS REYES', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1029, '2023-1158', 'LOUIE', 'BLASA', 'PEPITO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1030, '2023-0160', 'JOYCE', 'VILLACARLOS', 'SISDOYRO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1031, '2023-0692', 'EDUARDO JR.', 'ESCALA', 'QUEZON', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1032, '2023-0480', 'KAREL ANN', 'VILLACERAN', 'CUEVA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1033, '2023-1038', 'ALIMAR', 'ESCALA', 'ALON', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1034, '2023-0508', 'ELIEZER', 'FORROSUELO', 'MANSUETO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1035, '2023-0930', 'PAUL', 'GERCAN', 'BOLJORAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1036, '2023-0951', 'JEROME', 'JULIANE', 'BALILI', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1037, '2023-1009', 'RAMEL', 'LAWAN', 'SUAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1038, '2023-1227', 'JOEY', 'MARCE', 'ABELLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1039, '2023-0971', 'ABELLO', 'RHEY JACOB', 'ILLUT', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1040, '2023-1415', 'SYORICK', 'ALONTE', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1041, '2023-1129', 'ANGELO', 'ANCIANO', 'YBANEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1042, '2023-0879', 'APAWAN', 'ALJON', 'VILLAVITO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1043, '2023-0269', 'VINCENT', 'AQUE', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1044, '2023-1041', 'KEN MICHAEL', 'ARRANCHADO', 'DUCAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1045, '2023-0393', 'ROMNICK', 'BELAIS', 'CORNEA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1046, '2023-0926', 'JEREMIAS', 'CABAHUG', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1047, '2023-1049', 'CARALLAS', 'LEOMAR', 'MARABE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1048, '2023-1361', 'RAPHAEL JOVANNE', 'CARANZO', 'ALOTA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1049, '2023-0451', 'JAMES LORENCE', 'CERNAL', 'VALLEJOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1050, '2023-1135', 'CHRIS JOHN', 'CORDOVA', 'VILLACASTIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1051, '2023-0018', 'JOHN ERICZON', 'DEMORAL', 'GILTENDEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1052, '2023-0538', 'REYMARK', 'DESUCATAN', 'SATERA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1053, '2023-0475', 'JOHN LOUISE', 'ESPINOSA', 'SAPALECIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1054, '2023-0970', 'JERRY YAN', 'GIDUCOS', 'GIBUENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1055, '2023-1054', 'JUNMARK', 'GIDUCOS', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1056, '2023-1133', 'JOEBERT', 'MEDALLO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1057, '2023-0870', 'JOSHUA', 'GILBUELA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1058, '2023-1047', 'ANTONIO', 'OFLAS JR.', 'COSE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1059, '2023-1272', 'NOGIE', 'GILBUENA', 'ESGANA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1060, '2023-1233', 'JOHN PATRICK', 'PARAGSA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1061, '2023-1280', 'MIGUEL CEDRICK', 'GUARISMA', 'BAYARONG', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1062, '2023-0875', 'RONYL', 'PAROCHEL', 'MATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1063, '2023-1482', 'JOHN FRANCIS', 'QUIJANO', 'DESCARTIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1064, '2023-0144', 'MACELLONES', 'VENZ HARRY', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1065, '2023-1042', 'JOREX', 'SARRAGA', 'NEPANGUE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1066, '2023-1281', 'JUNE TOMMY', 'OFIANGA', 'SANDAYA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1067, '2023-1297', 'CHRISTIAN DY', 'REBUSIT', 'TAPAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1068, '2023-1097', 'JOHN PAUL', 'SANTILLAN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1069, '2020-0311', 'ANTHONY', 'SEPUESCA', 'ALOLOR', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1070, '2023-0908', 'VILEGANO', 'CLIFFORD', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1071, '2023-1010', 'JEHU', 'TAES', 'MANSUETO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1072, '2023-1011', 'SALMER DAVE', 'TAIES', 'ILLUT', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1073, '2023-1299', 'JUDY ANN', 'ABALLE', 'LEQUIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1074, '2023-0962', 'MARJUN', 'TAYACTAC', 'DESPI', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1075, '2023-0396', 'KATE ROSEL', 'ALONTAGA', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1076, '2023-0452', 'JOSHUA', 'TAYO', 'RIBAMONTE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1077, '2023-1079', 'RONALIE', 'AQUE', 'BORNALES', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1078, '2023-1219', 'NIÑO MARK', 'VILLABRILLE', 'ALMODIEL', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1079, '2023-1224', 'RAFAEL', 'VILLACERAN', 'PACELAN ', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1080, '2023-0603', 'CLINTON JAY', 'VILLACIN', 'JUBAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1081, '2023-0830', 'JENNY', 'ABING', 'OMBING', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1082, '2023-0766', 'KYZEL', 'ALEVIADO', 'FERNANDEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1083, '2023-0303', 'ERICKA', 'BATINDAAN', 'SARABIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1084, '2023-1095', 'SHAMIE', 'ALMONICAR', 'CARANZO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1085, '2023-0520', 'CARACENA', 'RENALYN', 'BAYON-ON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1086, '2023-0295', 'CARAMONTE', 'MAE ANNE', 'RAYCO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1087, '2023-0606', 'LEAN JOY', 'BARCO', 'MATEO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1088, '2023-0102', 'JUVIELYN', 'DELA PEÑA', 'SEAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1089, '2023-1036', 'CRISTEL JOY', 'BATOBALONOS', 'UGBAMIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1090, '2023-1000', 'FARIOLEN', 'MELJOY', 'MIAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1091, '2023-1001', 'FARIOLEN', 'MELJEAN', 'MIAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1092, '2023-0910', 'BREYLAN', 'BAYON-ON', 'LURA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1093, '2023-0341', 'JENNY', 'GILBUENA', 'SALINAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1094, '2023-0929', 'JANEY', 'BOLJORAN', 'OLIVA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1095, '2023-0369', 'ANNA MAREI', 'MANZANARES', 'DILAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1096, '2023-0368', 'MICHELLE', 'MARTUS', 'BAYNOSA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1097, '2023-1144', 'RUCHIELEE', 'MARU', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1098, '2023-0984', 'ROSE MARIE', 'DESPI', 'DESUCATAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1099, '2023-0363', 'MYLA', 'MATA', 'DESUCATAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1100, '2023-0514', 'ATHENA MAE', 'MIRAL', 'CABILAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1101, '2023-0014', 'MHEL ROSE', 'PASTRANA', 'SALVE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1102, '2023-0229', 'REBOSIT', 'CHRISTINE JOY', 'ABAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1103, '2023-0914', 'LOVELY', 'DUCAY', 'MATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1104, '2023-0556', 'ROSE CLARIZ', 'SIACOR', 'GINATADCAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1105, '2023-1185', 'LYN MIE', 'YBAÑEZ', 'ESPINA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1106, '2023-0551', 'JENELL NICOLE', 'MATA', 'ARRIESGADO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1107, '2023-0904', 'MA. JOELETTE MAY', 'OFQUERIA', 'FARIOLEN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1108, '2023-0961', 'SHERYL', 'TAYACTAC', 'DESPI', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1109, '2023-0685', 'RIZA', 'SALINAS', 'YBANEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1110, '2023-1045', 'ISABEL', 'VERALLO', 'LAYESE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1111, '2023-0637', 'NICOLE', 'SANTILLAN', 'DEOCAMPO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1112, '2023-1035', 'CATHERINE MAE', 'SANTILLAN', 'VILLACERAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1113, '2023-0765', 'MILDRED', 'SOLITARIO', 'ELBA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1114, '2023-0574', 'JEREMIA', 'ADOLFO', 'BACASMAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1115, '2023-1081', 'MATEO JR', 'ALMONICAR', 'AGUILAR', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1116, '2023-0525', 'LENPOL MIKE', 'ALOYAN', 'DEMATE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1117, '2023-1221', 'JEROME', 'ALTAR', 'GARCIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1118, '2023-0698', 'RAPHY', 'ANCIANO', 'ESPLIGUERA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1119, '2023-0478', 'REWEL JR.', 'BATIANCILA', 'VELIGANIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1120, '2023-0936', 'ALDENNIS', 'BATIANCILA', 'SOMBESE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1121, '2023-0398', 'JOVEN', 'CENA', 'SEVILLANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1122, '2023-1013', 'JAMES', 'DELA PEÑA', 'PESTAÑO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1123, '2023-0985', 'JUNARD', 'DELOS REYES', 'ESPINOSA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1124, '2023-1389', 'RAFAEL', 'GILBUENA', 'DERDER', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1125, '2023-0644', 'KEVIN', 'ILUSTRISIMO', 'RIVERA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1126, '2023-1080', 'REMLAN', 'JAMILI', 'JUVAYAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1127, '2023-1242', 'HARLEY JADE', 'LIM', 'MORINO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1128, '2023-1100', 'AARON JOHN', 'MONTAÑO', 'TIPONTIPON', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1129, '2023-1132', 'JOHN PHILIP', 'PARILLA', 'VELIGAÑO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1130, '2023-1229', 'ROWELL JAY', 'PLACENCIA', 'ANCIANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1131, '2023-1243', 'ARGIE', 'PLOTENIA', 'DESALES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1132, '2023-1257', 'IKE', 'RICO', 'COMPUESTO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1133, '2023-1422', 'JONELLE', 'OQUILA', 'TAYO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1134, '2023-0958', 'REYMART', 'SANGUTAN', 'VILLAESTER', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1135, '2023-0400', 'JOSHUA', 'SEGOVIA', 'SOLITARIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1136, '2023-1267', 'WILSON', 'TUMABIENE', 'IGPAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1137, '2023-1472', 'NIÑO JHOEVANN', 'VILLACERAN', 'AMADEO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1138, '2023-1189', 'NIHL JOSHUA', 'VILLARINO', 'LOCAY-LOCAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1139, '2023-1302', 'CHARLIE VAN', 'ZAMORA', 'DESUCATAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1140, '2023-0937', 'LAVIGN', 'ALOYAN', 'HOMENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1141, '2023-0567', 'JAYLIAN', 'BACOLOD', 'CAHUTAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1142, '2023-0305', 'BERNADETTE', 'BAULITA', 'PELAYO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1143, '2023-0881', 'CRISHA MAE', 'DEMORAL', 'MONTANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1144, '2023-0007', 'DAYLYN', 'DERDER', 'FARIOLEN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1145, '2023-1101', 'JULIENNE MAR', 'DESCARTIN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1146, '2023-1473', 'JHANNA JOY', 'DURIAS', 'VILLACERAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1147, '2023-0560', 'NATHALY PEARL', 'ESPINOSA', 'ESPINA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1148, '2023-0927', 'AIRENE', 'HIJAPON', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1149, '2023-1262', 'SHANEL', 'LABARDA', 'CARATAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1150, '2023-0734', 'ANGELINE', 'LAPI', 'SEBUYANA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1151, '2023-1121', 'JEMAICA', 'LAURQUE', 'GILTENDEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1152, '2023-0995', 'CLEA STEPHANIE', 'LOBO', 'PAGHINAYAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1153, '2023-0129', 'MAY', 'MANATAD', 'CAHUTAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1154, '2023-1159', 'CHRIS JAY', 'MARU', 'ALOB', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1155, '2023-0264', 'SHANE LOU', 'NECESARIO', 'SEAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1156, '2023-0484', 'ALSAN JAY', 'NECESARIO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1157, '2023-1155', 'CHERRY ROSE', 'OFTANA', 'OFQUERIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1158, '2023-1056', 'FRANNY', 'SOMBESE', 'FLORES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1159, '2023-0872', 'ROSE', 'VILLARAN', 'BARTOLATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Southwest', 'First Semester', '2023-2024', 'Male', NULL),
(1160, '2023-1497', 'KEILORD', 'ALMOCERA', 'BACOLOD', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1161, '2023-1441', 'JOHN MATT', 'ALOBA', 'MONTAÑO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1162, '2023-0736', 'REYMART', 'APAWAN', 'HERMOSO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1163, '2023-1374', 'JOHN RYAN', 'BACUS', 'N/A', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1164, '2023-1534', 'SAMELITO', 'BAULITA', 'BANDOCON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1165, '2023-1518', 'ELBERT', 'BOLANDRES', 'ALMONICAR', 'almonicar2002@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1166, '2023-1476', 'MARK JOHN', 'CABASE', 'CAPURAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1167, '2023-1130', '.EUBERTO', 'CABILING JR', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1168, '2023-1433', 'CLARK', 'CALZADA', 'BURLAOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1169, '2023-1393', 'ARVEY BRYLLE', 'CAPURAS', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1170, '2023-1432', 'JAN ANTHONY', 'CASIPONG', 'JUANICO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1171, '2023-0986', 'MELVIN JOHN', 'CERVANTES', 'BITOCA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1172, '2023-0491', 'JOHN NIEL', 'CUBELO', 'PRIAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1173, '2023-1566', 'MICO', 'DEOCAMPO', 'LIBRE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1174, '2023-1513', 'JOHN REY NIÑO', 'DESCOTIDO', 'TAMPARONG', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1175, '2023-0772', 'JOHN LESTER', 'DUCAY', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1176, '2023-1368', 'MARK JOHNRYL', 'ENOY', 'GIGANTO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1177, '2023-1430', 'LIBERATO', 'FERNANDEZ JR.', 'GILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1178, '2023-0777', 'GEORICH', 'FLORES', 'SALIMBOT', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1179, '2023-1337', 'MIKE', 'GILBUENA', 'SANCHEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1180, '2023-1378', 'CARLO', 'ILUSTRISIMO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1181, '2023-1519', 'ALDRICH', 'ILUSTRISIMO', 'CARAMELO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1182, '2023-1548', 'ELDON', 'LAYAGUE', 'BAUTRO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1183, '2023-0770', 'ERICH', 'LAYONES', 'CABULLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1184, '2023-1333', 'THIRD JHON', 'LIMBAGA', 'BOLTRON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1185, '2023-1369', 'NIÑO CHRISTIAN', 'MATA', 'KAQUILALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1186, '2023-1030', 'REY', 'MONTIÑOLA', 'VILLAESTER', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1187, '2023-1375', 'REYNOLD', 'OROCIO', 'MANSUETO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1188, '2023-1484', 'CHRISTIAN', 'POTAYRE', 'LECCIONES', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1189, '2023-1446', 'ERIC JHON', 'SEVILLANO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1190, '2023-1402', 'IAN JAY', 'SILVA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1191, '2023-1365', 'EUGENE', 'VELIGANIO', 'PUTONG', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1192, '2023-1474', 'CRISANTO', 'VILLACERAN JR.', 'DESPI', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1193, '2023-0262', 'JEAM', 'VILLAESTER', 'LEGASPINO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1194, '2023-1363', 'KIM LOYD', 'ZASPA', 'SETINTA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1195, '2023-0877', 'QUENN', 'BUSTILLO', 'CARABELLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1196, '2023-1314', 'JENNY', 'CABRERA', 'BAGONOC', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1197, '2023-1420', 'JHEA MAE', 'CARABAÑA', 'CILLACARLOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1198, '2023-0932', 'KRISHA ANN', 'DERDER', 'FERNANDEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1199, '2023-1312', 'ANA LIZA', 'DESUYO', 'GARCIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1200, '2023-0273', 'MERCY MARIE', 'DIONGSON', 'MAGALLANES', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1201, '2023-1371', 'MARY ROSENETTE', 'ESGANA', 'CUIZON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1202, '2023-1396', 'GILBUENA', 'DERZA JEAN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1203, '2023-1370', 'LESLIE', 'MATA', 'KAQUILALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1204, '2023-1576', 'JELIE JAME', 'MONTELLANO', 'COMPRA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1205, '2023-0864', 'GIA', 'REBUSIT', 'ARLOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1207, '2023-0016', 'REY ANGELO', 'AGUIRRE', 'ABELLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1208, '2023-1367', 'JHADE', 'ALOBA', 'PRIAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL);
INSERT INTO `student` (`id`, `studid`, `fname`, `lname`, `mname`, `email`, `course`, `year`, `section`, `semester`, `ay`, `gender`, `regular`) VALUES
(1209, '2023-1304', 'JOHN PAUL', 'BATIN-DAAN', 'CHAVEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1210, '2023-0408', 'REIL DAVE', 'BAWIIN', 'DUCAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1211, '2023-1294', 'RAFAEL', 'BUHAWI', 'VELIGANIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1212, '2023-1458', 'WINVER', 'CALAWAGAN', 'ASIS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1213, '2023-0952', 'JOEMARIE', 'DABLE', 'LUAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1214, '2023-1540', 'CHRISTIAN', 'CLARO', 'BARUC', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1215, '2023-1455', 'JOHN VON', 'DARUCA', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1216, '2023-1538', 'SENANDO', 'DELA FUENTE JR.', 'ESCALICAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1217, '2023-1338', 'ARNIEL', 'DELA PEÑA JR.', 'MANSUETO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1218, '2023-1293', 'BRYAN', 'DESCARTIN', 'DESPI', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1219, '2023-0949', 'RONALD', 'ESCARIO', 'TAYACTAC', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1220, '2023-1592', 'JOHN NINO', 'ESPLIGUERA', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1221, '2023-1542', 'REYMARK', 'FARIOLEN', 'BAIS', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1222, '2023-1401', 'RJAY', 'FORROSUELO', 'DECAPE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1223, '2023-1350', 'JAN KYLE', 'GIDAYAWAN', 'LAWAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1224, '2023-0342', 'DANIEL', 'GIDUCOS', 'ESCARAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1225, '2023-1577', 'JOHN PAUL', 'GIDUCOS', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1226, '2023-1543', 'JEFFREY', 'GIDUQUIO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1227, '2023-0308', 'CLAUS', 'JUBAY', 'LOCAYLOCAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1228, '2023-1421', 'JOVAN', 'MAHUSAY', 'BATIRZAL', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1229, '2023-0135', 'JAMES', 'NAPALYA', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1230, '2023-0998', 'DANIEL', 'NELMIDA', 'ALONTAGA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1231, '2023-1536', 'JEYAN KER', 'PANGANIBAN', 'ZATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1232, '2023-1416', 'JOHN DAVID', 'PARADERO', 'OFTANA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1233, '2023-1579', 'ISAAC', 'QUIJANO', 'LAYAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1234, '2023-0643', 'JOVANIE', 'RAYCO JR.', 'CABRERA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1235, '2023-0733', 'JOHN MANUEL', 'RIBO', 'ESPINOSA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1236, '2023-0874', 'JONATHAN', 'RICO', 'ROSATASE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1237, '2023-0933', 'GENEIL', 'SARUSAL', 'MEDALLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1238, '2023-1424', 'ELISEO', 'SEVILLA', 'BATAYOLA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1239, '2023-1593', 'MARLON JAMES', 'TINGA', 'LOCAY-LOCAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1240, '2023-0414', 'ROGEL NIÑO', 'UGBAMIN', 'OFTANA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1241, '2023-0211', 'JM', 'VILLACARLOS', 'SALVE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1242, '2023-1578', 'RONEL', 'YAUN', 'CAÑETE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1243, '2023-1544', 'DANIELA', 'BULA', 'ESGANA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1244, '2023-1148', 'KEISHA MARIE', 'CARATAO', 'YHAPON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1245, '2023-1575', 'IUBHEL MARIE', 'CONTINEDO', 'SEVILLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1246, '2023-0907', 'LOVELY', 'CORNEA', 'LAWAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1247, '2023-0773', 'DEISELYN', 'ENRIQUEZ', 'PESCANTE', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1248, '2023-0771', 'JANELLE', 'ESCOBILLO', 'BOLTRON', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1249, '2023-0553', 'CRYSTAL', 'FORROSUELO', 'GULA', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1250, '2023-0230', 'SHANE ARA', 'LUCHAVEZ', 'ABRIL', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1251, '2023-0996', 'ANAMIE', 'MARU', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1252, '2023-0497', 'RICHELLE ANN', 'MULLE', 'DESCARTIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1253, '2023-0046', 'ANGELICA', 'SANTILLAN', 'PAROCHEL', 'collegeofinfotech2023@gmail.com', 'BSIT', '1', 'Southeast', 'First Semester', '2023-2024', 'Male', NULL),
(1256, '2022-3018', 'JENFORD', 'ALBACIETE', 'NOT APPLICABLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1257, '2022-1981', 'JOSHUA', 'ALBURO', 'OFTANA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1258, '2022-1876', 'JOHN RALPH', ' ALMODIEL', 'JARINA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1259, '2022-1907', 'JUNEL', 'DABALOS', 'REBAMONTE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1260, '2022-1909', 'KEITH IAN', 'DESAMPARADO', 'MANSUETO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1261, '2022-7023', 'CHRIS IAN', 'DESAMPARADO', 'LUCERNAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1262, '2022-7100', 'JIMWELL', 'DESUCATAN', 'TURBANOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1263, '2022-1831', 'JUNEL', 'DOLINO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1264, '2022-1922', 'KYLE', 'GADIANO', 'DESABILLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1265, '2022-1969', 'WARREN', 'ILUSTRISIMO', 'JUMANTOC', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1266, '2022-3083', 'RODGE', 'LAURENTE', 'FLORES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1267, '2022-6078', 'MARK JOHN', 'LAWAN', 'SILVA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1268, '2022-1936', 'MELCHADES', 'MANSUETO', 'CAPUS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1269, '2022-4028', 'JERRY', 'NASOL', 'MATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1270, '2022-1836', 'VINCENT', 'PESCANTE', 'ESCARAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1271, '2022-1783', 'JAKE', 'RODRIGUEZ', 'BALLANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1272, '2022-1896', 'JOHN LOYD', 'SARABIA', 'NOT APPLICABLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1273, '2022-1813', 'DANIELLE ACE', 'SEVILLEJO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1274, '2022-1843', 'KERBIE', 'VILLACERAN', 'FLORES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1275, '2021-7026', 'DESIREE', 'APAWAN', 'ILLUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1276, '2022-1764', 'MARIAN', 'BACOLOD', 'CARANZO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1277, '2022-7086', 'NIÑA JANE', 'ALOLOR', 'ESPINA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1278, '2022-1789', 'JIMELYN', 'CAPURAS', 'CUEVA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1279, '2022-1956', 'SAMANTHA', 'CENA', 'DELA PEÑA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1280, '2022-1747', 'TRESHA MAE', 'DESUCATAN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1281, '2022-1780', 'MARY ANN', 'DUCAY', 'MULLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1282, '2022-1770', 'RONILY', 'NESCARAN', 'DERDER', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1283, '2022-2004', 'JENNEFER', 'ESCARLAN', 'CARABALLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1284, '2022-2005', 'CHUNLY JANE', 'GILBUENA', 'GIDUCOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1285, '2022-1750', 'EMMA', 'GILTENDEZ', 'PASTOR', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1286, '2022-2006', 'JONA MAE', 'ILLUT', 'GIDUCOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1287, '2022-2003', 'RUDELYN', 'ILLUT', 'OFQUERIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1288, '2022-1970', 'CRISTINA', 'ILUSTRISIMO', 'JUMANTOC', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1289, '2022-1758', 'HARELINE', 'JIMENEZ', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1290, '2021-0748', 'NANCY', 'LOREDA', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1291, '2022-5023', 'LANNY', 'MORADAS', 'DOCDOCAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1292, '2022-1768', 'MARYCRIS', 'PESCANTE', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1293, '2022-1777', 'RICAMAE JANE', 'SANTILLAN', 'MULLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1294, '2022-7026', 'FLORDILIZE', 'SEVILLENO', 'ESCALICAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1295, '2022-1761', 'RONA', 'TAYACTAC', 'CORDERO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1296, '2022-1754', 'KYLA MARIE', 'TEVES', 'ESPINOSA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1297, '2022-1847', 'KC JOY', 'VELIGANILAO', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1298, '2022-7056', 'AMRAFEL', 'ALENSONORIN', 'ANIBAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1299, '2022-5004', 'KHAMYR', 'ARAÑO', 'BAUTISTA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1300, '2022-3076', 'JOHN ERLOU', 'BALIJADO', 'ALVERIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1301, '2022-5000', 'JUNNICK', 'BAUTRO', 'VILLACERAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1302, '2022-3031', 'JEV', 'BAUTRO', 'JARINA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1303, '2022-5043', 'JUSTINE', 'BELMONTE', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1304, '2022-5073', 'RAUL', 'BUCADO JR.', 'AMORES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1305, '2022-3041', 'SEAN KEVIN', 'CHAVEZ', 'HERMOSO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1306, '2022-4056', 'ANGELO', 'DERDER', 'GIDUCOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1307, '2022-4099', 'DEN JOHN', 'DESPI', 'ISABEL', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1308, '2022-4066', 'AIAN', 'DESUCATAN', 'CARALLAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1309, '2022-4070', 'PAUL MARK', 'DESUYO', 'VILLACERAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1310, '2022-3025', 'ELMER', 'ESPINOSA', 'DESCARTIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1311, '2022-4069', 'KENNETH', 'GIDUCOS', 'ESCARAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1312, '2022-3027', 'JUNEL', 'GAMAO', 'MANSUETO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1313, '2022-7120', 'ARGIE', 'GILBUENA', 'CERVANTES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1314, '2022-4058', 'DOMINEC', 'LAYA-OG', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1315, '2022-7117', 'ELBERT', 'MANSUETO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1316, '2022-3030', 'JOSHUA', 'PASTORPIDE', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1317, '2022-3073', 'JOHN PAUL', 'RAZONABLE', 'MARU', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1318, '2022-7039', 'JOHN PATRICK', 'SELLE', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1319, '2022-4045', 'JOERGE', 'YANGAO', 'BILBAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1320, '2022-4067', 'JOHN MARQUE', 'VILLACERAN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1321, '2022-3060', 'NIÑO MIKE', 'ZASPA', 'SETINTA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1322, '2022-4001', 'JULINETTE', 'BATIRZAL', 'SALUDAR', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1323, '2023-1237', 'MIRIAM', 'BATAIN', 'FARIOLEN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1324, '2022-4097', 'CRISTINA', 'BILBAO', 'REBAMONTE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1325, '2022-5088', 'SHESHAN', 'BOLIVAR', 'UNGON', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1326, '2022-6027', 'NERIZA', 'CERVANTES', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1327, '2022-5007', 'TERESA', 'CORDOVA', 'MATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1328, '2022-7038', 'ARA MAE', 'DEMORAL', 'RELATOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1329, '2022-5059', 'GENILYN', 'DESABILLE', 'VELIGANIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1330, '2022-5085', 'JENNIFER', 'DESUYO', 'DE LA PEÑA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1331, '2022-4073', 'SHERY MAE', 'DORIN', 'MAROLLANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1332, '2021-1112', 'ANNA MAE', 'EBEN', 'ALOLOR', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1333, '2022-6030', 'JESSA MAE', 'ESCARAN', 'SALUDAR', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1334, '2022-4052', 'JANE', 'GARCIA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1335, '2022-4038', 'JESSAMEN', 'ILUSTRISIMO', 'ILLUT', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1336, '2022-4022', 'RICA', 'RAQUIZA', 'UMBAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1337, '2022-4033', 'HIZELL', 'SANTILLAN', 'MAGDADARO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1338, '2022-6076', 'JOHN REY', 'ANGO', 'BAUTRO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1339, '2022-7009', 'NIÑO', 'BACOLOD', 'SEVILLA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1340, '2022-7002', 'EMIL JR.', 'DE JESUS', 'BARUC', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1341, '2022-5084', 'JERRY', 'ESCARIO', 'LALICAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1342, '2022-6095', 'JONATHAN', 'ESGANA', 'VERONIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1343, '2022-7006', 'FRANCISCO', 'FERNANDEZ JR.', 'SANTIAGO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1344, '2022-6020', 'DANEL', 'GIDAYAWAN', 'NANOY', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1345, '2022-5080', 'LEE', 'GILBUELA', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1346, '2022-7015', 'JOHN KENNETH', 'GRANDE', 'ROSALES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1347, '2022-5068', 'CARL JASSON', 'ILUSTRISIMO', 'OFIASA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1348, '2022-5060', 'MARK GENO', 'INSO', 'COLAMBOT', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1349, '2022-6008', 'DAVE', 'JANGZON', 'OFIANGA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1350, '2022-5032', 'MICHAEL JOSH', 'KAQUILALA', 'OLINARES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1351, '2022-5057', 'JUSTIN MARK', 'KAQUILALA', 'OLINARES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1352, '2022-5021', 'ROYCE VINCENT', 'LANDERO', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1353, '2022-5093', 'ARWIN', 'LORCA', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1354, '2022-6037', 'JAY VAN', 'MANSUETO', 'VILLARINO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1355, '2022-5020', 'REMAR', 'MARABI', 'GIDUCOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1356, '2022-5092', 'CHARLIE', 'NEGAPATAN', 'TORRECAMPO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1357, '2022-5002', 'KARL DENRALF', 'NEGAPATAN', 'PASTITEO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1358, '2022-5040', 'JAYSAM', 'MARU', 'PANAMA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1359, '2022-4057', 'JEY ARE', 'PASTRANA', 'CABRERA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1360, '2022-5077', 'PEDROSA', 'MARK LOUIE', 'BUCADO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1361, '2022-5037', 'ARNEL', 'REBAMONTE', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1362, '2022-7018', 'IGNATIUS BARON', 'RIO', 'PANGILINAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1363, '2022-6052', 'SERAPIN', 'SANTILLAN JR.', 'CHAVEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1364, '2022-6087', 'SHERWIN', 'SUMBI', 'ALOLOR', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1365, '2022-5010', 'ARJUN', 'TAGALOG', 'MELINDRES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1366, '2022-7028', 'AGIE', 'VERALLO', 'BATASIN-IN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1367, '2022-4063', 'YANKEE', 'NEDO', 'HERIDA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1368, '2022-7007', 'JOYCE', 'COSTA', 'MATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1369, '2022-4071', 'DHEZA', 'ESCARAN', 'CANDIDO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1370, '2022-5089', 'CHRISTINE', 'FORROSUELO', 'SINAMBONG', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1371, '2021-1510', 'JONALYN', 'GIDUCOS', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1372, '2022-6039', 'LEIRA JADE', 'REYES', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1373, '2022-6029', 'RILY', 'REYES', 'ALMOCERA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1374, '2021-1406', 'ZENY', 'MEDALLO', 'CERVANTES', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1375, '2022-2029', 'LEONISIS', 'ASIS', 'MAGALLANES', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1376, '2022-2034', 'JOHN PAUL', 'BAULITA', 'ESCALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1377, '2022-1950', 'EVRANCE', 'CARACAS', 'GILBUENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1378, '2022-2050', 'JOSHUA', 'DESUYO', 'MARABI', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1379, '2022-2096', 'CHARLES', 'DUMABOK', 'SEGOVIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1380, '2022-3010', 'IAN JAY', 'FARIOLEN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1381, '2022-5026', 'JAN ROBERT', 'FRANCISCO', 'QUEZON', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1382, '2022-2045', 'JOHN PAUL', 'GILBUELA', 'CENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1383, '2022-3007', 'ARDIAN', 'ILUSTRISIMO', 'CAPANGPANGAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1384, '2022-2054', 'ZEPORD', 'MARU', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1385, '2022-2093', 'SHANE LEMUEL', 'OLINARES', 'CAYOTE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1386, '2022-4050', 'KEVIN ADRIAN', 'PACINIO', 'TURBANOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1387, '2022-1924', 'NELSON', 'PROJO JR.', 'ARCO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1388, '2022-1887', 'HENRYL', 'PUNAY', 'UMBAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1389, '2022-2013', 'MARK GERALD', 'QUEZON', 'GIPIALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1390, '2022-2035', 'JULIUS', 'ROSALES', 'PEREZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1391, '2022-2095', 'EDDIE', 'SEGOBIA JR.', 'LAYAOG', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1392, '2022-1897', 'JOMAR', 'SETENTA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1393, '2022-2000', 'HASAN', 'SYED', 'AHMAD', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1394, '2022-4048', 'CLINT JOHN', 'TIBAY', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1395, '2022-7068', 'ROBERTO', 'TRADIO ', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1396, '2022-3011', 'KIM ROD', 'VELIGANIO', 'OFQUERIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1397, '2022-7032', 'DOMINGO', 'VELIGANIO JR.', 'GIDUCOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1398, '2022-1743', 'JOHN NILO', 'VERSOZA', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1399, '2022-1908', 'JEROMIE', 'VILLACERAN', 'VELASCO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1400, '2022-2086', 'DEXTER', 'VILLACRUCIS', 'HERMOGILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1401, '2022-7082', 'WINDEL', 'YGOT', 'RUELO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1402, '2022-2032', 'NIÑO MARK', 'ZASPA', 'SETINTA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1403, '2022-1319', 'MARJANNY', 'ALOB', 'CASIPLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1404, '2022-7019', 'LINALYN', 'ALOB', 'YSULAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1405, '2022-3057', 'FATIMA', 'ARNASAN', 'PERPIÑAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1406, '2022-2027', 'PRINCESS MARTENE', 'BATAYOLA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1407, '2022-7005', 'AMETIZ', 'BATIANCILA', 'CERNAL', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1408, '2021-1562', 'HAZEL MAE', 'BATUHAN', 'LAYAOG', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1409, '2023-1228', 'MEAH JEAN', 'CAMIGUING', 'PANCHO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1410, '2022-2028', 'JAY ANN', 'ESCALICAS', 'GIDUQUIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1411, '2022-2065', 'CLAIRE', 'ILUSORIO', 'BATUSBATUSAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1412, '2022-2008', 'JOVIE NORIELLE', 'ILUSTRISIMO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1413, '2022-2073', 'RONALYN', 'LANUTAN', 'VILLARUEL', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1414, '2022-1986', 'CRISTINE JANE', 'PAGHUBASAN', 'UMBAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1415, '2022-5090', 'ROSELYN', 'ROSALES', 'ANGCLA', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Female', NULL),
(1416, '2021-0921', 'JOHNREY', 'ALO', 'REBANUELA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1417, '2021-0850', 'MARK', 'ARNAZAN', 'JOHN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1418, '2021-0804', 'NELBAN', 'BETACHE', 'BAIS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1419, '2021-0891', 'REY JOHN', 'CABURNAY', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1420, '2021-1009', 'CARL JASTINE', 'CARAOS', 'KAQUILALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1421, '2021-0869', 'JERICHO', 'DESPI', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1422, '2021-0883', 'JUPITER', 'DESUYO', 'ACAMPADO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1423, '2021-0861', 'NILO JAY', 'DESUYO', 'ALOB', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1424, '2020-0130', 'ROMMEL', 'DESABILLE', 'RELOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1425, '2020-0129', 'RADEN JOSHUA', 'HIBA', 'MARU', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1426, '2021-1013', 'RODULFO, JR.', 'KAQUILALA', 'YSULAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1427, '2021-0969', 'JAMESON', 'MATA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1428, '2020-0737', 'NEIL ALBERT', 'QUEJADA', 'QUIJANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1429, '2021-0898', 'GILBERT', 'SEVILLEJO', 'SABORDO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1430, '2021-0949', 'JIMAR', 'VILLACARLOS', 'DESPI', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1431, '2021-1005', 'JOHN REY', 'YBAÑEZ', 'NEGRE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1432, '2021-1718', 'REJULES', 'HISTORIA', 'BACOLOD', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1433, '2021-1716', 'PAUL ANDREY', ' SANTILLAN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1434, '2021-0815', 'ESTELLA', 'ABING', 'ALMONICAR', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1435, '2021-1001', 'CLAVELLE', 'APAWAN', 'OROPESA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1436, '2021-0889', 'JEE ANN', 'APITONG', 'PAMINGGAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1437, '2021-0817', 'REALYN', 'BARSAGA', 'ENERO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1438, '2021-0963', 'QUEENIELYN', 'BATAYOLA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1439, '2021-0849', 'PERCEDIE', 'BUHAYAN', 'IDANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1440, '2021-1011', 'CRISTINE MEA', 'CARAOS', 'CAQUILALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1441, '2021-0952', 'MICHELLE', 'COSE', 'LAYOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1442, '2021-0943', 'MARYJEAN', 'DESCARTIN', 'OFIANGA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1443, '2021-0827', 'MERRIAM', 'DUCAY', 'ORQUE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1444, '2021-0977', 'RONA LIZA', 'FERNANDEZ', 'MATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1445, '2021-0866', 'JAYME', 'ISHIE MYCA', 'BERNAL', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1446, '2021-1008', 'MARY JOY', 'KAQUILALA', 'REYES', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1447, '2021-1000', 'CHRISTEL MARIE', 'LUTARTE', 'LEGASPINO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1448, '2021-0829', 'JOAN', 'MARU', 'OFLAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1449, '2021-0818', 'KISHA MAE', 'MARU', 'GRANADA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1450, '2021-0914', 'JHOANA MAE', 'SANTILLAN', 'BARDINAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1452, '2019-0603', 'MARCHIE', 'TUMABIENE', 'COYOCA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1453, '2021-1052', 'RONA JEAN', 'UMBAO', 'ESCALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1454, '2021-0830', 'MEAGAN MARIE', 'VILLACARLOS', 'LEQUIGAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1455, '2021-1616', 'SHARA', 'VILLACARLOS', 'DUCAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1456, '2021-1007', 'JESLYN', 'YBAÑEZ', 'NEGAPATAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1457, '2022-7116', 'KYEBE JEAN', 'UNGON', 'MACIAR', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'East', 'Second Semester', '2023-2024', 'Male', NULL),
(1458, '2019-0198', 'ANTHONY', 'ABING', 'APAWAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1459, '2021-1206', 'JAYSON', 'ALCANTARA', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1460, '2021-1266', 'JOHNIEL', 'AMADEO', 'GIDAYAWAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1461, '2019-0271', 'MARK REBB', 'BARSAGA', 'ENERO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1462, '2021-1188', 'KENNETH', 'BATUSBATUSAN', 'DUCAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1463, '2021-1252', 'EDSAN AGUSTIN', 'BAUSIN', 'ESPINA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1464, '2021-1253', 'JHADE', 'BAUSIN', 'DESTURA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1466, '2021-1055', 'DIOVIN', 'CALATERO', 'PASICARAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1467, '2021-1199', 'PERMEN', 'CANILLO', 'SIBULAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1475, '2021-1219', 'JANIE', 'CARANOO', 'ILLUT', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1476, '2021-1221', 'JAN REY', 'CARANO-O', 'QUIJANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1477, '2021-1220', 'CYRIEL', 'CARATAO', 'LAYAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1478, '2019-0681', 'SHERWIN', 'CHAVEZ', 'HERMOSO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1479, '2021-1205', 'RENE', 'ESCALA', 'CASIPONG', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1480, '2021-1140', 'SHERWIN', 'ESCARAN', 'MARFA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1481, '2021-1097', 'ELMER', 'MEDALLO', 'SEVILLENO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1482, '2021-1107', 'MINARD', 'OFLAS', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1483, '2021-1614', 'JULIAN', 'SEVILLENO, JR.', 'LIBRE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1484, '2021-1042', 'TOM DOMINIQUE', 'VEGA', 'SALVADO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1485, '2021-1114', 'JOHNREY', 'VERALLO', 'GIDO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1486, '2021-1109', 'LOURDES', 'ALORO', 'ABELLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1487, '2021-1254', 'BACOLOD', 'ANGELYN', 'CORDOVA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1488, '2021-1676', 'RAQUEL', 'BARUC', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1489, '2021-1064', 'CHRISTINE', 'BAYON-ON', 'RAMIREZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1490, '2021-1180', 'MAYETTE', 'CAHUTAY', 'DELA PEÑA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1491, '2021-1249', 'CHONA', 'CARANO-O', 'CATALUÑA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1492, '2021-1084', 'JONA', 'CUEVA', 'PACIFICO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1493, '2021-1250', 'GENEROSE', 'DESUCATAN', 'YSULAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1494, '2021-1077', 'MAE ANN', 'DUCAY', 'VICTOSA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1495, '2020-0409', 'IRENE', 'DUCAY', 'CARAMELO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1496, '2021-1138', 'MAY JOY', 'ESCALA', 'SESBREÑO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1497, '2021-1238', 'JUDY ANN', 'ESCARAN', 'GIDACAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1498, '2021-1041', 'JESSICA', 'ILOSORIO', 'LAYOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1499, '2018-1443', 'ROSELYN', 'MAGBULOGTONG', 'SARRAGA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1500, '2021-1141', 'CRISTINE', 'MAROLLANO', 'LAYOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1501, '2021-1181', 'JOANA', 'OFIANGA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1502, '2021-1098', 'MARY ANN', 'OFLAS', 'COCE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1503, '2021-1099', 'RAQUEL', 'OFLAS', 'COSE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1504, '2021-1236', 'JESSA', 'TUMABIENE', 'ROSALEJOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1505, '2021-1051', 'HASMIN', 'VILLADOLID', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1506, '2021-1058', 'YVONNE CRYSTAL', 'VISMANOS', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1507, '2021-1476', 'JOHN LLOYD', 'BAWI-IN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1508, '2021-1345', 'JEFFREY', 'CAHUTAY', 'LOCAYLOCAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1509, '2021-1336', 'ROMMEL', 'DARUCA JR.', 'DESUCATAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1510, '2020-0140', 'REYMARK', 'DESTURA', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1511, '2021-1604', 'ARJIE', 'MAGALLANES', 'ALOB', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1512, '2020-0596', 'SAMUEL', 'MULLE JR.', 'UNGUI', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1513, '2021-1654', 'ANGELITO', 'REBAMONTE', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1514, '2021-1546', 'JHON LOUIE', 'RUBIN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1515, '2021-1484', 'ROWEN', 'SECUYA', 'GIGANTO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1516, '2021-1312', 'JAMES', 'TEQUILLO', 'CASTILLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1517, '2021-1274', 'JAYMEL', 'UNGON', 'GALLARDE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1518, '2021-1477', 'JERSON', 'VILLACERAN', 'APAWAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1519, '2021-1349', 'ORMEN', 'VILLALON', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1520, '2021-1473', 'KIAH', 'BACOLOD', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1521, '2021-1656', 'JULIE ANN', 'ALMOHALLAS', 'TAYACTAC', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1522, '2021-1281', 'JONA', 'BATERZAL', 'MANZANARES', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1523, '2021-1311', 'MARIALIN', 'DERDER', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1524, '2021-1338', 'JENELYN', 'DESPI', 'TAYACTAC', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1525, '2021-1360', 'ARMELYN', 'ESCALA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1526, '2021-1324', 'DESABEL', 'FARIOLEN', 'BATINDAAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1527, '2021-1483', 'ALYZZA JYEN', 'GARCIA', 'CASPILLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1528, '2021-1278', 'MONALINDA', 'GIDUCOS', 'BATIRZAL', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1529, '2021-1277', 'ROGINA', 'ILLUT', 'NAVARRO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1530, '2021-1286', 'ILUSTRISIMO', 'ALMIERA', 'ALAGBAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1531, '2021-1316', 'LAUSA', 'MACHIKO', 'DELA BAJAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1532, '2021-1290', 'ANNA JOY MAR', 'LEGASPINO', 'ALOLOR', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1533, '2021-1673', 'KESIYA', 'MARABE', 'MAGALLANES', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1534, '2021-1339', 'JENELYN', 'MONTALLANA', 'ESCARIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1535, '2021-1263', 'ROXIE JEAN', 'NUÑEZ', 'SOLITARIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1536, '2021-1653', 'MITCHE', 'PEDROZA', 'BAHANDE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1537, '2021-1291', 'MEL ANN', 'SAROL', 'DAWA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1538, '2021-1635', 'JUVILYN', 'TAN-AWON', 'BACUS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1539, '2021-1557', 'ERMA', 'TAYACTAC', 'OLINGAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1540, '2021-1292', 'JESSA MAE', 'UNGOD', 'BAYON-ON', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1541, '2021-1681', 'KATHLEEN', 'UNGON', 'MACIAR', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL);
INSERT INTO `student` (`id`, `studid`, `fname`, `lname`, `mname`, `email`, `course`, `year`, `section`, `semester`, `ay`, `gender`, `regular`) VALUES
(1542, '2021-1280', 'JADE ANTONETTE', 'VELEZ', 'MARTOÑA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1543, '2021-1265', 'JUNELYN', 'VIÑALON', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1544, '2021-1539', 'LOURENCE', 'ALOLOD', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1545, '2021-1640', 'ROBERT', 'AZARCON', 'MEDALLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1546, '2021-1636', 'VINCENT', 'BAYAWA', 'CHAVEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1547, '2021-1541', 'RAPRAP', 'CAHUTAY', 'GIDUCOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1548, '2021-1448', 'JOSE JASON', 'CUEVA', 'OFIANGA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1549, '2021-1542', 'JOEMARIE', 'ESCARRO', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1550, '2021-1485', 'JOHN CHRISTIAN', 'FARIOLA', 'LARAYOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1551, '2021-1475', 'ANGELO', 'FERNANDEZ', 'YBAÑEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1552, '2021-1565', 'JOHN CARLO', 'JAGDON', 'RONDINA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1553, '2021-1537', 'MANUEL', 'JARINA', 'CONTINEDO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1554, '2021-1657', 'JOHN PAUL', 'LAGUDA', 'ALOB', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1555, '2021-1444', 'LORCA', 'ARNEJAN', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1556, '2019-0289', 'ALEX', 'MACARIO', 'TIDOSO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1557, '2020-0717', 'JULIUS', 'MARU', 'GARCIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1558, '2021-1538', 'CHRISTOPHER', 'MORENO', 'CENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1559, '2021-1445', 'AGUSTIN', 'MULLE JR.', 'COMPUESTO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1560, '2021-1449', 'PACILAN', 'OMAR', 'VELIGANIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1561, '2021-1613', 'JAMES VINCENT', 'PASTORILLO', 'DELA PEÑA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1562, '2021-1606', 'GEO', 'RICO', 'DELA PEÑA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1563, '2021-1487', 'ERWIN', 'SANTANDER', 'MACABENTA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1564, '2021-1481', 'NIEL JOHN', 'SANTILLAN', 'GIGANTO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1565, '2021-1482', 'RONEL', 'SECUYA', 'GIGANTO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1566, '2021-1543', 'JOHN RICO', 'SULLANO', 'BATASIN-IN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1567, '2021-1442', 'ERICK ', 'YHAPON', 'LIBRE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1568, '2021-1611', 'ERICA', 'ADLIT', 'CHAVEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1569, '2021-1480', 'ROSEMARIE', 'ALONTAGA', 'TAYO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1570, '2021-1691', 'PEARL ANNE', 'ARSOLON', 'BULADO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1571, '2021-1612', 'SALVACION', 'AVENIDO', 'ARCENAL', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1572, '2021-1608', 'MARIA CRISTINE', 'BATIANCILA', 'SIDO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1573, '2021-1566', 'ROXANNE', 'CARANO-O', 'CATALUÑA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1574, '2021-1547', 'JORISSA', 'CARCOSIA', 'ESCALICAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1575, '2021-1474', 'DIANNA LYN', 'CENA', 'YBAÑEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1576, '2021-1609', 'CORRIDOR', 'JEMIACA', 'DESUCATAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1577, '2021-1545', 'JESSA MARIE', 'COSTA', 'MATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1578, '2021-1441', 'JOAN', 'CUEVA', 'CARACENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1579, '2021-1610', 'MANILYN', 'DE MESA', 'VERDIDA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1580, '2021-1443', 'JONALYN', 'DELA PEÑA', 'OBA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1581, '2021-1669', 'GWENDELYN', 'ESCARAN', 'MARABI', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1582, '2021-1446', 'JERALDENE', 'ILUSTRISIMO', 'ARCAZA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1583, '2021-1668', 'AYRES', 'ILUSTRISIMO', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1584, '2021-1479', 'MARY ROSE', 'MANALOP', 'TAYO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1585, '2021-1489', 'JO ANN', 'REBAMONTE', 'REBAMONTE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1586, '2021-1558', 'INNA', 'SANTILLAN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1587, '2021-1540', 'ROCHEL ', 'SEDURIFA', 'YSULAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1588, '2021-1687', 'MA. EDISA', 'VILLACASTIN', 'PARAGOYA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1589, '2021-1667', 'SHANINE', 'ZASPA', 'BATINDAAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1590, '2021-1580', 'DEVERLY', ' ALMOCERA', 'ALAGBAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1591, '2021-1575', 'KYLA MARIE', ' ARRANGUEZ', 'GARCIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1592, '2021-1410', 'LUCILE', 'ARRIESGADO', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1593, '2020-0447', 'JESSA MAE', 'BAYAWA', 'GERONIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1594, '2021-1582', 'QUEENIE JANE', 'BILBAO', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1595, '2021-1602', 'JOEBERT', 'BILBAO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1596, '2021-1680', 'MARK JOHN', 'BATASIN-IN', 'SERVAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1598, '2021-1714', 'KIRT', 'CARALLAS', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1600, '2020-0772', 'SHERWIN', 'CIERVO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1601, '2021-1589', 'JASMINE', 'CARASCAL', 'RICO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1602, '2021-1591', 'JENNILEE', 'DE LEON', 'PONTANOZA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1603, '2021-1588', 'RINALYN', 'DESAMPARADO', 'BORCE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1604, '2021-1376', 'JONAS', 'DABALOS', 'REBAMONTE', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1605, '2021-1592', 'JOHN ANTHON', 'DE LA CRUZ', 'GIDAYAWAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1606, '2021-1675', 'KEITH ANGELO', 'DEO', 'SEARES', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1607, '2021-1574', 'SAMUEL JR.', 'DESCARTIN', 'BATERNA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1608, '2021-1407', 'BRYAN JAMES', 'DESUYO', 'BAWI-IN', 'dinzky0307@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1609, '2021-1577', 'MARK NHIEL', 'FERNANDEZ', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1610, '2021-1601', 'JEFF', 'GIGANTO', 'SAYSON', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1611, '2021-1695', 'JECELO', 'ILUSTRISIMO', 'DESCARTIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1612, '2021-1593', 'JOHN REY', 'JUBAY', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1613, '2021-1412', 'VINCE SIMUELLE', 'LAURON', 'DE LA PEÑA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1614, '2021-1595', 'CARLOS JR.', 'LUMAPAS', 'LAYOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1615, '2021-1414', 'MARIA FE', 'FERNANDEZ', 'CAHUTAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1616, '2021-1585', 'JEANNIVIVE', 'JUMOLA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1617, '2021-1411', 'HAZEL', 'LIMBAGA', 'BOLTRON', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1618, '2021-1696', 'RICO', 'MAGALLANES', 'UNGON', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1619, '2021-1686', ' KENT PETER', 'MEDALLO', 'MANCIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1620, '2021-1375', 'DANTE ', 'MONTECALVO JR.', 'CARANZO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1621, '2021-1559', 'GERAMAY', 'MARTUS', 'ESCAÑO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1622, '2021-1596', 'MAFEL', 'NIEDO', 'LAYOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1623, '2021-1377', 'JOHN RYAN', 'PALAÑA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1624, '2021-1576', 'CHAD RHINO', 'QUIJANO', 'IWAYAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1625, '2020-0787', 'RAMOS', 'KENT ALLAN', 'GILBUELA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1626, '2021-1737', 'ROLLY JR', 'RECABAR', 'DAWA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1627, '2022-7118', 'RIO', 'IGNATIUS', 'BARON', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'Northeast', 'First Semester', '2023-2024', 'Male', NULL),
(1628, '2021-1732', 'JOHN MICHAELLE', 'ROBLES', 'PIEDAD', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1629, '2021-1699', 'JOHNRIL', 'ROSELLO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1630, '2021-1717', 'HERSHEY', 'SEDURIFA', 'QUIAMCO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1631, '2021-1581', 'JERICO ', 'TAYO ', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1632, '2021-1374', 'ARABELA', 'VILLAROSA', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1633, '2019-0590', 'EDMARK', 'BATIANCILA', 'VILLABRELLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1634, '2020-0231', 'MELCHOR', 'CAJETAS JR.', 'MANGUBAT', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1635, '2020-0259', 'JOHN PAUL', 'CERILLES', 'DAWA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1636, '2020-0262', 'KRISALDO', 'DAWA', 'GIDUCOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1637, '2019-0300', 'CRISMAR', 'DESTACAMENTO', 'UMBAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1638, '2019-0197', 'JOHN ARJIE', 'DUCAY', 'NAIRE', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1639, '2020-0272', 'FRED MARK', 'EMNACIN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1640, '2019-0745', 'MARIO JR.', 'ESGANA', 'DABLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1641, '2020-0257', 'IRENEO', 'GACOLA', 'DESTACAMENTO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1642, '2020-0261', 'JOENNIFER', 'GIDUCOS', 'DAWA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1643, '2020-0314', 'RACKY JAY', 'JUMANTOC', 'ESCALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1644, '2020-0280', 'JUNEIL', 'LABONITE', 'PACILAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1645, '2020-0260', 'ELMER', 'LASALA', 'CARABALLE', 'elmer.lasala@mcclawis.edu.ph', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1646, '2020-0399', 'ORLEGIN', 'LAYESE', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1647, '2020-0379', 'LAWRENCE', 'LAYOS', 'APUHIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1648, '2019-0267', 'ROGER JR.', 'MANDING', 'ALOLOR', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1649, '2020-0360', 'RYAN', 'PACINIO', 'TIBAY', 'ryantibay69@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1650, '2020-0240', 'JUANCHO', 'PALOMAR JR.', 'NEGRE', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1651, '2020-0232', 'JONEL', 'PINOTE', 'GIGANTO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1652, '2020-0404', 'LOWEN', 'PLACENCIA', 'PIOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1653, '2019-0793', 'MARK LOUIE', 'PONTRIVIDA', 'MANSUETO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1654, '2020-0398', 'MARK WILSON', 'REBAMONTE', '', '', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1655, '2020-0230', 'CLIFFORD', 'SARABIA', 'CAÑACAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1656, '2020-0361', 'JOSELITO', 'TIBAY', 'BACOLOD', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1657, '2020-0413', 'JEREMEL', 'TUMABIENE', 'UY', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1658, '2019-0254', 'JOEY', 'VILLANUEVA', 'CARANOO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1659, '2020-0423', 'KRISTINE DIANE', 'ALO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1660, '2020-0425', 'SHELLA MAE', 'ALO', 'REVANUEL', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1661, '2020-0344', 'ELMARIE', 'ANDALES', 'SINTOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1662, '2020-0276', 'SHANEN', 'CAHUTAY', 'DESUYO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1663, '2020-0275', 'CHASELYN', 'CHAVEZ', 'DERRAYAL', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1664, '2020-0250', 'DIANE ROSE', 'ESCALA', 'ILUSTRISIMO', 'dianeroseescala@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1665, '2020-0274', 'KATHLEEN GERI', 'ESPINA', 'TAYAD', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1666, '2020-0402', 'CJ', 'JUMANTOC', 'ESPINA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1667, '2020-0332', 'SHEENA MAE', 'LAWAN', 'SILVA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1668, '2020-0347', 'JAMIE', 'LEONES', 'LAYAM', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1669, '2020-0333', 'JENNY MAE', 'MARU', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1670, '2019-0770', 'JENLY', 'NECESARIO', 'BATAYOLA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1671, '2020-0411', 'ROSALINDA', 'TAYAD', 'BACOLOD', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1672, '2020-0334', 'MARIFE', 'VILLACASTIN', 'MARABE', 'marifevillacastinm@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1673, '2020-0785', 'VECELLE', 'VILLACERAN', 'COSTA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1674, '2020-0234', 'ARA MOLINA', 'VILLACRUCIS', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1675, '2019-0287', 'ALOLOR', 'TEDGIE', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1676, '2019-0746', 'ALOLOR', 'EDCEL', 'COLUMNA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1677, '2020-0167', 'JOSELITO', 'CUEVA', 'CARACENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1678, '2020-0241', 'DARUCA', 'REYNALDO', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1679, '2020-0052', 'ILUSTRISIMO', 'CRISTIAN BERT', 'ALMONICAR', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1680, '2020-0097', 'ROMEO', 'MANSUETO JR.', 'BORRES', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1681, '2020-0072', 'ROLAND', 'MARU', 'PASICARAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1682, '2020-0046', 'OFIANGA', 'REY JEE', 'TURBANOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1683, '2020-0182', 'OFLAS', 'MILBERT', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1684, '2019-0286', 'JOVEN', 'PACIFICO', 'PASTITEO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1685, '2020-0073', 'SESLES', 'MICHAEL', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1686, '2020-0778', 'SOLON', 'CHESTER', 'VILLACERAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1687, '2020-0032', 'JULIO', 'VILLACERAN JR.', 'VALDEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1688, '2020-0089', 'NIÑA MARIE', 'BARING', 'BARNUEVO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1689, '2020-0120', 'SHELLA', 'BAUTRO', 'FARIOLEN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1690, '2020-0118', 'MA. MAY', 'CARATOR', 'GONZAGA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1691, '2020-0733', 'JUDY ANN', 'CORDOVA', 'QUIJANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1692, '2020-0122', 'MARIBEL', 'DELA PEÑA', 'GIDO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1693, '2020-0202', 'RIZA', 'DELA RAMA', 'MARU', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1694, '2020-0113', 'ROSELYN', 'DESPI', 'ALAGBAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1695, '2020-0199', 'JHIE ANN', 'DOBLE', 'OFLAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1696, '2020-0200', 'JASMIN', 'GABUYA', 'OFLAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1697, '2020-0114', 'GALLARDO', 'GENEME', 'DUCAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1698, '2020-0203', 'GIDAYAWAN', 'REYNA', 'VELASQUEZ', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1699, '2020-0045', 'JUPIA', 'LOUISE ANNE', 'TURBANOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1700, '2020-0163', 'SHAINA', 'LUCERO', 'NOYNAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1701, '2020-0081', 'JULIE MAE', 'MALINAO', 'ROXAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1702, '2020-0092', 'MILLA', 'NORIELA', 'GRANDE', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1703, '2020-0431', 'OFIASAIRA FE', 'OFIASA', 'CANOY', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1704, '2020-0082', 'MARIEL', 'OLINARES', 'ADVINCULA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1705, '2020-0116', 'JERALYN', 'PANTALEON', 'MONTAÑO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1706, '2020-0117', 'PERPIÑAN', 'APRIL ROSE', 'IDAÑO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1707, '2020-0121', 'QUIJANO', 'AILENE', 'GONJURAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1708, '2020-0137', 'JOAN', 'SANTILLAN', 'DUCAY', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1709, '2020-0789', 'ALOLOD', 'ROMEL', 'MEDALLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1710, '2019-0655', 'ABRASADO', 'ORWIN', 'GALAPAGO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1711, '2020-0569', 'CERNICK JAY', 'ALOLOR', 'GREGORIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1712, '2020-0594', 'BACOLOD', 'RODEL', 'PASASADABA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1713, '2020-0550', 'BAWI-IN', 'ARIEL', 'LANDAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1714, '2020-0433', 'BAYON-ON JR.', 'AGUSTIN ', 'VILLANUEVA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1715, '2018-0421', 'JOHN HUMPHREY', 'CERVANTES', 'CARANZO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1716, '2020-0554', 'CUEVA', 'RICHARD ', 'PACIFICO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1717, '2020-0539', 'DERDER', 'RIMAR', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1718, '2020-0625', 'JAMES KENNAN', 'DESABILLE', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1719, '2020-0764', 'DOBLE', 'NIONEL', 'ALMOHALLAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1720, '2019-0706', 'ROWEL', 'ENERO', 'OFIANGA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1721, '2020-0741', 'JOSE', 'LAYOS JR.', 'ALLER', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1722, '2020-0632', 'KELVIN', 'MANZANARES', 'YPIL', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1723, '2019-0680', 'MARU', 'DEXTER ', 'ARUPO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1724, '2020-0326', 'MATA', 'ANGELO', 'PASTITEO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1725, '2020-0742', 'EROME', 'MEDALLOJ', 'MANCIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1726, '2019-0795', 'GERALD', 'MEDALLO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1727, '2020-0568', 'MELGAR', 'REYMART', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1728, '2020-0592', 'OSIO', 'ROD HARVIE', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1729, '2020-0768', 'PACINIO', 'ALPIE', 'PLEÑOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1730, '2020-0786', 'JEROLD', 'QUIAMCO', 'PASCUA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1731, '2020-0776', 'JAY MICHAEL', 'SARRAGA', 'PACINIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1732, '2020-0507', 'SOLITARIO', 'NIÑO', 'CABANAG', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1733, '2019-0580', 'TIBURCIO', 'VICENTE ANGELO  ', 'ALEGRE', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1734, '2020-0534', 'VILLABRILLE', 'EDEN', 'SEGOVIA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1735, '2020-0564', 'VILLACARLOS', 'ALDRIN', 'BARCELO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1736, '2020-0441', 'KHYLE PAOLO', 'YHAPON', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1737, '2020-0746', 'ALMOHALLAS', 'ARGELYN', 'NECESARIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1738, '2020-0629', 'ROSELYN', 'ALONTAGA', 'TAYO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1739, '2020-0535', 'ANCIANO', 'DARNIE', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1740, '2020-0472', 'SHIELA MAE', 'BACOLOD', 'ALOB', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1741, '2020-0744', 'LILIBETH', 'BAUTRO', 'CAPUS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1742, '2020-0583', 'LEOVETTE', 'CALATCAT', 'TAYONG', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1743, '2020-0753', 'IRISH', 'CARABIO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1744, '2020-0327', 'MARIEL', 'CARANZO', 'SANTILLAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1745, '2020-0600', 'DE ASIS', 'CLARA MAY', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1746, '2020-0755', 'GINA', 'DERDER', 'LAYAOG', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1747, '2020-0525', 'RUBY', 'FORROSUELO', 'MATA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1748, '2020-0429', 'GARCIA', 'ROSA MAE', 'ALOLOR', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1749, '2020-0473', 'GILTENDEZ', 'MYLENE', 'TAYO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1750, '2020-0538', 'IRISH', 'ILUSTRISIMO', 'VILLABRILLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1751, '2020-0602', 'MIRANDA', 'DESERY', 'PACINIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1752, '2020-0604', 'KEESHIA MAE', 'OFQUERIA', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1753, '2020-0767', 'PAGHUBASAN', 'LOREN JOYCE', 'GABION', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1754, '2020-0627', 'ISA MYR', 'PARDILLA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1755, '2020-0412', 'PASQUITE', 'CHRISTINE MAE', 'DESAMPARADO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1756, '2020-0572', 'PLOTENIA', 'DANA MAE', 'ALOLOR', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1757, '2020-0551', 'QUEZON', 'DAYLIN', 'BAUSIN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1758, '2020-0571', 'SAYSON', 'LYZA', 'LEGASPINO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1759, '2020-0665', 'JUNMAR', 'BATUHAN', 'APAWAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1760, '2020-0647', 'BENIGNOS', 'ERICO', 'FLORES', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1761, '2020-0728', 'JADE NELSON', 'BUHAYAN ', 'NEGRE', 'jadepoiskls@mcclawis.edu.ph', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1762, '2020-0724', 'DESTRIZA', 'MATTHEW DAVID ', 'LAYOS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1763, '2019-0005', 'JOHN MARK ', 'ESCALA', 'DELA PEÑA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1764, '2020-0697', 'GILBUENA', 'ARJEY', 'BATINDAAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1765, '2020-0700', 'LAWAN', 'ANDREO', 'ILUSTRISIMO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1766, '2019-0025', 'RAYMOND', 'LORCA', 'MARTUS', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1767, '2020-0668', 'JONEL', 'MEDALLO', 'REBAMONTE', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1768, '2020-0723', 'LORENZO', 'PAGHUBASAN', 'GABION', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1769, '2020-0699', 'JOMARIE', 'PASTORPIDE', 'LAWAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1770, '2020-0675', 'JESSIE', 'SANTILLAN', 'RAYCO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1771, '2019-0441', 'UMBAO', 'BREX', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1772, '2019-0540', 'ROLJUN ', 'VELIGANIO', 'MELENDRES', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1773, '2020-0671', 'CLINT ANGELO', 'ZIGA', 'OFLAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1774, '2020-0713', 'PAULA ', 'ALARCON', 'BUSTILLO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1775, '2020-0777', 'RONITH ', 'BAGUIO', 'TANTANO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1776, '2019-0497', 'SOCCORO MARIE ', ' BALEJADO', 'PASASADABA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1777, '2020-0730', 'IRENE', 'CAPURAS', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1778, '2020-0646', 'GENIEBE ', 'CASTRO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1779, '2020-0689', 'JOANNA', 'COMPANIA', 'DELOS REYES', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1780, '2020-0692', 'MA. JENNEFER', 'CUEVA', 'BATARILAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1781, '2020-0747', 'CUEVA', 'REGINA', 'ZAPA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1782, '2020-0663', 'RITCHEL', 'DESABILLE', 'BATIANCILA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1783, '2020-0666', 'JUVY ROSE', 'DOBLE', 'MAGDADARO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1784, '2020-0661', 'GINA ', 'DUCAY', 'ESCALA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1785, '2020-0715', 'JESSICA ', 'ILUSTRISIMO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1786, '2020-0690', 'JAVY MAY', 'MANSUETO', 'LAYAO  ', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1787, '2020-0729', 'MARIA MAE', 'MANZANARES', 'DILAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1788, '2020-0760', 'NIÑA', 'MATA', 'DESPI', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1789, '2020-0659', 'GWENDOLYN', 'NEGRIDO', 'PERPIÑAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1790, '2020-0770', 'GLYZA', 'ORONAN', 'CENA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1791, '2020-0734', 'ROSELYN', 'POSTER', 'VARGAS', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1792, '2020-0645', 'JESSEL', 'SALINAS', 'UMBAO', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1793, '2019-0425', 'MARY VIAGUSTY', 'TAYO', 'MULLE', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1794, '2020-0676', 'SHARRA MAE', 'TEAÑO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1795, '2019-0542', 'UMBAO', 'LOVELY ', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1796, '2020-0648', 'VILLADOLID', 'AIRA MAY', 'CAYAYAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1797, '2020-0766', 'ZAPA', 'CLARISSE', 'LORCA', 'collegeofinfotech2023@gmail.com', 'BSIT', '4', 'East', 'First Semester', '2023-2024', 'Male', NULL),
(1798, '2021-1251', 'EDCHELL MAY', 'BAUSIN', 'JABONERO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1799, '2021-1350', 'RONALD', 'AGUIREE', 'VELIGANIO', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1800, '2021-1358', 'JERICHO', 'BATUIGAS', 'CAPUS', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1803, '2021-1736', 'JOHN MIGUEL', 'ANACAN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1804, '2021-1619', 'KIER', 'ANDO', 'TONGGALANI', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'North', 'Second Semester', '2023-2024', 'Male', NULL),
(1805, '2020-0438', 'EDDIESON', 'ARELLANO', 'MARU', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1806, '2021-1408', 'RIZEL', 'BRACERO', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1807, '2020-0740', 'CHRISTINE MAE', 'SAYSON', '', '', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1808, '2021-1650', 'MELVIN', 'CHAVEZ', 'PASILABAN', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'North', 'First Semester', '2023-2024', 'Male', NULL),
(1809, '2021-1594', 'CHARLES CHRISTIAN', 'LUGNASIN', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '2', 'West', 'Second Semester', '2023-2024', 'Male', NULL),
(1810, '2022-5009', 'KYLLE', 'BAUTISTA', '', 'collegeofinfotech2023@gmail.com', 'BSIT', '3', 'West', 'First Semester', '2023-2024', 'Male', NULL),
(1811, '2019-0019', 'LUISITO', 'TAYACTAC', 'BALANSAG', '', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1812, '2021-1289', 'JOHN EDMER', 'ALOBA', 'GODINEZ', 'JohnEdmer.Aloba@mcclawis.edu.ph', 'BSIT', '3', 'South', 'First Semester', '2023-2024', 'Male', NULL),
(1820, '2023-1390', 'MHARJORIE', 'RIBO', '', 'collegeofinfotechmcc2023@gmail.com', 'BSIT', '1', 'Northwest', 'First Semester', '2023-2024', 'Male', NULL),
(1832, '2021-1012', 'MARY ANN', 'SISDOYRO', 'LAWAN', '', 'BSIT', '4', 'North', 'First Semester', '2024-2025', 'Male', NULL),
(1834, '2024-9999', 'Regular', 'Import', 'Test', 'regularimport', 'BSBA', '1', 'A', '1ST', '2025-2026', 'Male', 1),
(1835, '2024-9998', 'Test', 'Test', 'Test', 'Test@test.com', 'BSHM', '1', 'Test', 'First Semester', 'Test', 'Male', 1),
(1836, '2024-9997', 'Test', 'Test', 'Test', 'test@test.com', 'EDUC', '2', 'Test', 'First Semester', 'Test', 'Male', 1),
(1849, '9999-9999', 'Hasan', 'Syed', NULL, 'hasansyed@gmail.com', 'BSIT', '4', 'North', 'First Semester', '2025-2026', 'Male', 1),
(1850, '1111-1111', 'Importing', 'Irregular', 'Test', 'irregimport@gmail.com', 'BSIT', '4', 'West', '1ST', '2025-2026', 'Female', 0),
(1866, '9999-9998', 'Update', 'Import', 'Test', 'insertimport@gmail.com', 'BSHM', '3', 'A', '1ST', '2025-2026', 'Male', 1),
(1867, '9999-9997', 'Insert', 'Import', 'Test', 'insertimport@gmail.com', 'BSHM', '4', 'A', '1ST', '2025-2026', 'Male', 1);

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `title` varchar(100) NOT NULL,
  `lecunit` varchar(10) NOT NULL,
  `labunit` varchar(10) NOT NULL,
  `totalunit` varchar(50) NOT NULL,
  `pre` varchar(50) NOT NULL,
  `semester` varchar(11) NOT NULL,
  `year` int(11) DEFAULT NULL,
  `course` varchar(10) DEFAULT NULL,
  `curriculum` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `subject`
--

INSERT INTO `subject` (`id`, `code`, `title`, `lecunit`, `labunit`, `totalunit`, `pre`, `semester`, `year`, `course`, `curriculum`) VALUES
(0, 'ITE 311', 'Information Management', '2', '1', '3', 'ITE 121', '1', 3, 'BSIT', 0),
(1, 'ITE 111', 'Introduction to Computing', '2', '1', '3', 'None', '1', 1, 'BSIT', 0),
(2, 'ITE 112', 'Computer Programming 1', '2', '1', '3', 'None', '1', 1, 'BSIT', 0),
(4, 'ITE 211', 'Computer Programming 2', '2', '1', '3', 'ITE 112', '2', 1, 'BSIT', 0),
(5, 'ITE 212', 'Multimedia System', '2', '1', '3', 'ITE 111, ITE 123', '1', 2, 'BSIT', 0),
(6, 'ITM 210', 'Digital Logic Design', '2', '1', '3', 'None', '1', 2, 'BSIT', 0),
(7, 'ITE 221', 'Networking 1', '2', '1', '3', 'ITE 111', '2', 2, 'BSIT', 0),
(8, 'ITE 222', 'Database 1', '2', '1', '3', 'ITE 111', '2', 2, 'BSIT', 0),
(9, 'MATH 310', 'Linear Algebra', '3', '0', '3', 'MATH 110', '1', 3, 'BSIT', 0),
(10, 'ITE 322', 'Information Assurance and Security 1', '2', '1', '3', 'ITE 313', '2', 3, 'BSIT', 0),
(11, 'ITE 331', 'Capstone 1', '3', '0', '3', 'Adviser\'s Consent', 'summer', 3, 'BSIT', 0),
(12, 'ITE 421', 'Capstone Project 2', '3', '0', '3', 'ITE 412', '1', 4, 'BSIT', 0),
(14, 'IT234', 'Practicum', '3', '2', '1', 'IT Field', '2', 4, 'BSIT', 0),
(16, 'ENG12', 'Purposive Communication', '2', '2', '4', 'ENG12', '2', 1, 'BSIT', 0),
(21, 'SOCSCI110', 'Understanding the Self', '4', '1', '5', 'None', '1', 1, 'BSIT', 0),
(22, 'HIST110', 'Readings in the Philippine History', '2', '1', '3', 'None', '1', 1, 'BSIT', 0),
(23, 'LIT110', 'The Contemporary World', '2', '1', '3', 'None', '1', 1, 'BSIT', 0),
(24, 'MATH 110', 'Mathematics in the Modern World', '2', '1', '3', 'None', '1', 1, 'BSIT', 0),
(25, 'FIL 110', 'Komunikasyon sa Akademikong Pilipino', '2', '1', '3', 'None', '1', 1, 'BSIT', 0),
(26, 'PE 1', 'Movement Enhancement', '2', '1', '3', 'None', '1', 1, 'BSIT', 0),
(27, 'NSTP 1', 'National Service Training Program', '2', '1', '3', 'None', '1', 1, 'BSIT', 0),
(28, 'ITE 122', 'Human Computer Interaction', '2', '1', '3', 'None', '2', 1, 'BSIT', 0),
(29, 'ITE 1213', 'Discrete Mathematics', '2', '1', '3', 'MATH 110', '2', 1, 'BSIT', 0),
(30, 'HUMS 120', 'Art Appreciation', '2', '1', '3', 'None', '2', 1, 'BSIT', 0),
(31, 'FIL 120', 'Masining na Pagpapahayag', '2', '1', '3', 'None', '2', 1, 'BSIT', 0),
(32, 'PE 2', 'Fitness Exercises', '2', '1', '3', 'PE 1', '2', 1, 'BSIT', 0),
(33, 'NSTP 2', 'National Service Training Program ', '2', '1', '3', 'NSTP 1', '2', 1, 'BSIT', 0),
(34, 'ITE 221', 'Data Structure and Algorithms', '2', '1', '3', 'ITE 121', '1', 2, 'BSIT', 0),
(35, 'ITE 213', 'Quantitative Method (incl Modelling & Simulation)', '2', '1', '3', 'ITE 111, ITE 122', '1', 2, 'BSIT', 0),
(36, 'ITM 211', 'Fundamentals of Accounting', '2', '1', '3', 'None', '1', 2, 'BSIT', 0),
(37, 'SOCSCI 210', 'Ethics: Moral Valuation', '2', '1', '3', 'None', '1', 2, 'BSIT', 0),
(38, 'SSP 210', 'Gender and Society', '2', '1', '3', 'None', '1', 2, 'BSIT', 0),
(39, 'MST 210', 'People and the Earth\'s Ecosystem', '2', '1', '3', 'None', '1', 2, 'BSIT', 0),
(40, 'PE 3', 'PATH-Fit I (Physical Activities Towards Health and Fitness)', '2', '1', '3', 'PE 2', '1', 2, 'BSIT', 0),
(41, 'ITE 220', 'ITE Prof Elect1- Object Oriented Programming', '2', '1', '3', 'ITE 211', '2', 2, 'BSIT', 0),
(42, 'ITE 223', 'Social Issues and Professional Practices', '2', '1', '3', 'None', '2', 2, 'BSIT', 0),
(44, 'ITM 220', 'Office Productivity Enhancement', '2', '1', '3', 'None', '2', 2, 'BSIT', 0),
(45, 'RIZAL', 'Life and Work of Rizal', '2', '1', '3', 'None', '2', 2, 'BSIT', 0),
(46, 'STS 120', 'Science, Technology and Society', '2', '1', '3', 'None', '2', 2, 'BSIT', 0),
(47, 'PE 4', 'PATH-Fit II (Physical Activities Towards Health and Fitness)', '2', '1', '3', 'PE 3', '2', 2, 'BSIT', 0),
(48, 'ITE 310', 'ITE Prof Elect2- Platform Technologies', '2', '1', '3', 'ITE 211, ITE 222, ITE 221', '1', 3, 'BSIT', 0),
(49, 'ITE 312', 'System Integration and Architecture', '2', '1', '3', 'ITE 224', '1', 3, 'BSIT', 0),
(50, 'AH 310', 'Philippine Popular Culture', '2', '1', '3', 'None', '1', 3, 'BSIT', 0),
(51, 'ENGL 310', 'Speech Improvement', '2', '1', '3', 'ENGL 120', '1', 3, 'BSIT', 0),
(52, 'ITE 320', 'ITE Prof Elect3- Web Systems & Technologies', '2', '1', '3', 'ITE 310, ITE 311, ITE 312', '2', 3, 'BSIT', 0),
(53, 'ITE 321', 'Application Development and Emerging Technologies', '1', '1', '1', 'ITE 311, ITE 312', '1', 3, 'BSIT', 0),
(54, 'ITM 320', 'Mobile Application Development', '2', '1', '3', 'ITE 311, ITE 310, ITE 213', '2', 3, 'BSIT', 0),
(55, 'Electives in Techn', 'Methods of Research in Computing', '2', '1', '3', 'ITE 213', '2', 3, 'BSIT', 0),
(56, 'ENGL 320', 'Technical Writing', '2', '1', '3', 'ENGL 310', '2', 3, 'BSIT', 0),
(57, 'ITE 224', 'Computer Organization and Architecture', '2', '1', '3', 'ITM 210', '2', 2, 'BSIT', 0),
(58, 'ITE 441', 'Information Assurance and Security 2', '2', '1', '3', 'ITE 322', '1', 4, 'BSIT', 0),
(59, 'ITM 332', 'Innovative Participation and Social Engagement', '2', '1', '3', '4th Year Standing', 'summer', 3, 'BSIT', 0),
(60, 'ITE 420', 'ITE Prof Elect4- Human Computer Interaction 2', '2', '1', '3', 'ITE 112', '1', 4, 'BSIT', 0),
(61, 'ITE 422', 'Systems Administration and Maintenance', '2', '1', '3', 'ITE 411', '2', 4, 'BSIT', 0),
(62, 'ITM 120', 'Web Development', '2', '1', '3', 'ITE 111, ITE 112', '2', 1, 'BSIT', 0),
(79, 'ITE 111', 'Introduction to Computing', '3', '0', '3', 'None', '1', 1, 'BSIT', 1),
(80, 'ITE 112', 'Program Logic Formulation', '2', '1', '3', 'None', '1', 1, 'BSIT', 1),
(81, 'ITE 113', 'Computer Assembly, Troubleshooting and Repair', '2', '1', '3', 'None', '1', 1, 'BSIT', 1),
(82, 'GE 3', 'Mathematics in the Modern World', '3', '0', '3', 'None', '1', 1, 'BSIT', 1),
(83, 'GE 4', 'The Contemporary World', '3', '0', '3', 'None', '1', 1, 'BSIT', 1),
(84, 'GEFIL 1', 'Komunikasyon sa Akademikong Filipino', '3', '0', '3', 'None', '1', 1, 'BSIT', 1),
(85, 'GE ELECT 1', 'People and the Earth\'s Ecosystem', '3', '0', '3', 'None', '1', 1, 'BSIT', 1),
(86, 'PATHFit 1', 'Movement Competency Training', '2', '0', '2', 'None', '1', 1, 'BSIT', 1),
(87, 'NSTP 1', 'National Service Training Program 1', '3', '0', '3', 'None', '1', 1, 'BSIT', 1),
(88, 'ITE 121', 'Computer Programming 1', '2', '1', '3', 'ITE 111, ITE 112', '2', 1, 'BSIT', 1),
(89, 'ITE 122', 'Computer Networking 1', '2', '1', '3', 'ITE 111', '2', 1, 'BSIT', 1),
(90, 'ITE 123', 'Discrete Mathematics', '3', '0', '3', 'GE 3', '2', 1, 'BSIT', 1),
(91, 'GE 1', 'Understanding the Self', '3', '0', '3', 'None', '2', 1, 'BSIT', 1),
(92, 'GE 2', 'Readings in the Philippine History', '3', '0', '3', 'None', '2', 1, 'BSIT', 1),
(93, 'GE 6', 'Purposive Communication', '3', '0', '3', 'None', '2', 1, 'BSIT', 1),
(94, 'GEFIL 2', 'Pagbasa at Pagsulat Tungo sa Pananaliksik', '3', '0', '3', 'GEFIL 1', '2', 1, 'BSIT', 1),
(95, 'PATHFit 2', 'Exercise-based Fitness Activities', '2', '0', '2', 'PATHFit 1', '2', 1, 'BSIT', 1),
(96, 'NSTP 2', 'National Service Training Program 2', '3', '0', '3', 'NSTP 1', '2', 1, 'BSIT', 1),
(97, 'ITE 211', 'Computer Programming 2', '2', '1', '3', 'ITE 121', '1', 2, 'BSIT', 1),
(98, 'ITE 212', 'Graphics Designing', '2', '1', '3', 'None', '1', 2, 'BSIT', 1),
(99, 'ITE 213', 'Information Management', '2', '1', '3', 'ITE 121', '1', 2, 'BSIT', 1),
(100, 'ITE 214', 'Digital Logic Design  (Workshop 1)', '2', '1', '3', 'ITE123', '1', 2, 'BSIT', 1),
(101, 'ITE 215', 'Platform Technologies', '3', '0', '3', 'ITE121, ITE123', '1', 2, 'BSIT', 1),
(102, 'IT Elect1', 'IT  Elective 1 - Fundamentals of Accounting', '3', '0', '3', 'None', '1', 2, 'BSIT', 1),
(103, 'GE ELECT 2', 'Philippine Popular Culture', '3', '0', '3', 'None', '1', 2, 'BSIT', 1),
(104, 'PATHFit 3', 'Choice of Dance, Sports, Martial Arts, Group Exercise, Outdoor and Adventure Activities 1', '2', '0', '2', 'PATHFit 2', '1', 2, 'BSIT', 1),
(105, 'ITE 221', 'Data Structures and Algorithms', '2', '1', '3', 'ITE 211', '2', 2, 'BSIT', 1),
(106, 'ITE 222', 'Multimedia System', '2', '1', '3', 'ITE 212', '2', 2, 'BSIT', 1),
(107, 'ITE 223', 'Digital Logic Design (Workshop 2)', '2', '1', '3', 'ITE 214', '2', 2, 'BSIT', 1),
(108, 'ITE 224', 'Advanced Office Productivity', '2', '1', '3', 'None', '2', 2, 'BSIT', 1),
(109, 'IT Elect2', 'IT Elective 2 - Ergonomics and Facilities Planning in IT', '3', '0', '3', 'None', '2', 2, 'BSIT', 1),
(110, 'GE 5', 'Ethics', '3', '0', '3', 'None', '2', 2, 'BSIT', 1),
(111, 'GE 8', 'Science, Technology and Society', '3', '0', '3', 'None', '2', 2, 'BSIT', 1),
(112, 'PATHFit 4', 'Choice of Dance, Sports, Martial Arts, Group Exercise, Outdoor and Adventure Activities 2', '2', '0', '2', 'PATHFit 3', '2', 2, 'BSIT', 1),
(113, 'ITE 311', 'ITE Professional Electives 1', '2', '1', '3', 'All prior Common Courses', '1', 3, 'BSIT', 1),
(114, 'ITE 312', 'Information Assurance and Security', '2', '1', '3', 'All prior Common Courses', '1', 3, 'BSIT', 1),
(115, 'ITE 313', 'Mobile Applications Development', '2', '1', '3', 'All prior Common Courses', '1', 3, 'BSIT', 1),
(116, 'ITE 314', 'Web Systems and Technologies', '2', '1', '3', 'All prior Common Courses', '1', 3, 'BSIT', 1),
(117, 'ITE 315', 'Social Issues and Professional Practices', '3', '0', '3', 'None', '1', 3, 'BSIT', 1),
(118, 'IT Elect 3', 'IT Elective 3 - Trends and Issues in IT', '3', '0', '3', 'None', '1', 3, 'BSIT', 1),
(119, 'GE 9', 'Life and Works of Rizal', '3', '0', '3', 'None', '1', 3, 'BSIT', 1),
(120, 'ITE 321', 'ITE Professional Elective 2', '2', '1', '3', 'ITE 311', '2', 3, 'BSIT', 1),
(121, 'ITE 322', 'Applications Development and Emerging Technologies', '2', '1', '3', 'ITE312, ITE313, ITE 314', '2', 3, 'BSIT', 1),
(122, 'ITE 323', 'System Integration and Architecture', '2', '1', '3', 'ITE312, ITE313, ITE 314', '2', 3, 'BSIT', 1),
(123, 'ITE 324', 'Research in Computing', '3', '0', '3', 'All prior Professional and Common Courses', '2', 3, 'BSIT', 1),
(124, 'ITE 325', 'Human Computer Interaction (HCI)', '2', '1', '3', 'All prior Professional and Common Courses', '2', 3, 'BSIT', 1),
(125, 'GE 7', 'Art Appreciation', '3', '0', '3', 'None', '2', 3, 'BSIT', 1),
(126, 'GE ELECT 3', 'Gender and Society', '3', '0', '3', 'None', '2', 3, 'BSIT', 1),
(127, 'ITE 331', 'ITE Professional Electives 3', '2', '1', '3', 'ITE 321', 'summer', 3, 'BSIT', 1),
(128, 'ITE 332', 'Systems Administration and Maintenance', '2', '1', '3', 'All prior Professional and Common Courses', 'summer', 3, 'BSIT', 1),
(129, 'ITE 411', 'System Analysis, Design and Documentation', '3', '0', '3', 'All prior Professional and Common Courses', '1', 4, 'BSIT', 1),
(130, 'ITE 412', 'ITE Professional Electives 4', '2', '1', '3', 'ITE 321', '1', 4, 'BSIT', 1),
(131, 'ITE 413', 'Capstone Project 1 (Planning, Designing & Development Phase)', '3', '0', '3', 'All prior Professional and Common Courses', '1', 4, 'BSIT', 1),
(132, 'ITE 421', 'Capstone Project 2 (Testing, Deployment and Review Phase)', '3', '0', '3', 'All prior Professional and Common Courses', '2', 4, 'BSIT', 1),
(133, 'ITE 422', 'Internship', '6', '0', '6', 'All prior Professional and Common Courses', '2', 4, 'BSIT', 1),
(135, 'BA111', 'Introduction to BSBA', '3', '0', '3', 'None', '1', 1, 'BSBA', 1);

-- --------------------------------------------------------

--
-- Table structure for table `teacher`
--

CREATE TABLE `teacher` (
  `id` int(11) NOT NULL,
  `teachid` varchar(11) DEFAULT NULL,
  `fname` varchar(100) DEFAULT NULL,
  `mname` varchar(50) DEFAULT NULL,
  `lname` varchar(100) DEFAULT NULL,
  `sex` varchar(50) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone` varchar(12) DEFAULT NULL,
  `department` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `teacher`
--

INSERT INTO `teacher` (`id`, `teachid`, `fname`, `mname`, `lname`, `sex`, `age`, `email`, `phone`, `department`) VALUES
(43, '1234567', 'Emily', 'Sorbilon', 'Ilustrisimo', 'Female', 21, 'ilustrisimoemily@gmail.com', '09484748375', 'BSIT'),
(44, '1234568', 'Jamaica Fe', 'Demotor', 'Carabio', 'Female', 22, 'carabiojamaica@gmail.com', '09274748365', 'BSIT'),
(45, '4', 'Emelita', ' ', 'Postrero', 'Female', NULL, 'emelitapostrero@gmail.com', NULL, 'EDUC'),
(48, '7', 'Jason', 'Desamparado', 'Baulita', 'Male', NULL, 'jasonbaulita@gmail.com', NULL, 'EDUC'),
(49, '8', 'Gilbert John', ' ', 'Montajes', 'Male', NULL, 'montajes@gmail.com', NULL, 'EDUC'),
(50, '9', 'Ricardo ', ' ', 'Santillan', 'Male', NULL, 'ricardosantillan@gmail.com', NULL, 'EDUC'),
(51, '10', 'Dhina', ' ', 'Dalisay', 'Female', NULL, 'dhinadalisay@gmail.com', NULL, 'EDUC'),
(52, '11', 'Jose Dindo', ' ', 'Mansueto', 'Male', NULL, 'josedindo@gmail.com', NULL, 'EDUC'),
(55, '14', 'Brent Loren', ' ', 'Denden', 'Male', NULL, 'brentloren@gmail.com', NULL, 'EDUC'),
(56, '15', 'Reyan', ' ', 'Diaz', 'Male', NULL, 'reyandiaz@gmail.com', NULL, 'EDUC'),
(72, '1234569', 'Ligaya', 'A', 'Batiancila', 'Female', 23, 'collegeofinfotech2023@gmail.com', '09876543211', 'BSIT'),
(73, '1234570', 'Kurt Bryan', 'Salvado', 'Alegre', 'Male', 21, 'kurtbryanalegre@gmail.com', '09876543212', 'BSIT'),
(74, '34', 'Ma. Luisa', 'N.', 'Labores', 'Female', NULL, 'labores@gmail.com', NULL, 'EDUC'),
(75, '35', 'Chito', 'R.', 'Villacampa', 'Male', NULL, 'chitovillacampa@gail.com', NULL, 'EDUC'),
(77, '1234571', 'Alvine', 'B.', 'Billones', 'Male', 22, 'alvinbillones12@gmail.com', '09876543213', 'BSIT'),
(79, '1234572', 'Jessica', NULL, 'Alcazar', 'Female', 25, 'kurtbryanalegre@gmail.com', '09234828222', 'BSIT'),
(80, '1234573', 'Richard', NULL, 'Bracero', 'Male', 33, 'bracerorichard@gmail.com', '09876543214', 'BSIT'),
(81, '5', 'Wilfred', ' ', 'Maru', 'Male', NULL, 'maruwilfred@gmail.com', NULL, 'EDUC'),
(82, '1234574', 'JunielA', NULL, 'Marfa', 'Male', 22, 'junielmarfa@gmail.com', '09876543215', 'BSIT'),
(83, '3071992', 'Dino', 'Landao', 'Ilustrisimo', 'Male', NULL, 'dinzky0307@gmail.com', NULL, 'BSIT'),
(84, '12', 'Junie', ' ', 'Mansueto', 'Male', NULL, 'juniemansueto@gmail.com', NULL, 'BSBA'),
(85, '11', 'Louise', ' ', 'Niedo', 'Female', NULL, 'niedo.louise@gmail.com', NULL, 'EDUC'),
(87, '1234575', 'Danilo', 'V', 'Villarino', 'Male', 31, 'zethvillz0501@gmail.com', '09876543217', 'BSIT'),
(89, '1234576', 'Jered', 'Y', 'Cueva', 'Male', 31, 'cuevajered@gmail.com', '09876543218', 'BSIT'),
(90, '39', 'Alberto', 'R.', 'Oflas', 'Male', NULL, 'albertooflas@gmail.com', NULL, 'BSBA'),
(91, '40', 'Emily', 'A.', 'Villaceran', 'Female', NULL, 'emily@gmail.com', NULL, 'EDUC'),
(92, '22', 'Jeanalyn', 'C.', 'Escaran', 'Male', NULL, 'escaranjenalyn@gmail.com', NULL, 'EDUC'),
(93, '33', 'Ephraim', 'G.', 'Dela Cruz Jr.', 'Male', NULL, 'ephraim@gmail.com', NULL, 'EDUC'),
(94, '11', 'Maribel', 'M.', 'Moradas', 'Female', NULL, 'moradas@gmail.com', NULL, 'EDUC'),
(96, '999', 'Sulpicia', 'A.', 'Villaceran', 'Female', NULL, 'sulpicia@gmail.com', NULL, 'EDUC'),
(97, '9999999', 'Hasan', NULL, 'Mangubat', 'Male', 21, 'imnothasan.ph@gmail.com', '09074670256', 'BSIT'),
(100, '20001234', 'Juniel', 'Doctor', 'Marfa', 'Male', 21, 'junelmarfa@gmail.com', '09090909090', 'BSIT'),
(105, '12341234', 'Registrar', 'Test', 'Cruz', 'Male', 44, '12341234@gmail.com', '09090909090', 'BSIT'),
(106, '20259999', 'Sheena', NULL, 'Arda', 'Female', 21, 'sheenaarda@gmail.com', '09213478951', 'BSIT'),
(107, '20259998', 'Kent Peter', NULL, 'Medallo', 'Male', 21, 'kentpeter@gmail.com', '09239048190', 'BSIT'),
(108, '77226658', 'Vicente', 'D', 'Layao', 'Male', 30, 'vicentelayao@gmail.com', '09347812312', 'BSIT'),
(109, '89891286', 'Mary Ann', 'L', 'Sisdoyro', 'Female', 26, 'maryannsisdoyro@gmail.com', '09234578457', 'BSIT'),
(110, '91203812', 'Elmer', 'A', 'Lasala', 'Male', 26, 'elmerlasala@gmail.com', '09237894789', 'BSIT'),
(111, '93564562', 'Cheska Marie', 'E', 'Jumantoc', 'Male', 25, 'cheskamariejumantoc@gmail.com', '09237822244', 'BSIT'),
(112, '82435782', 'Jose', 'C', 'Quiamco', 'Male', 35, 'josequiamco@gmail.com', '09892347823', 'BSIT'),
(113, '44444928', 'Glinford', 'Placencia', 'Buncal', 'Male', 35, 'glinfordbuncal@gmail.com', '09123891238', 'BSIT');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `teacher_id` (`teacher_id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indexes for table `ay`
--
ALTER TABLE `ay`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `class`
--
ALTER TABLE `class`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `class_student`
--
ALTER TABLE `class_student`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `curriculums`
--
ALTER TABLE `curriculums`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `grades_data`
--
ALTER TABLE `grades_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `grades_submissions`
--
ALTER TABLE `grades_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_teacher_subject` (`teacher_id`,`subject_id`,`course`,`year`,`section`,`ay_id`);

--
-- Indexes for table `grade_components`
--
ALTER TABLE `grade_components`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_component` (`subject_id`,`teacher_id`,`course`,`year`,`section`,`ay_id`,`component_type`,`component_index`);

--
-- Indexes for table `instructor_class`
--
ALTER TABLE `instructor_class`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `irregstudentsubject`
--
ALTER TABLE `irregstudentsubject`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `studid_2` (`studid`),
  ADD KEY `studid` (`studid`);

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `teacher`
--
ALTER TABLE `teacher`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `ay`
--
ALTER TABLE `ay`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `class`
--
ALTER TABLE `class`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `class_student`
--
ALTER TABLE `class_student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `curriculums`
--
ALTER TABLE `curriculums`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_data`
--
ALTER TABLE `grades_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_submissions`
--
ALTER TABLE `grades_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grade_components`
--
ALTER TABLE `grade_components`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instructor_class`
--
ALTER TABLE `instructor_class`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `irregstudentsubject`
--
ALTER TABLE `irregstudentsubject`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `student`
--
ALTER TABLE `student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1868;

--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=136;

--
-- AUTO_INCREMENT for table `teacher`
--
ALTER TABLE `teacher`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignments`
--
ALTER TABLE `assignments`
  ADD CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`id`),
  ADD CONSTRAINT `assignments_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`);

--
-- Constraints for table `irregstudentsubject`
--
ALTER TABLE `irregstudentsubject`
  ADD CONSTRAINT `irregstudentsubject_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`id`),
  ADD CONSTRAINT `irregstudentsubject_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
