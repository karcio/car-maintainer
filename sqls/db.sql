DROP DATABASE carmanagerdb;
CREATE DATABASE carmanagerdb;

CREATE TABLE `fuel`(
    `fuelid` INT NOT NULL AUTO_INCREMENT,
    `fueltype` VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    PRIMARY KEY(`fuelid`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3 COLLATE = utf8_unicode_ci;

CREATE TABLE `cars`(
    `carid` INT NOT NULL AUTO_INCREMENT,
    `brand` VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `type` VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `engine` INT NOT NULL,
    `year` INT NOT NULL,
    `owner` VARCHAR(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `fuelid` INT NOT NULL,
    PRIMARY KEY(`carid`),
    FOREIGN KEY(`fuelid`) REFERENCES fuel(`fuelid`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3 COLLATE = utf8_unicode_ci;

CREATE TABLE `fuel_log`(
    `fuellogid` INT NOT NULL AUTO_INCREMENT,
    `carid` INT NOT NULL,
    `fuel` FLOAT(4, 2) NOT NULL,
    `odometer` FLOAT(4, 2) NOT NULL,
    `petrolcost` FLOAT(3, 2) NOT NULL,
    `timestamp` DATE NOT NULL,
    PRIMARY KEY(`fuellogid`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3 COLLATE = utf8_unicode_ci; 

CREATE INDEX `idx_carid` ON
    `fuel_log`(carid);

CREATE TABLE `maintanance`(
    `maintananceid` INT NOT NULL AUTO_INCREMENT,
    `fix` VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `wash` VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `shop` VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `replacement` VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    PRIMARY KEY(`maintananceid`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3 COLLATE = utf8_unicode_ci;

CREATE TABLE `maintanance_log`(
    `maintlogid` INT NOT NULL AUTO_INCREMENT,
    `maintananceid` INT NOT NULL,
    `carid` INT NOT NULL,
    `issue` VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `issue_cost` FLOAT(6, 2) NOT NULL,
    `timestamp` DATE NOT NULL,
    `notes` TEXT NULL,
    PRIMARY KEY(`maintlogid`),
    FOREIGN KEY(`maintananceid`) REFERENCES maintanance(`maintananceid`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3 COLLATE = utf8_unicode_ci;

CREATE INDEX `idx_carid` ON
    `maintanance_log`(carid);

CREATE TABLE `consumption_cost`(
    `concostid` INT NOT NULL AUTO_INCREMENT,
    `carid` INT NOT NULL,
    `consumption` FLOAT(3, 1) NOT NULL,
    `cost` FLOAT(6, 2) NOT NULL,
    `timestamp` DATE NOT NULL,
    PRIMARY KEY(`concostid`),
    FOREIGN KEY(`carid`) REFERENCES fuel_log(`carid`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3 COLLATE = utf8_unicode_ci;

CREATE TABLE `maintenance_cost`(
    `maincostid` INT NOT NULL AUTO_INCREMENT,
    `carid` INT NOT NULL,
    `issue` VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
    `cost` FLOAT(6, 2) NOT NULL,
    `timestamp` DATE NOT NULL,
    PRIMARY KEY(`maincostid`),
    FOREIGN KEY(`carid`) REFERENCES maintanance_log(`carid`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3 COLLATE = utf8_unicode_ci;

INSERT INTO `fuel`(`fuelid`, `fueltype`)
VALUES(NULL, 'Petrol');

INSERT INTO `fuel`(`fuelid`, `fueltype`)
VALUES(NULL, 'Diesel');

INSERT INTO `cars`(
    `carid`,
    `brand`,
    `type`,
    `engine`,
    `year`,
    `owner`,
    `fuelid`
)
VALUES(
    NULL,
    'Ford',
    'Fiesta',
    '1200',
    '2011',
    'Karol',
    '1'
);