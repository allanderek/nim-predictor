drop table if exists users ;
drop table if exists drivers ;
drop table if exists teams ;
drop table if exists formula_one_seasons ;
drop table if exists formula_one_events ;
drop table if exists formula_one_sessions ;
drop table if exists formula_one_entrants ;
drop table if exists formula_one_prediction_lines ;

create table users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname TEXT NOT NULL,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    admin integer default 0    
);
insert into users (id, fullname, username, password, admin) values (1, 'Allan', 'allanderek', 'pdkdf2_sha256$Prologue$24400$OrNEbmqgkoK/6Oow6KFoMTXNUN0FD+9N3+uvxmpanYoMvSiEDWtbgpe1PvYxmF//a6Zs3fVE4ngq/InSYaGuCA==', 1);
insert into users (id, fullname, username, password, admin) values (2, 'Dan', 'dan', 'pdkdf2_sha256$Prologue$24400$OrNEbmqgkoK/6Oow6KFoMTXNUN0FD+9N3+uvxmpanYoMvSiEDWtbgpe1PvYxmF//a6Zs3fVE4ngq/InSYaGuCA==', 1);
insert into users (id, fullname, username, password, admin) values (3, 'Charlie', 'charlie', 'pdkdf2_sha256$Prologue$24400$OrNEbmqgkoK/6Oow6KFoMTXNUN0FD+9N3+uvxmpanYoMvSiEDWtbgpe1PvYxmF//a6Zs3fVE4ngq/InSYaGuCA==', 1);
insert into users (id, fullname, username, password, admin) values (4, 'James', 'james', 'pdkdf2_sha256$Prologue$24400$OrNEbmqgkoK/6Oow6KFoMTXNUN0FD+9N3+uvxmpanYoMvSiEDWtbgpe1PvYxmF//a6Zs3fVE4ngq/InSYaGuCA==', 1);

CREATE TABLE drivers ( 
    id integer primary key autoincrement, 
    name text 
);

CREATE TABLE teams ( 
    id integer primary key autoincrement, 
    fullname text, 
    shortname text
);


-- STUFF different from schema.sql

create table formula_one_seasons (
    year text not null primary key
);

create table formula_one_events (
    id integer primary key autoincrement,
    name text,
    season text not null,
    foreign key (season) references formula_one_seasons (year)
);

create table formula_one_sessions (
    id integer primary key autoincrement,
    name text check (name in ("qualifying", "sprint-shootout", "sprint", "race")) not null,
    half_points integer default 0,
    start_time text,
    event integer not null,
    foreign key (event) references formula_one_events (id)
);


create table formula_one_entrants ( 
    id integer primary key autoincrement,
    number integer not null,
    driver integer not null, 
    team integer not null, 
    session integer not null,
    foreign key (driver) references drivers (id), 
    foreign key (team) references teams (id),
    foreign key (session) references formula_one_sessions (id),
    unique (driver, team, session)
    );

create table formula_one_prediction_lines (
    -- The user can be null, which represents a result
    user integer,
    session integer not null,
    fastest_lap integer,
    position integer check (position >= 1 and position <= 20),
    entrant integer not null,
    foreign key (entrant) references formula_one_entrants (id)
    unique(user, session, position)
);

insert into formula_one_seasons (year) values ("2024");
insert into formula_one_events (name, season) values
    ("Bahrain Grand Prix", "2024"),
    ("Saudi Arabian Grand Prix", "2024"),
    ("Australian Grand Prix", "2024"),
    ("Japanese Grand Prix", "2024"),
    ("Chinese Grand Prix", "2024"),
    ("Miami Grand Prix", "2024"),
    ("Emilia Romagna Grand Prix", "2024"),
    ("Monaco Grand Prix", "2024"),
    ("Canadian Grand Prix", "2024"),
    ("Spanish Grand Prix", "2024"),
    ("Austrian Grand Prix", "2024"),
    ("British Grand Prix", "2024"),
    ("Hungarian Grand Prix", "2024"),
    ("Belgian Grand Prix", "2024"),
    ("Dutch Grand Prix", "2024"),
    ("Italian Grand Prix", "2024"),
    ("Azerbaijan Grand Prix", "2024"),
    ("Singapore Grand Prix", "2024"),
    ("United States Grand Prix", "2024"),
    ("Mexico City Grand Prix", "2024"),
    ("São Paulo Grand Prix", "2024"),
    ("Las Vegas Grand PriX", "2024"),
    ("Qatar Grand Prix", "2024"),
    ("Abu Dhabi Grand Prix", "2024")
    ;

