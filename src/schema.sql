DROP TABLE IF EXISTS users ;
DROP TABLE IF EXISTS drivers ;
DROP TABLE IF EXISTS formula_e_constructors ;
DROP TABLE IF EXISTS entrants ;
DROP TABLE IF EXISTS races ;
DROP TABLE IF EXISTS teams ;
DROP TABLE IF EXISTS seasons;
DROP TABLE IF EXISTS results ;
DROP TABLE IF EXISTS predictions ;
DROP TABLE IF EXISTS temp_drivers ;
DROP TABLE IF EXISTS temp_entries ;
DROP TABLE IF EXISTS temp_results ;




CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname TEXT NOT NULL,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    admin integer default 0    
);
insert into users (id, fullname, username, password, admin) values (1, 'Allan', 'allanderek', 'pdkdf2_sha256$Prologue$24400$OrNEbmqgkoK/6Oow6KFoMTXNUN0FD+9N3+uvxmpanYoMvSiEDWtbgpe1PvYxmF//a6Zs3fVE4ngq/InSYaGuCA==', 1);
insert into users (id, fullname, username, password, admin) values (2, 'Dan', 'dan', 'pdkdf2_sha256$Prologue$24400$8kdAzWvj4i78PF0TTiaouMsa/jPK08pk4TtL1xXJdjOUH1PEnKB6r0p1PQ18DyKWriZR13hbsuqm7A8J8mauiA==', 1);
insert into users (id, fullname, username, password, admin) values (3, 'Charlie', 'charlie', 'pdkdf2_sha256$Prologue$24400$Rw+otrxmI2uoEmrspm+0ftsK3h1Xu/6V9B4EHOioSLif4jepM+pxre3cavdVoVsXb6z74zENM//URTwis508BQ==', 1);
insert into users (id, fullname, username, password, admin) values (4, 'James', 'james', 'pdkdf2_sha256$Prologue$24400$dteSREtZlbugOwmed76fXUva70mFjKBzZ40HkLc3psZKcHP/8McibNqwXGtBw6BZMnuwNuJ/9mUUBP9LGCsI4w==', 1);

CREATE TABLE drivers ( 
    id integer primary key autoincrement, 
    name text 
);
insert into drivers (name) values ("Stoffel Vandoorne");
insert into drivers (name) values ("Jean-Éric Vergne");
insert into drivers (name) values ("Sérgio Sette Câmara");
insert into drivers (name) values ("Dan Ticktum");
insert into drivers (name) values ("Robin Frijns");
insert into drivers (name) values ("Kelvin van der Linde");
insert into drivers (name) values ("Nico Müller");
insert into drivers (name) values ("Jake Hughes");
insert into drivers (name) values ("René Rast");
insert into drivers (name) values ("Maximilian Günther");
insert into drivers (name) values ("Edoardo Mortara");
insert into drivers (name) values ("Oliver Rowland");
insert into drivers (name) values ("Roberto Merhi");
insert into drivers (name) values ("Lucas di Grassi");
insert into drivers (name) values ("Mitch Evans");
insert into drivers (name) values ("Sam Bird");
insert into drivers (name) values ("António Félix da Costa");
insert into drivers (name) values ("Pascal Wehrlein");
insert into drivers (name) values ("Sébastien Buemi");
insert into drivers (name) values ("Nick Cassidy");
insert into drivers (name) values ("Norman Nato");
insert into drivers (name) values ("Sacha Fenestraz");
insert into drivers (name) values ("Jake Dennis");
insert into drivers (name) values ("André Lotterer");
insert into drivers (name) values ("David Beckmann");


create table formula_e_constructors (
    id integer primary key autoincrement,
    name text
);

create table seasons (
    year text not null primary key
);

insert into seasons (year) values ("2022-23");
insert into seasons (year) values ("2023-24");

CREATE TABLE teams ( 
    id integer primary key autoincrement, 
    constructor text not null,
    season text not null,
    fullname text, 
    shortname text,
    color text,
    foreign key (season) references seasons (year),
    foreign key (constructor) references formula_e_constructors 
);

insert into formula_e_constructors (name) values
    ( "Penske" ),
    ( "NIO" ),
    ( "ABT" ),
    ( "McLaren"),
    ( "Maserati"),
    ( "Mahindra"),
    ( "Jaguar" ),
    ( "Porsche" ),
    ( "Envision" ),
    ( "Nissan" ),
    ( "Andretti" ),
    ( "ERT" )
    ;

with temp_teams (fullname, shortname, color, constructor, season) as (
    values
    -- 2022/23
    ("DS Penske", "Penske", "#cba65f", "Penske", "2022-23"),
    ("NIO 333 Racing", "NIO", "#3c3c3c", "NIO", "2022-23"),
    ("ABT CUPRA Formula E Team", "ABT Cupra", "#527c8d", "ABT", "2022-23"),
    ("NEOM McLaren Formula E Team", "McLaren", "#ff8000", "McLaren", "2022-23"),
    ("Maserati MSG Racing", "Maserati", "#001489", "Maserati", "2022-23"),
    ("Mahindra Racing", "Mahindra", "#dd052b", "Mahindra", "2022-23"),
    ("Jaguar TCS Racing", "Jaguar", "#000000", "Jaguar", "2022-23"),
    ("TAG Heuer Porsche Formula E Team", "Porsche", "#d5001c", "Porsche", "2022-23"),
    ("Envision Racing", "Envision", "#00be26", "Envision", "2022-23"),
    ("Nissan Formula E Team", "Nissan", "#c3002f", "Nissan", "2022-23"),
    ("Avalanche Andretti Formula E", "Andretti", "#ed3124", "Andretti", "2022-23"),

    -- 2023/24
    ("DS Penske", "Penske", "#cba65f", "Penske", "2023-24"),
    ("NIO 333 Racing", "NIO", "#3c3c3c", "NIO", "2023-24"),
    ("ABT CUPRA Formula E Team", "ABT Cupra", "#527c8d", "ABT", "2023-24"),
    ("NEOM McLaren Formula E Team", "McLaren", "#ff8000", "McLaren", "2023-24"),
    ("Maserati MSG Racing", "Maserati", "#001489", "Maserati", "2023-24"),
    ("Mahindra Racing", "Mahindra", "#dd052b", "Mahindra", "2023-24"),
    ("Jaguar TCS Racing", "Jaguar", "#000000", "Jaguar", "2023-24"),
    ("TAG Heuer Porsche Formula E Team", "Porsche", "#d5001c", "Porsche", "2023-24"),
    ("Envision Racing", "Envision", "#00be26", "Envision", "2023-24"),
    ("Nissan Formula E Team", "Nissan", "#c3002f", "Nissan", "2023-24"),
    ("Andretti Global", "Andretti", "#ed3124", "Andretti", "2023-24"),
    ("ERT Formula E Team", "ERT", "#3c3c3c", "ERT", "2023-24")
)
insert into teams (fullname, shortname, color, constructor, season)
    select temp_teams.fullname, temp_teams.shortname, temp_teams.color, formula_e_constructors.id, temp_teams.season
    from temp_teams
    inner join formula_e_constructors on temp_teams.constructor = formula_e_constructors.name
