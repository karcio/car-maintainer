-- mysql
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

-- postgres
DROP DATABASE carmanagerdb;
CREATE DATABASE carmanagerdb;

CREATE USER dbuser1;
ALTER USER dbuser1 WITH ENCRYPTED PASSWORD 'pa88w0rd';
GRANT ALL PRIVILEGES ON DATABASE carmanagerdb TO dbuser1;
ALTER USER dbuser1 WITH SUPERUSER;
ALTER DATABASE carmanagerdb OWNER TO dbuser1;

\c carmanagerdb;

CREATE TABLE fuel(
    fuelid SERIAL PRIMARY KEY,
    fueltype VARCHAR(10) NOT NULL
);

INSERT INTO fuel (fueltype) VALUES ('Petrol');
INSERT INTO fuel (fueltype) VALUES ('Diesel');

CREATE TABLE cars(
    carid SERIAL PRIMARY KEY,
    brand VARCHAR(10) NOT NULL,
    typename VARCHAR(10) NOT NULL,
    engine INT NOT NULL,
    year INT NOT NULL,
    carowner VARCHAR(10) NOT NULL,
    fuelid INT NOT NULL,
    CONSTRAINT fk_fuelid 
        FOREIGN KEY(fuelid) 
        REFERENCES fuel(fuelid)
);

INSERT INTO cars (brand, typename, engine, year, carowner, fuelid) VALUES('Ford', 'Fiesta', 1200, 2011, 'Karol', 1);

CREATE TABLE fuel_log(
    fuellogid SERIAL PRIMARY KEY,
    carid INT NOT NULL,
    fuel NUMERIC(4, 2) NOT NULL,
    odometer NUMERIC(4, 2) NOT NULL,
    petrolcost NUMERIC(3, 2) NOT NULL,
    currentdate DATE NOT NULL
); 

CREATE TABLE maintanance(
    maintananceid SERIAL PRIMARY KEY,
    fix VARCHAR(20) NOT NULL,
    wash VARCHAR(20) NOT NULL,
    shop VARCHAR(20) NOT NULL,
    replacement VARCHAR(20) NOT NULL
);

CREATE TABLE maintanance_log(
    maintlogid SERIAL PRIMARY KEY,
    maintananceid INT NOT NULL,
    carid INT NOT NULL,
    issue VARCHAR(20) NOT NULL,
    issue_cost NUMERIC(6, 2) NOT NULL,
    currentdate DATE NOT NULL,
    notes TEXT NULL,
    CONSTRAINT fk_maintananceid 
        FOREIGN KEY(maintananceid) 
        REFERENCES maintanance(maintananceid)
);

CREATE TABLE consumption_cost(
    concostid SERIAL PRIMARY KEY,
    carid INT NOT NULL,
    consumption NUMERIC(3, 1) NOT NULL,
    cost NUMERIC(6, 2) NOT NULL,
    currentdate DATE NOT NULL,
    CONSTRAINT fk_carid 
        FOREIGN KEY(carid) 
        REFERENCES fuel_log(carid)
);

-- ERROR:  there is no unique constraint matching given keys for referenced table "fuel_log"

CREATE TABLE maintenance_cost(
    maincostid SERIAL PRIMARY KEY,
    carid INT NOT NULL,
    issue VARCHAR(20) NOT NULL,
    cost NUMERIC(6, 2) NOT NULL,
    currentdate DATE NOT NULL,
    CONSTRAINT fk_carid
        FOREIGN KEY(carid) 
        REFERENCES maintanance_log(carid)
);

-- ERROR:  there is no unique constraint matching given keys for referenced table "maintanance_log"