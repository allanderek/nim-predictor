DROP TABLE IF EXISTS users ;
DROP TABLE IF EXISTS drivers ;
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

CREATE TABLE teams ( 
    id integer primary key autoincrement, 
    fullname text, 
    shortname text
);

-- 2022/23
insert into teams (fullname, shortname) values ("DS Penske", "Penske");
insert into teams (fullname, shortname) values ("NIO 333 Racing", "NIO");
insert into teams (fullname, shortname) values ("ABT CUPRA Formula E Team", "ABT Cupra");
insert into teams (fullname, shortname) values ("NEOM McLaren Formula E Team", "McLaren");
insert into teams (fullname, shortname) values ("Maserati MSG Racing", "Maserati");
insert into teams (fullname, shortname) values ("Mahindra Racing", "Mahindra");
insert into teams (fullname, shortname) values ("Jaguar TCS Racing", "Jaguar");
insert into teams (fullname, shortname) values ("TAG Heuer Porsche Formula E Team", "Porsche");
insert into teams (fullname, shortname) values ("Envision Racing", "Envision");
insert into teams (fullname, shortname) values ("Nissan Formula E Team", "Nissan");
insert into teams (fullname, shortname) values ("Avalanche Andretti Formula E", "Andretti");

create table seasons (
    year text not null primary key
);

insert into seasons (year) values ("2022-23");
insert into seasons (year) values ("2023-24");

CREATE TABLE races (
    id integer primary key autoincrement, 
    name text, 
    country text, 
    circuit text, 
    date text,
    season text not null,
    foreign key (season) references seasons (year)
);

-- Note no semi-colons here so that the nim code doesn't attempt to execute a comment as a command.
-- insert into races (name, country, circuit, date) values ('Edinburgh e-prix', 'Scotland', 'Meadows',  '2023-10-10T18:00:00Z')
-- insert into races (name, country, circuit, date) values ('Mexico city e-prix', 'Mexico', 'Autódromo Hermanos Rodríguez',  '2024-01-13T18:00:00Z')

insert into races (name, country, circuit, date, season) values ("Hancook Mexico city e-prix", "Mexico", "Autódromo Hermanos Rodríguez", "2023-01-14T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Core Diriyah ePrix", "Saudi Arabia", "Riyadh Street Circuit", "2023-01-27T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Core Diriyah ePrix", "Saudi Arabia", "Riyadh Street Circuit", "2023-01-28T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Greenko Hyderabad ePrix", "India", "Hyderabad Street Circuit", "2023-02-11T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Cape Town ePrix", "South Africa", "Cape Town Street Circuit", "2023-02-25T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Julius Baer São Paulo ePrix", "Brazil", "São Paulo Street Circuit", "2023-03-25T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("SABIC Berlin ePrix", "Germany", "Tempelhof Airport Street Circuit", "2023-04-22T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("SABIC Berlin ePrix", "Germany", "Tempelhof Airport Street Circuit", "2023-04-23T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Monaco ePrix", "Monaco", "Circuit de Monaco", "2023-05-06T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Gulavit Jakarta ePrix", "Indonesia", "Jakarta International e-Prix Circuit", "2023-06-03T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Gulavit Jakarta ePrix", "Indonesia", "Jakarta International e-Prix Circuit", "2023-06-04T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Southwire Portland ePrix", "United States", "Portland International Raceway", "2023-06-24T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Hankook Rome ePrix", "Italy", "Circuito Cittadino dell'EUR", "2023-07-15T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Hankook Rome ePrix", "Italy", "Circuito Cittadino dell'EUR", "2023-07-16T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Hankook London ePrix", "United Kingdom", "ExCeL London", "2023-07-29T18:00:00Z", "2022-23");
insert into races (name, country, circuit, date, season) values ("Hankook London ePrix", "United Kingdom", "ExCeL London", "2023-07-30T18:00:00Z", "2022-23");

CREATE TABLE entrants ( 
    id integer primary key autoincrement,
    number integer not null,
    driver integer not null, 
    team integer not null, 
    race integer not null,
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


-- Do all the 2023/24 stuff AFTER we've done all the gumph above, otherwise you can end up with duplicate drivers etc.
insert into teams (fullname, shortname) values ("Andretti Global", "Andretti");
insert into teams (fullname, shortname) values ("ERT Formula E Team", "ERT");