;

CREATE TABLE races (
    id integer primary key autoincrement, 
    round integer,
    name text, 
    country text, 
    circuit text, 
    date text,
    season text not null,
    cancelled integer default 0,
    foreign key (season) references seasons (year)
);


insert into races (round, name, country, circuit, date, season) 
    values 
    (1, "Hancook Mexico city e-prix", "Mexico", "Autódromo Hermanos Rodríguez", "2023-01-14T18:00:00Z", "2022-23"),
    (2, "Core Diriyah ePrix", "Saudi Arabia", "Riyadh Street Circuit", "2023-01-27T18:00:00Z", "2022-23"),
    (3, "Core Diriyah ePrix", "Saudi Arabia", "Riyadh Street Circuit", "2023-01-28T18:00:00Z", "2022-23"),
    (4, "Greenko Hyderabad ePrix", "India", "Hyderabad Street Circuit", "2023-02-11T18:00:00Z", "2022-23"),
    (5, "Cape Town ePrix", "South Africa", "Cape Town Street Circuit", "2023-02-25T18:00:00Z", "2022-23"),
    (6, "Julius Baer São Paulo ePrix", "Brazil", "São Paulo Street Circuit", "2023-03-25T18:00:00Z", "2022-23"),
    (7, "SABIC Berlin ePrix", "Germany", "Tempelhof Airport Street Circuit", "2023-04-22T18:00:00Z", "2022-23"),
    (8, "SABIC Berlin ePrix", "Germany", "Tempelhof Airport Street Circuit", "2023-04-23T18:00:00Z", "2022-23"),
    (9, "Monaco ePrix", "Monaco", "Circuit de Monaco", "2023-05-06T18:00:00Z", "2022-23"),
    (10, "Gulavit Jakarta ePrix", "Indonesia", "Jakarta International e-Prix Circuit", "2023-06-03T18:00:00Z", "2022-23"),
    (11, "Gulavit Jakarta ePrix", "Indonesia", "Jakarta International e-Prix Circuit", "2023-06-04T18:00:00Z", "2022-23"),
    (12, "Southwire Portland ePrix", "United States", "Portland International Raceway", "2023-06-24T18:00:00Z", "2022-23"),
    (13, "Hankook Rome ePrix", "Italy", "Circuito Cittadino dell'EUR", "2023-07-15T18:00:00Z", "2022-23"),
    (14, "Hankook Rome ePrix", "Italy", "Circuito Cittadino dell'EUR", "2023-07-16T18:00:00Z", "2022-23"),
    (15, "Hankook London ePrix", "United Kingdom", "ExCeL London", "2023-07-29T18:00:00Z", "2022-23"),
    (16, "Hankook London ePrix", "United Kingdom", "ExCeL London", "2023-07-30T18:00:00Z", "2022-23")
    ;


CREATE TABLE entrants ( 
    id integer primary key autoincrement,
    number integer not null,
    driver integer not null, 
    team integer not null, 
    race integer not null,
    participating integer default 1,
    foreign key (driver) references drivers (id), 
    foreign key (team) references teams (id),
    foreign key (race) references races (id),
    unique (driver, team, race)
    );

create temporary table temp_drivers(
     number integer not null,
     driver_name text not null,
     team_shortname text not null
     );

insert into temp_drivers (number, driver_name, team_shortname) values
    (1, 'Stoffel Vandoorne', 'Penske'),
    (25, 'Jean-Éric Vergne', 'Penske'),
    (3, 'Sérgio Sette Câmara', 'NIO'),
    (33, 'Dan Ticktum', 'NIO' ),
    (4, "Robin Frijns",  "ABT Cupra"),
    (4, "Kelvin van der Linde",  "ABT Cupra"),
    (51, "Nico Müller",  "ABT Cupra"),
    (5, "Jake Hughes", 'McLaren'),
    (58, "René Rast", 'McLaren'),
    (7, "Maximilian Günther", 'Maserati'),
    (48, "Edoardo Mortara", 'Maserati'),
    (8, "Oliver Rowland", 'Mahindra'),
    (8, "Roberto Merhi", 'Mahindra'),
    (11, "Lucas di Grassi", 'Mahindra'),
    (9, "Mitch Evans", 'Jaguar'),
    (10, "Sam Bird", 'Jaguar'),
    (13, "António Félix da Costa", 'Porsche'),
    (94, "Pascal Wehrlein", 'Porsche'),
    (16, "Sébastien Buemi", 'Envision'),
    (37, "Nick Cassidy", 'Envision'),
    (17, "Norman Nato", 'Nissan'),
    (23, "Sacha Fenestraz", 'Nissan'),
    (27, "Jake Dennis", 'Andretti'),
    (36, "André Lotterer", 'Andretti'),
    (36, "David Beckmann", 'Andretti')
    ;

-- So this will just insert all the drivers as entrants to *all* the races. Obviously that's not quite what happened
-- in 2022/23, but it's not worth it to go back and fix them.
insert into entrants (number, driver, team, race) 
    select temp_drivers.number, drivers.id, teams.id, races.id 
    from temp_drivers
    inner join drivers on temp_drivers.driver_name = drivers.name
    inner join teams on temp_drivers.team_shortname = teams.shortname
    cross join races
    where teams.season = "2022-23"
    ;

drop table temp_drivers ;

