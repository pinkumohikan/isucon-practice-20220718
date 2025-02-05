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
    popularity  INTEGER             NOT NULL
);
alter table isuumo.estate add column estate_point point as (POINT(latitude,longitude)) stored NOT NULL;
CREATE SPATIAL INDEX idx_estate_point ON isuumo.estate (estate_point);

CREATE INDEX idx_estate_popularity_id ON isuumo.estate(popularity DESC,id);
CREATE INDEX idx_estate_rent_id ON isuumo.estate(rent,id);
CREATE INDEX idx_latitude_longitude ON isuumo.estate (latitude, longitude);
CREATE INDEX idx_door_width_door_height ON isuumo.estate( door_width, door_height);


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