-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.1.36-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win32
-- HeidiSQL Version:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table evoucher.agents
DROP TABLE IF EXISTS `agents`;
CREATE TABLE IF NOT EXISTS `agents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '',
  `alias` varchar(30) DEFAULT '',
  `contact` varchar(50) DEFAULT '',
  `tel_no` varchar(20) DEFAULT '',
  `fax_no` varchar(20) DEFAULT '',
  `web_url` varchar(100) DEFAULT '',
  `email` varchar(100) DEFAULT '',
  `remark` text,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.agents: ~3 rows (approximately)
DELETE FROM `agents`;
/*!40000 ALTER TABLE `agents` DISABLE KEYS */;
INSERT INTO `agents` (`id`, `name`, `alias`, `contact`, `tel_no`, `fax_no`, `web_url`, `email`, `remark`, `created_at`, `updated_at`) VALUES
	(1, 'Pacific Coffee', 'PCC', NULL, 'fdssfds', NULL, 'https://www.pacificcoffee.com/', NULL, NULL, NULL, '2020-02-17 04:30:29'),
	(2, 'Shell Hong Kong Limited', 'Shell', '', '', '', 'https://www.shell.com.hk/', '', NULL, NULL, NULL),
	(3, 'Haagen-Dazs', 'HD', NULL, NULL, NULL, 'https://www.haagendazs.com.hk/', NULL, NULL, NULL, '2020-02-20 01:35:37');
/*!40000 ALTER TABLE `agents` ENABLE KEYS */;

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.migrations: ~8 rows (approximately)
DELETE FROM `migrations`;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '2014_10_12_000000_create_users_table', 1),
	(2, '2014_10_12_100000_create_password_resets_table', 1),
	(3, '2020_02_10_025402_create_menus_table', 2),
	(4, '2016_06_01_000001_create_oauth_auth_codes_table', 3),
	(5, '2016_06_01_000002_create_oauth_access_tokens_table', 3),
	(6, '2016_06_01_000003_create_oauth_refresh_tokens_table', 3),
	(7, '2016_06_01_000004_create_oauth_clients_table', 3),
	(8, '2016_06_01_000005_create_oauth_personal_access_clients_table', 3);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;

-- Dumping structure for table evoucher.oauth_access_tokens
DROP TABLE IF EXISTS `oauth_access_tokens`;
CREATE TABLE IF NOT EXISTS `oauth_access_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `client_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_access_tokens_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.oauth_access_tokens: ~0 rows (approximately)
DELETE FROM `oauth_access_tokens`;
/*!40000 ALTER TABLE `oauth_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth_access_tokens` ENABLE KEYS */;

-- Dumping structure for table evoucher.oauth_auth_codes
DROP TABLE IF EXISTS `oauth_auth_codes`;
CREATE TABLE IF NOT EXISTS `oauth_auth_codes` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.oauth_auth_codes: ~0 rows (approximately)
DELETE FROM `oauth_auth_codes`;
/*!40000 ALTER TABLE `oauth_auth_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth_auth_codes` ENABLE KEYS */;

-- Dumping structure for table evoucher.oauth_clients
DROP TABLE IF EXISTS `oauth_clients`;
CREATE TABLE IF NOT EXISTS `oauth_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `redirect` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_clients_user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.oauth_clients: ~2 rows (approximately)
DELETE FROM `oauth_clients`;
/*!40000 ALTER TABLE `oauth_clients` DISABLE KEYS */;
INSERT INTO `oauth_clients` (`id`, `user_id`, `name`, `secret`, `redirect`, `personal_access_client`, `password_client`, `revoked`, `created_at`, `updated_at`) VALUES
	(1, NULL, 'Laravel Personal Access Client', 'RtboXMWiP0zUFgb4ND8KvdnRaZrHzWsbsiD87LLH', 'http://localhost', 1, 0, 0, '2020-02-14 02:00:23', '2020-02-14 02:00:23'),
	(2, NULL, 'Laravel Password Grant Client', 'i6i8oAIdifGdbadWPIniNgpY2UpzNJY9o9nCJzDX', 'http://localhost', 0, 1, 0, '2020-02-14 02:00:23', '2020-02-14 02:00:23');
/*!40000 ALTER TABLE `oauth_clients` ENABLE KEYS */;

-- Dumping structure for table evoucher.oauth_personal_access_clients
DROP TABLE IF EXISTS `oauth_personal_access_clients`;
CREATE TABLE IF NOT EXISTS `oauth_personal_access_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_personal_access_clients_client_id_index` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.oauth_personal_access_clients: ~0 rows (approximately)
DELETE FROM `oauth_personal_access_clients`;
/*!40000 ALTER TABLE `oauth_personal_access_clients` DISABLE KEYS */;
INSERT INTO `oauth_personal_access_clients` (`id`, `client_id`, `created_at`, `updated_at`) VALUES
	(1, 1, '2020-02-14 02:00:23', '2020-02-14 02:00:23');