CREATE TABLE predictions (
    user integer not null,
    race integer not null,
    pole integer not null,
    fam  integer not null,
    fl   integer not null,
    hgc  integer not null,
    first integer not null,
    second integer not null,
    third integer not null,
    fdnf integer not null,
    safety_car text check (safety_car in ("yes", "no")) not null,
    foreign key (user) references users(id),
    foreign key (race) references races(id),
    foreign key (pole) references entrants(id),
    foreign key (fam) references entrants(id),
    foreign key (fl) references entrants(id),
    foreign key (hgc) references entrants(id),
    foreign key (first) references entrants(id),
    foreign key (second) references entrants(id),
    foreign key (third) references entrants(id),
    foreign key (fdnf) references entrants(id),
    primary key (user, race)
    );

CREATE TABLE results (
    race integer primary key not null,
    pole integer not null,
    fam  integer not null,
    fl   integer not null,
    hgc  integer not null,
    first integer not null,
    second integer not null,
    third integer not null,
    fdnf integer not null,
    safety_car text check (safety_car in ("yes", "no")) not null,
    foreign key (race) references races(id),
    foreign key (pole) references entrants(id)
    foreign key (fam) references entrants(id),
    foreign key (fl) references entrants(id),
    foreign key (hgc) references entrants(id),
    foreign key (first) references entrants(id),
    foreign key (second) references entrants(id),
    foreign key (third) references entrants(id),
    foreign key (fdnf) references entrants(id)
    );

create temporary table temp_entries (
    user text not null,
    race integer not null,
    pole text not null,
    fam text not null,
    fl text not null,
    hgc text not null,
    first text not null,
    second text not null,
    third text not null,
    fdnf text not null,
    safety_car text not null
);

-- Allan's predictions

INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 1, 'Mitch Evans', 'Sérgio Sette Câmara', 'Stoffel Vandoorne', 'Edoardo Mortara', 'Mitch Evans', 'Stoffel Vandoorne', 'Edoardo Mortara', 'Dan Ticktum', 'no');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 2, 'Mitch Evans', 'Sacha Fenestraz', 'Dan Ticktum', 'Stoffel Vandoorne', 'Pascal Wehrlein', 'Mitch Evans', 'Dan Ticktum', 'Norman Nato', 'no');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 3, 'Mitch Evans', 'Nick Cassidy', 'Jake Dennis', 'Stoffel Vandoorne', 'Sam Bird', 'Pascal Wehrlein', 'René Rast', 'Sacha Fenestraz', 'no');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 4, 'Mitch Evans', 'Oliver Rowland', 'Pascal Wehrlein', 'Jake Hughes', 'Mitch Evans', 'Pascal Wehrlein', 'Jake Dennis', 'Maximilian Günther', 'no');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 5, 'Mitch Evans', 'Nico Müller', 'Jake Dennis', 'António Félix da Costa', 'Sam Bird', 'Pascal Wehrlein', 'Mitch Evans', 'Kelvin van der Linde', 'yes');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 6, 'Jean-Éric Vergne', 'Norman Nato', 'Pascal Wehrlein', 'António Félix da Costa', 'Mitch Evans', 'Jean-Éric Vergne', 'Pascal Wehrlein', 'Maximilian Günther', 'yes');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 7, 'Stoffel Vandoorne', 'René Rast', 'Jake Dennis', 'Jean-Éric Vergne', 'Mitch Evans', 'Pascal Wehrlein', 'Sam Bird', 'Dan Ticktum', 'yes');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 8, 'António Félix da Costa', 'Norman Nato', 'Mitch Evans', 'Stoffel Vandoorne', 'Sam Bird', 'António Félix da Costa', 'Mitch Evans', 'Robin Frijns', 'no');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 9, 'Jean-Éric Vergne', 'René Rast', 'Jean-Éric Vergne', 'Jake Hughes', 'Mitch Evans', 'Jake Dennis', 'Sam Bird', 'Norman Nato', 'yes');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 10, 'Nick Cassidy', 'Roberto Merhi', 'Mitch Evans', 'Sam Bird', 'Mitch Evans', 'Nick Cassidy', 'Sam Bird', 'Maximilian Günther', 'yes');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 11, 'António Félix da Costa', 'Sérgio Sette Câmara', 'Nick Cassidy', 'Lucas di Grassi', 'Mitch Evans', 'Nick Cassidy', 'Sam Bird', 'David Beckmann', 'yes');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 12, 'Jean-Éric Vergne', 'Roberto Merhi', 'Sam Bird', 'Maximilian Günther', 'Maximilian Günther', 'Mitch Evans', 'Sam Bird', 'Norman Nato', 'yes');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 13, 'Mitch Evans', 'Sérgio Sette Câmara', 'Mitch Evans', 'Pascal Wehrlein', 'Mitch Evans', 'Edoardo Mortara', 'Jake Dennis', 'Sacha Fenestraz', 'yes');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 14, 'Mitch Evans', 'Sérgio Sette Câmara', 'Mitch Evans', 'António Félix da Costa', 'Mitch Evans', 'Jake Dennis', 'Nick Cassidy', 'Dan Ticktum', 'yes');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 15, 'Nick Cassidy', 'Nico Müller', 'Nick Cassidy', 'António Félix da Costa', 'Mitch Evans', 'Jake Dennis', 'Nick Cassidy', 'Dan Ticktum', 'yes');
INSERT INTO temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES ('Allan', 16, 'Mitch Evans', 'Roberto Merhi', 'António Félix da Costa', 'Pascal Wehrlein', 'Mitch Evans', 'Nick Cassidy', 'René Rast', 'Maximilian Günther', 'yes');

-- Dan's predictions

