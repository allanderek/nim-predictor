drop table if exists formula_one_teams ;
drop table if exists formula_one_seasons ;
drop table if exists formula_one_events ;
drop table if exists formula_one_sessions ;
drop table if exists formula_one_entrants ;
drop table if exists formula_one_prediction_lines ;
drop table if exists constructors ;
drop table if exists formula_one_season_prediction_lines ;

create table constructors (
    id integer primary key autoincrement,
    name text
);

create table formula_one_seasons (
    year text not null primary key
);

create table formula_one_teams ( 
    id integer primary key autoincrement, 
    fullname text, 
    shortname text,
    constructor text not null,
    season text not null,
    color text,
    foreign key (season) references formula_one_seasons (year),
    foreign key (constructor) references constructors 
);

create table formula_one_events (
    id integer primary key autoincrement,
    round integer not null,
    name text,
    season text not null,
    cancelled integer default 0,
    foreign key (season) references formula_one_seasons (year)
);

create table formula_one_sessions (
    id integer primary key autoincrement,
    name text check (name in ("qualifying", "sprint-shootout", "sprint", "race")) not null,
    half_points integer default 0,
    start_time text,
    cancelled integer default 0,
    event integer not null,
    foreign key (event) references formula_one_events (id)
);


create table formula_one_entrants ( 
    id integer primary key autoincrement,
    number integer not null,
    driver integer not null, 
    team integer not null, 
    session integer not null,
    participating integer default 1,
    foreign key (driver) references drivers (id), 
    foreign key (team) references formula_one_teams (id),
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
    foreign key (entrant) references formula_one_entrants (id),
    foreign key (session) references formula_one_sessions (id),
    unique(user, session, position)
);

insert into formula_one_seasons (year) values ("2024");
insert into formula_one_events (round, name, season) values
    (1, "Bahrain Grand Prix", "2024"),
    (2, "Saudi Arabian Grand Prix", "2024"),
    (3, "Australian Grand Prix", "2024"),
    (4, "Japanese Grand Prix", "2024"),
    (5, "Chinese Grand Prix", "2024"),
    (6, "Miami Grand Prix", "2024"),
    (7, "Emilia Romagna Grand Prix", "2024"),
    (8, "Monaco Grand Prix", "2024"),
    (9, "Canadian Grand Prix", "2024"),
    (10, "Spanish Grand Prix", "2024"),
    (11, "Austrian Grand Prix", "2024"),
    (12, "British Grand Prix", "2024"),
    (13, "Hungarian Grand Prix", "2024"),
    (14, "Belgian Grand Prix", "2024"),
    (15, "Dutch Grand Prix", "2024"),
    (16, "Italian Grand Prix", "2024"),
    (17, "Azerbaijan Grand Prix", "2024"),
    (18, "Singapore Grand Prix", "2024"),
    (19, "United States Grand Prix", "2024"),
    (20, "Mexico City Grand Prix", "2024"),
    (21, "São Paulo Grand Prix", "2024"),
    (22, "Las Vegas Grand PriX", "2024"),
    (23, "Qatar Grand Prix", "2024"),
    (24, "Abu Dhabi Grand Prix", "2024")
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

drop table if exists temp_teams ;
create temporary table temp_teams(
     shortname text not null,
     fullname text not null,
     constructor text not null
     );

insert into temp_teams (shortname, fullname, constructor) values
    ('Alpine', 'BWT Alpine F1 Team', 'Renault'),
    ('Aston Martin', 'Aston Martin Aramco F1 Team', 'Aston Martin'),
    ('Ferrari', 'Scuderia Ferrari', 'Ferrari'),
    ('Haas', 'MoneyGram Haas F1 Team', 'Haas'),
    ('Stake', 'Stake F1 Team Kick Sauber', 'Sauber'),
    ('McLaren', 'McLaren F1 Team', 'McLaren'),
    ('Mercedes', 'Mercedes-AMG Petronas F1 Team', 'Mercedes'),
    ('Visa', 'Visa Cash App RB F1 Team', 'Torro Rosso'),
    ('Red Bull', 'Oracle Red Bull Racing', 'Red Bull'),
    ('Williams', 'Williams Racing', 'Williams')
    ;

insert into constructors (name)
    select temp_teams.constructor
    from temp_teams
    ;

insert into formula_one_teams (fullname, shortname, constructor, season)
    select temp_teams.fullname, temp_teams.shortname, constructors.id, "2024"
    from temp_teams
    inner join constructors on temp_teams.constructor = constructors.name
    ;
drop table temp_teams;


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

insert into drivers (name)
    select temp_drivers.driver_name
    from temp_drivers
    ;

insert into formula_one_entrants (number, driver, team, session) 
    select temp_drivers.number, drivers.id, formula_one_teams.id, formula_one_sessions.id 
    from temp_drivers
    inner join drivers on temp_drivers.driver_name = drivers.name
    cross join formula_one_sessions 
    inner join formula_one_teams on temp_drivers.team_shortname = formula_one_teams.shortname
    ;


create table formula_one_season_prediction_lines (
    -- In prediction lines, this can be null which represents a result, but here we calculate the
    -- results from each of the season results so we never explicitly enter the 'results'. Aside from
    -- which if we were to enter them then it would need to contain the points whereas here we just record
    -- the position.
    -- Also note there are several other constraints we could add here. You cannot have the same team twice
    -- in the same season (though, note, *during* the update that would be true).
    -- More importantly the 'season' of team must match that of the season, I'm not sure if we can specify such a constraint.
    user integer not null,
    season text not null,
    position integer check (position >= 1 and position <= 10),
    team integer not null,
    foreign key (user) references users (id),
    foreign key (season) references formula_one_seasons (year),
    foreign key (team) references formula_one_teams (id),
    unique(user, season, position)
    )
    ;
