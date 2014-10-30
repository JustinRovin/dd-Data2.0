USE tester;

CREATE TABLE IF NOT EXISTS Person (
   pid    INTEGER AUTO_INCREMENT,
   last   VARCHAR(50) NOT NULL,
   first  VARCHAR(50) NOT NULL,
   -- description VARCHAR(1000), deprecated, moved ot legislator profile

   PRIMARY KEY (pid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

-- we can probably remove this table and roll into a "role" field in Person
-- alternatively, make it a (pid, jobhistory) and put term for the hearing in here
CREATE TABLE IF NOT EXISTS Legislator (
   pid         INTEGER AUTO_INCREMENT,
   description VARCHAR(1000),
   
   PRIMARY KEY (pid),
   FOREIGN KEY (pid) REFERENCES Person(pid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

-- we can probably remove this table and roll into a "role" field in Person
-- alternatively, we can make it (pid, jobhistory) and put client information here

-- CREATE TABLE IF NOT EXISTS Lobbyist (
--   pid    INTEGER,

--   PRIMARY KEY (pid),
--   FOREIGN KEY (pid) REFERENCES Person(pid)
-- )

-- ENGINE = INNODB
-- CHARACTER SET utf8 COLLATE utf8_general_ci;

-- only Legislators have Terms
CREATE TABLE IF NOT EXISTS Term (
   pid      INTEGER,
   year     YEAR,
   district INTEGER(3),
   house    ENUM('Assembly', 'Senate') NOT NULL,
   party    ENUM('Republican', 'Democrat', 'Other') NOT NULL,
   start    DATE,
   end      DATE,
   
   PRIMARY KEY (pid, year, district, house),
   FOREIGN KEY (pid) REFERENCES Legislator(pid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS Committee (
   cid    INTEGER(3),
   house  ENUM('Assembly', 'Senate') NOT NULL,
   name   VARCHAR(200) NOT NULL,

   PRIMARY KEY (cid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS servesOn (
   pid      INTEGER,
   year     YEAR,
   district INTEGER(3),
   house    ENUM('Assembly', 'Senate') NOT NULL,
   cid      INTEGER(3),

   PRIMARY KEY (pid, year, district, house, cid),
   FOREIGN KEY (pid, year, district, house) REFERENCES Term(pid, year, district, house),
   FOREIGN KEY (cid) REFERENCES Committee(cid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS Bill (
   bid     VARCHAR(20),
   type    VARCHAR(3) NOT NULL,
   number  INTEGER NOT NULL,
   state   ENUM('Chaptered', 'Introduced', 'Amended Assembly', 'Amended Senate', 'Enrolled',
      'Proposed', 'Amended', 'Vetoed') NOT NULL,
   status  VARCHAR(60),
   house   ENUM('Assembly', 'Senate', 'Secretary of State', 'Governor', 'Legislature'),
   session INTEGER(1),

   PRIMARY KEY (bid),
   INDEX name (type, number)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS Hearing (
   hid    INTEGER AUTO_INCREMENT,
   date   DATE,
   cid    INTEGER(3),

   PRIMARY KEY (hid),
   UNIQUE KEY (cid, date),
   FOREIGN KEY (cid) REFERENCES Committee(cid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS JobSnapshot (
   pid   INTEGER,
   hid   INTEGER,
   role  ENUM('Lobbyist', 'General_public', 'Legislative_staff_commitee', 'Legislative_staff_author', 'State_agency_rep', 'Unknown'),
   employer VARCHAR(50), -- employer: lobbyist: lobying firm, union, corporation. SAR: name of Agency/Department. GP: teacher/etc.
   client   VARCHAR(50), -- client: only for lobbyist

   PRIMARY KEY (pid, hid),
   FOREIGN KEY (pid) REFERENCES Person(pid),
   FOREIGN KEY (hid) REFERENCES Hearing(hid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS Action (
   bid    VARCHAR(20),
   date   DATE,
   text   TEXT,

   FOREIGN KEY (bid) REFERENCES Bill(bid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS Video (
   vid INTEGER AUTO_INCREMENT,
   youtubeId VARCHAR(20),
   hid INTEGER,
   position INTEGER,
   startOffset INTEGER,
   duration INTEGER,

   PRIMARY KEY (vid),
   FOREIGN KEY (hid) REFERENCES Hearing(hid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS Video_ttml (
   vid INTEGER,
   ttml TEXT,

   FOREIGN KEY (vid) REFERENCES Video(vid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS BillDiscussion (
   did         INTEGER AUTO_INCREMENT,
   bid         VARCHAR(20),
   hid         INTEGER,
   startVideo  INTEGER,
   startTime   INTEGER,
   endVideo    INTEGER,
   endTime     INTEGER,
   numVideos   INTEGER(4),

   PRIMARY KEY (did),
   UNIQUE KEY (bid, startVideo),
   FOREIGN KEY (bid) REFERENCES Bill(bid),
   FOREIGN KEY (hid) REFERENCES Hearing(hid),
   FOREIGN KEY (startVideo) REFERENCES Video(vid),
   FOREIGN KEY (endVideo) REFERENCES Video(vid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS Motion (
   mid    INTEGER(20),
   bid    VARCHAR(20),
   date   DATE,
   text   TEXT,

   PRIMARY KEY (mid, bid, date),
   FOREIGN KEY (bid) REFERENCES Bill(bid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS votesOn (
   pid    INTEGER,
   mid    INTEGER(20),
   vote   ENUM('Yea', 'Nay', 'Abstain') NOT NULL,

   PRIMARY KEY (pid, mid),
   FOREIGN KEY (pid) REFERENCES Legislator(pid),
   FOREIGN KEY (mid) REFERENCES Motion(mid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS BillVersion (
   vid                 VARCHAR(30),
   bid                 VARCHAR(20),
   date                DATE,
   state               ENUM('Chaptered', 'Introduced', 'Amended Assembly', 'Amended Senate',
                            'Enrolled', 'Proposed', 'Amended', 'Vetoed') NOT NULL,
   subject             TEXT,
   appropriation       BOOLEAN,
   substantive_changes BOOLEAN,
   title               TEXT,
   digest              MEDIUMTEXT,
   text                MEDIUMTEXT,

   PRIMARY KEY (vid),
   FOREIGN KEY (bid) REFERENCES Bill(bid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS authors (
   pid          INTEGER,
   bid          VARCHAR(20),
   vid          VARCHAR(30),
   contribution ENUM('Lead Author', 'Principal Coauthor', 'Coauthor') DEFAULT 'Coauthor',

   PRIMARY KEY (pid, bid, vid),
   FOREIGN KEY (pid) REFERENCES Legislator(pid),
   FOREIGN KEY (bid, vid) REFERENCES BillVersion(bid, vid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS attends (
   pid    INTEGER,
   hid    INTEGER,

   PRIMARY KEY (pid, hid),
   FOREIGN KEY (pid) REFERENCES Legislator(pid),
   FOREIGN KEY (hid) REFERENCES Hearing(hid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS Utterance (
   uid    INTEGER AUTO_INCREMENT,
   vid    INTEGER,
   pid    INTEGER,
   time   INTEGER,
   endTime INTEGER,
   text   TEXT,
   current BOOLEAN NOT NULL,
   finalized BOOLEAN NOT NULL,
   type   ENUM('Author', 'Testimony', 'Discussion'),
   alignment ENUM('For', 'Against', 'For_if_amend', 'Against_unless_amend', 'Neutral', 'Indeterminate'),

   PRIMARY KEY (uid, current),
   UNIQUE KEY (vid, pid, current, time),
   FOREIGN KEY (pid) REFERENCES Person(pid),
   FOREIGN KEY (vid) REFERENCES Video(vid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE OR REPLACE VIEW currentUtterance AS SELECT uid, vid, pid, time, endTime, text, type, alignment FROM Utterance WHERE current = TRUE AND finalized = TRUE ORDER BY time DESC;

-- tag is a keyword. For example, "education", "war on drugs"
-- can also include abbreviations for locations such as "Cal Poly" for "Cal Poly SLO"
CREATE TABLE IF NOT EXISTS tag (
   tid INTEGER AUTO_INCREMENT,
   tag VARCHAR(50),

   PRIMARY KEY (tid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

-- join table for Uterrance >>> Tag
CREATE TABLE IF NOT EXISTS join_utrtag (
   uid INTEGER,
   tid INTEGER,

   PRIMARY KEY (uid, tid),
   FOREIGN KEY (tid) REFERENCES tag(tid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

-- an utterance might contain an honorific or a pronoun where it is unclear who the actual person is
-- this is a "mention" and should be joined against when searching for a specific person 
CREATE TABLE IF NOT EXISTS Mention (
   uid INTEGER,
   pid INTEGER,

   PRIMARY KEY (uid, pid),
   FOREIGN KEY (pid) REFERENCES Person(pid),
   FOREIGN KEY (uid) REFERENCES Utterance(uid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;


-- Transcription Tool Tables
CREATE TABLE IF NOT EXISTS TT_Editor (
   id INTEGER AUTO_INCREMENT , 
   username VARCHAR(50) NOT NULL , 
   password VARCHAR(255) NOT NULL , 
   created TIMESTAMP NOT NULL , 
   active BOOLEAN NOT NULL , 
   role VARCHAR(15) NOT NULL , 
   
   PRIMARY KEY (id),
   UNIQUE KEY (username)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS TT_Task (
   tid INTEGER AUTO_INCREMENT ,
   did INTEGER , 
   editor_id INTEGER ,
   name VARCHAR(255) NOT NULL , 
   vid INTEGER , 
   startTime INTEGER NOT NULL , 
   endTime INTEGER NOT NULL , 
   created DATE,
   assigned DATE, 
   completed DATE,
   
   PRIMARY KEY (tid) ,
   FOREIGN KEY (did) REFERENCES BillDiscussion(did),
   FOREIGN KEY (editor_id) REFERENCES TT_Editor(id),
   FOREIGN KEY (vid) REFERENCES Video(vid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS TT_TaskCompletion (
   tcid INTEGER AUTO_INCREMENT , 
   tid INTEGER , 
   completion DATE , 
   
   PRIMARY KEY (tcid),
   FOREIGN KEY (tid) REFERENCES TT_Task(tid)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS user (
   email VARCHAR(255) NOT NULL,
   name VARCHAR(255),
   password VARCHAR(255) NOT NULL,
   new_user INTEGER,

   PRIMARY KEY (email)
)
ENGINE = INNODB
CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS LobbyingFirm(
   filer_naml VARCHAR(200),
   filer_id VARCHAR(9)  PRIMARY KEY,  -- modified  (PK)
   rpt_date DATE,
   ls_beg_yr INTEGER,    -- modified (INT)
   ls_end_yr INTEGER     -- modified (INT)
);

--  ALTER TABLE !!!!!
CREATE TABLE Lobbyist(
   pid INTEGER REFERENCES Person(pid)   -- added
   -- FILER_NAML VARCHAR(50),              -- modified, needs to be same as Person.last
   -- FILER_NAMF VARCHAR(50),              -- modified, needs to be same as Person.first  
   filer_id VARCHAR(9)  UNIQUE,         -- modified   
   PRIMARY KEY (pid)                    -- added
);

CREATE TABLE LobbyistEmployer(
   filer_naml VARCHAR(200),
   filer_id VARCHAR(9) PRIMARY KEY,  -- modified (PK)
   coalition TINYINT(1)
);

CREATE TABLE LobbyistEmployment(
   pid INT  REFERENCES  Lobbyist(pid),                         -- modified (FK)
   sender_id VARCHAR(9) REFERENCES LobbyingFirm(filer_id), -- modified (FK)
   rpt_date DATE,
   ls_beg_yr INTEGER,    -- modified (INT)
   ls_end_yr INTEGER     -- modified (INT)
   PRIMARY KEY (pid, sender_id, rpt_date, ls_end_yr) -- modified (May 21) 
);

-- NEW TABLE: Lobbyist Employed Directly by Lobbyist Employers 
-- Structure same as LOBBYIST_EMPLOYED_BY_LOBBYING_FIRM, 
-- but the SENDER_ID is a Foreign Key onto LOBBYIST_EMPLOYER

CREATE TABLE LobbyistDirectEmployment(
   pid INT  REFERENCES  Lobbyist(pid),                         
   sender_id VARCHAR(9) REFERENCES LobbyistEmployer(filer_id),
   rpt_date DATE,
   ls_beg_yr INTEGER,    -- modified (INT)
   ls_end_yr INTEGER     -- modified (INT)
   PRIMARY KEY (pid, sender_id, rpt_date, ls_end_yr) -- modified (May 21) 
);

-- end new table


CREATE TABLE LobbyingContracts(
   filer_id VARCHAR(9) REFERENCES LobbyingFirm(filer_id),     -- modified (FK)
   sender_id VARCHAR(9) REFERENCES LobbyistEmployer(filer_id), -- modified (FK)
   rpt_date DATE,
   ls_beg_yr INTEGER,    -- modified (INT)
   ls_end_yr INTEGER     -- modified (INT)
   PRIMARY KEY (filer_id sender_id, rpt_date) -- modified (May 21) 
);

CREATE TABLE LobbyistRepresentation(
   pid   INTEGER REFERENCES Lobbyist(pid),                  -- modified
   le_id VARCHAR(9) REFERENCES LobbyistEmployer(filer_id), -- modified (renamed)
   hearing_date DATE,                                       -- modified (renamed)
   hearing_id INTEGER REFERENCES Hearing(hid),              -- added
   PRIMARY KEY(filer_id, le_id, hearing_id)                 -- added
);

CREATE TABLE GeneralPublic(
   pid INTEGER REFERENCES Person(pid)   -- added
   employer VARCHAR(256),
   position VARCHAR(100),                

   PRIMARY KEY (pid)                    
);

CREATE TABLE LegislativeAuthorStaff(
   pid INTEGER REFERENCES Person(pid)   -- added
   legislator INTEGER REFERENCES Person(pid), -- this is the legislator 
   position VARCHAR(100),                

   PRIMARY KEY (pid)                    -- added
);

CREATE TABLE CommitteeStaff(
   pid INTEGER REFERENCES Person(pid)   -- added
   cid    INTEGER(3) REFERENCES Committee(cid),
   house  ENUM('Assembly', 'Senate') NOT NULL,            

   PRIMARY KEY (pid)                    -- added
);

CREATE TABLE Analyst(
   pid INTEGER REFERENCES Person(pid)   -- added            

   PRIMARY KEY (pid)                    -- added
);

CREATE TABLE StateAgencyRep(
   pid INTEGER REFERENCES Person(pid)   -- added
   employer VARCHAR(256),
   position VARCHAR(100),               

   PRIMARY KEY (pid)                    -- added
);