insert into temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) values
    ('Dan', 1, 'Jean-Éric Vergne', 'Robin Frijns', 'Jean-Éric Vergne', 'René Rast', 'Jean-Éric Vergne', 'Stoffel Vandoorne', 'Jake Hughes', 'Sébastien Buemi', 'no'),
    ('Dan', 2, 'Mitch Evans', 'Edoardo Mortara', 'Sébastien Buemi', 'Lucas di Grassi', 'Sébastien Buemi', 'Mitch Evans', 'Sam Bird', 'Kelvin van der Linde', 'yes'),
    ('Dan', 3, 'Mitch Evans', 'André Lotterer', 'Pascal Wehrlein', 'Pascal Wehrlein', 'Jake Dennis', 'Mitch Evans', 'Pascal Wehrlein', 'Sacha Fenestraz', 'yes'),
    ('Dan', 4, 'Sébastien Buemi', 'Norman Nato', 'Jake Dennis', 'Pascal Wehrlein', 'Mitch Evans', 'Jake Dennis', 'Sam Bird', 'Nico Müller', 'yes'),
    ('Dan', 5, 'Nick Cassidy', 'Maximilian Günther', 'Nick Cassidy', 'Jake Dennis', 'Mitch Evans', 'Sam Bird', 'Nick Cassidy', 'Kelvin van der Linde', 'yes'),
    ('Dan', 6, 'António Félix da Costa', 'Maximilian Günther', 'René Rast', 'Mitch Evans', 'Pascal Wehrlein', 'António Félix da Costa', 'Jake Dennis', 'Sacha Fenestraz', 'yes'),
    ('Dan', 7, 'Nick Cassidy', 'Robin Frijns', 'Sam Bird', 'Pascal Wehrlein', 'António Félix da Costa', 'Sam Bird', 'Nick Cassidy', 'Nico Müller', 'yes'),
    ('Dan', 8, 'Mitch Evans', 'Norman Nato', 'Jake Dennis', 'Edoardo Mortara', 'Mitch Evans', 'Sam Bird', 'Jake Dennis', 'Oliver Rowland', 'yes'),
    ('Dan', 9, 'Maximilian Günther', 'Sacha Fenestraz', 'Jake Dennis', 'Nick Cassidy', 'Mitch Evans', 'Jake Dennis', 'Stoffel Vandoorne', 'Nico Müller', 'yes'),
    ('Dan', 10, 'Maximilian Günther', 'Nick Cassidy', 'Edoardo Mortara', 'Lucas di Grassi', 'Mitch Evans', 'Stoffel Vandoorne', 'Maximilian Günther', 'Roberto Merhi', 'yes'),
    ('Dan', 11, 'Maximilian Günther', 'David Beckmann', 'Nick Cassidy', 'Jake Hughes', 'Jake Dennis', 'Maximilian Günther', 'Nick Cassidy', 'David Beckmann', 'no'),
    ('Dan', 12, 'René Rast', 'René Rast', 'René Rast', 'Nick Cassidy', 'Maximilian Günther', 'René Rast', 'Sam Bird', 'Roberto Merhi', 'yes'),
    ('Dan', 13, 'Mitch Evans', 'Pascal Wehrlein', 'Mitch Evans', 'Nick Cassidy', 'Mitch Evans', 'Jake Dennis', 'Nick Cassidy', 'Nico Müller', 'yes'),
    ('Dan', 14, 'Mitch Evans', 'Edoardo Mortara', 'Mitch Evans', 'Edoardo Mortara', 'Mitch Evans', 'Nick Cassidy', 'Sébastien Buemi', 'Roberto Merhi', 'yes'),
    ('Dan', 15, 'Nick Cassidy', 'Mitch Evans', 'Jake Dennis', 'Lucas di Grassi', 'Nick Cassidy', 'Mitch Evans', 'Jake Dennis', 'Roberto Merhi', 'yes'),
    ('Dan', 16, 'Mitch Evans', 'Jake Dennis', 'Nick Cassidy', 'Jake Hughes', 'Mitch Evans', 'Nick Cassidy', 'Sam Bird', 'André Lotterer', 'yes')
    ;
-- Charlies's predictions

insert into temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) values
    ('Charlie', 1, 'Stoffel Vandoorne', 'Norman Nato', 'Stoffel Vandoorne', 'Lucas di Grassi', 'António Félix da Costa', 'Stoffel Vandoorne', 'Robin Frijns', 'Dan Ticktum', 'no'),
    ('Charlie', 2, 'Jake Dennis', 'Sam Bird', 'Lucas di Grassi', 'Jean-Éric Vergne', 'Jake Dennis', 'Lucas di Grassi', 'Pascal Wehrlein', 'Mitch Evans', 'yes'),
    ('Charlie', 3, 'Sébastien Buemi', 'Kelvin van der Linde', 'Pascal Wehrlein', 'Stoffel Vandoorne', 'Pascal Wehrlein', 'Jake Dennis', 'Sam Bird', 'António Félix da Costa', 'yes'),
    ('Charlie', 4, 'Sébastien Buemi', 'António Félix da Costa', 'Sam Bird', 'António Félix da Costa', 'Pascal Wehrlein', 'Sébastien Buemi', 'Jake Dennis', 'Nico Müller', 'yes'),
    ('Charlie', 5, 'Mitch Evans', 'Kelvin van der Linde', 'Sam Bird', 'André Lotterer', 'Pascal Wehrlein', 'Nick Cassidy', 'René Rast', 'Nico Müller', 'yes'),
    ('Charlie', 6, 'Jean-Éric Vergne', 'Sérgio Sette Câmara', 'Jean-Éric Vergne', 'Sam Bird', 'Pascal Wehrlein', 'Jake Dennis', 'Nick Cassidy', 'Nico Müller', 'yes'),
    ('Charlie', 7, 'Stoffel Vandoorne', 'Robin Frijns', 'Sam Bird', 'Sam Bird', 'Mitch Evans', 'Nick Cassidy', 'Jean-Éric Vergne', 'Nico Müller', 'yes'),
    ('Charlie', 8, 'Jean-Éric Vergne', 'Pascal Wehrlein', 'Mitch Evans', 'António Félix da Costa', 'Nick Cassidy', 'Stoffel Vandoorne', 'Mitch Evans', 'Robin Frijns', 'yes'),
    ('Charlie', 9, 'Nick Cassidy', 'André Lotterer', 'Sam Bird', 'António Félix da Costa', 'Pascal Wehrlein', 'Nick Cassidy', 'Jean-Éric Vergne', 'Nico Müller', 'yes'),
    ('Charlie', 10, 'Jake Hughes', 'Robin Frijns', 'Jake Dennis', 'Jean-Éric Vergne', 'Nick Cassidy', 'Mitch Evans', 'Jake Dennis', 'David Beckmann', 'yes'),
    ('Charlie', 11, 'Mitch Evans', 'Roberto Merhi', 'Stoffel Vandoorne', 'António Félix da Costa', 'Sam Bird', 'Jake Dennis', 'Nick Cassidy', 'Sébastien Buemi', 'yes'),
    ('Charlie', 12, 'Maximilian Günther', 'Robin Frijns', 'Jake Dennis', 'René Rast', 'Maximilian Günther', 'Jake Dennis', 'Mitch Evans', 'André Lotterer', 'yes'),
    ('Charlie', 13, 'Jake Dennis', 'Robin Frijns', 'Mitch Evans', 'Sam Bird', 'Nick Cassidy', 'Jake Dennis', 'Mitch Evans', 'Roberto Merhi', 'yes'),
    ('Charlie', 14, 'Nick Cassidy', 'Maximilian Günther', 'Jake Hughes', 'Sérgio Sette Câmara', 'Mitch Evans', 'Jake Dennis', 'Nick Cassidy', 'André Lotterer', 'yes'),
    ('Charlie', 15, 'Jake Dennis', 'António Félix da Costa', 'Jean-Éric Vergne', 'Stoffel Vandoorne', 'Jake Dennis', 'Mitch Evans', 'Nick Cassidy', 'Nico Müller', 'yes'),
    ('Charlie', 16, 'Mitch Evans', 'Robin Frijns', 'Sébastien Buemi', 'Sérgio Sette Câmara', 'Mitch Evans', 'Sam Bird', 'Nick Cassidy', 'Dan Ticktum', 'yes')
    ;

