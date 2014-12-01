
CREATE TABLE :Player
(
  player_id SMALLINT NOT NULL AUTO_INCREMENT,
  pdga varchar(10),
  sex ENUM('male', 'female'),
  lastname VARCHAR(100),
  firstname VARCHAR(100),
  birthdate DATE,
  email VARCHAR(150),
  PRIMARY KEY(player_id),
  INDEX(pdga)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :User
(
  id INT NOT  NULL AUTO_INCREMENT,
  Username VARCHAR(40),
  UserEmail VARCHAR(100),
  Password VARCHAR(40),
  Role ENUM('admin', 'player') NOT NULL DEFAULT 'player',
  UserFirstName VARCHAR(40) NOT NULL,
  UserLastName VARCHAR(40) NOT NULL,
  Player SMALLINT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (Player) REFERENCES :Player(player_id),
  UNIQUE(Username),
  INDEX (Username, Password)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :Venue
(
  id INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(40) NOT NULL,
  PRIMARY KEY(id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :Level
(
  id INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(40) NOT NULL,
  ScoreCalculationMethod VARCHAR(40) NOT NULL,
  Available TINYINT NOT NULL,
  PRIMARY KEY(id),
  INDEX(Available)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :Tournament
(
  id INT NOT NULL AUTO_INCREMENT,
  Level INT NOT NULL,
  Name VARCHAR(40) NOT NULL,
  Year INT NOT NULL,
  Description TEXT NOT NULL,
  ScoreCalculationMethod VARCHAR(40) NOT NULL,
  Available TINYINT NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (Level) REFERENCES :Level(id),
  INDEX(Year),
  INDEX(Available)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :File
(
  id INT NOT NULL AUTO_INCREMENT,
  Filename VARCHAR(60) NOT NULL,
  Type VARCHAR(10) NOT NULL,
  DisplayName VARCHAR(60) NOT NULL,
  PRIMARY KEY(id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE IF NOT EXISTS `:AdBanner` (
  id INT(11) NOT NULL auto_increment,
  URL VARCHAR(200) NULL,
  ImageURL VARCHAR(200)  NULL,
  LongData TEXT,
  ImageReference INT(11) default NULL,
  Type VARCHAR(20) NOT NULL,
  Event INT(11) default NULL,
  ContentId VARCHAR(30)  NOT NULL,
  FOREIGN KEY (`ImageReference`) REFERENCES :File(id),
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :Event
(
  id INT NOT NULL AUTO_INCREMENT,
  Venue INT,
  Tournament INT,
  Level INT,
  Name VARCHAR(80) NOT NULL,
  Date DATETIME NOT NULL,
  Duration TINYINT NOT NULL,
  ActivationDate DATETIME,
  SignupStart DATETIME,
  SignupEnd DATETIME,
  ResultsLocked DATETIME NULL,
  ContactInfo VARCHAR(250) NOT NULL,
  FeesRequired TINYINT NOT NULL,
  AdBanner INT NULL,
  -- added 2014.02.15
  PlayerLimit INT NOT NULL DEFAULT 0,
  -- by Tumi
  PRIMARY KEY(id),
  FOREIGN KEY (Venue) REFERENCES :Venue(id),
  FOREIGN KEY (Level) REFERENCES :Level(id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :EventManagement
(
  id INT NOT NULL AUTO_INCREMENT,
  User INT NOT NULL,
  Event INT NOT NULL,
  Role VARCHAR(10) NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (User) REFERENCES :User(id),
  FOREIGN KEY (Event) REFERENCES :Event(id),
  INDEX (User, Event, Role)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :TextContent
(
  id INT NOT NULL AUTO_INCREMENT,
  Event INT NULL,
  Title VARCHAR(40) NOT NULL,
  Content TEXT NOT NULL,
  Date DATETIME NOT NULL,
  Type VARCHAR(14) NOT NULL,
  `Order` SMALLINT,
  PRIMARY KEY(id),
  FOREIGN KEY (Event) REFERENCES :Event(id),
  INDEX (Event, Title),
  INDEX (Event, Type)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :Classification
(
  id INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(40) NOT NULL,
  MinimumAge INT,
  MaximumAge INT,
  GenderRequirement CHAR(1),
  Available TINYINT NOT NULL,
  PRIMARY KEY(id),
  INDEX(Available)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :Course
(
  id INT NOT NULL AUTO_INCREMENT,
  Venue INT NULL,
  Name VARCHAR(40) NOT NULL,
  Description TEXT NOT NULL,
  Link VARCHAR(120) NOT NULL,
  Map VARCHAR(60) NOT NULL,
  Event INT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (Venue) REFERENCES :Venue(id),
  FOREIGN KEY (Event) REFERENCES :Event(id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE `:Round`
(
  id INT NOT NULL AUTO_INCREMENT,
  Event INT NOT NULL,
  Course INT NULL,
  StartType VARCHAR(12) NOT NULL,
  StartTime DATETIME NOT NULL,
  `Interval` TINYINT,
  ValidResults TINYINT(1) NOT NULL,
  GroupsFinished DATETIME NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (Event) REFERENCES :Event(id),
  FOREIGN KEY (Course) REFERENCES :Course(id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :Section (
  id INT NOT NULL AUTO_INCREMENT,
  Name VARCHAR(40) NOT NULL,
  Classification INT NULL,
  Round INT NOT NULL,
  Priority SMALLINT NULL,
  StartTime DATETIME NULL,
  Present TINYINT NOT NULL DEFAULT '1',
  PRIMARY KEY(id),
  FOREIGN KEY (Classification) REFERENCES :Classification(id),
  FOREIGN KEY (Round) REFERENCES `:Round`(id)
) ENGINE=InnoDB;


CREATE TABLE :Hole
(
  id INT NOT NULL AUTO_INCREMENT,
  Course INT NOT NULL,
  HoleNumber TINYINT NOT NULL,
  -- added 2014.10.05
  HoleText VARCHAR(4),
  -- by Tumi
  Par TINYINT NOT NULL,
  Length SMALLINT NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (Course) REFERENCES :Course(id),
  INDEX(Course, HoleNumber)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :Participation
(
  id INT NOT NULL AUTO_INCREMENT,
  Player SMALLINT NOT NULL,
  Event INT NOT NULL,
  Classification INT NOT NULL,
  Approved TINYINT NOT NULL,
  EventFeePaid DATETIME,
  OverallResult SMALLINT,
  Standing SMALLINT,
  DidNotFinish TINYINT NOT NULL,
  SignupTimestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  TournamentPoints INT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (Player) REFERENCES :Player(player_id),
  FOREIGN KEY (Event) REFERENCES :Event(id),
  FOREIGN KEY (Classification) REFERENCES :Classification(id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :RoundResult
(
  id INT NOT NULL AUTO_INCREMENT,
  `Round` INT NOT NULL,
  Player SMALLINT NOT NULL,
  Result SMALLINT NOT NULL,
  Penalty TINYINT NOT NULL,
  SuddenDeath TINYINT,
  Completed TINYINT DEFAULT '99',
  DidNotFinish TINYINT DEFAULT '0',
  PlusMinus MEDIUMINT NOT NULL,
  LastUpdated DATETIME NOT NULL,
  CumulativePlusminus INT DEFAULT '0',
  CumulativeTotal INT DEFAULT '0',
  PRIMARY KEY(id),
  FOREIGN KEY (`Round`) REFERENCES `:Round`(id),
  FOREIGN KEY (Player) REFERENCES :Player(player_id),
  INDEX(`Round`, LastUpdated)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :HoleResult
(
  id INT NOT NULL AUTO_INCREMENT,
  Hole INT NOT NULL,
  RoundResult INT NOT NULL,
  Player SMALLINT NOT NULL,
  Result TINYINT NOT NULL,
  DidNotShow TINYINT(1) NOT NULL,
  LastUpdated DATETIME NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (Hole) REFERENCES :Hole(id),
  FOREIGN KEY (RoundResult) REFERENCES :RoundResult(id),
  FOREIGN KEY (Player) REFERENCES :Player(player_id),
  INDEX(RoundResult, LastUpdated)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :StartingOrder
(
  id INT NOT NULL AUTO_INCREMENT,
  Player SMALLINT NOT NULL,
  `Section` INT NOT NULL,
  StartingTime DATETIME NOT NULL,
  StartingHole TINYINT,
  -- Changed from PoolNumber to GroupNumber 2014.10.05
  GroupNumber SMALLINT NOT NULL,
  -- by Tumi
  PRIMARY KEY(id),
  FOREIGN KEY (Player) REFERENCES :Player(player_id),
  FOREIGN KEY (`Section`) REFERENCES `:Section`(id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :SectionMembership
(
  id INT NOT NULL AUTO_INCREMENT,
  Participation INT NOT NULL,
  Section INT NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (Participation) REFERENCES :Participation(id),
  FOREIGN KEY (Section) REFERENCES :Section(id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :TournamentStanding
(
  id INT NOT NULL AUTO_INCREMENT,
  Player SMALLINT NOT NULL,
  Tournament INT NOT NULL,
  OverallScore SMALLINT NOT NULL,
  Standing SMALLINT,
  TieBreaker SMALLINT NOT NULL DEFAULT '0',
  PRIMARY KEY(id),
  FOREIGN KEY (Player) REFERENCES :Player(player_id),
  FOREIGN KEY (Tournament) REFERENCES :Tournament(id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :ClassInEvent
(
  id INT NOT NULL AUTO_INCREMENT,
  Classification INT NOT NULL,
  Event INT NOT NULL,
  -- added 2014.02.15
  MinQuota INT NOT NULL DEFAULT 0,
  MaxQuota INT NOT NULL DEFAULT 999,
  -- by Tumi
  PRIMARY KEY(id),
  FOREIGN KEY (Classification) REFERENCES :Classification(id),
  FOREIGN KEY (Event) REFERENCES :Event(id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :LicensePayment
(
  id INT NOT NULL AUTO_INCREMENT,
  Player SMALLINT NOT NULL,
  Year INT NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (Player) REFERENCES :Player(player_id)
) ENGINE=InnoDB;
SHOW WARNINGS;


CREATE TABLE :MembershipPayment
(
  id INT NOT NULL AUTO_INCREMENT,
  Player SMALLINT NOT NULL,
  Year INT NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (Player) REFERENCES :Player(player_id)
) ENGINE=InnoDB;
SHOW WARNINGS;


-- added 2012.02.15
-- if using previous version, add this to your database!
CREATE TABLE :EventQueue (
  id INT NOT NULL AUTO_INCREMENT,
  Event INT NOT NULL,
  Player SMALLINT NOT NULL,
  Classification INT NOT NULL,
  SignupTimestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (Event) REFERENCES :Event(id),
  FOREIGN KEY (Player) REFERENCES :Player(player_id),
  FOREIGN KEY (Classification) REFERENCES :Classification(id),
  INDEX(Event)
) ENGINE=InnoDB;
SHOW WARNINGS;
-- end 2012.02.15 migration

