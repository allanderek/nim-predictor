drop table if exists users ;
drop table if exists drivers ;
drop table if exists teams ;

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
insert into drivers (name) values ("Max Verstappen");
insert into drivers (name) values ("Charles Leclerc");

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
    parent integer not null,
    fastest_lap integer,
    position integer,
    entrant integer not null,
    foreign key (parent) references formula_one_predictions (id),
    foreign key (entrant) references formula_one_entrants (id)
    unique(user, session, position)
);

