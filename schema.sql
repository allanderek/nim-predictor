CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname TEXT NOT NULL,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    admin integer default 0    
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE drivers ( 
    id integer primary key autoincrement, 
    name text 
);
CREATE TABLE formula_e_constructors (
    id integer primary key autoincrement,
    name text
);
CREATE TABLE seasons (
    year text not null primary key
);
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
CREATE TABLE constructors (
    id integer primary key autoincrement,
    name text
);
CREATE TABLE formula_one_seasons (
    year text not null primary key
);
CREATE TABLE formula_one_teams ( 
    id integer primary key autoincrement, 
    fullname text, 
    shortname text,
    constructor text not null,
    season text not null,
    color text, secondary_color text,
    foreign key (season) references formula_one_seasons (year),
    foreign key (constructor) references constructors 
);
CREATE TABLE formula_one_events (
    id integer primary key autoincrement,
    round integer not null,
    name text,
    season text not null,
    cancelled integer default 0,
    foreign key (season) references formula_one_seasons (year)
);
CREATE TABLE formula_one_sessions (
    id integer primary key autoincrement,
    name text check (name in ("qualifying", "sprint-shootout", "sprint", "race")) not null,
    half_points integer default 0,
    start_time text,
    cancelled integer default 0,
    event integer not null, fastest_lap integer default 0,
    foreign key (event) references formula_one_events (id)
);
CREATE TABLE formula_one_entrants ( 
    id integer primary key autoincrement,
    number integer not null,
    driver integer not null, 
    team integer not null, 
    session integer not null,
    participating integer default 1, rank INTEGER NOT NULL DEFAULT 0,
    foreign key (driver) references drivers (id), 
    foreign key (team) references formula_one_teams (id),
    foreign key (session) references formula_one_sessions (id),
    unique (driver, team, session)
    );
CREATE TABLE formula_one_prediction_lines (
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
CREATE TABLE formula_one_season_prediction_lines (
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
    );
