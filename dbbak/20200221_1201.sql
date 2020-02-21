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

-- Dumping data for table evoucher.temp_leaflets: ~1 rows (approximately)
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.vouchers: ~3 rows (approximately)
DELETE FROM `vouchers`;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
INSERT INTO `vouchers` (`id`, `description`, `agent_id`, `activation_date`, `expiry_date`, `template`, `code_fields`, `qr_code_composition`, `qr_code_size`, `status`, `created_at`, `updated_at`) VALUES
	(1, 'Pacific Coffee Short Size e-Coffee Voucher細杯裝電子咖啡券', 2, '2020-02-06', '2020-02-19', '<table style="width: 100%; margin: 0 auto; border-collapse: collapse; max-width: 750px; border: none; font-family: \'Raleway\',微軟正黑體, \'Microsoft JhengHei\', sans-serif;">\n<tbody>\n<tr style="height: 54px;">\n<td style="width: 100%; height: auto; padding: 15px; background-color: #f0f1f1;"><code><img style="max-width: 100px; height: auto;" src="https://tx2media.rewards-centre.com/Images/060fa9de-6bb8-4285-900b-3f62c2cb44a1.png" /></code></td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;"><img src="https://tx2media.rewards-centre.com/Images/fabb7cf0-d1eb-48ed-9e40-35fba14b0916.jpg" /></td>\n</tr>\n<tr style="height: 32px;">\n<td style="padding: 0px 30px 20px; font-size: 28px; text-align: center; height: 32px;">{voucher_description}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; text-align: center;">{qr_code}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="font-size: 22px; text-decoration: none; color: #333333; padding: 0px 30px 30px; text-align: center; height: 26px;">電子禮券編號：{code_serial_no}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;">\n<table style="width: 100%; border-collapse: collapse; border-top: 1px solid black;" border="0">\n<tbody>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 15px 0px 10px 15px;">商品描述</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%;">{voucher_description}</td>\n</tr>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 10px 0px 10px 15px; vertical-align: middle;">有效期至</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%; vertical-align: middle;">{voucher_expiry_date}</td>\n</tr>\n</tbody>\n</table>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px; font-size: 14px;">\n<p style="color: #777; font-size: 16px;">條款及細則</p>\n<div>Short Size e-Coffee Voucher細杯裝電子咖啡券&nbsp;</div>\n<div>This e-voucher is valid until expiry date, which is non-extendable&nbsp;</div>\n<div>This e-voucher entitles the holder to redeem any short size handcrafted beverage on menu board (hot only), except specialty coffee, liqueur coffee, bottled drinks and juices (an additional $4 will be charged per beverage to upgrade to oat milk)</div>\n<div>This e-voucher is redeemable at any Pacific Coffee in Hong Kong (except Causeway Bay Midtown and Asia World Expo coffeehouses)</div>\n<div>This e-voucher cannot be exchanged for cash or its equivalent and is not applicable to delivery services</div>\n<div>This e-voucher cannot be used in conjunction with any other promotions or privileges</div>\n<div>Customers must use the QR code to redeem the beverage, and the code is valid for one-time use only</div>\n<div>Pacific Coffee Co. Ltd. reserves the right of final decision in case of disputes&nbsp;</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 15px; border-style: none; border-bottom: 1px solid #eee; font-size: 14px;">\n<div>請於有效日期前使用、逾期作廢</div>\n<div>可憑券換領菜單上任何細杯裝手調飲品一杯 (只限熱飲)，特調咖啡、酒調咖啡、樽裝飲品及果汁除外 (如欲升級選用燕麥奶，每杯飲品需額外加$4)</div>\n<div>此電子券適用於全線香港Pacific Coffee (銅鑼灣Midtown及亞洲國際博覽館分店除外)</div>\n<div>此電子券不可兌換現金及不適用於外賣遞送服務&nbsp;</div>\n<div>此電子券不可與其它優惠同時使用&nbsp;</div>\n<div>必須以電子券上的二維碼換領飲品，而此券之二維碼只可使用一次</div>\n<div>Pacific Coffee Co. Ltd. 將保留此優惠之最終決定權</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px;">\n<p>門市查詢</p>\n<p>{agent_web}</p>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; background-color: #f0f1f1; padding: 15px;"><img src="https://tx2media.rewards-centre.com/Images/b27780cd-2769-439b-9dbd-72d004cc18c3.png" width="75px" /></td>\n</tr>\n</tbody>\n</table>\n<p>&nbsp;</p>', 'PCC:string|Serial No.:string|Start Date:date|Expiry Date:date', '{code_pcc}', 160, 'pending', '2020-02-12 07:36:26', '2020-02-21 03:47:18'),
	(3, 'AAAAAAAAAAAAAAAAAAAAAAAAAAA', 3, '2020-02-07', '2020-02-07', '<table style="width: 100%; margin: 0 auto; border-collapse: collapse; max-width: 750px; border: none; font-family: \'Raleway\',微軟正黑體, \'Microsoft JhengHei\', sans-serif;">\n<tbody>\n<tr style="height: 54px;">\n<td style="width: 100%; height: auto; padding: 15px; background-color: #f0f1f1;"><code><img style="max-width: 100px; height: auto;" src="https://tx2media.rewards-centre.com/Images/060fa9de-6bb8-4285-900b-3f62c2cb44a1.png" /></code></td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;"><img src="https://tx2media.rewards-centre.com/Images/fabb7cf0-d1eb-48ed-9e40-35fba14b0916.jpg" /></td>\n</tr>\n<tr style="height: 32px;">\n<td style="padding: 0px 30px 20px; font-size: 28px; text-align: center; height: 32px;">{voucher_description}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; text-align: center;">{qr_code}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="font-size: 22px; text-decoration: none; color: #333333; padding: 0px 30px 30px; text-align: center; height: 26px;">電子禮券編號：{code_serial_no}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;">\n<table style="width: 100%; border-collapse: collapse; border-top: 1px solid black;" border="0">\n<tbody>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 15px 0px 10px 15px;">商品描述</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%;">{voucher_description}</td>\n</tr>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 15px 0px 10px 15px;">有效期至</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%; vertical-align: middle;">{voucher_expiry_date}</td>\n</tr>\n</tbody>\n</table>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px; font-size: 14px;">\n<div style="color: #777; font-size: 16px; margin-top: 15px; margin-bottom: 15px;">條款及細則</div>\n<div>Short Size e-Coffee Voucher細杯裝電子咖啡券&nbsp;</div>\n<div>This e-voucher is valid until expiry date, which is non-extendable&nbsp;</div>\n<div>This e-voucher entitles the holder to redeem any short size handcrafted beverage on menu board (hot only), except specialty coffee, liqueur coffee, bottled drinks and juices (an additional $4 will be charged per beverage to upgrade to oat milk)</div>\n<div>This e-voucher is redeemable at any Pacific Coffee in Hong Kong (except Causeway Bay Midtown and Asia World Expo coffeehouses)</div>\n<div>This e-voucher cannot be exchanged for cash or its equivalent and is not applicable to delivery services</div>\n<div>This e-voucher cannot be used in conjunction with any other promotions or privileges</div>\n<div>Customers must use the QR code to redeem the beverage, and the code is valid for one-time use only</div>\n<div>Pacific Coffee Co. Ltd. reserves the right of final decision in case of disputes&nbsp;</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 15px; border-style: none; border-bottom: 1px solid #eee; font-size: 14px;">\n<div>請於有效日期前使用、逾期作廢</div>\n<div>可憑券換領菜單上任何細杯裝手調飲品一杯 (只限熱飲)，特調咖啡、酒調咖啡、樽裝飲品及果汁除外 (如欲升級選用燕麥奶，每杯飲品需額外加$4)</div>\n<div>此電子券適用於全線香港Pacific Coffee (銅鑼灣Midtown及亞洲國際博覽館分店除外)</div>\n<div>此電子券不可兌換現金及不適用於外賣遞送服務&nbsp;</div>\n<div>此電子券不可與其它優惠同時使用&nbsp;</div>\n<div>必須以電子券上的二維碼換領飲品，而此券之二維碼只可使用一次</div>\n<div>Pacific Coffee Co. Ltd. 將保留此優惠之最終決定權</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px;">\n<p>門市查詢</p>\n<p>{agent_web}</p>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; background-color: #f0f1f1; padding: 15px;"><img src="https://tx2media.rewards-centre.com/Images/b27780cd-2769-439b-9dbd-72d004cc18c3.png" width="75px" /></td>\n</tr>\n</tbody>\n</table>\n<p>&nbsp;</p>', 'PCC:string|Serial No.:string|Start Date:date|Expiry Date:date', '{code_pcc}', 160, 'pending', '2020-02-12 08:07:45', '2020-02-18 09:56:24'),
	(6, '超級咖啡細杯裝電子優惠券', 3, '2020-02-02', '2020-02-11', '<table style="width: 100%; margin: 0 auto; border-collapse: collapse; max-width: 750px; border: none; font-family: \'Raleway\',微軟正黑體, \'Microsoft JhengHei\', sans-serif;">\n<tbody>\n<tr style="height: 54px;">\n<td style="width: 100%; height: auto; padding: 15px; background-color: #f0f1f1;"><code><img style="max-width: 100px; height: auto;" src="https://tx2media.rewards-centre.com/Images/060fa9de-6bb8-4285-900b-3f62c2cb44a1.png" /></code></td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;"><img src="https://tx2media.rewards-centre.com/Images/fabb7cf0-d1eb-48ed-9e40-35fba14b0916.jpg" /></td>\n</tr>\n<tr style="height: 32px;">\n<td style="padding: 0px 30px 20px; font-size: 28px; text-align: center; height: 32px;">{voucher_description}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; text-align: center;">{qr_code}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="font-size: 22px; text-decoration: none; color: #333333; padding: 0px 30px 30px; text-align: center; height: 26px;">電子禮券編號：{code_hd_code}</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px;">\n<table style="width: 100%; border-collapse: collapse; border-top: 1px solid black;" border="0">\n<tbody>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 15px 0px 10px 15px;">商品描述</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%;">{voucher_description}</td>\n</tr>\n<tr style="border-bottom: 1px solid #eee;">\n<td style="width: 11.3333%; color: #777777; padding: 10px 0px 10px 15px; vertical-align: middle;">有效期至</td>\n<td style="padding: 15px 15px 10px; width: 88.6667%; vertical-align: middle;">{voucher_expiry_date}</td>\n</tr>\n</tbody>\n</table>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px; font-size: 14px;">\n<p style="color: #777; font-size: 16px;">條款及細則</p>\n<div>Short Size e-Coffee Voucher細杯裝電子咖啡券&nbsp;</div>\n<div>This e-voucher is valid until expiry date, which is non-extendable&nbsp;</div>\n<div>This e-voucher entitles the holder to redeem any short size handcrafted beverage on menu board (hot only), except specialty coffee, liqueur coffee, bottled drinks and juices (an additional $4 will be charged per beverage to upgrade to oat milk)</div>\n<div>This e-voucher is redeemable at any Pacific Coffee in Hong Kong (except Causeway Bay Midtown and Asia World Expo coffeehouses)</div>\n<div>This e-voucher cannot be exchanged for cash or its equivalent and is not applicable to delivery services</div>\n<div>This e-voucher cannot be used in conjunction with any other promotions or privileges</div>\n<div>Customers must use the QR code to redeem the beverage, and the code is valid for one-time use only</div>\n<div>Pacific Coffee Co. Ltd. reserves the right of final decision in case of disputes&nbsp;</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 15px; border-style: none; border-bottom: 1px solid #eee; font-size: 14px;">\n<div>請於有效日期前使用、逾期作廢</div>\n<div>可憑券換領菜單上任何細杯裝手調飲品一杯 (只限熱飲)，特調咖啡、酒調咖啡、樽裝飲品及果汁除外 (如欲升級選用燕麥奶，每杯飲品需額外加$4)</div>\n<div>此電子券適用於全線香港Pacific Coffee (銅鑼灣Midtown及亞洲國際博覽館分店除外)</div>\n<div>此電子券不可兌換現金及不適用於外賣遞送服務&nbsp;</div>\n<div>此電子券不可與其它優惠同時使用&nbsp;</div>\n<div>必須以電子券上的二維碼換領飲品，而此券之二維碼只可使用一次</div>\n<div>Pacific Coffee Co. Ltd. 將保留此優惠之最終決定權</div>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; padding: 0 15px;">\n<p>門市查詢</p>\n<p>{agent_web}</p>\n</td>\n</tr>\n<tr style="height: 18px;">\n<td style="width: 100%; height: 18px; background-color: #f0f1f1; padding: 15px;"><img src="https://tx2media.rewards-centre.com/Images/b27780cd-2769-439b-9dbd-72d004cc18c3.png" width="75px" /></td>\n</tr>\n</tbody>\n</table>\n<p>&nbsp;</p>', 'HD Code:integer|Expiry Date:date', 'code_hd_code', 160, 'pending', '2020-02-18 10:31:30', '2020-02-21 02:48:57');
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
) ENGINE=InnoDB AUTO_INCREMENT=682 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table evoucher.voucher_codes: ~106 rows (approximately)
DELETE FROM `voucher_codes`;
/*!40000 ALTER TABLE `voucher_codes` DISABLE KEYS */;
INSERT INTO `voucher_codes` (`id`, `voucher_id`, `order`, `code`, `extra_fields`, `key`, `sent_on`, `status`, `remark`, `created_at`, `updated_at`) VALUES
	(12, 3, 1, '0019999900100008000000g0rDtKv136', '00092979|2019-11-14|2020-05-23', '3e9cd79894d4903029439fd747c4211d', NULL, 'pending', NULL, '2020-02-18 09:11:39', '2020-02-21 03:02:55'),
	(13, 3, 2, '0019999900100008000000fAqEsLt135', '00092978|2000-01-01|2050-12-31', '49c0b97e9e7ffbcdfc95d2fa4eea935b', NULL, 'pending', NULL, '2020-02-18 09:38:42', '2020-02-21 03:02:55'),
	(210, 6, 1, '4060000022610', '2021-05-31', 'fe6aee0e002d4e3508fa348e354c156d', NULL, 'pending', NULL, '2020-02-21 02:48:57', '2020-02-21 02:49:40'),
	(211, 6, 2, '4060000022611', '2021-05-31', '539d480be64d023d0914f6a97122f9f8', NULL, 'pending', NULL, '2020-02-21 02:48:57', '2020-02-21 02:49:40'),
	(212, 6, 3, '4060000022612', '2021-05-31', '0d79cf8002b39bc815afbc2f18d618ba', NULL, 'pending', NULL, '2020-02-21 02:48:57', '2020-02-21 02:49:40'),
	(213, 6, 4, '4060000022613', '2021-05-31', 'f7b97da5504e6a6a8e56071d3b64d4cb', NULL, 'pending', NULL, '2020-02-21 02:48:57', '2020-02-21 02:49:40'),
	(214, 6, 5, '4060000022614', '2021-05-31', 'e2e572896c5209e7242c12cc1992211b', NULL, 'pending', NULL, '2020-02-21 02:48:57', '2020-02-21 02:49:40'),
	(215, 6, 6, '4060000022615', '2021-05-31', '8a6baf402e0ed08f2a3624f8df968ec6', NULL, 'pending', NULL, '2020-02-21 02:48:57', '2020-02-21 02:49:40'),
	(216, 6, 7, '4060000022616', '2021-05-31', 'b9b2b8e5bf1f77ce7c895de63f044feb', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:40'),
	(217, 6, 8, '4060000022617', '2021-05-31', 'd02220bf6ec26c2a10aab458a6fbc57e', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:40'),
	(218, 6, 9, '4060000022618', '2021-05-31', '7d6fc721400fc42daf25e1ea0ad1e05b', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:40'),
	(219, 6, 10, '4060000022619', '2021-05-31', 'e1394833905a20f1e54e57d721ff52d5', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:40'),
	(220, 6, 11, '4060000022620', '2021-05-31', 'b22261569d6c578abb7042d12b04bdc6', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:40'),
	(221, 6, 12, '4060000022621', '2021-05-31', 'f64ce18ebe5be96935cdd307409e821b', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(222, 6, 13, '4060000022622', '2021-05-31', '824b80e4b14d021d547af74c6dcd1f7c', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(223, 6, 14, '4060000022623', '2021-05-31', 'f12d6bf31b75b11b0f8b12078da70a3a', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(224, 6, 15, '4060000022624', '2021-05-31', '430ba75c0811181493dd894166e95475', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(225, 6, 16, '4060000022625', '2021-05-31', 'fe693d3b7e7da0e47cf4b2ce0ab52353', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(226, 6, 17, '4060000022626', '2021-05-31', 'a50fa7cbe05cac77b83d41bac6700f49', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(227, 6, 18, '4060000022627', '2021-05-31', '8398ce9a9a13909f506afc4b6b861066', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(228, 6, 19, '4060000022628', '2021-05-31', 'a41f7dadc0585ac0ff8d069013ab114f', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(229, 6, 20, '4060000022629', '2021-05-31', 'b8f1b38c6e5d8e3cc64fd7ede440adc0', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(230, 6, 21, '4060000022630', '2021-05-31', '2ca5fd8aef029c2e08432155bddf2c5d', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(231, 6, 22, '4060000022631', '2021-05-31', 'f1af77aa7c2576f586a1c4b0cc675282', NULL, 'pending', NULL, '2020-02-21 02:48:58', '2020-02-21 02:49:41'),
	(232, 6, 23, '4060000022632', '2021-05-31', 'be63fe26d827684a5e0e6c67a0c0c6a4', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:41'),
	(233, 6, 24, '4060000022633', '2021-05-31', '9a52b643f0bb3f8b0d0608c235db2791', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(234, 6, 25, '4060000022634', '2021-05-31', 'f6ec73abe19bddb89f8a1abdb2c12d10', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(235, 6, 26, '4060000022635', '2021-05-31', 'f1378cc750204e45d879f8955904c322', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(236, 6, 27, '4060000022636', '2021-05-31', '3050ec7585a01766693e9025259ccdeb', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(237, 6, 28, '4060000022637', '2021-05-31', '84cf4b40c5ba41a19d9f0381ffd75b73', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(238, 6, 29, '4060000022638', '2021-05-31', 'afe6799610b8b385fd15c34eaf843fc3', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(239, 6, 30, '4060000022639', '2021-05-31', 'f6a2eee5a0a3e1df12df65997171b798', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(240, 6, 31, '4060000022640', '2021-05-31', 'a43a7d25c934a544954cf89fd0be2e47', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(241, 6, 32, '4060000022641', '2021-05-31', '2b673afcf2f8541c937454231d6bc6b3', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(242, 6, 33, '4060000022642', '2021-05-31', 'a5a36157fca6dc5261c3892061bed7c3', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(243, 6, 34, '4060000022643', '2021-05-31', '264a5922520d585a078ee71bd056e233', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(244, 6, 35, '4060000022644', '2021-05-31', 'caddd9810089b581d44b8246207e2868', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(245, 6, 36, '4060000022645', '2021-05-31', 'e8a31d834a040c8024d993375554ba2a', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:42'),
	(246, 6, 37, '4060000022646', '2021-05-31', '920c4eca6c4df0f7f352c79279d7c07c', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:43'),
	(247, 6, 38, '4060000022647', '2021-05-31', '040baa0d94e2ef7f4f5d9a69e3c069fc', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:43'),
	(248, 6, 39, '4060000022648', '2021-05-31', '2e6148780e1120c4ae9be263a4bfb2f2', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:43'),
	(249, 6, 40, '4060000022649', '2021-05-31', 'e92f485c1c26e84e3b25a7bf3e917d51', NULL, 'pending', NULL, '2020-02-21 02:48:59', '2020-02-21 02:49:43'),
	(250, 6, 41, '4060000022650', '2021-05-31', '0b357209ddbc4cb92d0a12eaa0801631', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:43'),
	(251, 6, 42, '4060000022651', '2021-05-31', '61f0a75bbea1cb4b363afe4e144396da', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:43'),
	(252, 6, 43, '4060000022652', '2021-05-31', 'c5b060d2fd7a9e5d932379f220efab7c', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:43'),
	(253, 6, 44, '4060000022653', '2021-05-31', '75a911a2e245b779b2f01479df95719c', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:43'),
	(254, 6, 45, '4060000022654', '2021-05-31', '9c96a4c3dde9ac4c0fe4278d34138ff4', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:43'),
	(255, 6, 46, '4060000022655', '2021-05-31', '88492d32d1037d9ce3b9430d43b3ba47', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:43'),
	(256, 6, 47, '4060000022656', '2021-05-31', 'a548f940a26e8b1f1fe9b7e0181396ad', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:43'),
	(257, 6, 48, '4060000022657', '2021-05-31', 'a4a398a90b8c79db354a384908b85975', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:43'),
	(258, 6, 49, '4060000022658', '2021-05-31', '6a2cc51a3b83a09cedafe779522e76fc', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:43'),
	(259, 6, 50, '4060000022659', '2021-05-31', 'e497f24c303a9288d15a69a666676f01', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:44'),
	(260, 6, 51, '4060000022660', '2021-05-31', 'e817050d8be61c84a19473741dd97275', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:44'),
	(261, 6, 52, '4060000022661', '2021-05-31', '903d5fe8eeeb41209ea07fde52ec897b', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:44'),
	(262, 6, 53, '4060000022662', '2021-05-31', '129e88eb1c23913ae8f38517135556db', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:44'),
	(263, 6, 54, '4060000022663', '2021-05-31', 'd14af97df4a8bc91bfcf4df795ad160f', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:44'),
	(264, 6, 55, '4060000022664', '2021-05-31', 'dcff8f1b3d7c3d7b57c2a63de1e6bcbe', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:44'),
	(265, 6, 56, '4060000022665', '2021-05-31', '45ba88ed9f13e65a2bce13784981770a', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:44'),
	(266, 6, 57, '4060000022666', '2021-05-31', '54f35866c6189169e47d3a4e551ee9ab', NULL, 'pending', NULL, '2020-02-21 02:49:00', '2020-02-21 02:49:44'),
	(267, 6, 58, '4060000022667', '2021-05-31', '5a18f49e9cee3fa31ada3582522d352e', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:44'),
	(268, 6, 59, '4060000022668', '2021-05-31', '1711dd8c66ae4a9cbb55958c290501fd', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:44'),
	(269, 6, 60, '4060000022669', '2021-05-31', 'e910e506b1830810c5346efd9ba3b7e5', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:44'),
	(270, 6, 61, '4060000022670', '2021-05-31', 'afe6b943d93dc5ecbf9f5e426bdfca57', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:44'),
	(271, 6, 62, '4060000022671', '2021-05-31', 'c4a2507a3894e532c84ced9bd6095366', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:44'),
	(272, 6, 63, '4060000022672', '2021-05-31', '096ed9654af0b92288bcee0e9f6882fc', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(273, 6, 64, '4060000022673', '2021-05-31', '4227437806d10ae5df4ba3ee6b688088', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(274, 6, 65, '4060000022674', '2021-05-31', 'df3cf13560c0d91b7f5609b9ee9e99c7', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(275, 6, 66, '4060000022675', '2021-05-31', '48dad36aaa3d55e07fa277f3716284e1', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(276, 6, 67, '4060000022676', '2021-05-31', '3180b52948c98bdb9f9a301a2ea5d7d2', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(277, 6, 68, '4060000022677', '2021-05-31', '0c2dd1d2f6db80bf1a81f9c612d48157', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(278, 6, 69, '4060000022678', '2021-05-31', 'c412001a851f1c97a0643e9e817fc74a', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(279, 6, 70, '4060000022679', '2021-05-31', 'e62d70669cff7fdaf5c55559e64ddf33', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(280, 6, 71, '4060000022680', '2021-05-31', '40d594be9c3b6dd952c0530f33f25ce8', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(281, 6, 72, '4060000022681', '2021-05-31', 'c96fdc30319093a3d09e8d944f6bdb71', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(282, 6, 73, '4060000022682', '2021-05-31', 'f94fad8b3f9fce674cc5b0e5f7b0280d', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(283, 6, 74, '4060000022683', '2021-05-31', 'b900b0bb16e9e38030b58858506feb3e', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(284, 6, 75, '4060000022684', '2021-05-31', '19fd5d38125268897ffd887e2f16da02', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:45'),
	(285, 6, 76, '4060000022685', '2021-05-31', '8ba43008f433c6525bde5a5f239e9129', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:46'),
	(286, 6, 77, '4060000022686', '2021-05-31', '659b0a3a9f0d39b08f0b2b30ec0ffcef', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:46'),
	(287, 6, 78, '4060000022687', '2021-05-31', '54e7b2b04038e066f4587d68a96698b5', NULL, 'pending', NULL, '2020-02-21 02:49:01', '2020-02-21 02:49:46'),
	(288, 6, 79, '4060000022688', '2021-05-31', 'dd38c732b86c037df42d6e4e4d333102', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:46'),
	(289, 6, 80, '4060000022689', '2021-05-31', '494b35984136ee5ca568e1767bd60c3d', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:46'),
	(290, 6, 81, '4060000022690', '2021-05-31', '53df7e714587bbed657d49c942ad006d', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:46'),
	(291, 6, 82, '4060000022691', '2021-05-31', 'aa8727fcba74f3c9ff1b5c4f24cec212', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:46'),
	(292, 6, 83, '4060000022692', '2021-05-31', '7e3a9848d7aeeba4c4874fbdc01ccff3', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:46'),
	(293, 6, 84, '4060000022693', '2021-05-31', '161ccff4660d3fdf527c5d22977d3263', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:46'),
	(294, 6, 85, '4060000022694', '2021-05-31', '8635f0489e2a3878379366af852111a2', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:46'),
	(295, 6, 86, '4060000022695', '2021-05-31', 'be284126043c7ee13260067360fbe970', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:46'),
	(296, 6, 87, '4060000022696', '2021-05-31', 'bfa68191c3f43ff170fbf8c09dd3c674', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:46'),
	(297, 6, 88, '4060000022697', '2021-05-31', 'f62feb4df4893dc576ea447a22294d46', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:47'),
	(298, 6, 89, '4060000022698', '2021-05-31', '70c6f41337b571c5f2723003779c6739', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:47'),
	(299, 6, 90, '4060000022699', '2021-05-31', 'b2edf78cbd4f078908f9049ca6efdf3c', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:47'),
	(300, 6, 91, '4060000022700', '2021-05-31', '3b7d7e0bd1e85cf61b348ca55b947024', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:47'),
	(301, 6, 92, '4060000022701', '2021-05-31', '03dbba004c406bafbf48cc56f6650db5', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:47'),
	(302, 6, 93, '4060000022702', '2021-05-31', '38e6c14d988aca8ba55f1d9998056d89', NULL, 'pending', NULL, '2020-02-21 02:49:02', '2020-02-21 02:49:47'),
	(680, 1, 1, '0019999900100008000000fAqEsLt135', '00092978|2000-01-01|2050-12-31', '589abebafbfe41d64ecf6660e9d6c1ea', NULL, 'pending', NULL, '2020-02-21 03:47:18', '2020-02-21 03:47:18'),
	(681, 1, 2, '0019999900100008000000g0rDtKv136', '00092979|2019-11-14|2020-05-23', 'b6b10a67bd7f98b2b059f0aeca4443af', NULL, 'pending', NULL, '2020-02-21 03:47:18', '2020-02-21 03:47:18');
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