drop table if exists temp_sessions ;
create temporary table temp_sessions(
    event_name not null,
    name not null,
    start_time not null
    );

insert into temp_sessions (event_name, name, start_time) values
    ("Bahrain Grand Prix", "qualifying", "2024-03-01T16:00:00Z"),
    ("Bahrain Grand Prix", "race", "2024-03-02T15:00:00Z"),
    ("Saudi Arabian Grand Prix", "qualifying", "2024-03-08T17:00:00Z"),
    ("Saudi Arabian Grand Prix", "race", "2024-03-09T17:00:00Z"),
    ("Australian Grand Prix", "qualifying", "2024-03-23T05:00:00Z"),
    ("Australian Grand Prix", "race", "2024-03-24T04:00:00Z"),
    ("Japanese Grand Prix", "qualifying", "2024-04-06T06:00:00Z"),
    ("Japanese Grand Prix", "race", "2024-04-07T05:00:00Z")
    ;

insert into formula_one_sessions (name, start_time, event) 
    select temp_sessions.name, temp_sessions.start_time, formula_one_events.id
    from temp_sessions
    inner join formula_one_events on temp_sessions.event_name = formula_one_events.name and formula_one_events.season = "2024"
    ;

drop table if exists temp_drivers ;
create temporary table temp_drivers(
     number integer not null,
     driver_name text not null,
     team_shortname text not null
     );

insert into temp_drivers (number, driver_name, team_shortname) values
    (10, 'Pierre Gasly', 'Alpine'),
    (31, 'Esteban Ocon', 'Alpine'),
    (14, 'Fernando Alonso', 'Aston Martin'),
    (18, 'Lance Stroll', 'Aston Martin'),
    (16, 'Charles Leclerc', 'Ferrari'),
    (55, 'Carlos Sainz Jr.', 'Ferrari'),
    (20, 'Kevin Magnussen', 'Haas'),
    (27, 'Nico Hülkenberg', 'Haas'),
    (24, 'Zhou Guanyu', 'Stake'),
    (77, 'Valtteri Bottas', 'Stake'),
    (4, 'Lando Norris', 'McLaren'),
    (81, 'Oscar Piastri', 'McLaren'),
    (44, 'Lewis Hamilton', 'Mercedes'),
    (63, 'George Russell', 'Mercedes'),
    (3, 'Daniel Ricciardo', 'Visa'),
    (22, 'Yuki Tsunoda', 'Visa'),
    (1, 'Max Verstappen', 'Red Bull'),
    (11, 'Sergio Pérez', 'Red Bull'),
    (2, 'Logan Sargeant', 'Williams'),
    (23, 'Alexander Albon', 'Williams')
    ;

insert into teams (shortname, fullname) values
    ('Alpine', 'BWT Alpine F1 Team'),
    ('Aston Martin', 'Aston Martin Aramco F1 Team'),
    ('Ferrari', 'Scuderia Ferrari'),
    ('Haas', 'MoneyGram Haas F1 Team'),
    ('Stake', 'Stake F1 Team Kick Sauber'),
    ('McLaren', 'McLaren F1 Team'),
    ('Mercedes', 'Mercedes-AMG Petronas F1 Team'),
    ('Visa', 'Visa Cash App RB F1 Team'),
    ('Red Bull', 'Oracle Red Bull Racing'),
    ('Williams', 'Williams Racing')
    ;


insert into drivers (name)
    select temp_drivers.driver_name
    from temp_drivers
    ;

insert into formula_one_entrants (number, driver, team, session) 
    select temp_drivers.number, drivers.id, teams.id, formula_one_sessions.id 
    from temp_drivers
    inner join drivers on temp_drivers.driver_name = drivers.name
    inner join teams on temp_drivers.team_shortname = teams.shortname
    cross join formula_one_sessions 
    ;