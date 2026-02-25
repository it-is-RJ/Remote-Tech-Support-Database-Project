DROP DATABASE IF EXISTS Remote_Tech_Support_Service;
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE;

-- -----------------------------------------------------
-- Schema Remote_Tech_Support_Service
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Remote_Tech_Support_Service
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Remote_Tech_Support_Service` DEFAULT CHARACTER SET utf8 ;
USE `Remote_Tech_Support_Service` ;

-- -----------------------------------------------------
-- Table `Remote_Tech_Support_Service`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Remote_Tech_Support_Service`.`Customer` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(50) NOT NULL,
  `LastName` VARCHAR(50) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `Phone` VARCHAR(20) NOT NULL,
  `Address` VARCHAR(225) NOT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Remote_Tech_Support_Service`.`Technician`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Remote_Tech_Support_Service`.`Technician` (
  `TechnicianID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(100) NOT NULL,
  `Specialization` VARCHAR(100) NOT NULL,
  `AvailabilityStatus` ENUM('Available', 'Busy', 'Offline') NOT NULL,
  PRIMARY KEY (`TechnicianID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Remote_Tech_Support_Service`.`Ticket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Remote_Tech_Support_Service`.`Ticket` (
  `TicketID` INT NOT NULL AUTO_INCREMENT,
  `Description` TEXT NOT NULL,
  `Status` ENUM('Open', 'In Progress', 'Resolved', 'Closed') NOT NULL,
  `Priority` ENUM('Low', 'Medium', 'High', 'Critical') NOT NULL,
  `Created_Date` DATETIME NOT NULL,
  `CustomerID` INT NOT NULL,
  `TechnicianID` INT NOT NULL,
  PRIMARY KEY (`TicketID`),
  INDEX `fk_ticket_customer_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `fk_ticket_technician_idx` (`TechnicianID` ASC) VISIBLE,
  CONSTRAINT `fk_ticket_customer`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `Remote_Tech_Support_Service`.`Customer` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ticket_technician`
    FOREIGN KEY (`TechnicianID`)
    REFERENCES `Remote_Tech_Support_Service`.`Technician` (`TechnicianID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Remote_Tech_Support_Service`.`Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Remote_Tech_Support_Service`.`Payment` (
  `PaymentID` INT NOT NULL AUTO_INCREMENT,
  `PaymentDate` DATETIME NOT NULL,
  `Amount` DECIMAL(10,2) NOT NULL,
  `PaymentMethod` ENUM('Card', 'PayPal', 'Bank Transfer') NOT NULL,
  `TicketID` INT NOT NULL,
  PRIMARY KEY (`PaymentID`),
  UNIQUE INDEX `TicketID_UNIQUE` (`TicketID` ASC) VISIBLE,
  CONSTRAINT `fk_payment_ticket`
    FOREIGN KEY (`TicketID`)
    REFERENCES `Remote_Tech_Support_Service`.`Ticket` (`TicketID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Remote_Tech_Support_Service`.`Feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Remote_Tech_Support_Service`.`Feedback` (
  `FeedbackID` INT NOT NULL AUTO_INCREMENT,
  `rating` INT NOT NULL,
  `comments` TEXT NOT NULL,
  `TicketID` INT NOT NULL,
  PRIMARY KEY (`FeedbackID`),
  INDEX `fk_feedback_ticket_idx` (`TicketID` ASC) VISIBLE,
  UNIQUE INDEX `TicketID_UNIQUE` (`TicketID` ASC) VISIBLE,
  CONSTRAINT `fk_feedback_ticket`
    FOREIGN KEY (`TicketID`)
    REFERENCES `Remote_Tech_Support_Service`.`Ticket` (`TicketID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;



-- Customers
INSERT INTO Customer (FirstName, LastName, Email, Phone, Address)
VALUES
('John', 'Doe', 'john.doe@example.com', '555-1234', '123 Main St'),
('Sarah', 'Lee', 'sarah.lee@example.com', '555-5678', '45 Park Ave'),
('Michael', 'Smith', 'michael.smith@example.com', '555-9012', '78 River Road'),
('Emily', 'Johnson', 'emily.johnson@example.com', '555-3456', '22 Oak Street'),
('David', 'Kim', 'david.kim@example.com', '555-7890', '90 Maple Ave'),
('Sophia', 'Brown', 'sophia.brown@example.com', '555-2468', '12 Pine Lane');

-- Technicians
INSERT INTO Technician (FirstName, Specialization, AvailabilityStatus)
VALUES
('Alex', 'Networking', 'Available'),
('Priya', 'Software', 'Busy'),
('David', 'Hardware', 'Offline'),
('Liam', 'Cybersecurity', 'Available'),
('Olivia', 'Database Systems', 'Busy'),
('Noah', 'Cloud Support', 'Available');

-- Tickets
INSERT INTO Ticket (Description, Status, Priority, Created_Date, CustomerID, TechnicianID)
VALUES
('Laptop not turning on', 'Open', 'High', NOW(), 1, 3),
('WiFi connection dropping frequently', 'In Progress', 'Medium', NOW(), 2, 1),
('Software installation error', 'Resolved', 'Low', NOW(), 3, 2),
('Blue screen error after update', 'Open', 'Critical', NOW(), 4, 4),
('Printer not connecting', 'In Progress', 'Medium', NOW(), 5, 5),
('Slow computer performance', 'Resolved', 'Low', NOW(), 6, 6);

-- Payments
INSERT INTO Payment (PaymentDate, Amount, PaymentMethod, TicketID)
VALUES
(NOW(), 89.99, 'Card', 1),
(NOW(), 49.99, 'PayPal', 2),
(NOW(), 29.99, 'Bank Transfer', 3),
(NOW(), 119.99, 'Card', 4),
(NOW(), 39.99, 'PayPal', 5),
(NOW(), 59.99, 'Card', 6);

-- Feedback
INSERT INTO Feedback (rating, comments, TicketID)
VALUES
(5, 'Great service, very helpful!', 1),
(4, 'Issue resolved quickly.', 2),
(3, 'Took longer than expected.', 3),
(5, 'Technician was very knowledgeable.', 4),
(2, 'Problem came back after a day.', 5),
(4, 'Good support, would recommend.', 6);