/*!40000 ALTER TABLE `oauth_personal_access_clients` ENABLE KEYS */;

-- Dumping structure for table evoucher.oauth_refresh_tokens
DROP TABLE IF EXISTS `oauth_refresh_tokens`;
CREATE TABLE IF NOT EXISTS `oauth_refresh_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.oauth_refresh_tokens: ~0 rows (approximately)
DELETE FROM `oauth_refresh_tokens`;
/*!40000 ALTER TABLE `oauth_refresh_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth_refresh_tokens` ENABLE KEYS */;

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

-- Dumping structure for table evoucher.template_keys
DROP TABLE IF EXISTS `template_keys`;
CREATE TABLE IF NOT EXISTS `template_keys` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(50) NOT NULL DEFAULT '',
  `category` varchar(50) NOT NULL DEFAULT '',
  `field_path` varchar(191) NOT NULL DEFAULT '',
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `order` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.template_keys: ~6 rows (approximately)
DELETE FROM `template_keys`;
/*!40000 ALTER TABLE `template_keys` DISABLE KEYS */;
INSERT INTO `template_keys` (`id`, `key`, `category`, `field_path`, `enabled`, `order`) VALUES
	(1, 'agent_name', 'agent', 'agent.name', 1, 2),
	(2, 'agent_web', 'agent', 'agent.web_url', 1, 3),
	(3, 'voucher_expiry_date', 'voucher', 'expiry_date', 1, 6),
	(4, 'voucher_activation_date', 'voucher', 'activation_date', 1, 4),
	(5, 'voucher_description', 'voucher', 'description', 1, 5),
	(7, 'qr_code', 'qr_code', 'qr_code', 1, 1);
/*!40000 ALTER TABLE `template_keys` ENABLE KEYS */;

-- Dumping structure for table evoucher.temp_leaflets
DROP TABLE IF EXISTS `temp_leaflets`;
CREATE TABLE IF NOT EXISTS `temp_leaflets` (
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `key` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `qr_code_size` int(11) NOT NULL DEFAULT '160',
  `template` text,
  `params` text,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.temp_leaflets: ~0 rows (approximately)
DELETE FROM `temp_leaflets`;
/*!40000 ALTER TABLE `temp_leaflets` DISABLE KEYS */;
/*!40000 ALTER TABLE `temp_leaflets` ENABLE KEYS */;

-- Dumping structure for table evoucher.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `is_verified` tinyint(1) unsigned DEFAULT '0',
  `confirmation_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table evoucher.users: ~0 rows (approximately)
DELETE FROM `users`;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `name`, `email`, `password`, `is_active`, `is_verified`, `confirmation_code`, `remember_token`, `last_login`, `created_at`, `updated_at`) VALUES
	(1, 'Yoov Coupon', 'yoovcoupon@gmail.com', '$2y$10$aLg9TLY7hJWqtz3GOEYSq..0nWdjfZprxDdg6IKw2kAoww5mECgCO', 0, 1, '', NULL, NULL, '2020-02-18 07:00:10', '2020-02-19 07:28:08');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Dumping structure for table evoucher.user_verifications
