-- --------------------------------------------
-- 04LVMUpdateTutorTableSproc
-- Date: MAR 24 2016
-- 
-- Creates sproc to insert data into the tutor table
-- --------------------------------------------

USE lvm;

DROP PROCEDURE IF EXISTS updateTutorTable;


DELIMITER //

CREATE PROCEDURE updateTutorTable(
  `person` int,
  `occupation` varchar(255),
  `orientation` date,
  `training` date,
  `trainingType`enum('ABE', 'ESOL'),
  `dateAdded` datetime,
  `dateModified` datetime,
  `isTestData` bit)

BEGIN

INSERT INTO Tutor(
	person,
	occupation,
    orientation,
    training,
    trainingType,
	dateAdded,
	dateModified,
    isTestData)
VALUES(
    `person`,
    `occupation`,
    `orientation`,
    `training`,
    `trainingType`,
    `dateAdded`,
    `dateModified`,
    `isTestData`);
    
END //