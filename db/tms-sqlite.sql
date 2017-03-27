PRAGMA synchronous = OFF;
PRAGMA journal_mode = MEMORY;
BEGIN TRANSACTION;
CREATE TABLE "aliases" (
  "id" INTEGER PRIMARY KEY NOT NULL ,
  "domain_id" int(10) NOT NULL,
  "local_part" varchar(250) NOT NULL,
  "goto" varchar(250) NOT NULL,
  "description" varchar(250) DEFAULT NULL,
  "active" tinyint(1) NOT NULL DEFAULT '0',
  "created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "modified" timestamp NULL DEFAULT NULL
);
CREATE TABLE "domains" (
  "id" INTEGER PRIMARY KEY  NOT NULL ,
  "fqdn" varchar(250) NOT NULL,
  "type" text  NOT NULL DEFAULT 'local',
  "description" varchar(250) DEFAULT NULL,
  "active" tinyint(1) NOT NULL DEFAULT '0',
  "created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "modified" timestamp NULL DEFAULT NULL
);
CREATE TABLE "mailboxes" (
  "id" INTEGER PRIMARY KEY  NOT NULL ,
  "domain_id" int(10) NOT NULL,
  "local_part" varchar(250) NOT NULL,
  "password" varchar(100) DEFAULT NULL,
  "description" varchar(250) DEFAULT NULL,
  "active" tinyint(1) NOT NULL DEFAULT '0',
  "created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "modified" timestamp NULL DEFAULT NULL
);
CREATE TABLE "vacations" (
  "id" INTEGER PRIMARY KEY  NOT NULL ,
  "mailbox_id" int(10) NOT NULL,
  "subject" varchar(250) NOT NULL,
  "body" text NOT NULL,
  "description" varchar(250) DEFAULT NULL,
  "active" tinyint(1) NOT NULL DEFAULT '0',
  "created" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "modified" timestamp NULL DEFAULT NULL
);
END TRANSACTION;
