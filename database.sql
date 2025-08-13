-- SQL Database Schema for MySQL (Optional)
-- Run this in your MySQL database if you want persistent data storage

CREATE DATABASE IF NOT EXISTS `retail_jobs`;
USE `retail_jobs`;

-- Player job data table
CREATE TABLE IF NOT EXISTS `retail_jobs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `job` varchar(50) DEFAULT 'unemployed',
    `rank` int(11) DEFAULT 1,
    `experience` int(11) DEFAULT 0,
    `earnings` int(11) DEFAULT 0,
    `stats` longtext DEFAULT '{}',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Store performance data
CREATE TABLE IF NOT EXISTS `store_performance` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `store_id` int(11) NOT NULL,
    `date` date NOT NULL,
    `revenue` int(11) DEFAULT 0,
    `customers_served` int(11) DEFAULT 0,
    `items_sold` int(11) DEFAULT 0,
    `employee_count` int(11) DEFAULT 0,
    `satisfaction_rating` decimal(3,2) DEFAULT 0.00,
    PRIMARY KEY (`id`),
    UNIQUE KEY `store_date` (`store_id`, `date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Training progress tracking
CREATE TABLE IF NOT EXISTS `training_progress` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `module_name` varchar(100) NOT NULL,
    `progress` int(11) DEFAULT 0,
    `completed` tinyint(1) DEFAULT 0,
    `completion_date` timestamp NULL DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `identifier_module` (`identifier`, `module_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Employee schedules
CREATE TABLE IF NOT EXISTS `employee_schedules` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `store_id` int(11) NOT NULL,
    `day_of_week` int(11) NOT NULL, -- 0 = Sunday, 6 = Saturday
    `start_time` time NOT NULL,
    `end_time` time NOT NULL,
    `is_active` tinyint(1) DEFAULT 1,
    PRIMARY KEY (`id`),
    KEY `identifier` (`identifier`),
    KEY `store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Payroll tracking
CREATE TABLE IF NOT EXISTS `payroll` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `store_id` int(11) NOT NULL,
    `hours_worked` decimal(5,2) DEFAULT 0.00,
    `base_pay` int(11) DEFAULT 0,
    `commission` int(11) DEFAULT 0,
    `bonuses` int(11) DEFAULT 0,
    `total_pay` int(11) DEFAULT 0,
    `pay_period_start` date NOT NULL,
    `pay_period_end` date NOT NULL,
    `paid_at` timestamp NULL DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `identifier` (`identifier`),
    KEY `pay_period` (`pay_period_start`, `pay_period_end`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Customer feedback and complaints
CREATE TABLE IF NOT EXISTS `customer_feedback` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `store_id` int(11) NOT NULL,
    `employee_identifier` varchar(50) DEFAULT NULL,
    `feedback_type` enum('complaint', 'compliment', 'suggestion') NOT NULL,
    `rating` int(11) DEFAULT NULL, -- 1-5 stars
    `comment` text DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `store_id` (`store_id`),
    KEY `employee_identifier` (`employee_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Store inventory tracking
CREATE TABLE IF NOT EXISTS `store_inventory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `store_id` int(11) NOT NULL,
    `product_name` varchar(100) NOT NULL,
    `stock_level` int(11) DEFAULT 0,
    `price` decimal(10,2) DEFAULT 0.00,
    `cost` decimal(10,2) DEFAULT 0.00,
    `min_stock` int(11) DEFAULT 5,
    `max_stock` int(11) DEFAULT 100,
    `last_restock` timestamp NULL DEFAULT NULL,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `store_product` (`store_id`, `product_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Achievement system
CREATE TABLE IF NOT EXISTS `employee_achievements` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `achievement_name` varchar(100) NOT NULL,
    `achievement_description` text DEFAULT NULL,
    `earned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `reward_amount` int(11) DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default achievements
INSERT IGNORE INTO `employee_achievements` (`identifier`, `achievement_name`, `achievement_description`, `reward_amount`) VALUES
('system', 'First Sale', 'Complete your first customer transaction', 50),
('system', 'Customer Service Star', 'Serve 100 customers with high satisfaction', 500),
('system', 'Sales Champion', 'Achieve highest sales in a single day', 1000),
('system', 'Team Player', 'Help train 5 new employees', 750),
('system', 'Perfect Month', 'Work a full month with perfect attendance', 2000),
('system', 'Inventory Master', 'Successfully manage inventory for 30 days', 800),
('system', 'Leadership Excellence', 'Get promoted to management level', 1500),
('system', 'Customer Whisperer', 'Resolve 50 customer complaints successfully', 600);

-- Create indexes for better performance
CREATE INDEX `idx_retail_jobs_job` ON `retail_jobs` (`job`);
CREATE INDEX `idx_retail_jobs_rank` ON `retail_jobs` (`rank`);
CREATE INDEX `idx_store_performance_date` ON `store_performance` (`date`);
CREATE INDEX `idx_training_progress_completed` ON `training_progress` (`completed`);
CREATE INDEX `idx_payroll_dates` ON `payroll` (`pay_period_start`, `pay_period_end`);
CREATE INDEX `idx_customer_feedback_type` ON `customer_feedback` (`feedback_type`);
CREATE INDEX `idx_inventory_stock` ON `store_inventory` (`stock_level`);

-- Sample data for testing (optional)
INSERT IGNORE INTO `store_inventory` (`store_id`, `product_name`, `stock_level`, `price`, `cost`, `min_stock`, `max_stock`) VALUES
(1, 'Sandwich', 30, 5.00, 2.50, 5, 50),
(1, 'Water', 80, 2.00, 0.50, 10, 100),
(1, 'Energy Drink', 25, 8.00, 4.00, 5, 30),
(1, 'Cigarettes', 15, 15.00, 10.00, 3, 20),
(2, 'Sandwich', 20, 6.00, 3.00, 5, 30),
(2, 'Water', 60, 3.00, 0.75, 10, 80),
(2, 'Snacks', 35, 4.00, 2.00, 8, 40),
(3, 'Burger', 25, 12.00, 6.00, 8, 40),
(3, 'Fries', 40, 6.00, 2.00, 10, 60),
(3, 'Soda', 65, 4.00, 1.50, 15, 80),
(3, 'Milkshake', 20, 8.00, 3.50, 5, 30),
(4, 'Chicken Burger', 20, 14.00, 7.00, 5, 35),
(4, 'Wings', 30, 10.00, 4.50, 8, 45),
(4, 'Soda', 50, 4.00, 1.50, 10, 70);