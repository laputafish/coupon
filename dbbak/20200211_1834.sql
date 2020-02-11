-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               10.1.36-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win32
-- HeidiSQL Version:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table evoucher.medias
DROP TABLE IF EXISTS `medias`;
CREATE TABLE IF NOT EXISTS `medias` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `type` varchar(20) NOT NULL DEFAULT '0',
  `path` varchar(50) NOT NULL DEFAULT '0',
  `filename` varchar(100) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table evoucher.medias: ~0 rows (approximately)
DELETE FROM `medias`;
/*!40000 ALTER TABLE `medias` DISABLE KEYS */;
INSERT INTO `medias` (`id`, `user_id`, `type`, `path`, `filename`, `created_at`, `updated_at`) VALUES
	(1, 0, 'temp', 'fa/30', '20200211_023748_78568200.xlsx', '2020-02-11 02:37:48', '2020-02-11 02:37:48');
/*!40000 ALTER TABLE `medias` ENABLE KEYS */;

-- Dumping structure for table evoucher.menus
DROP TABLE IF EXISTS `menus`;
CREATE TABLE IF NOT EXISTS `menus` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `type` enum('group','link','root') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'link',
  `label_tag` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `route_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `icon_class` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `link` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `_lft` int(10) unsigned NOT NULL DEFAULT '0',
  `_rgt` int(10) unsigned NOT NULL DEFAULT '0',
  `parent_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `menus__lft__rgt_parent_id_index` (`_lft`,`_rgt`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.menus: ~38 rows (approximately)
DELETE FROM `menus`;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` (`id`, `enabled`, `type`, `label_tag`, `route_name`, `icon_class`, `link`, `_lft`, `_rgt`, `parent_id`, `created_at`, `updated_at`) VALUES
	(1, 1, 'root', 'root', '', '', '', 1, 76, NULL, '2020-02-10 03:12:13', '2020-02-10 03:12:13'),
	(2, 1, 'link', 'menu.vouchers', 'vouchers', 'fas fa-qrcode', '/vouchers', 2, 3, 1, '2020-02-10 03:12:13', '2020-02-10 06:08:49'),
	(3, 0, 'group', 'menu.dashboard', '', 'fas fa-tachometer-alt', '', 4, 11, 1, '2020-02-10 03:12:13', '2020-02-10 03:12:13'),
	(4, 0, 'link', 'menu.dashboard1', 'dashboard1', 'far fa-circle', '/dashboard', 5, 6, 3, '2020-02-10 03:12:13', '2020-02-10 06:35:27'),
	(5, 0, 'link', 'menu.dashboard2', 'dashboard2', 'far fa-circle', '/dashboard2', 7, 8, 3, '2020-02-10 03:12:14', '2020-02-10 06:35:27'),
	(6, 0, 'link', 'menu.dashboard3', 'dashboard3', 'far fa-circle', '/dashboard3', 9, 10, 3, '2020-02-10 03:12:14', '2020-02-10 06:35:27'),
	(7, 0, 'link', 'menu.widgets', 'widgets', 'fas fa-th', '/widgets', 12, 13, 1, '2020-02-10 03:12:14', '2020-02-10 06:35:27'),
	(8, 0, 'group', 'menu.layout_options', '', 'fas fa-copy', '', 14, 29, 1, '2020-02-10 03:12:14', '2020-02-10 03:12:14'),
	(9, 0, 'link', 'menu.top_navigation', 'top_navigation', 'far fa-circle', '/top_navigation', 15, 16, 8, '2020-02-10 03:12:14', '2020-02-10 06:35:28'),
	(11, 0, 'link', 'menu.boxed', 'boxed', 'far fa-circle', '/boxed', 17, 18, 8, '2020-02-10 03:12:14', '2020-02-10 06:35:28'),
	(12, 0, 'link', 'menu.fixed_sidebar', 'fixed_sidebar', 'far fa-circle', '/fixed_sidebar', 19, 20, 8, '2020-02-10 03:12:15', '2020-02-10 06:35:28'),
	(13, 0, 'link', 'menu.fixed_navbar', 'fixed_navbar', 'far fa-circle', '/fixed_navbar', 21, 22, 8, '2020-02-10 03:12:15', '2020-02-10 06:35:28'),
	(14, 0, 'link', 'menu.fixed_footer', 'fixed_footer', 'far fa-circle', '/fixed_footer', 23, 24, 8, '2020-02-10 03:12:15', '2020-02-10 06:35:28'),
	(15, 0, 'link', 'menu.collapsed_sidebar', 'collapsed_sidebar', 'far fa-circle', '/collapsed_sidebar', 25, 26, 8, '2020-02-10 03:12:15', '2020-02-10 06:35:28'),
	(16, 0, 'group', 'menu.charts', '', 'fas fa-chart-pie', '', 30, 37, 1, '2020-02-10 03:12:15', '2020-02-10 03:12:15'),
	(17, 0, 'link', 'menu.charts_js', 'charts_js', 'far fa-circle', '/charts_js', 31, 32, 16, '2020-02-10 03:12:15', '2020-02-10 06:35:28'),
	(18, 0, 'link', 'menu.flot', 'charts_flot', 'far fa-circle', '/flot', 33, 34, 16, '2020-02-10 03:12:15', '2020-02-10 06:35:28'),
	(19, 0, 'link', 'menu.inline', 'charts_inline', 'far fa-circle', '/inline', 35, 36, 16, '2020-02-10 03:12:16', '2020-02-10 06:35:28'),
	(20, 0, 'group', 'menu.ui_elements', '', 'fas fa-tree', '', 38, 55, 1, '2020-02-10 03:12:16', '2020-02-10 03:12:16'),
	(21, 0, 'link', 'menu.general', 'ui_general', 'fas fa-circle', '/ui_general', 39, 40, 20, '2020-02-10 03:12:16', '2020-02-10 06:35:28'),
	(22, 0, 'link', 'menu.icons', 'ui_icons', 'fas fa-circle', '/ui_icons', 41, 42, 20, '2020-02-10 03:12:16', '2020-02-10 06:35:28'),
	(23, 0, 'link', 'menu.buttons', 'ui_buttons', 'fas fa-circle', '/ui_buttons', 43, 44, 20, '2020-02-10 03:12:16', '2020-02-10 06:35:28'),
	(24, 0, 'link', 'menu.sliders', 'ui_sliders', 'fas fa-circle', '/ui_sliders', 45, 46, 20, '2020-02-10 03:12:16', '2020-02-10 06:35:28'),
	(25, 0, 'link', 'menu.modals_alerts', '', 'fas fa-circle', '/ui_modals_alerts', 47, 48, 20, '2020-02-10 03:12:16', '2020-02-10 03:12:16'),
	(26, 0, 'link', 'menu.navbar_tabs', 'ui_navbar_tabs', 'fas fa-circle', '/ui_navbar_tabs', 49, 50, 20, '2020-02-10 03:12:17', '2020-02-10 06:35:29'),
	(27, 0, 'link', 'menu.timeline', 'ui_timeline', 'fas fa-circle', '/ui_timeline', 51, 52, 20, '2020-02-10 03:12:17', '2020-02-10 06:35:29'),
	(28, 0, 'link', 'menu.ribbons', 'ui_ribbons', 'fas fa-circle', '/ui_ribbons', 53, 54, 20, '2020-02-10 03:12:17', '2020-02-10 06:35:29'),
	(29, 0, 'group', 'menu.forms', '', 'far fa-circle', '', 56, 65, 1, '2020-02-10 03:12:17', '2020-02-10 03:12:17'),
	(30, 0, 'link', 'menu.general', 'forms_general', 'far fa-circle', '/forms/general', 57, 58, 29, '2020-02-10 03:12:17', '2020-02-10 06:35:29'),
	(31, 0, 'link', 'menu.advanced', 'forms_advanced', 'far fa-circle', '/forms/advanced', 59, 60, 29, '2020-02-10 03:12:17', '2020-02-10 06:35:29'),
	(32, 0, 'link', 'menu.editors', 'forms_editors', 'far fa-circle', '/forms/editors', 61, 62, 29, '2020-02-10 03:12:18', '2020-02-10 06:35:29'),
	(33, 0, 'link', 'menu.validation', 'forms_validation', 'far fa-circle', '/forms/validation', 63, 64, 29, '2020-02-10 03:12:18', '2020-02-10 06:35:29'),
	(34, 0, 'group', 'menu.tables', '', 'fas fa-table', '', 66, 73, 1, '2020-02-10 03:12:18', '2020-02-10 03:12:18'),
	(37, 0, 'link', 'menu.datatables', 'datatables', 'far fa-circle', '/tables/datatables', 67, 68, 34, '2020-02-10 03:12:19', '2020-02-10 06:35:29'),
	(38, 0, 'link', 'menu.js_grid', 'js_grid', 'far fa-circle', '/tables/js_grid', 69, 70, 34, '2020-02-10 03:12:19', '2020-02-10 06:35:29'),
	(40, 1, 'link', 'menu.agents', 'agents', 'fas fa-chess', '/agents', 74, 75, 1, '2020-02-10 05:30:57', '2020-02-10 06:34:13'),
	(41, 0, 'link', 'menu.top_navigation_sidebar', 'top_navigation_sidebar', 'far fa-circle', '/top_navigation_sidebar', 27, 28, 8, '2020-02-10 06:33:12', '2020-02-10 06:35:28'),
	(42, 0, 'link', 'menu.simple_tables', 'simple_tables', 'far fa-circle', '/tables/simple_table', 71, 72, 34, '2020-02-10 06:33:12', '2020-02-10 06:35:29');
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;

-- Dumping structure for table evoucher.migrations
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.migrations: ~3 rows (approximately)
DELETE FROM `migrations`;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '2014_10_12_000000_create_users_table', 1),
	(2, '2014_10_12_100000_create_password_resets_table', 1),
	(3, '2020_02_10_025402_create_menus_table', 2);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;

-- Dumping structure for table evoucher.password_resets
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.password_resets: ~0 rows (approximately)
DELETE FROM `password_resets`;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;

-- Dumping structure for table evoucher.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.users: ~1 rows (approximately)
DELETE FROM `users`;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `name`, `email`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
	(1, 'yoovcenter', 'yoovcenter@gmail.com', '$2y$10$gBhtftn7J0q3MYvZwYGe.u649Ozuy4CpOQie47YmfjvpsRLgQDsJy', NULL, '2020-02-10 02:13:35', '2020-02-10 02:13:35');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Dumping structure for table evoucher.vouchers
DROP TABLE IF EXISTS `vouchers`;
CREATE TABLE IF NOT EXISTS `vouchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(200) NOT NULL DEFAULT '',
  `agent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `activation_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `template` text,
  `status` enum('pending','ready_to_send','sending','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.vouchers: ~0 rows (approximately)
DELETE FROM `vouchers`;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;

-- Dumping structure for table evoucher.voucher_codes
DROP TABLE IF EXISTS `voucher_codes`;
CREATE TABLE IF NOT EXISTS `voucher_codes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` int(10) unsigned NOT NULL,
  `code` varchar(191) NOT NULL DEFAULT '',
  `serial_no` varchar(50) NOT NULL DEFAULT '',
  `amount` double NOT NULL DEFAULT '0',
  `expiry_date` date DEFAULT NULL,
  `activation_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.voucher_codes: ~0 rows (approximately)
DELETE FROM `voucher_codes`;
/*!40000 ALTER TABLE `voucher_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `voucher_codes` ENABLE KEYS */;

-- Dumping structure for table evoucher.voucher_emails
DROP TABLE IF EXISTS `voucher_emails`;
CREATE TABLE IF NOT EXISTS `voucher_emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` int(10) unsigned NOT NULL DEFAULT '0',
  `voucher_code_id` int(10) unsigned NOT NULL DEFAULT '0',
  `email` varchar(191) NOT NULL DEFAULT '',
  `sent_at` timestamp NULL DEFAULT NULL,
  `status` enum('pending','sent') DEFAULT NULL,
  `remark` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.voucher_emails: ~0 rows (approximately)
DELETE FROM `voucher_emails`;
/*!40000 ALTER TABLE `voucher_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `voucher_emails` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
