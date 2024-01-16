BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "child" (
    "id" serial PRIMARY KEY
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "parent" (
    "id" serial PRIMARY KEY,
    "childId" integer NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "child_id_unique_idx" ON "parent" USING btree ("childId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "parent"
    ADD CONSTRAINT "parent_fk_0"
    FOREIGN KEY("childId")
    REFERENCES "child"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20240116133305946', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240116133305946', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20231205080924753', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231205080924753', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20231205080920260', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231205080920260', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20231205080932899', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231205080932899', "timestamp" = now();


COMMIT;
