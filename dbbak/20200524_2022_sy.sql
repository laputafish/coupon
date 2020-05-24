-- --------------------------------------------------------
-- Host:                         192.168.1.240
-- Server version:               10.3.11-MariaDB - Source distribution
-- Server OS:                    Linux
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table coupon_yoov_com.abilities
DROP TABLE IF EXISTS `abilities`;
CREATE TABLE IF NOT EXISTS `abilities` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_id` int(10) unsigned DEFAULT NULL,
  `entity_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `only_owned` tinyint(1) NOT NULL DEFAULT 0,
  `options` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scope` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `abilities_scope_index` (`scope`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.access_keys
DROP TABLE IF EXISTS `access_keys`;
CREATE TABLE IF NOT EXISTS `access_keys` (
  `user_id` int(11) NOT NULL,
  `key` varchar(60) NOT NULL,
  `module` varchar(60) NOT NULL,
  `command` varchar(50) DEFAULT NULL,
  `params` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Enable temporary export or pdf showing';

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.agents
DROP TABLE IF EXISTS `agents`;
CREATE TABLE IF NOT EXISTS `agents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(255) DEFAULT '',
  `alias` varchar(30) DEFAULT '',
  `contact` varchar(50) DEFAULT '',
  `tel_no` varchar(20) DEFAULT '',
  `fax_no` varchar(20) DEFAULT '',
  `web_url` varchar(100) DEFAULT '',
  `email` varchar(100) DEFAULT '',
  `remark` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.agent_smtp_servers
DROP TABLE IF EXISTS `agent_smtp_servers`;
CREATE TABLE IF NOT EXISTS `agent_smtp_servers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `agent_id` int(11) DEFAULT NULL,
  `description` varchar(50) DEFAULT '',
  `mail_driver` enum('smtp') DEFAULT 'smtp',
  `mail_host` varchar(50) DEFAULT '',
  `mail_port` int(10) unsigned DEFAULT 587,
  `mail_username` varchar(100) DEFAULT '',
  `mail_password` varchar(191) DEFAULT '',
  `mail_encryption` enum('tls') DEFAULT 'tls',
  `mail_from_address` varchar(100) DEFAULT '',
  `mail_from_name` varchar(191) DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.assigned_roles
DROP TABLE IF EXISTS `assigned_roles`;
CREATE TABLE IF NOT EXISTS `assigned_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL,
  `entity_id` int(10) unsigned NOT NULL,
  `entity_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `restricted_to_id` int(10) unsigned DEFAULT NULL,
  `restricted_to_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scope` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assigned_roles_entity_index` (`entity_id`,`entity_type`,`scope`),
  KEY `assigned_roles_role_id_index` (`role_id`),
  KEY `assigned_roles_scope_index` (`scope`),
  CONSTRAINT `assigned_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.input_obj_attributes
DROP TABLE IF EXISTS `input_obj_attributes`;
CREATE TABLE IF NOT EXISTS `input_obj_attributes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '',
  `caption` varchar(30) NOT NULL DEFAULT '',
  `style_name` varchar(30) NOT NULL DEFAULT '',
  `option_group` enum('element','container') NOT NULL DEFAULT 'element',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.input_obj_groups
