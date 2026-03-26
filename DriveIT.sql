
/*
DriveIT - Databassystem för körskola
Slutprojekt i Databaser
*/

CREATE DATABASE korskola_bokning;

USE korskola_bokning;

-- Skapar Elever tabellen
CREATE TABLE Elever (
    ElevID INT AUTO_INCREMENT PRIMARY KEY,
    Namn VARCHAR(100) NOT NULL,
    Telefon VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);

-- Skapar Instruktorer tabellen
CREATE TABLE Instruktorer (
    InstruktorID INT AUTO_INCREMENT PRIMARY KEY,
    Namn VARCHAR(100) NOT NULL,
    Kompetens VARCHAR(30),
    CHECK (Kompetens IN ('Manuell','Automat','Handledarekurs','Riskettan'))
);

-- Skapar Lektioner tabellen
CREATE TABLE Lektioner (
    LektionID INT AUTO_INCREMENT PRIMARY KEY,
    Typ VARCHAR(100) NOT NULL,
    Pris DECIMAL(10,2) NOT NULL,
    Langdminuter INT NOT NULL,
    CHECK (Pris > 0),
    CHECK (Langdminuter > 0)
);

-- Skapar Bokningar tabellen
CREATE TABLE Bokningar (
    BokningID INT AUTO_INCREMENT PRIMARY KEY,
    ElevID INT NOT NULL,
    InstruktorID INT NOT NULL,
    LektionID INT NOT NULL,
    DatumTid DATETIME NOT NULL,
    Status VARCHAR(20) DEFAULT 'Bokad',
    CHECK (Status IN ('Bokad','Avbokad','Genomförd')),
    CHECK (TIME(DatumTid) BETWEEN '07:00:00' AND '18:00:00'),

    FOREIGN KEY (ElevID) REFERENCES Elever(ElevID),
    FOREIGN KEY (InstruktorID) REFERENCES Instruktorer(InstruktorID),
    FOREIGN KEY (LektionID) REFERENCES Lektioner(LektionID)
);

SELECT * FROM Bokningar;

