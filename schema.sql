/*
Updated from https://github.com/chroman/df-gtfs/blob/master/schema.sql
*/

DROP SCHEMA IF EXISTS gtfs CASCADE;
CREATE SCHEMA gtfs;

DROP DOMAIN IF EXISTS wgs84_lat CASCADE;
CREATE DOMAIN wgs84_lat AS DOUBLE PRECISION CHECK(VALUE >= -90 AND VALUE <= 90);

DROP DOMAIN IF EXISTS wgs84_lon CASCADE;
CREATE DOMAIN wgs84_lon AS DOUBLE PRECISION CHECK(VALUE >= -180 AND VALUE <= 180);

DROP DOMAIN IF EXISTS gtfstime CASCADE;
CREATE DOMAIN gtfstime AS text CHECK(VALUE ~ '^[0-9]?[0-9]:[0-5][0-9]:[0-5][0-9]$');

CREATE TABLE gtfs.agency
(
  agency_id         text UNIQUE NULL,
  agency_name       text NOT NULL,
  agency_url        text NOT NULL,
  agency_timezone   text NOT NULL,
  agency_lang       text NULL,
  agency_phone      text NULL,
  agency_fare_url   text NULL
);

CREATE TABLE gtfs.calendar
(
  service_id        text PRIMARY KEY,
  monday            boolean NOT NULL,
  tuesday           boolean NOT NULL,
  wednesday         boolean NOT NULL,
  thursday          boolean NOT NULL,
  friday            boolean NOT NULL,
  saturday          boolean NOT NULL,
  sunday            boolean NOT NULL,
  start_date        numeric(8) NOT NULL,
  end_date          numeric(8) NOT NULL
);

CREATE TABLE gtfs.calendar_dates
(
  service_id        text PRIMARY KEY,
  date              numeric(8) NOT NULL,
  exception_type    integer NOT NULL
);

CREATE TABLE gtfs.fare_attributes
(
  fare_id text PRIMARY KEY,
  price numeric NOT NULL,
  currency_type text NOT NULL,
  payment_method integer NOT NULL,
  transfers integer NULL,
  transfer_duration integer NULL
);

CREATE TABLE gtfs.fare_rules
(
  fare_id text PRIMARY KEY,
  route_id text NULL,
  origin_id text NULL,
  destination_id text NULL,
  contains_id text NULL
);

CREATE TABLE gtfs.feed_info
(
  feed_publisher_name text NULL,
  feed_publisher_url text NULL,
  feed_lang text NULL,
  feed_start_date numeric(8) NULL,
  feed_version text NULL
);

CREATE TABLE gtfs.frequencies
(
  trip_id text NOT NULL,
  start_time text NOT NULL,
  end_time text NOT NULL,
  headway_secs text NOT NULL,
  exact_times integer NULL
);

CREATE TABLE gtfs.routes
(
  route_id          text PRIMARY KEY,
  agency_id         text NULL,
  route_short_name  text NOT NULL,
  route_long_name   text NOT NULL,
  route_desc        text NULL,
  route_type        integer NOT NULL,
  route_url         text NULL,
  route_color       text NULL,
  route_text_color  text NULL
);

CREATE TABLE gtfs.stops
(
  stop_id           text PRIMARY KEY,
  stop_code         text UNIQUE NULL,
  stop_name         text NOT NULL,
  stop_desc         text NULL,
  stop_lat          wgs84_lat NOT NULL,
  stop_lon          wgs84_lon NOT NULL,
  zone_id           text NULL,
  stop_url          text NULL,
  location_type     integer NULL,
  parent_station    integer NULL,
  stop_timezone     text NULL,
  wheelchair_boarding text NULL
);

CREATE TABLE gtfs.shapes
(
  shape_id          text,
  shape_pt_lat      wgs84_lat NOT NULL,
  shape_pt_lon      wgs84_lon NOT NULL,
  shape_pt_sequence integer NOT NULL,
  shape_dist_traveled double precision NULL
);

CREATE TABLE gtfs.transfers
(
  from_stop_id text NOT NULL,
  to_stop_id text NOT NULL,
  transfer_type integer NOT NULL,
  min_transfer_time integer NULL
);

CREATE TABLE gtfs.trips
(
  route_id          text NOT NULL,
  service_id        text NOT NULL,
  trip_id           text NOT NULL PRIMARY KEY,
  trip_headsign     text NULL,
  trip_short_name   text NULL,
  direction_id      boolean NULL,
  block_id          text NULL,
  shape_id          text NULL,
  wheelchair_accessible integer NULL,
  bikes_allowed     integer NULL
);

CREATE TABLE gtfs.stop_times
(
  trip_id           text NOT NULL,
  arrival_time      interval NOT NULL,
  departure_time    interval NOT NULL,
  stop_id           text NOT NULL,
  stop_sequence     integer NOT NULL,
  stop_headsign     text NULL,
  pickup_type       integer NULL,
  drop_off_type     integer NULL,
  shape_dist_traveled double precision NULL,
  timepoint         integer NULL
);

\copy gtfs.agency from './dart-transit/agency.txt' csv header;
\copy gtfs.stops from './dart-transit/stops.txt' csv header;
\copy gtfs.routes from './dart-transit/routes.txt' csv header;
\copy gtfs.trips from './dart-transit/trips.txt' csv header;
\copy gtfs.stop_times from './dart-transit/stop_times.txt' csv header;
\copy gtfs.calendar from './dart-transit/calendar.txt' csv header;
\copy gtfs.calendar_dates from './dart-transit/calendar_dates.txt' csv header;
\copy gtfs.fare_attributes from './dart-transit/fare_attributes.txt' csv header;
\copy gtfs.fare_rules from './dart-transit/fare_rules.txt' csv header;
\copy gtfs.shapes from './dart-transit/shapes.txt' csv header;
\copy gtfs.frequencies from './dart-transit/frequencies.txt' csv header;
\copy gtfs.transfers from './dart-transit/transfers.txt' csv header;
\copy gtfs.feed_info from './dart-transit/feed_info.txt' csv HEADER;