DROP TABLE IF EXISTS `input_obj_groups`;
CREATE TABLE IF NOT EXISTS `input_obj_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `input_obj_type_id` int(10) unsigned NOT NULL DEFAULT 0,
  `caption` enum('Attributes','Container Attributes','') NOT NULL DEFAULT 'Attributes',
  `order` int(10) unsigned NOT NULL DEFAULT 0,
  `remark` varchar(191) NOT NULL DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_inputobj_groups_inputobj_types` (`input_obj_type_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.input_obj_group_attributes
DROP TABLE IF EXISTS `input_obj_group_attributes`;
CREATE TABLE IF NOT EXISTS `input_obj_group_attributes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `input_obj_group_id` int(10) unsigned NOT NULL DEFAULT 0,
  `attribute_key` varchar(30) DEFAULT '',
  `order` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.input_obj_types
DROP TABLE IF EXISTS `input_obj_types`;
CREATE TABLE IF NOT EXISTS `input_obj_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT '',
  `icon` varchar(20) DEFAULT '',
  `new_icon` varchar(20) DEFAULT '',
  `text` varchar(20) DEFAULT '',
  `label` varchar(30) DEFAULT '',
  `is_input` tinyint(1) unsigned DEFAULT 1,
  `fixed` tinyint(1) unsigned DEFAULT 0,
  `default` varchar(100) DEFAULT '',
  `order` int(10) unsigned DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.medias
DROP TABLE IF EXISTS `medias`;
CREATE TABLE IF NOT EXISTS `medias` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL DEFAULT 0,
  `agent_id` int(11) unsigned NOT NULL DEFAULT 0,
  `type` varchar(20) NOT NULL DEFAULT '0',
  `path` varchar(50) NOT NULL DEFAULT '0',
  `filename` varchar(100) NOT NULL DEFAULT '0',
  `scope` enum('general','tinymce') NOT NULL DEFAULT 'general',
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.menus
DROP TABLE IF EXISTS `menus`;
CREATE TABLE IF NOT EXISTS `menus` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `type` enum('group','link','root') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'link',
  `label_tag` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `route_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `icon_class` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `link` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `_lft` int(10) unsigned NOT NULL DEFAULT 0,
  `_rgt` int(10) unsigned NOT NULL DEFAULT 0,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `menus__lft__rgt_parent_id_index` (`_lft`,`_rgt`,`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.migrations
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.oauth_access_tokens
DROP TABLE IF EXISTS `oauth_access_tokens`;
CREATE TABLE IF NOT EXISTS `oauth_access_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `client_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_access_tokens_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.oauth_auth_codes
DROP TABLE IF EXISTS `oauth_auth_codes`;
CREATE TABLE IF NOT EXISTS `oauth_auth_codes` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.oauth_clients
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

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.oauth_personal_access_clients
DROP TABLE IF EXISTS `oauth_personal_access_clients`;
CREATE TABLE IF NOT EXISTS `oauth_personal_access_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_personal_access_clients_client_id_index` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.oauth_refresh_tokens
DROP TABLE IF EXISTS `oauth_refresh_tokens`;
CREATE TABLE IF NOT EXISTS `oauth_refresh_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.password_resets
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.permissions
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ability_id` int(10) unsigned NOT NULL,
  `entity_id` int(10) unsigned DEFAULT NULL,
  `entity_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `forbidden` tinyint(1) NOT NULL DEFAULT 0,
  `scope` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `permissions_entity_index` (`entity_id`,`entity_type`,`scope`),
  KEY `permissions_ability_id_index` (`ability_id`),
  KEY `permissions_scope_index` (`scope`),
  CONSTRAINT `permissions_ability_id_foreign` FOREIGN KEY (`ability_id`) REFERENCES `abilities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.questionnaire_participants
DROP TABLE IF EXISTS `questionnaire_participants`;
CREATE TABLE IF NOT EXISTS `questionnaire_participants` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_template_id` int(10) unsigned NOT NULL DEFAULT 0,
  `field_values` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.roles
DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int(10) unsigned DEFAULT NULL,
  `scope` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_unique` (`name`,`scope`),
  KEY `roles_scope_index` (`scope`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.system
DROP TABLE IF EXISTS `system`;
CREATE TABLE IF NOT EXISTS `system` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(50) NOT NULL DEFAULT '',
  `value` varchar(50) NOT NULL DEFAULT '',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.template_keys
DROP TABLE IF EXISTS `template_keys`;
CREATE TABLE IF NOT EXISTS `template_keys` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(50) NOT NULL DEFAULT '',
  `category` varchar(50) NOT NULL DEFAULT '',
  `field_path` varchar(191) NOT NULL DEFAULT '',
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `order` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.temp_leaflets
DROP TABLE IF EXISTS `temp_leaflets`;
CREATE TABLE IF NOT EXISTS `temp_leaflets` (
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `key` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `code_configs` text DEFAULT NULL,
  `template` text DEFAULT NULL,
  `template_path` varchar(10) DEFAULT NULL,
  `params` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.temp_question_forms
DROP TABLE IF EXISTS `temp_question_forms`;
CREATE TABLE IF NOT EXISTS `temp_question_forms` (
  `user_id` int(11) NOT NULL,
  `form_key` varchar(50) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `form_configs` text DEFAULT NULL,
  PRIMARY KEY (`user_id`,`form_key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.temp_upload_files
DROP TABLE IF EXISTS `temp_upload_files`;
CREATE TABLE IF NOT EXISTS `temp_upload_files` (
  `user_id` int(11) NOT NULL DEFAULT 0,
  `key` varchar(50) NOT NULL DEFAULT '',
  `filename` varchar(50) NOT NULL DEFAULT '',
  `voucher_id` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `is_verified` tinyint(1) unsigned DEFAULT 0,
  `confirmation_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.user_verifications
DROP TABLE IF EXISTS `user_verifications`;
CREATE TABLE IF NOT EXISTS `user_verifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `token` varchar(191) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK__users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.vouchers
DROP TABLE IF EXISTS `vouchers`;
CREATE TABLE IF NOT EXISTS `vouchers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `description` varchar(255) DEFAULT '',
  `notes` varchar(255) DEFAULT '',
  `agent_id` int(10) unsigned NOT NULL DEFAULT 0,
  `agent_smtp_server_id` int(10) unsigned NOT NULL DEFAULT 0,
  `activation_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `template` mediumtext DEFAULT NULL,
  `voucher_type` enum('form','voucher') DEFAULT 'voucher',
  `template_path` varchar(10) DEFAULT NULL,
  `has_template` tinyint(1) DEFAULT 0,
  `has_custom_link` tinyint(4) DEFAULT 0,
  `custom_link_key` varchar(50) DEFAULT NULL,
  `entrance_page_type` enum('questionnaire','custom','none') DEFAULT NULL,
  `entrance_page_id` int(10) unsigned DEFAULT 0,
  `entrance_page_type_after_quota` varchar(50) DEFAULT '',
  `entrance_page_id_after_quota` int(10) unsigned DEFAULT 0,
  `questionnaire` mediumtext DEFAULT NULL,
  `questionnaire_fields` text DEFAULT NULL,
  `questionnaire_configs` text DEFAULT NULL,
  `participant_configs` mediumtext DEFAULT NULL,
  `goal_type` enum('fixed','codes','none') DEFAULT 'fixed',
  `goal_count` int(10) unsigned DEFAULT 0,
  `action_type_before_goal` enum('form_voucher','form_custom','custom') DEFAULT 'form_voucher',
  `custom_form_key_before_goal` varchar(50) DEFAULT '',
  `action_type_after_goal` enum('form_custom','custom','none') DEFAULT 'custom',
  `custom_form_key_after_goal` varchar(50) DEFAULT '',
  `code_fields` text DEFAULT NULL,
  `code_count` int(11) DEFAULT 0,
  `participant_count` int(11) unsigned DEFAULT 0,
  `qr_code_composition` varchar(255) DEFAULT NULL,
  `qr_code_size` int(10) unsigned DEFAULT 160,
  `sharing_image_id` int(10) unsigned DEFAULT 0,
  `sharing_title` varchar(191) DEFAULT '',
  `sharing_description` varchar(191) DEFAULT '',
  `form_sharing_image_id` int(10) unsigned DEFAULT 0,
  `form_sharing_title` varchar(191) DEFAULT '',
  `form_sharing_description` varchar(191) DEFAULT '',
  `status` enum('preparing','pending','ready_to_send','sending','completed') DEFAULT 'pending',
  `script` mediumtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2044 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.voucher_codes
DROP TABLE IF EXISTS `voucher_codes`;
CREATE TABLE IF NOT EXISTS `voucher_codes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` int(10) unsigned NOT NULL,
  `order` int(10) unsigned NOT NULL DEFAULT 0,
  `code` varchar(255) NOT NULL DEFAULT '0',
  `extra_fields` text NOT NULL,
  `key` varchar(100) NOT NULL DEFAULT '',
  `sent_on` date DEFAULT NULL,
  `status` enum('pending','ready','completed') DEFAULT 'pending',
  `participant_id` int(10) unsigned DEFAULT 0,
  `remark` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35578 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.voucher_code_configs
DROP TABLE IF EXISTS `voucher_code_configs`;
CREATE TABLE IF NOT EXISTS `voucher_code_configs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` int(10) unsigned NOT NULL DEFAULT 0,
  `composition` varchar(191) DEFAULT NULL,
  `code_group` enum('qrcode','barcode') NOT NULL DEFAULT 'qrcode',
  `code_type` varchar(50) NOT NULL DEFAULT '',
  `code_color` varchar(20) NOT NULL DEFAULT '',
  `width` int(10) unsigned NOT NULL DEFAULT 0,
  `height` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4079 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.voucher_custom_forms
DROP TABLE IF EXISTS `voucher_custom_forms`;
CREATE TABLE IF NOT EXISTS `voucher_custom_forms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` int(10) unsigned NOT NULL DEFAULT 0,
  `form_key` varchar(50) NOT NULL DEFAULT '0',
  `name` varchar(191) NOT NULL DEFAULT '',
  `type` enum('questionnaire','general') DEFAULT 'questionnaire',
  `form_configs` mediumtext DEFAULT NULL,
  `questionnaire_fields` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.voucher_emails
DROP TABLE IF EXISTS `voucher_emails`;
CREATE TABLE IF NOT EXISTS `voucher_emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` int(10) unsigned NOT NULL DEFAULT 0,
  `voucher_code_id` int(10) unsigned NOT NULL DEFAULT 0,
  `email` varchar(191) NOT NULL DEFAULT '',
  `sent_at` timestamp NULL DEFAULT NULL,
  `status` enum('pending','sent') DEFAULT NULL,
  `remark` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.voucher_medias
DROP TABLE IF EXISTS `voucher_medias`;
CREATE TABLE IF NOT EXISTS `voucher_medias` (
  `voucher_id` int(10) unsigned NOT NULL DEFAULT 0,
  `media_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`voucher_id`,`media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.voucher_participants
DROP TABLE IF EXISTS `voucher_participants`;
CREATE TABLE IF NOT EXISTS `voucher_participants` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(200) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `form_content` text DEFAULT NULL,
  `form_content_medium_text` mediumtext DEFAULT NULL,
  `participant_key` varchar(50) DEFAULT NULL,
  `remark` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table coupon_yoov_com.voucher_templates
DROP TABLE IF EXISTS `voucher_templates`;
CREATE TABLE IF NOT EXISTS `voucher_templates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(191) NOT NULL DEFAULT '',
  `type` enum('questionnaire','general') DEFAULT 'questionnaire',
  `content` mediumtext DEFAULT NULL,
  `questionnaire_fields` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
