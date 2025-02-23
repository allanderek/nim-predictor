-- SQL Statements
insert into formula_one_events 
            (round, name, season) 
            values 
            (1, 'Australian Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-03-16T04:00:00Z', (select id from formula_one_events where name = 'Australian Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-03-15T05:00:00Z', (select id from formula_one_events where name = 'Australian Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (2, 'Chinese Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-03-23T07:00:00Z', (select id from formula_one_events where name = 'Chinese Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-03-22T07:00:00Z', (select id from formula_one_events where name = 'Chinese Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint', '2025-03-22T03:00:00Z', (select id from formula_one_events where name = 'Chinese Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint-shootout', '2025-03-21T07:30:00Z', (select id from formula_one_events where name = 'Chinese Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (3, 'Japanese Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-04-06T06:00:00Z', (select id from formula_one_events where name = 'Japanese Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-04-05T07:00:00Z', (select id from formula_one_events where name = 'Japanese Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (4, 'Bahrain Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-04-13T16:00:00Z', (select id from formula_one_events where name = 'Bahrain Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-04-12T17:00:00Z', (select id from formula_one_events where name = 'Bahrain Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (5, 'Saudi Arabian Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-04-20T18:00:00Z', (select id from formula_one_events where name = 'Saudi Arabian Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-04-19T18:00:00Z', (select id from formula_one_events where name = 'Saudi Arabian Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (6, 'Miami Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-05-04T21:00:00Z', (select id from formula_one_events where name = 'Miami Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-05-03T21:00:00Z', (select id from formula_one_events where name = 'Miami Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint', '2025-05-03T17:00:00Z', (select id from formula_one_events where name = 'Miami Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint-shootout', '2025-05-02T21:30:00Z', (select id from formula_one_events where name = 'Miami Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (7, 'Emilia Romagna Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-05-18T14:00:00Z', (select id from formula_one_events where name = 'Emilia Romagna Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-05-17T15:00:00Z', (select id from formula_one_events where name = 'Emilia Romagna Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (8, 'Monaco Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-05-25T14:00:00Z', (select id from formula_one_events where name = 'Monaco Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-05-24T15:00:00Z', (select id from formula_one_events where name = 'Monaco Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (9, 'Spanish Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-06-01T14:00:00Z', (select id from formula_one_events where name = 'Spanish Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-05-31T15:00:00Z', (select id from formula_one_events where name = 'Spanish Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (10, 'Canadian Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-06-15T19:00:00Z', (select id from formula_one_events where name = 'Canadian Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-06-14T21:00:00Z', (select id from formula_one_events where name = 'Canadian Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (11, 'Austrian Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-06-29T14:00:00Z', (select id from formula_one_events where name = 'Austrian Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-06-28T15:00:00Z', (select id from formula_one_events where name = 'Austrian Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (12, 'British Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-07-06T15:00:00Z', (select id from formula_one_events where name = 'British Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-07-05T15:00:00Z', (select id from formula_one_events where name = 'British Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (13, 'Belgian Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-07-27T14:00:00Z', (select id from formula_one_events where name = 'Belgian Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-07-26T15:00:00Z', (select id from formula_one_events where name = 'Belgian Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint', '2025-07-26T11:00:00Z', (select id from formula_one_events where name = 'Belgian Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint-shootout', '2025-07-25T15:30:00Z', (select id from formula_one_events where name = 'Belgian Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (14, 'Hungarian Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-08-03T14:00:00Z', (select id from formula_one_events where name = 'Hungarian Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-08-02T15:00:00Z', (select id from formula_one_events where name = 'Hungarian Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (15, 'Dutch Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-08-31T14:00:00Z', (select id from formula_one_events where name = 'Dutch Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-08-30T14:00:00Z', (select id from formula_one_events where name = 'Dutch Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (16, 'Italian Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-09-07T14:00:00Z', (select id from formula_one_events where name = 'Italian Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-09-06T15:00:00Z', (select id from formula_one_events where name = 'Italian Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (17, 'Azerbaijan Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-09-21T12:00:00Z', (select id from formula_one_events where name = 'Azerbaijan Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-09-20T13:00:00Z', (select id from formula_one_events where name = 'Azerbaijan Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (18, 'Singapore Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-10-05T13:00:00Z', (select id from formula_one_events where name = 'Singapore Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-10-04T14:00:00Z', (select id from formula_one_events where name = 'Singapore Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (19, 'United States Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-10-19T20:00:00Z', (select id from formula_one_events where name = 'United States Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-10-18T22:00:00Z', (select id from formula_one_events where name = 'United States Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint', '2025-10-18T18:00:00Z', (select id from formula_one_events where name = 'United States Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint-shootout', '2025-10-17T22:30:00Z', (select id from formula_one_events where name = 'United States Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (20, 'Mexico City Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-10-26T20:00:00Z', (select id from formula_one_events where name = 'Mexico City Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-10-25T22:00:00Z', (select id from formula_one_events where name = 'Mexico City Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (21, 'São Paulo Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-11-09T17:00:00Z', (select id from formula_one_events where name = 'São Paulo Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-11-08T18:00:00Z', (select id from formula_one_events where name = 'São Paulo Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint', '2025-11-08T14:00:00Z', (select id from formula_one_events where name = 'São Paulo Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint-shootout', '2025-11-07T18:30:00Z', (select id from formula_one_events where name = 'São Paulo Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (22, 'Las Vegas Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-11-22T04:00:00Z', (select id from formula_one_events where name = 'Las Vegas Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-11-22T04:00:00Z', (select id from formula_one_events where name = 'Las Vegas Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (23, 'Qatar Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-11-30T16:00:00Z', (select id from formula_one_events where name = 'Qatar Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-11-29T18:00:00Z', (select id from formula_one_events where name = 'Qatar Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint', '2025-11-29T14:00:00Z', (select id from formula_one_events where name = 'Qatar Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint-shootout', '2025-11-28T17:30:00Z', (select id from formula_one_events where name = 'Qatar Grand Prix' and season = '2025'));
insert into formula_one_events 
            (round, name, season) 
            values 
            (24, 'Abu Dhabi Grand Prix', '2025');
insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '2025-12-07T13:00:00Z', (select id from formula_one_events where name = 'Abu Dhabi Grand Prix' and season = '2025'));
insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '2025-12-06T14:00:00Z', (select id from formula_one_events where name = 'Abu Dhabi Grand Prix' and season = '2025'));