DROP TABLE IF EXISTS `user_verifications`;
CREATE TABLE IF NOT EXISTS `user_verifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `token` varchar(191) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK__users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.user_verifications: ~0 rows (approximately)
DELETE FROM `user_verifications`;
/*!40000 ALTER TABLE `user_verifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_verifications` ENABLE KEYS */;

-- Dumping structure for table evoucher.vouchers
DROP TABLE IF EXISTS `vouchers`;
CREATE TABLE IF NOT EXISTS `vouchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL DEFAULT '',
  `agent_id` int(10) unsigned NOT NULL DEFAULT '0',
  `activation_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `template` text,
  `code_fields` text,
  `qr_code_composition` varchar(255) DEFAULT NULL,
  `qr_code_size` int(10) unsigned DEFAULT '160',
  `status` enum('preparing','pending','ready_to_send','sending','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.vouchers: ~97 rows (approximately)
DELETE FROM `vouchers`;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
INSERT INTO `vouchers` (`id`, `description`, `agent_id`, `activation_date`, `expiry_date`, `template`, `code_fields`, `qr_code_composition`, `qr_code_size`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'Pacific Coffee Short Size e-Coffee Voucher細杯裝電子咖啡券', 3, '2020-02-06', '2020-02-19', '<table style="width: 100%; margin: 0 auto; border-collapse: collapse; max-width: 750px; border: none; font-family: \'Raleway\',微軟正黑體, \'Microsoft JhengHei\', sans-serif;">\n<tbody>\n<tr style="height: 54px;">\n<td style="width: 100%; height: auto; padding: 15px; background-color: #f0f1f1;"><code><img style="max-width: 100px; height: auto;" src="https://tx2media.rewards-centre.com/Images/060fa9de-6bb8-4285-900b-3f62c2cb44a1.png" /></code></td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;"><img src="https://tx2media.rewards-centre.com/Images/fabb7cf0-d1eb-48ed-9e40-35fba14b0916.jpg" /></td>\n</tr>\n<tr style="height: 32px;">\n<td style="padding: 0px 30px 20px; font-size: 28px; text-align: center; height: 32px;">{voucher_description}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; text-align: center;">{qr_code}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="font-size: 22px; text-decoration: none; color: #333333; padding: 0px 30px 30px; text-align: center; height: 26px;">電子禮券編號：{code_serial_no}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;">\n<table style="width: 100%; border-collapse: collapse; border-top: 1px solid black;" border="0">\n<tbody>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 15px 0px 10px 15px;">商品描述</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%;">{voucher_description}</td>\n</tr>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 10px 0px 10px 15px; vertical-align: middle;">有效期至</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%; vertical-align: middle;">{voucher_expiry_date}</td>\n</tr>\n</tbody>\n</table>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px; font-size: 14px;">\n<p style="color: #777; font-size: 16px;">條款及細則</p>\n<div>Short Size e-Coffee Voucher細杯裝電子咖啡券&nbsp;</div>\n<div>This e-voucher is valid until expiry date, which is non-extendable&nbsp;</div>\n<div>This e-voucher entitles the holder to redeem any short size handcrafted beverage on menu board (hot only), except specialty coffee, liqueur coffee, bottled drinks and juices (an additional $4 will be charged per beverage to upgrade to oat milk)</div>\n<div>This e-voucher is redeemable at any Pacific Coffee in Hong Kong (except Causeway Bay Midtown and Asia World Expo coffeehouses)</div>\n<div>This e-voucher cannot be exchanged for cash or its equivalent and is not applicable to delivery services</div>\n<div>This e-voucher cannot be used in conjunction with any other promotions or privileges</div>\n<div>Customers must use the QR code to redeem the beverage, and the code is valid for one-time use only</div>\n<div>Pacific Coffee Co. Ltd. reserves the right of final decision in case of disputes&nbsp;</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 15px; border-style: none; border-bottom: 1px solid #eee; font-size: 14px;">\n<div>請於有效日期前使用、逾期作廢</div>\n<div>可憑券換領菜單上任何細杯裝手調飲品一杯 (只限熱飲)，特調咖啡、酒調咖啡、樽裝飲品及果汁除外 (如欲升級選用燕麥奶，每杯飲品需額外加$4)</div>\n<div>此電子券適用於全線香港Pacific Coffee (銅鑼灣Midtown及亞洲國際博覽館分店除外)</div>\n<div>此電子券不可兌換現金及不適用於外賣遞送服務&nbsp;</div>\n<div>此電子券不可與其它優惠同時使用&nbsp;</div>\n<div>必須以電子券上的二維碼換領飲品，而此券之二維碼只可使用一次</div>\n<div>Pacific Coffee Co. Ltd. 將保留此優惠之最終決定權</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px;">\n<p>門市查詢</p>\n<p>{agent_web}</p>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; background-color: #f0f1f1; padding: 15px;"><img src="https://tx2media.rewards-centre.com/Images/b27780cd-2769-439b-9dbd-72d004cc18c3.png" width="75px" /></td>\n</tr>\n</tbody>\n</table>\n<p>&nbsp;</p>', 'PCC:string|Serial No.:string|Start Date:date|Expiry Date:date', '{code_pcc}', 160, 'pending', '2020-02-12 07:36:26', '2020-02-19 07:33:46'),
	(3, 'AAAAAAAAAAAAAAAAAAAAAAAAAAA', 3, '2020-02-07', '2020-02-07', '<table style="width: 100%; margin: 0 auto; border-collapse: collapse; max-width: 750px; border: none; font-family: \'Raleway\',微軟正黑體, \'Microsoft JhengHei\', sans-serif;">\n<tbody>\n<tr style="height: 54px;">\n<td style="width: 100%; height: auto; padding: 15px; background-color: #f0f1f1;"><code><img style="max-width: 100px; height: auto;" src="https://tx2media.rewards-centre.com/Images/060fa9de-6bb8-4285-900b-3f62c2cb44a1.png" /></code></td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;"><img src="https://tx2media.rewards-centre.com/Images/fabb7cf0-d1eb-48ed-9e40-35fba14b0916.jpg" /></td>\n</tr>\n<tr style="height: 32px;">\n<td style="padding: 0px 30px 20px; font-size: 28px; text-align: center; height: 32px;">{voucher_description}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; text-align: center;">{qr_code}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="font-size: 22px; text-decoration: none; color: #333333; padding: 0px 30px 30px; text-align: center; height: 26px;">電子禮券編號：{code_serial_no}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;">\n<table style="width: 100%; border-collapse: collapse; border-top: 1px solid black;" border="0">\n<tbody>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 15px 0px 10px 15px;">商品描述</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%;">{voucher_description}</td>\n</tr>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 15px 0px 10px 15px;">有效期至</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%; vertical-align: middle;">{voucher_expiry_date}</td>\n</tr>\n</tbody>\n</table>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px; font-size: 14px;">\n<div style="color: #777; font-size: 16px; margin-top: 15px; margin-bottom: 15px;">條款及細則</div>\n<div>Short Size e-Coffee Voucher細杯裝電子咖啡券&nbsp;</div>\n<div>This e-voucher is valid until expiry date, which is non-extendable&nbsp;</div>\n<div>This e-voucher entitles the holder to redeem any short size handcrafted beverage on menu board (hot only), except specialty coffee, liqueur coffee, bottled drinks and juices (an additional $4 will be charged per beverage to upgrade to oat milk)</div>\n<div>This e-voucher is redeemable at any Pacific Coffee in Hong Kong (except Causeway Bay Midtown and Asia World Expo coffeehouses)</div>\n<div>This e-voucher cannot be exchanged for cash or its equivalent and is not applicable to delivery services</div>\n<div>This e-voucher cannot be used in conjunction with any other promotions or privileges</div>\n<div>Customers must use the QR code to redeem the beverage, and the code is valid for one-time use only</div>\n<div>Pacific Coffee Co. Ltd. reserves the right of final decision in case of disputes&nbsp;</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 15px; border-style: none; border-bottom: 1px solid #eee; font-size: 14px;">\n<div>請於有效日期前使用、逾期作廢</div>\n<div>可憑券換領菜單上任何細杯裝手調飲品一杯 (只限熱飲)，特調咖啡、酒調咖啡、樽裝飲品及果汁除外 (如欲升級選用燕麥奶，每杯飲品需額外加$4)</div>\n<div>此電子券適用於全線香港Pacific Coffee (銅鑼灣Midtown及亞洲國際博覽館分店除外)</div>\n<div>此電子券不可兌換現金及不適用於外賣遞送服務&nbsp;</div>\n<div>此電子券不可與其它優惠同時使用&nbsp;</div>\n<div>必須以電子券上的二維碼換領飲品，而此券之二維碼只可使用一次</div>\n<div>Pacific Coffee Co. Ltd. 將保留此優惠之最終決定權</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px;">\n<p>門市查詢</p>\n<p>{agent_web}</p>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; background-color: #f0f1f1; padding: 15px;"><img src="https://tx2media.rewards-centre.com/Images/b27780cd-2769-439b-9dbd-72d004cc18c3.png" width="75px" /></td>\n</tr>\n</tbody>\n</table>\n<p>&nbsp;</p>', 'PCC:string|Serial No.:string|Start Date:date|Expiry Date:date', '{code_pcc}', 160, 'pending', '2020-02-12 08:07:45', '2020-02-18 09:56:24'),
	(6, 'dsffdsfdsfsda', 3, '2020-02-02', '2020-02-11', NULL, NULL, NULL, 160, 'pending', '2020-02-18 10:31:30', '2020-02-18 10:31:30'),
	(7, 'Voucher #0', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:38', '2020-02-19 01:35:00'),
	(8, 'Voucher #1', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(9, 'Voucher #2', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(10, 'Voucher #3', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(11, 'Voucher #4', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(12, 'Voucher #5', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(13, 'Voucher #6', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(14, 'Voucher #7', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(15, 'Voucher #8', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(16, 'Voucher #9', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(17, 'Voucher #10', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(18, 'Voucher #11', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(19, 'Voucher #12', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:00'),
	(20, 'Voucher #13', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:01'),
	(21, 'Voucher #14', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:01'),
	(22, 'Voucher #15', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:39', '2020-02-19 01:35:01'),
	(23, 'Voucher #16', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(24, 'Voucher #17', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(25, 'Voucher #18', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(26, 'Voucher #19', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(27, 'Voucher #20', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(28, 'Voucher #21', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(29, 'Voucher #22', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(30, 'Voucher #23', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(31, 'Voucher #24', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(32, 'Voucher #25', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(33, 'Voucher #26', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(34, 'Voucher #27', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:01'),
	(35, 'Voucher #28', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:02'),
	(36, 'Voucher #29', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:02'),
	(37, 'Voucher #30', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:02'),
	(38, 'Voucher #31', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:02'),
	(39, 'Voucher #32', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:02'),
	(40, 'Voucher #33', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:40', '2020-02-19 01:35:02'),
	(41, 'Voucher #34', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:02'),
	(42, 'Voucher #35', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:02'),
	(43, 'Voucher #36', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:02'),
	(44, 'Voucher #37', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:02'),
	(45, 'Voucher #38', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:02'),
	(46, 'Voucher #39', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:02'),
	(47, 'Voucher #40', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(48, 'Voucher #41', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(49, 'Voucher #42', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(50, 'Voucher #43', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(51, 'Voucher #44', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(52, 'Voucher #45', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(53, 'Voucher #46', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(54, 'Voucher #47', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(55, 'Voucher #48', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(56, 'Voucher #49', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(57, 'Voucher #50', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:41', '2020-02-19 01:35:03'),
	(58, 'Voucher #51', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:03'),
	(59, 'Voucher #52', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:03'),
	(60, 'Voucher #53', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(61, 'Voucher #54', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(62, 'Voucher #55', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(63, 'Voucher #56', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(64, 'Voucher #57', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(65, 'Voucher #58', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(66, 'Voucher #59', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(67, 'Voucher #60', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(68, 'Voucher #61', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(69, 'Voucher #62', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(70, 'Voucher #63', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(71, 'Voucher #64', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:04'),
	(72, 'Voucher #65', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:05'),
	(73, 'Voucher #66', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:05'),
	(74, 'Voucher #67', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:42', '2020-02-19 01:35:05'),
	(75, 'Voucher #68', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(76, 'Voucher #69', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(77, 'Voucher #70', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(78, 'Voucher #71', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(79, 'Voucher #72', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(80, 'Voucher #73', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(81, 'Voucher #74', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(82, 'Voucher #75', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(83, 'Voucher #76', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(84, 'Voucher #77', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(85, 'Voucher #78', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:05'),
	(86, 'Voucher #79', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:06'),
	(87, 'Voucher #80', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:06'),
	(88, 'Voucher #81', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:06'),
	(89, 'Voucher #82', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:06'),
	(90, 'Voucher #83', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:06'),
	(91, 'Voucher #84', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:43', '2020-02-19 01:35:06'),
	(92, 'Voucher #85', 2, '2020-02-19', '2020-03-10', '<table style="width: 100%; margin: 0 auto; border-collapse: collapse; max-width: 750px; border: none; font-family: \'Raleway\',微軟正黑體, \'Microsoft JhengHei\', sans-serif;">\n<tbody>\n<tr style="height: 54px;">\n<td style="width: 100%; height: auto; padding: 15px; background-color: #f0f1f1;"><code><img style="max-width: 100px; height: auto;" src="https://tx2media.rewards-centre.com/Images/060fa9de-6bb8-4285-900b-3f62c2cb44a1.png" /></code></td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;"><img src="https://tx2media.rewards-centre.com/Images/fabb7cf0-d1eb-48ed-9e40-35fba14b0916.jpg" /></td>\n</tr>\n<tr style="height: 32px;">\n<td style="padding: 0px 30px 20px; font-size: 28px; text-align: center; height: 32px;">{voucher_description}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; text-align: center;">{qr_code}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="font-size: 22px; text-decoration: none; color: #333333; padding: 0px 30px 30px; text-align: center; height: 26px;">電子禮券編號：{code_serial_no}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;">\n<table style="width: 100%; border-collapse: collapse; border-top: 1px solid black;" border="0">\n<tbody>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 15px 0px 10px 15px;">商品描述</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%;">{voucher_description}</td>\n</tr>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 10px 0px 10px 15px; vertical-align: middle;">有效期至</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%; vertical-align: middle;">{voucher_expiry_date}</td>\n</tr>\n</tbody>\n</table>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px; font-size: 14px;">\n<p style="color: #777; font-size: 16px;">條款及細則</p>\n<div>Short Size e-Coffee Voucher細杯裝電子咖啡券&nbsp;</div>\n<div>This e-voucher is valid until expiry date, which is non-extendable&nbsp;</div>\n<div>This e-voucher entitles the holder to redeem any short size handcrafted beverage on menu board (hot only), except specialty coffee, liqueur coffee, bottled drinks and juices (an additional $4 will be charged per beverage to upgrade to oat milk)</div>\n<div>This e-voucher is redeemable at any Pacific Coffee in Hong Kong (except Causeway Bay Midtown and Asia World Expo coffeehouses)</div>\n<div>This e-voucher cannot be exchanged for cash or its equivalent and is not applicable to delivery services</div>\n<div>This e-voucher cannot be used in conjunction with any other promotions or privileges</div>\n<div>Customers must use the QR code to redeem the beverage, and the code is valid for one-time use only</div>\n<div>Pacific Coffee Co. Ltd. reserves the right of final decision in case of disputes&nbsp;</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 15px; border-style: none; border-bottom: 1px solid #eee; font-size: 14px;">\n<div>請於有效日期前使用、逾期作廢</div>\n<div>可憑券換領菜單上任何細杯裝手調飲品一杯 (只限熱飲)，特調咖啡、酒調咖啡、樽裝飲品及果汁除外 (如欲升級選用燕麥奶，每杯飲品需額外加$4)</div>\n<div>此電子券適用於全線香港Pacific Coffee (銅鑼灣Midtown及亞洲國際博覽館分店除外)</div>\n<div>此電子券不可兌換現金及不適用於外賣遞送服務&nbsp;</div>\n<div>此電子券不可與其它優惠同時使用&nbsp;</div>\n<div>必須以電子券上的二維碼換領飲品，而此券之二維碼只可使用一次</div>\n<div>Pacific Coffee Co. Ltd. 將保留此優惠之最終決定權</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px;">\n<p>門市查詢</p>\n<p>{agent_web}</p>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; background-color: #f0f1f1; padding: 15px;"><img src="https://tx2media.rewards-centre.com/Images/b27780cd-2769-439b-9dbd-72d004cc18c3.png" width="75px" /></td>\n</tr>\n</tbody>\n</table>\n<p>&nbsp;</p>', 'PCC:string|Serial No.:string|Start Date:date|Expiry Date:date', '{code_pcc}', 160, 'pending', '2020-02-19 01:27:44', '2020-02-20 07:00:11'),
	(93, 'Voucher #86', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:44', '2020-02-19 01:35:06'),
	(94, 'Voucher #87', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:44', '2020-02-19 01:35:06'),
	(95, 'Voucher #88', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:44', '2020-02-19 01:35:06'),
	(96, 'Voucher #89', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:44', '2020-02-19 01:35:06'),
	(97, 'Voucher #90', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:44', '2020-02-19 01:35:06'),
	(98, 'Voucher #91', 2, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:44', '2020-02-19 01:35:06'),
	(99, 'Voucher #92', 3, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:44', '2020-02-19 01:35:06'),
	(100, 'Voucher #93', 1, '2020-02-19', '2020-03-10', NULL, NULL, NULL, 160, 'pending', '2020-02-19 01:27:44', '2020-02-19 01:35:07');
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;

-- Dumping structure for table evoucher.voucher_codes
DROP TABLE IF EXISTS `voucher_codes`;
CREATE TABLE IF NOT EXISTS `voucher_codes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` int(10) unsigned NOT NULL,
  `order` int(10) unsigned NOT NULL DEFAULT '0',
  `code` varchar(255) NOT NULL DEFAULT '0',
  `extra_fields` text NOT NULL,
  `key` varchar(100) NOT NULL DEFAULT '',
  `sent_on` date DEFAULT NULL,
  `status` enum('pending','ready','completed') DEFAULT 'pending',
  `remark` text,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.voucher_codes: ~106 rows (approximately)
DELETE FROM `voucher_codes`;
/*!40000 ALTER TABLE `voucher_codes` DISABLE KEYS */;
INSERT INTO `voucher_codes` (`id`, `voucher_id`, `order`, `code`, `extra_fields`, `key`, `sent_on`, `status`, `remark`, `created_at`, `updated_at`) VALUES
	(6, 1, 1, '0019999900100008000000g0rDtKv136', '00092979|2019-11-14|2020-05-23', '10f9a001f6d7ba7975df2893a5d82aea', NULL, 'pending', NULL, '2020-02-13 02:47:45', '2020-02-18 10:41:53'),
	(12, 3, 1, '0019999900100008000000g0rDtKv136', '00092979|2019-11-14|2020-05-23', 'dd4f26157e33fff8ca9fbc0038b01321', NULL, 'pending', NULL, '2020-02-18 09:11:39', '2020-02-18 09:46:56'),
	(13, 3, 2, '0019999900100008000000fAqEsLt135', '00092978|2000-01-01|2050-12-31', 'ac0e188fa00d1796a2661754955db82d', NULL, 'pending', NULL, '2020-02-18 09:38:42', '2020-02-18 09:41:29'),
	(14, 1, 2, '0019999900100008000000fAqEsLt135', '00092978|2000-01-01|2050-12-31', '36d011f3d2bec9aca7a989d9e8310541', NULL, 'pending', NULL, '2020-02-18 10:41:53', '2020-02-19 07:33:46'),
	(15, 92, 1, '0019999900100008000000fAqEsLt135', '00092978|2000-01-01|2050-12-31', '60a4ebb381640092cd45eb17e0f035f2', '2020-02-19', 'pending', 'aaaa', '2020-02-19 04:11:50', '2020-02-19 07:28:34'),
	(16, 92, 2, '0019999900100008000000g0rDtKv136', '00092979|2019-11-14|2020-05-23', '029fe6710a80abaaaeb6fea4fa6b7d4e', '2020-02-21', 'pending', 'bbbb', '2020-02-19 04:11:50', '2020-02-19 07:28:34'),
	(17, 1, 0, '0019999900100008000000g0rDtK0000', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:11', '2020-02-19 09:09:11'),
	(18, 1, 0, '0019999900100008000000g0rDtK0001', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:11', '2020-02-19 09:09:11'),
	(19, 1, 0, '0019999900100008000000g0rDtK0002', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:11', '2020-02-19 09:09:11'),
	(20, 1, 0, '0019999900100008000000g0rDtK0003', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:11', '2020-02-19 09:09:11'),
	(21, 1, 0, '0019999900100008000000g0rDtK0004', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:11', '2020-02-19 09:09:11'),
	(22, 1, 0, '0019999900100008000000g0rDtK0005', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:12', '2020-02-19 09:09:12'),
	(23, 1, 0, '0019999900100008000000g0rDtK0006', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:12', '2020-02-19 09:09:12'),
	(24, 1, 0, '0019999900100008000000g0rDtK0007', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:12', '2020-02-19 09:09:12'),
	(25, 1, 0, '0019999900100008000000g0rDtK0008', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:12', '2020-02-19 09:09:12'),
	(26, 1, 0, '0019999900100008000000g0rDtK0009', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:12', '2020-02-19 09:09:12'),
	(27, 1, 0, '0019999900100008000000g0rDtK0010', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:12', '2020-02-19 09:09:12'),
	(28, 1, 0, '0019999900100008000000g0rDtK0011', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:12', '2020-02-19 09:09:12'),
	(29, 1, 0, '0019999900100008000000g0rDtK0012', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:12', '2020-02-19 09:09:12'),
	(30, 1, 0, '0019999900100008000000g0rDtK0013', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:12', '2020-02-19 09:09:12'),
	(31, 1, 0, '0019999900100008000000g0rDtK0014', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:12', '2020-02-19 09:09:12'),
	(32, 1, 0, '0019999900100008000000g0rDtK0015', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(33, 1, 0, '0019999900100008000000g0rDtK0016', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(34, 1, 0, '0019999900100008000000g0rDtK0017', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(35, 1, 0, '0019999900100008000000g0rDtK0018', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(36, 1, 0, '0019999900100008000000g0rDtK0019', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(37, 1, 0, '0019999900100008000000g0rDtK0020', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(38, 1, 0, '0019999900100008000000g0rDtK0021', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(39, 1, 0, '0019999900100008000000g0rDtK0022', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(40, 1, 0, '0019999900100008000000g0rDtK0023', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(41, 1, 0, '0019999900100008000000g0rDtK0024', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(42, 1, 0, '0019999900100008000000g0rDtK0025', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(43, 1, 0, '0019999900100008000000g0rDtK0026', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(44, 1, 0, '0019999900100008000000g0rDtK0027', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:13', '2020-02-19 09:09:13'),
	(45, 1, 0, '0019999900100008000000g0rDtK0028', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(46, 1, 0, '0019999900100008000000g0rDtK0029', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(47, 1, 0, '0019999900100008000000g0rDtK0030', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(48, 1, 0, '0019999900100008000000g0rDtK0031', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(49, 1, 0, '0019999900100008000000g0rDtK0032', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(50, 1, 0, '0019999900100008000000g0rDtK0033', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(51, 1, 0, '0019999900100008000000g0rDtK0034', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(52, 1, 0, '0019999900100008000000g0rDtK0035', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(53, 1, 0, '0019999900100008000000g0rDtK0036', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(54, 1, 0, '0019999900100008000000g0rDtK0037', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(55, 1, 0, '0019999900100008000000g0rDtK0038', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(56, 1, 0, '0019999900100008000000g0rDtK0039', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(57, 1, 0, '0019999900100008000000g0rDtK0040', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(58, 1, 0, '0019999900100008000000g0rDtK0041', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(59, 1, 0, '0019999900100008000000g0rDtK0042', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:14', '2020-02-19 09:09:14'),
	(60, 1, 0, '0019999900100008000000g0rDtK0043', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(61, 1, 0, '0019999900100008000000g0rDtK0044', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(62, 1, 0, '0019999900100008000000g0rDtK0045', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(63, 1, 0, '0019999900100008000000g0rDtK0046', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(64, 1, 0, '0019999900100008000000g0rDtK0047', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(65, 1, 0, '0019999900100008000000g0rDtK0048', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(66, 1, 0, '0019999900100008000000g0rDtK0049', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(67, 1, 0, '0019999900100008000000g0rDtK0050', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(68, 1, 0, '0019999900100008000000g0rDtK0051', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(69, 1, 0, '0019999900100008000000g0rDtK0052', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(70, 1, 0, '0019999900100008000000g0rDtK0053', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(71, 1, 0, '0019999900100008000000g0rDtK0054', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(72, 1, 0, '0019999900100008000000g0rDtK0055', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(73, 1, 0, '0019999900100008000000g0rDtK0056', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:15', '2020-02-19 09:09:15'),
	(74, 1, 0, '0019999900100008000000g0rDtK0057', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(75, 1, 0, '0019999900100008000000g0rDtK0058', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(76, 1, 0, '0019999900100008000000g0rDtK0059', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(77, 1, 0, '0019999900100008000000g0rDtK0060', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(78, 1, 0, '0019999900100008000000g0rDtK0061', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(79, 1, 0, '0019999900100008000000g0rDtK0062', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(80, 1, 0, '0019999900100008000000g0rDtK0063', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(81, 1, 0, '0019999900100008000000g0rDtK0064', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(82, 1, 0, '0019999900100008000000g0rDtK0065', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(83, 1, 0, '0019999900100008000000g0rDtK0066', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(84, 1, 0, '0019999900100008000000g0rDtK0067', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(85, 1, 0, '0019999900100008000000g0rDtK0068', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(86, 1, 0, '0019999900100008000000g0rDtK0069', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(87, 1, 0, '0019999900100008000000g0rDtK0070', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(88, 1, 0, '0019999900100008000000g0rDtK0071', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:16', '2020-02-19 09:09:16'),
	(89, 1, 0, '0019999900100008000000g0rDtK0072', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(90, 1, 0, '0019999900100008000000g0rDtK0073', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(91, 1, 0, '0019999900100008000000g0rDtK0074', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(92, 1, 0, '0019999900100008000000g0rDtK0075', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(93, 1, 0, '0019999900100008000000g0rDtK0076', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(94, 1, 0, '0019999900100008000000g0rDtK0077', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(95, 1, 0, '0019999900100008000000g0rDtK0078', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(96, 1, 0, '0019999900100008000000g0rDtK0079', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(97, 1, 0, '0019999900100008000000g0rDtK0080', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(98, 1, 0, '0019999900100008000000g0rDtK0081', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(99, 1, 0, '0019999900100008000000g0rDtK0082', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(100, 1, 0, '0019999900100008000000g0rDtK0083', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(101, 1, 0, '0019999900100008000000g0rDtK0084', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(102, 1, 0, '0019999900100008000000g0rDtK0085', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(103, 1, 0, '0019999900100008000000g0rDtK0086', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:17', '2020-02-19 09:09:17'),
	(104, 1, 0, '0019999900100008000000g0rDtK0087', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(105, 1, 0, '0019999900100008000000g0rDtK0088', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(106, 1, 0, '0019999900100008000000g0rDtK0089', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(107, 1, 0, '0019999900100008000000g0rDtK0090', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(108, 1, 0, '0019999900100008000000g0rDtK0091', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(109, 1, 0, '0019999900100008000000g0rDtK0092', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(110, 1, 0, '0019999900100008000000g0rDtK0093', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(111, 1, 0, '0019999900100008000000g0rDtK0094', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(112, 1, 0, '0019999900100008000000g0rDtK0095', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(113, 1, 0, '0019999900100008000000g0rDtK0096', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(114, 1, 0, '0019999900100008000000g0rDtK0097', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(115, 1, 0, '0019999900100008000000g0rDtK0098', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18'),
	(116, 1, 0, '0019999900100008000000g0rDtK0099', '00092979|2019-11-14|2020-05-23', '', NULL, 'pending', NULL, '2020-02-19 09:09:18', '2020-02-19 09:09:18');
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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.voucher_emails: ~0 rows (approximately)
DELETE FROM `voucher_emails`;
/*!40000 ALTER TABLE `voucher_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `voucher_emails` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
