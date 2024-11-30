
insert into seasons (year) values ("2024-25") ;

INSERT INTO teams (constructor, season, fullname, shortname, color) VALUES
    ('8', '2024-25', 'TAG Heuer Porsche Formula E Team', 'Porsche', '#d5001c'),
    ('5', '2024-25', 'Maserati MSG Racing', 'Maserati', '#001489'),
    ('12', '2024-25', 'Kiro Race Co', 'Kiro', '#3c3c3c'),
    ('9', '2024-25', 'Envision Racing', 'Envision', '#00be26'),
    ('4', '2024-25', 'NEOM McLaren Formula E Team', 'McLaren', '#ff8000'),
    ('1', '2024-25', 'DS Penske', 'Penske', '#cba65f'),
    ('7', '2024-25', 'Jaguar TCS Racing', 'Jaguar', '#000000'),
    ('10', '2024-25', 'Nissan Formula E Team', 'Nissan', '#c3002f'),
    ('6', '2024-25', 'Mahindra Racing', 'Mahindra', '#dd052b'),
    ('11', '2024-25', 'Andretti Formula E', 'Andretti', '#ed3124')
    ;

insert into formula_e_constructors (name) values ("Lola");
INSERT INTO teams (constructor, season, fullname, shortname, color)
    VALUES (
        (SELECT formula_e_constructors.id FROM formula_e_constructors WHERE name = 'Lola'),
        '2024-25',
        'Lola Yamaha ABT Formula E Team',
        'Lola',
        '#194997'
        )
        ;

INSERT INTO races (round, name, country, circuit, date, season) VALUES
    (1, 'São Paulo ePrix', 'Brazil', 'São Paulo Street Circuit', '2024-12-07T10:00:00Z', '2024-25'),
    (2, 'Mexico City ePrix', 'Mexico', 'Autódromo Hermanos Rodríguez', '2025-01-11T10:00:00Z', '2024-25'),
    (3, 'Jeddah ePrix', 'Saudi Arabia', 'Jeddah Corniche Circuit', '2025-02-14T10:00:00Z', '2024-25'),
    (4, 'Jeddah ePrix', 'Saudi Arabia', 'Jeddah Corniche Circuit', '2025-02-15T10:00:00Z', '2024-25'),
    (5, 'Miami ePrix', 'United States', 'Homestead–Miami Speedway', '2025-04-12T10:00:00Z', '2024-25'),
    (6, 'Monaco ePrix', 'Monaco', 'Circuit de Monaco', '2025-05-03T10:00:00Z', '2024-25'),
    (7, 'Monaco ePrix', 'Monaco', 'Circuit de Monaco', '2025-05-04T10:00:00Z', '2024-25'),
    (8, 'Tokyo ePrix', 'Japan', 'Tokyo Street Circuit', '2025-05-17T10:00:00Z', '2024-25'),
    (9, 'Tokyo ePrix', 'Japan', 'Tokyo Street Circuit', '2025-05-18T10:00:00Z', '2024-25'),
    (10, 'Shanghai ePrix', 'China', 'Shanghai International Circuit', '2025-05-31T10:00:00Z', '2024-25'),
    (11, 'Shanghai ePrix', 'China', 'Shanghai International Circuit', '2025-06-01T10:00:00Z', '2024-25'),
    (12, 'Jakarta ePrix', 'Indonesia', 'Jakarta International e-Prix Circuit', '2025-06-21T10:00:00Z', '2024-25'),
    (13, 'Berlin ePrix', 'Germany', 'Tempelhof Airport Street Circuit', '2025-07-12T10:00:00Z', '2024-25'),
    (14, 'Berlin ePrix', 'Germany', 'Tempelhof Airport Street Circuit', '2025-07-13T10:00:00Z', '2024-25'),
    (15, 'London ePrix', 'United Kingdom', 'ExCeL London Circuit', '2025-07-26T10:00:00Z', '2024-25'),
    (16, 'London ePrix', 'United Kingdom', 'ExCeL London Circuit', '2025-07-27T10:00:00Z', '2024-25')
    ;


insert into drivers (name) values ("Zane Maloney");