-- James' predictions
insert into temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) values
    ('James', 1, 'Jean-Éric Vergne', 'Mitch Evans', 'António Félix da Costa', 'Lucas di Grassi', 'Jean-Éric Vergne', 'Pascal Wehrlein', 'Jake Hughes', 'Nico Müller', 'yes'),
    ('James', 2, 'Sam Bird', 'Sacha Fenestraz', 'Jake Hughes', 'Jean-Éric Vergne', 'Stoffel Vandoorne', 'Sam Bird', 'Sébastien Buemi', 'Kelvin van der Linde', 'yes'),
    ('James', 3, 'Jake Dennis', 'Sacha Fenestraz', 'René Rast', 'António Félix da Costa', 'Jake Dennis', 'Mitch Evans', 'Sam Bird', 'Nick Cassidy', 'no'),
    ('James', 4, 'Sam Bird', 'Nick Cassidy', 'René Rast', 'António Félix da Costa', 'Edoardo Mortara', 'Sam Bird', 'Pascal Wehrlein', 'Oliver Rowland', 'yes'),
    ('James', 5, 'Edoardo Mortara', 'Sacha Fenestraz', 'Jake Hughes', 'Sam Bird', 'Mitch Evans', 'Edoardo Mortara', 'Nick Cassidy', 'Norman Nato', 'yes'),
    ('James', 6, 'António Félix da Costa', 'Sacha Fenestraz', 'Nick Cassidy', 'Mitch Evans', 'Pascal Wehrlein', 'António Félix da Costa', 'René Rast', 'Norman Nato', 'yes'),
    ('James', 7, 'Stoffel Vandoorne', 'Maximilian Günther', 'Stoffel Vandoorne', 'Jake Dennis', 'Stoffel Vandoorne', 'António Félix da Costa', 'Maximilian Günther', 'Nico Müller', 'yes'),
    ('James', 8, 'Nick Cassidy', 'Lucas di Grassi', 'Sam Bird', 'Pascal Wehrlein', 'Mitch Evans', 'António Félix da Costa', 'Pascal Wehrlein', 'Maximilian Günther', 'no'),
    ('James', 9, 'Mitch Evans', 'Mitch Evans', 'Mitch Evans', 'Pascal Wehrlein', 'Stoffel Vandoorne', 'Mitch Evans', 'Maximilian Günther', 'André Lotterer', 'yes'),
    ('James', 10, 'Jean-Éric Vergne', 'Sébastien Buemi', 'Mitch Evans', 'Jean-Éric Vergne', 'Mitch Evans', 'Edoardo Mortara', 'Jake Dennis', 'Roberto Merhi', 'yes'),
    ('James', 11, 'Jean-Éric Vergne', 'René Rast', 'Nick Cassidy', 'Pascal Wehrlein', 'Nick Cassidy', 'Jake Dennis', 'Mitch Evans', 'David Beckmann', 'no'),
    ('James', 12, 'Maximilian Günther', 'Pascal Wehrlein', 'René Rast', 'Nick Cassidy', 'Mitch Evans', 'Jake Dennis', 'Nick Cassidy', 'Sérgio Sette Câmara', 'no'),
    ('James', 13, 'Mitch Evans', 'Pascal Wehrlein', 'Jake Dennis', 'Nick Cassidy', 'Mitch Evans', 'Pascal Wehrlein', 'Jake Dennis', 'Nico Müller', 'yes'),
    ('James', 14, 'Mitch Evans', 'Mitch Evans', 'Nick Cassidy', 'Jean-Éric Vergne', 'Mitch Evans', 'Nick Cassidy', 'Jake Dennis', 'Sérgio Sette Câmara', 'yes'),
    ('James', 15, 'Sébastien Buemi', 'Sacha Fenestraz', 'Mitch Evans', 'Edoardo Mortara', 'Nick Cassidy', 'Mitch Evans', 'Jake Dennis', 'Robin Frijns', 'yes'),
    ('James', 16, 'Nick Cassidy', 'Sacha Fenestraz', 'Jake Hughes', 'Jean-Éric Vergne', 'Sam Bird', 'Jake Dennis', 'Mitch Evans', 'Stoffel Vandoorne', 'yes')
    ;

with 
    race_entrants 
    as (select 
       entrants.id as id, 
       drivers.name as driver_name,
       entrants.race as race_id 
       from entrants inner join drivers on entrants.driver = drivers.id
       )
