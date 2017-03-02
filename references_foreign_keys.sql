CREATE TABLE members (id serial PRIMARY KEY, surname varchar, first_name varchar, address varchar, zipcode int, telephone varchar, recommended_by int REFERENCES members(id), joindate timestamp);

CREATE TABLE facilities (id serial PRIMARY KEY, name varchar, member_cost numeric, guest_cost numeric, initial_out_lay numeric, monthly_maintenance numeric);

CREATE TABLE bookings (id serial PRIMARY KEY, facility_id int REFERENCES facilities(id), member_id int REFERENCES members(id), start_time timestamp, slots int);

-- Produce a list of start times for bookings by members named 'David Farrell'?

SELECT b.start_time FROM members m JOIN bookings b ON (m.id = b.member_id) WHERE m.first_name = 'David' AND m.surname = 'Farrell';

-- Produce a list of the start times for bookings for tennis courts, for the date '2016-09-21'? Return a list of start time and facility name pairings, ordered by the time.

SELECT
  b.start_time
FROM
  bookings b JOIN
  facilities f ON (b.facility_id = f.id)
WHERE
  f.name LIKE 'Tennis Court%'
  AND
  b.start_time BETWEEN '2012-09-21 00:00:00'::timestamp AND '2012-09-21 23:59:59'::timestamp
ORDER BY
  b.start_time;

SELECT
  b.start_time
FROM
  bookings b JOIN
  facilities f ON (b.facility_id = f.id)
WHERE
  f.name LIKE 'Tennis Court%'
  AND
  -- using to_char for filtering date
  to_char(b.start_time, 'YYYY-MM-DD') = '2012-09-21'
ORDER BY
  b.start_time;

SELECT b.start_time FROM bookings b JOIN facilities f ON (b.facility_id = f.id) WHERE f.name LIKE 'Tennis Court%' AND to_char(b.start_time, 'YYYY-MM-DD') = '2012-09-21' ORDER BY b.start_time;

-- Produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as first name, surname. Ensure no duplicate data, and order by the first name.
SELECT DISTINCT on (m.first_name, m.surname)
  m.first_name,
  m.surname,
  f.name
FROM
  members m JOIN bookings b ON (m.id = b.member_id)
  bookings b_1 JOIN facilities f ON (b_1.facility_id = f.id)
WHERE
  f.name LIKE 'Tennis Court%'
ORDER BY
  m.first_name,
  m.surname;

SELECT DISTINCT on (m.first_name, m.surname) m.first_name, m.surname, f.name FROM members m JOIN bookings b ON (m.id = b.member_id), bookings b_1 JOIN facilities f ON (b_1.facility_id = f.id) WHERE f.name LIKE 'Tennis Court%' ORDER BY m.first_name, m.surname;

-- Produce a number of how many times Nancy Dare has used the pool table facility?
WITH nancy_dare AS
  (SELECT
    facility_id,
    member_id,
    count(member_id) AS count
  FROM
    bookings
  WHERE
    member_id = 7
    AND
    facility_id = 8
  GROUP BY facility_id, member_id)

SELECT
  m.first_name,
  m.surname,
  nancy_dare
FROM
  nancy_dare JOIN members m ON (nancy_dare.member_id = m.id);
-- GROUP BY
--   m.first_name,
--   m.surname,
--   f.name;

WITH nancy_dare AS (SELECT facility_id, member_id, count(member_id) AS count FROM bookings WHERE member_id = 7 AND facility_id = 8 GROUP BY facility_id, member_id) SELECT m.first_name, m.surname, nancy_dare.count FROM nancy_dare JOIN members m ON (nancy_dare.member_id = m.id);

-- Produce a list of how many times Nancy Dare has visited each country club facility.

WITH nancy_dare AS
  (SELECT
    facility_id,
    member_id,
    f.name,
    count(member_id) AS count
  FROM
    bookings b JOIN facilities f ON (b.facility_id = f.id)
  WHERE
    member_id = 7
  GROUP BY facility_id, member_id)

SELECT
  m.first_name,
  m.surname,
  nd.name,
  nd.count,
FROM
  nancy_dare nd JOIN members m ON (nd.member_id = m.id);

WITH nancy_dare AS (SELECT facility_id, member_id, f.name, count(member_id) AS count FROM bookings b JOIN facilities f ON (b.facility_id = f.id) WHERE member_id = 7 GROUP BY facility_id, member_id, f.name) SELECT m.first_name, m.surname, nd.count, nd.name FROM nancy_dare nd JOIN members m ON (nd.member_id = m.id);


(SELECT
  (first_name || ' ' ||  surname) AS fullname,
  recommended by
FROM
  members)