WITH driver_team_pairs AS (
    SELECT 
        d.id as driver_id,
        t.id as team_id,
        CASE 
            WHEN d.name = 'Pascal Wehrlein' THEN 1
            WHEN d.name = 'António Félix da Costa' THEN 13
            WHEN d.name = 'Stoffel Vandoorne' THEN 2
            WHEN d.name = 'Jake Hughes' THEN 55
            WHEN d.name = 'David Beckmann' THEN 3
            WHEN d.name = 'Dan Ticktum' THEN 33
            WHEN d.name = 'Robin Frijns' THEN 4
            WHEN d.name = 'Sébastien Buemi' THEN 16
            WHEN d.name = 'Taylor Barnard' THEN 5
            WHEN d.name = 'Sam Bird' THEN 8
            WHEN d.name = 'Maximilian Günther' THEN 7
            WHEN d.name = 'Jean-Éric Vergne' THEN 25
            WHEN d.name = 'Mitch Evans' THEN 9
            WHEN d.name = 'Nick Cassidy' THEN 37
            WHEN d.name = 'Lucas di Grassi' THEN 11
            WHEN d.name = 'Zane Maloney' THEN 22
            WHEN d.name = 'Norman Nato' THEN 17
            WHEN d.name = 'Oliver Rowland' THEN 23
            WHEN d.name = 'Nyck de Vries' THEN 21
            WHEN d.name = 'Edoardo Mortara' THEN 48
            WHEN d.name = 'Jake Dennis' THEN 27
            WHEN d.name = 'Nico Müller' THEN 51
        END as number
    FROM drivers d
    JOIN teams t ON (
        t.season = '2024-25' AND
        CASE 
            WHEN d.name IN ('Pascal Wehrlein', 'António Félix da Costa') THEN t.fullname = 'TAG Heuer Porsche Formula E Team'
            WHEN d.name IN ('Stoffel Vandoorne', 'Jake Hughes') THEN t.fullname = 'Maserati MSG Racing'
            WHEN d.name IN ('David Beckmann', 'Dan Ticktum') THEN t.fullname = 'Kiro Race Co'
            WHEN d.name IN ('Robin Frijns', 'Sébastien Buemi') THEN t.fullname = 'Envision Racing'
            WHEN d.name IN ('Taylor Barnard', 'Sam Bird') THEN t.fullname = 'NEOM McLaren Formula E Team'
            WHEN d.name IN ('Maximilian Günther', 'Jean-Éric Vergne') THEN t.fullname = 'DS Penske'
            WHEN d.name IN ('Mitch Evans', 'Nick Cassidy') THEN t.fullname = 'Jaguar TCS Racing'
            WHEN d.name IN ('Lucas di Grassi', 'Zane Maloney') THEN t.fullname = 'Lola Yamaha ABT Formula E Team'
            WHEN d.name IN ('Norman Nato', 'Oliver Rowland') THEN t.fullname = 'Nissan Formula E Team'
            WHEN d.name IN ('Nyck de Vries', 'Edoardo Mortara') THEN t.fullname = 'Mahindra Racing'
            WHEN d.name IN ('Jake Dennis', 'Nico Müller') THEN t.fullname = 'Andretti Formula E'
        END
    )
    WHERE d.name IN (
        'Pascal Wehrlein', 'António Félix da Costa', 'Stoffel Vandoorne', 'Jake Hughes',
        'David Beckmann', 'Dan Ticktum', 'Robin Frijns', 'Sébastien Buemi',
        'Taylor Barnard', 'Sam Bird', 'Maximilian Günther', 'Jean-Éric Vergne',
        'Mitch Evans', 'Nick Cassidy', 'Lucas di Grassi', 'Zane Maloney',
        'Norman Nato', 'Oliver Rowland', 'Nyck de Vries', 'Edoardo Mortara',
        'Jake Dennis', 'Nico Müller'
    )
)
INSERT INTO entrants (number, driver, team, race)
SELECT 
    dt.number,
    dt.driver_id,
    dt.team_id,
    r.id
FROM driver_team_pairs dt
CROSS JOIN races r
WHERE r.season = '2024-25'
;