-- Skapar Loggtabellen för när en ny lektion bokas
CREATE TABLE Bokningslogg (
    LoggID INT AUTO_INCREMENT PRIMARY KEY,
    Meddelande VARCHAR(255),
    SkapadTid TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Denna trigger körs automatiskt efter att en ny bokning har lagts till i tabellen Bokningar
-- Syftet är att registrera att en ny körlektion har bokats, så att systemet kan spåra händelser i databasen
DELIMITER $$

CREATE TRIGGER efter_bokning
AFTER INSERT ON Bokningar
FOR EACH ROW
BEGIN
INSERT INTO Bokningslogg (Meddelande)
VALUES ('En ny lektion bokades');
END $$

DELIMITER ;

-- Skapar en trigger som förhindrar dubbelbokningar
DELIMITER $$

CREATE TRIGGER kontroll_dubbelbokning
BEFORE INSERT ON Bokningar
FOR EACH ROW
BEGIN
	IF EXISTS (
		SELECT 1
		FROM Bokningar
		WHERE InstruktorID = NEW.InstruktorID
		AND DatumTid = NEW.DatumTID
	) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Instruktören är redan bokad, vänligen välj en ny tid!';
	END IF;
END $$

DELIMITER ;

-- Testar och kollar under tiden som vi bygger
SHOW TABLES;
DESCRIBE Elever;
DESCRIBE Bokningar;
DESCRIBE Instruktorer;
DESCRIBE Lektioner;
DESCRIBE Bokningslogg;

-- Infogar data i Elever tabellen
INSERT INTO Elever (Namn, Telefon, Email)
VALUES
('Thomas Hansson','0701765467','thomas@email.com'),
('Lis Johanberg','0701239876','lis@email.com'),
('Tina Person','0701234567','tina@email.com'),
('Elsa Peterson','0787234567','elsa@email.com'),
('Sara Lind','0709876543','sara@email.com');

SELECT * FROM Elever;

-- Infogar data i Instrukorer tabellen
INSERT INTO Instruktorer (Namn, Kompetens)
VALUES
('Anna Svensson','Manuell'),
('Gabriel Johansson','Manuell'),
('Maria Larsson','Handledarekurs'),
('Alice Åberg','Riskettan'),
('Johan Karlsson','Automat');

SELECT * FROM Instruktorer;

-- Infogar data i Lektioner tabellen
INSERT INTO Lektioner (Typ, Pris, Langdminuter)
VALUES
('Körlektion 40 min',500,40),
('Körlektion 60 min',700,60),
('Handledarekurs',400,120),
('Riskettan',800,180);

SELECT * FROM Lektioner;

-- Infogar data i Bokningar tabellen
INSERT INTO Bokningar (ElevID, InstruktorID, LektionID, DatumTid)
VALUES
(1, 1, 1,'2026-04-10 10:00:00'),
(1, 4, 4,'2026-04-11 12:00:00'),
(4, 5, 2, '2026-04-12 09:00:00'),
(4, 5, 2, '2026-04-14 08:00:00'),
(2, 3, 3, '2026-04-13 14:30:00')
;

SELECT * FROM Bokningar;

-- Hämtar Bokningsloggen för att kontrollera att triggern fungerar
SELECT * FROM Bokningslogg;

-- Uppdatera status för Bokningar
UPDATE Bokningar 
SET STATUS = 'Avbokad' -- elev kontaktar oss för avbokning
WHERE BokningID = 3;

-- Denna SQL-fråga hämtar information om alla bokningar i systemet
-- AS används för att ge tydliga namn på kolumnerna, till exempel ElevNamn och InstruktorNamn
SELECT 
    Bokningar.BokningID,
    Elever.Namn AS ElevNamn,
    Instruktorer.Namn AS InstruktorNamn,
    Lektioner.Typ AS Lektion,
    Bokningar.DatumTid,
    Bokningar.Status
FROM Bokningar
JOIN Elever ON Bokningar.ElevID = Elever.ElevID
JOIN Instruktorer ON Bokningar.InstruktorID = Instruktorer.InstruktorID
JOIN Lektioner ON Bokningar.LektionID = Lektioner.LektionID
ORDER BY Bokningar.BokningID;

-- Hur många bokningar varje instruktör har
SELECT Instruktorer.Namn, COUNT(*) AS AntalBokningar
FROM Bokningar
JOIN Instruktorer 
ON Bokningar.InstruktorID = Instruktorer.InstruktorID
GROUP BY Instruktorer.InstruktorID, Instruktorer.Namn;

-- Stored Procedure 
DELIMITER $$

CREATE PROCEDURE BokningarPerElev(IN Elev_ID INT)
BEGIN
SELECT Elever.Namn, COUNT(*) AS AntalBokningar
FROM Bokningar
JOIN Elever ON Bokningar.ElevID = Elever.ElevID
WHERE Elever.ElevID = Elev_ID OR Elev_ID IS NULL
GROUP BY Elever.Namn;
END $$

DELIMITER ;

-- Test av stored procedure
CALL BokningarPerElev(1);
CALL BokningarPerElev(NULL);

-- Index för bättre prestanda
CREATE INDEX idx_datum
ON Bokningar(DatumTid);

SHOW INDEX FROM Bokningar;

-- Säkerhet / behörigheter

-- Skapar en adminanvändare som kan logga in i databasen
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin123'; 
GRANT ALL PRIVILEGES ON korskola_bokning.* TO 'admin'@'localhost'; -- vi ger alla rättigheter till admin

-- Skapa en användare med begränsade rättigheter
CREATE USER 'driveit'@'localhost' IDENTIFIED BY 'drive123'; 
GRANT SELECT ON korskola_bokning.* TO 'driveit'@'localhost'; -- ger användaren läsrättigheter till databasen

-- Uppdatera rättigheter
FLUSH PRIVILEGES;

-- Visar användare och rättigheter 
SELECT USER, HOST FROM MYSQL.User;
SHOW GRANTS FOR 'admin'@'localhost';
SHOW GRANTS FOR 'driveit'@'localhost';

-- Ge tillfälligt fler rättigheter
GRANT INSERT, UPDATE, DELETE 
ON korskola_bokning.* 
TO 'driveit'@'localhost';

SHOW GRANTS FOR 'driveit'@'localhost';

-- Ta bort tillfälliga rättigheter
REVOKE INSERT, UPDATE, DELETE 
ON korskola_bokning.* 
FROM 'driveit'@'localhost';

SHOW GRANTS FOR 'driveit'@'localhost';
