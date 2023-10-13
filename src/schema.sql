DROP TABLE IF EXISTS users ;
DROP TABLE IF EXISTS drivers ;
DROP TABLE IF EXISTS entrants ;
DROP TABLE IF EXISTS race ;
DROP TABLE IF EXISTS teams ;


CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname TEXT NOT NULL,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE drivers ( id integer primary key autoincrement, number integer, name text )  ;
insert into drivers (number, name) values (27, "Jake Dennis");
insert into drivers (number, name) values (17, "Norman Nato");



CREATE TABLE teams ( id integer primary key autoincrement, fullname text, shortname text, powertrain text) ;
insert into teams (fullname, shortname, powertrain) values ("Andretti Global", "Andretti", "Porsche");

CREATE TABLE entrants ( 
    id integer primary key autoincrement,
    driver integer not null, 
    team integer not null, 
    foreign key (driver) references drivers (id), 
    foreign key (team) references teams (id),
    unique (driver, team)
    );
-- I believe I could do this in a better way some thing to link the drivers and treams inserting via select.
insert into entrants (driver, team) values (1, 1) ;
insert into entrants (driver, team) values (2, 1) ;

CREATE TABLE races (id integer primary key autoincrement, name text, country text, circuit text, date text) ;
insert into races (name, country, circuit, date) values ('Mexico city e-prix', 'Mexico', 'Autódromo Hermanos Rodríguez',  '2024-01-13');

CREATE TABLE predictions (
    user integer not null,
    race integer not null,
    pole integer not null,
    foreign key (user) references users(id),
    foreign key (race) references races(id),
    foreign key (pole) references entrants(id),
    primary key (user, race)
    );
