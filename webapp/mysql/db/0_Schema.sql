DROP DATABASE IF EXISTS isuumo;
CREATE DATABASE isuumo;

DROP TABLE IF EXISTS isuumo.estate;
DROP TABLE IF EXISTS isuumo.chair;

CREATE TABLE isuumo.estate
(
    id          INTEGER             NOT NULL PRIMARY KEY,
    name        VARCHAR(64)         NOT NULL,
    description VARCHAR(4096)       NOT NULL,
    thumbnail   VARCHAR(128)        NOT NULL,
    address     VARCHAR(128)        NOT NULL,
    latitude    DOUBLE PRECISION    NOT NULL,
    longitude   DOUBLE PRECISION    NOT NULL,
    rent        INTEGER             NOT NULL,
    door_height INTEGER             NOT NULL,
    door_width  INTEGER             NOT NULL,
    features    VARCHAR(64)         NOT NULL,
    popularity  INTEGER             NOT NULL,
    rent_id INTEGER INVISIBLE GENERATED ALWAYS AS(rent_id = CASE WHEN rent < 50000 THEN 0 WHEN rent < 100000 THEN 1 WHEN rent < 150000 THEN 2 ELSE 3 END),
    door_height_id INTEGER INVISIBLE GENERATED ALWAYS AS(door_height_id = CASE WHEN door_height < 80 THEN 0 WHEN door_height < 110 THEN 1 WHEN door_height < 150 THEN 2 ELSE 3 END),
    door_width_id INTEGER INVISIBLE GENERATED ALWAYS AS(door_width_id = CASE WHEN door_width < 80 THEN 0 WHEN door_width < 110 THEN 1 WHEN door_width < 150 THEN 2 ELSE 3 END)
);


CREATE TABLE isuumo.chair
(
    id          INTEGER         NOT NULL PRIMARY KEY,
    name        VARCHAR(64)     NOT NULL,
    description VARCHAR(4096)   NOT NULL,
    thumbnail   VARCHAR(128)    NOT NULL,
    price       INTEGER         NOT NULL,
    height      INTEGER         NOT NULL,
    width       INTEGER         NOT NULL,
    depth       INTEGER         NOT NULL,
    color       VARCHAR(64)     NOT NULL,
    features    VARCHAR(64)     NOT NULL,
    kind        VARCHAR(64)     NOT NULL,
    popularity  INTEGER         NOT NULL,
    stock       INTEGER         NOT NULL
);


CREATE INDEX idx_chair_price_id ON isuumo.chair (price,id);
CREATE INDEX idx_chair_stock_price_id ON isuumo.chair (stock, price, id);

CREATE INDEX idx_estate_popularity_id_asc ON isuumo.estate(popularity DESC,id ASC);
CREATE INDEX idx_estate_rent_id ON isuumo.estate(rent,id);
CREATE INDEX idx_latitude_longitude ON isuumo.estate (latitude, longitude);
CREATE INDEX idx_door_width_door_height ON isuumo.estate(door_width, door_height);
CREATE INDEX idx_door_height_id_rent_id ON isuumo.estate (door_height_id, rent_id),
CREATE INDEX idx_door_height_id_rent_id ON  isuumo.estate (door_width_id, rent_id),