insert into predictions (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car)
    select users.id, temp_entries.race, pole_entrants.id, fam_entrants.id, fl_entrants.id, hgc_entrants.id, first_entrants.id, second_entrants.id, third_entrants.id, fdnf_entrants.id, temp_entries.safety_car
    from temp_entries
    inner join users on temp_entries.user = users.fullname
    inner join race_entrants as pole_entrants on temp_entries.pole = pole_entrants.driver_name and pole_entrants.race_id = temp_entries.race
    inner join race_entrants as fam_entrants on temp_entries.fam = fam_entrants.driver_name and fam_entrants.race_id = temp_entries.race
    inner join race_entrants as fl_entrants on temp_entries.fl = fl_entrants.driver_name and fl_entrants.race_id = temp_entries.race
    inner join race_entrants as hgc_entrants on temp_entries.hgc = hgc_entrants.driver_name and hgc_entrants.race_id = temp_entries.race
    inner join race_entrants as first_entrants on temp_entries.first = first_entrants.driver_name and first_entrants.race_id = temp_entries.race
    inner join race_entrants as second_entrants on temp_entries.second = second_entrants.driver_name and second_entrants.race_id = temp_entries.race
    inner join race_entrants as third_entrants on temp_entries.third = third_entrants.driver_name and third_entrants.race_id = temp_entries.race
    inner join race_entrants as fdnf_entrants on temp_entries.fdnf = fdnf_entrants.driver_name and fdnf_entrants.race_id = temp_entries.race
    ;

drop table temp_entries;

-- Results.

