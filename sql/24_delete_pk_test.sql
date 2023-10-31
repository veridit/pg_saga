INSERT INTO houses VALUES 
  (1, 150000, tstzrange('2015-01-01', '2016-01-01')),
  (1, 200000, tstzrange('2016-01-01', '2017-01-01')),
  (2, 300000, tstzrange('2015-01-01', '2016-01-01')),
  (3, 100000, tstzrange('2014-01-01', '2015-01-01')),
  (3, 200000, tstzrange('2015-01-01', null))
;



-- ON DELETE RESTRICT
SELECT create_temporal_foreign_key('room_has_a_house', 'rooms', 'house_id', 'valid_at', 'houses', 'id', 'valid_at');

-- You can delete a pk with no references
DELETE FROM houses WHERE id = 2;

-- You can delete a finite pk range with no references
INSERT INTO rooms VALUES (1, 1, tstzrange('2016-06-01', '2017-01-01'));
DELETE FROM houses WHERE id = 1 and valid_at @> '2015-06-01'::timestamptz;
INSERT INTO houses VALUES (1, 200000, tstzrange('2015-01-01', '2016-01-01'));
DELETE FROM rooms;

-- You can't delete a finite pk range that is partly covered
INSERT INTO rooms VALUES (1, 1, tstzrange('2016-01-01', '2016-06-01'));
DELETE FROM houses WHERE id = 1 and valid_at @> '2016-06-01'::timestamptz;
DELETE FROM rooms;

-- You can't delete a finite pk range that is exactly covered
INSERT INTO rooms VALUES (1, 1, tstzrange('2016-01-01', '2017-01-01'));
DELETE FROM houses WHERE id = 1 and valid_at @> '2016-06-01'::timestamptz;
DELETE FROM rooms;

-- You can't delete a finite pk range that is more than covered
INSERT INTO rooms VALUES (1, 1, tstzrange('2015-06-01', '2017-01-01'));
DELETE FROM houses WHERE id = 1 and valid_at @> '2016-06-01'::timestamptz;
DELETE FROM rooms;

-- You can delete an infinite pk range with no references
INSERT INTO rooms VALUES (1, 3, tstzrange('2014-06-01', '2015-01-01'));
DELETE FROM houses WHERE id = 3 and valid_at @> '2016-01-01'::timestamptz;
INSERT INTO houses VALUES (3, 200000, tstzrange('2015-01-01', null));
DELETE FROM rooms;

-- You can't delete an infinite pk range that is partly covered
INSERT INTO rooms VALUES (1, 3, tstzrange('2016-01-01', '2017-01-01'));
DELETE FROM houses WHERE id = 3 and valid_at @> '2016-01-01'::timestamptz;
DELETE FROM rooms;

-- You can't delete an infinite pk range that is exactly covered
INSERT INTO rooms VALUES (1, 3, tstzrange('2015-01-01', null));
DELETE FROM houses WHERE id = 3 and valid_at @> '2016-01-01'::timestamptz;
DELETE FROM rooms;

-- You can't delete an infinite pk range that is more than covered
INSERT INTO rooms VALUES (1, 3, tstzrange('2014-06-01', null));
DELETE FROM houses WHERE id = 3 and valid_at @> '2016-01-01'::timestamptz;
DELETE FROM rooms;

-- ON DELETE NOACTION
-- (same behavior as RESTRICT, but different entry function so it should have separate tests)
-- TODO: Write some tests against normal FKs just to see NOACTION vs RESTRICT

-- ON DELETE CASCADE
-- TODO

-- ON DELETE SET NULL
-- TODO

-- ON DELETE SET DEFAULT
-- TODO

DELETE FROM rooms;
DELETE FROM houses;
SELECT drop_temporal_foreign_key('room_has_a_house', 'rooms', 'houses');