create temporary table temp_results (
    race integer not null,
    pole text not null,
    fam text not null,
    fl text not null,
    hgc text not null,
    first text not null,
    second text not null,
    third text not null,
    fdnf text not null,
    safety_car text not null
);
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (1, 'Lucas di Grassi', 'Nick Cassidy', 'Jake Dennis', 'Oliver Rowland', 'Jake Dennis', 'Pascal Wehrlein', 'Lucas di Grassi', 'Robin Frijns', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (2, 'Sébastien Buemi', 'António Félix da Costa', 'René Rast', 'Jake Dennis', 'Pascal Wehrlein', 'Jake Dennis', 'Sam Bird', 'Nico Müller', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (3, 'Jake Hughes', 'Kelvin van der Linde', 'Sam Bird', 'António Félix da Costa', 'Pascal Wehrlein', 'Jake Dennis', 'René Rast', 'Nico Müller', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (4, 'Mitch Evans', 'Kelvin van der Linde', 'Nico Müller', 'André Lotterer', 'Jean-Éric Vergne', 'Nick Cassidy', 'António Félix da Costa', 'Kelvin van der Linde', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (5, 'Sacha Fenestraz', 'Sérgio Sette Câmara', 'Jean-Éric Vergne', 'António Félix da Costa', 'António Félix da Costa', 'Jean-Éric Vergne', 'Nick Cassidy', 'Pascal Wehrlein', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (6, 'Stoffel Vandoorne', 'Robin Frijns', 'Sam Bird', 'Pascal Wehrlein', 'Mitch Evans', 'Nick Cassidy', 'Sam Bird', 'Norman Nato', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (7, 'Sébastien Buemi', 'Dan Ticktum', 'Jake Dennis', 'Oliver Rowland', 'Mitch Evans', 'Sam Bird', 'Maximilian Günther', 'Dan Ticktum', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (8, 'Robin Frijns', 'Robin Frijns', 'Sébastien Buemi', 'Maximilian Günther', 'Nick Cassidy', 'Jake Dennis', 'Jean-Éric Vergne', 'Edoardo Mortara', 'no');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (9, 'Jake Hughes', 'Oliver Rowland', 'Jake Dennis', 'Jean-Éric Vergne', 'Nick Cassidy', 'Mitch Evans', 'Jake Dennis', 'André Lotterer', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (10, 'Maximilian Günther', 'Sébastien Buemi', 'Sébastien Buemi', 'Jake Hughes', 'Pascal Wehrlein', 'Jake Dennis', 'Maximilian Günther', 'Mitch Evans', 'no');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (11, 'Maximilian Günther', 'Robin Frijns', 'Jake Dennis', 'Dan Ticktum', 'Maximilian Günther', 'Jake Dennis', 'Mitch Evans', 'David Beckmann', 'no');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (12, 'Jake Dennis', 'Robin Frijns', 'Mitch Evans', 'Mitch Evans', 'Nick Cassidy', 'Jake Dennis', 'António Félix da Costa', 'Roberto Merhi', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (13, 'Mitch Evans', 'Nico Müller', 'Mitch Evans', 'Sérgio Sette Câmara', 'Mitch Evans', 'Nick Cassidy', 'Maximilian Günther', 'André Lotterer', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (14, 'Jake Dennis', 'António Félix da Costa', 'Jean-Éric Vergne', 'Stoffel Vandoorne', 'Jake Dennis', 'Norman Nato', 'Sam Bird', 'Mitch Evans', 'yes');
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (15, 'Mitch Evans', 'Stoffel Vandoorne', 'André Lotterer', 'Lucas di Grassi', 'Mitch Evans', 'Jake Dennis', 'Sébastien Buemi', 'Robin Frijns', 'yes');
-- NOTE: Jean-Eric Vergne is wrong here, it should be null, but we cannot enter that because then the below insert won't work
INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES (16, 'Nick Cassidy', 'Stoffel Vandoorne', 'Jake Dennis', 'Robin Frijns', 'Nick Cassidy', 'Mitch Evans', 'Jake Dennis', 'Jean-Éric Vergne', 'yes');

with 
    race_entrants 
    as (select 
       entrants.id as id, 
       drivers.name as driver_name,
       entrants.race as race_id 
       from entrants inner join drivers on entrants.driver = drivers.id
       )
insert into results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car)
    select temp_results.race, pole_entrants.id, fam_entrants.id, fl_entrants.id, hgc_entrants.id, first_entrants.id, second_entrants.id, third_entrants.id, fdnf_entrants.id, temp_results.safety_car
    from temp_results
    inner join race_entrants as pole_entrants on temp_results.pole = pole_entrants.driver_name and pole_entrants.race_id = temp_results.race
    inner join race_entrants as fam_entrants on temp_results.fam = fam_entrants.driver_name and fam_entrants.race_id = temp_results.race
    inner join race_entrants as fl_entrants on temp_results.fl = fl_entrants.driver_name and fl_entrants.race_id = temp_results.race
    inner join race_entrants as hgc_entrants on temp_results.hgc = hgc_entrants.driver_name and hgc_entrants.race_id = temp_results.race
    inner join race_entrants as first_entrants on temp_results.first = first_entrants.driver_name and first_entrants.race_id = temp_results.race
    inner join race_entrants as second_entrants on temp_results.second = second_entrants.driver_name and second_entrants.race_id = temp_results.race
    inner join race_entrants as third_entrants on temp_results.third = third_entrants.driver_name and third_entrants.race_id = temp_results.race
    inner join race_entrants as fdnf_entrants on temp_results.fdnf = fdnf_entrants.driver_name and fdnf_entrants.race_id = temp_results.race
    ;

-- There was no dnf's in the final race believe it or not.
update results set fdnf = '' where race = 16;


drop table temp_results;



insert into drivers (name) values ("Jehan Daruvala");
insert into drivers (name) values ("Nyck de Vries");

insert into races (round, name, country, circuit, date, season) values 
    (1, "Hancook Mexico city e-prix", "Mexico", "Autódromo Hermanos Rodríguez", "2024-01-13T15:40:00Z", "2023-24"),
    (2, "Diriyah E-Prix", "Saudi Arabia", "Riyadh Street Circuit", "2024-01-26T17:00:00Z", "2023-24"),
    (3, "Diriyah E-Prix", "Saudi Arabia", "Riyadh Street Circuit", "2024-01-27T17:00:00Z", "2023-24"),
    (4, "Hyderabad E-Prix", "India", "Hyderabad Street Circuit", "2024-02-10T09:00:00Z", "2023-24"),
    (5, "São Paulo E-Prix", "Brazil", "São Paulo Street Circuit", "2024-03-16T14:00:00Z", "2023-24"),
    (6, "Tokyo E-Prix", "Japan", "Tokyo Street Cicuit", "2024-03-30T17:00:00Z", "2023-24"),
    (7, "Misano Adriatico E-Prix", "Italy", "Misano World Circuit Marco Simoncelli", "2024-04-13T18:00:00Z", "2023-24"),
    (8, "Misano Adriatico E-Prix", "Italy", "Misano World Circuit Marco Simoncelli", "2024-04-14T18:00:00Z", "2023-24"),
    (9, "Monaco E-Prix", "Monaco", "Circuit de Monaco", "2024-04-27T18:00:00Z", "2023-24"),
    (10, "Berlin E-Prix", "Germany", "Tempelhof Airport Street Circuit", "2024-05-11T18:00:00Z", "2023-24"),
    (11, "Berlin E-Prix", "Germany", "Tempelhof Airport Street Circuit", "2024-05-12T18:00:00Z", "2023-24"),
    (12, "Shanghai E-Prix", "China", "Shanghai International Circuit", "2024-05-25T18:00:00Z", "2023-24"),
    (13, "Shanghai E-Prix", "China", "Shanghai International Circuit", "2024-05-26T18:00:00Z", "2023-24"),
    (14, "Portland E-Prix", "United States", "Portland International Raceway", "2024-06-29T18:00:00Z", "2023-24"),
    (15, "Portland E-Prix", "United States", "Portland International Raceway", "2024-06-30T18:00:00Z", "2023-24"),
    (16, "London E-Prix", "United Kingdom", "ExCeL London", "2024-07-20T18:00:00Z", "2023-24"),
    (17, "London E-Prix", "United Kingdom", "ExCeL London", "2024-07-21T18:00:00Z", "2023-24")
    ;

update races set cancelled = 1 where round = 4 and season = "2023-24";

create temporary table temp_drivers(
     number integer not null,
     driver_name text not null,
     team_shortname text not null
     );

insert into temp_drivers (number, driver_name, team_shortname) values
    (1, 'Jake Dennis', 'Andretti'),
    (17, 'Norman Nato', 'Andretti'),
    (2, 'Stoffel Vandoorne', 'Penske'),
    (25, 'Jean-Éric Vergne', 'Penske'),
    (3, 'Sérgio Sette Câmara', 'ERT'),
    (33, 'Dan Ticktum', 'ERT' ),
    (4, "Robin Frijns",  "Envision"),
    (16, "Sébastien Buemi", 'Envision'),
    (5, "Jake Hughes", 'McLaren'),
    (8, "Sam Bird", 'McLaren'),
    (7, "Maximilian Günther", 'Maserati'),
    (18, "Jehan Daruvala", 'Maserati'),
    (9, "Mitch Evans", 'Jaguar'),
    (37, "Nick Cassidy", 'Jaguar'),
    (11, "Lucas di Grassi", 'ABT Cupra'),
    (51, "Nico Müller",  "ABT Cupra"),
    (13, "António Félix da Costa", 'Porsche'),
    (94, "Pascal Wehrlein", 'Porsche'),
    (21, "Nyck de Vries", 'Mahindra'),
    (48, "Edoardo Mortara", 'Mahindra'),
    (22, "Oliver Rowland", 'Nissan'),
    (23, "Sacha Fenestraz", 'Nissan')
    ;

insert into entrants (number, driver, team, race) 
    select temp_drivers.number, drivers.id, teams.id, races.id 
    from temp_drivers
    inner join drivers on temp_drivers.driver_name = drivers.name
    inner join teams on teams.season = "2023-24" and temp_drivers.team_shortname = teams.shortname
    cross join races on races.season = '2023-24';
    ;

drop table temp_drivers;

-- 2024 so far

create temporary table temp_entries (
    user text not null,
    race integer not null,
    pole text not null,
    fam text not null,
    fl text not null,
    hgc text not null,
    first text not null,
    second text not null,
    third text not null,
    fdnf text not null,
    safety_car text not null
);

insert into temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) values
( "Dan",17,"Mitch Evans","Nick Cassidy","Mitch Evans","Jake Dennis","Mitch Evans","Nick Cassidy","Maximilian Günther","Dan Ticktum","yes" ),
( "Charlie",17,"Mitch Evans","Sérgio Sette Câmara","Nick Cassidy","Lucas di Grassi","Jake Dennis","Sam Bird","Nick Cassidy","Nico Müller","yes" ),
( "Allan",17,"Mitch Evans","Sam Bird","Nick Cassidy","Lucas di Grassi","Mitch Evans","Nick Cassidy","Jake Hughes","Maximilian Günther","yes" ),
( "James",17,"Robin Frijns","Mitch Evans","Jake Hughes","Stoffel Vandoorne","Nick Cassidy","Mitch Evans","Sébastien Buemi","Sérgio Sette Câmara","yes" ),
( "Charlie",18,"Pascal Wehrlein","Pascal Wehrlein","Nick Cassidy","Pascal Wehrlein","Pascal Wehrlein","Sébastien Buemi","Nick Cassidy","Nico Müller","yes" ),
( "Charlie",19,"Pascal Wehrlein","Pascal Wehrlein","Nick Cassidy","Pascal Wehrlein","Pascal Wehrlein","Sébastien Buemi","Nick Cassidy","Nico Müller","yes" ),
( "Allan",18,"Pascal Wehrlein","Sam Bird","Mitch Evans","Edoardo Mortara","Pascal Wehrlein","Mitch Evans","Jake Hughes","Sacha Fenestraz","yes" ),
( "Dan",18,"Maximilian Günther","Lucas di Grassi","Jake Dennis","Robin Frijns","Jake Dennis","Maximilian Günther","Mitch Evans","Jehan Daruvala","yes" ),
( "James",18,"Jake Dennis","Mitch Evans","Jake Dennis","António Félix da Costa","Sébastien Buemi","Nick Cassidy","Mitch Evans","Jehan Daruvala","yes" ),
( "Allan",19,"Mitch Evans","Nico Müller","Jake Dennis","Sam Bird","Mitch Evans","Jake Dennis","Jean-Éric Vergne","Oliver Rowland","no" ),
( "Dan",19,"Mitch Evans","Mitch Evans","Jake Dennis","Pascal Wehrlein","Jake Dennis","Mitch Evans","Nick Cassidy","Jehan Daruvala","no" ),
( "James",19,"Mitch Evans","Jean-Éric Vergne","Jake Dennis","Pascal Wehrlein","Mitch Evans","Nick Cassidy","Jean-Éric Vergne","Nico Müller","yes" )
    ;
with 
    race_entrants 
    as (select 
       entrants.id as id, 
       drivers.name as driver_name,
       entrants.race as race_id 
       from entrants inner join drivers on entrants.driver = drivers.id
       )
insert into predictions (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car)
    select users.id, temp_entries.race, pole_entrants.id, fam_entrants.id, fl_entrants.id, hgc_entrants.id, first_entrants.id, second_entrants.id, third_entrants.id, fdnf_entrants.id, temp_entries.safety_car
    from temp_entries
    inner join users on temp_entries.user = users.fullname
    inner join race_entrants as pole_entrants on temp_entries.pole = pole_entrants.driver_name and pole_entrants.race_id = temp_entries.race
    inner join race_entrants as fam_entrants on temp_entries.fam = fam_entrants.driver_name and fam_entrants.race_id = temp_entries.race
    inner join race_entrants as fl_entrants on temp_entries.fl = fl_entrants.driver_name and fl_entrants.race_id = temp_entries.race
    inner join race_entrants as hgc_entrants on temp_entries.hgc = hgc_entrants.driver_name and hgc_entrants.race_id = temp_entries.race
    inner join race_entrants as first_entrants on temp_entries.first = first_entrants.driver_name and first_entrants.race_id = temp_entries.race
    inner join race_entrants as second_entrants on temp_entries.second = second_entrants.driver_name and second_entrants.race_id = temp_entries.race
    inner join race_entrants as third_entrants on temp_entries.third = third_entrants.driver_name and third_entrants.race_id = temp_entries.race
    inner join race_entrants as fdnf_entrants on temp_entries.fdnf = fdnf_entrants.driver_name and fdnf_entrants.race_id = temp_entries.race
    ;

drop table temp_entries;

create temporary table temp_results (
    race integer not null,
    pole text not null,
    fam text not null,
    fl text not null,
    hgc text not null,
    first text not null,
    second text not null,
    third text not null,
    fdnf text not null,
    safety_car text not null
);

INSERT INTO temp_results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) VALUES 
( 17,"Pascal Wehrlein","Pascal Wehrlein","Nick Cassidy","Oliver Rowland","Pascal Wehrlein","Sébastien Buemi","Nick Cassidy","Lucas di Grassi","yes" ),
( 18,"Jean-Éric Vergne","Jean-Éric Vergne","Jake Dennis","Edoardo Mortara","Jake Dennis","Jean-Éric Vergne","Nick Cassidy","Sacha Fenestraz","no" ),
( 19,"Oliver Rowland","Stoffel Vandoorne","Jake Dennis","Edoardo Mortara","Nick Cassidy","Robin Frijns","Oliver Rowland","Sam Bird","no" )
;

with 
    race_entrants 
    as (select 
       entrants.id as id, 
       drivers.name as driver_name,
       entrants.race as race_id 
       from entrants inner join drivers on entrants.driver = drivers.id
       )
insert into results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car)
    select temp_results.race, pole_entrants.id, fam_entrants.id, fl_entrants.id, hgc_entrants.id, first_entrants.id, second_entrants.id, third_entrants.id, fdnf_entrants.id, temp_results.safety_car
    from temp_results
    inner join race_entrants as pole_entrants on temp_results.pole = pole_entrants.driver_name and pole_entrants.race_id = temp_results.race
    inner join race_entrants as fam_entrants on temp_results.fam = fam_entrants.driver_name and fam_entrants.race_id = temp_results.race
    inner join race_entrants as fl_entrants on temp_results.fl = fl_entrants.driver_name and fl_entrants.race_id = temp_results.race
    inner join race_entrants as hgc_entrants on temp_results.hgc = hgc_entrants.driver_name and hgc_entrants.race_id = temp_results.race
    inner join race_entrants as first_entrants on temp_results.first = first_entrants.driver_name and first_entrants.race_id = temp_results.race
    inner join race_entrants as second_entrants on temp_results.second = second_entrants.driver_name and second_entrants.race_id = temp_results.race
    inner join race_entrants as third_entrants on temp_results.third = third_entrants.driver_name and third_entrants.race_id = temp_results.race
    inner join race_entrants as fdnf_entrants on temp_results.fdnf = fdnf_entrants.driver_name and fdnf_entrants.race_id = temp_results.race
    ;


drop table temp_results;

