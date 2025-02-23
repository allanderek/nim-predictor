insert into formula_one_entrants (number, driver, team, session, rank)
select 
    d.number,
    d.driver_id,
    d.team_id,
    s.id as session_id,
    d.rank
from (
    select 
        7 as number, (select id from drivers where name = 'Jack Doohan') as driver_id, (select id from formula_one_teams where shortname = 'Alpine' and season = '2025') as team_id, 9 as rank union all
    select 10, (select id from drivers where name = 'Pierre Gasly'), (select id from formula_one_teams where shortname = 'Alpine' and season = '2025'), 10 union all
    select 14, (select id from drivers where name = 'Fernando Alonso'), (select id from formula_one_teams where shortname = 'Aston Martin' and season = '2025'), 12 union all
    select 18, (select id from drivers where name = 'Lance Stroll'), (select id from formula_one_teams where shortname = 'Aston Martin' and season = '2025'), 11 union all
    select 16, (select id from drivers where name = 'Charles Leclerc'), (select id from formula_one_teams where shortname = 'Ferrari' and season = '2025'), 20 union all
    select 44, (select id from drivers where name = 'Lewis Hamilton'), (select id from formula_one_teams where shortname = 'Ferrari' and season = '2025'), 19 union all
    select 31, (select id from drivers where name = 'Esteban Ocon'), (select id from formula_one_teams where shortname = 'Haas' and season = '2025'), 4 union all
    select 87, (select id from drivers where name = 'Oliver Bearman'), (select id from formula_one_teams where shortname = 'Haas' and season = '2025'), 3 union all
    select 5, (select id from drivers where name = 'Gabriel Bortoleto'), (select id from formula_one_teams where shortname = 'Stake' and season = '2025'), 1 union all
    select 27, (select id from drivers where name = 'Nico Hülkenberg'), (select id from formula_one_teams where shortname = 'Stake' and season = '2025'), 2 union all
    select 4, (select id from drivers where name = 'Lando Norris'), (select id from formula_one_teams where shortname = 'McLaren' and season = '2025'), 18 union all
    select 81, (select id from drivers where name = 'Oscar Piastri'), (select id from formula_one_teams where shortname = 'McLaren' and season = '2025'), 17 union all
    select 12, (select id from drivers where name = 'Andrea Kimi Antonelli'), (select id from formula_one_teams where shortname = 'Mercedes' and season = '2025'), 13 union all
    select 63, (select id from drivers where name = 'George Russell'), (select id from formula_one_teams where shortname = 'Mercedes' and season = '2025'), 14 union all
    select 6, (select id from drivers where name = 'Isack Hadjar'), (select id from formula_one_teams where shortname = 'Racing Bulls' and season = '2025'), 6 union all
    select 22, (select id from drivers where name = 'Yuki Tsunoda'), (select id from formula_one_teams where shortname = 'Racing Bulls' and season = '2025'), 5 union all
    select 1, (select id from drivers where name = 'Max Verstappen'), (select id from formula_one_teams where shortname = 'Red Bull' and season = '2025'), 16 union all
    select 30, (select id from drivers where name = 'Liam Lawson'), (select id from formula_one_teams where shortname = 'Red Bull' and season = '2025'), 15 union all
    select 23, (select id from drivers where name = 'Alexander Albon'), (select id from formula_one_teams where shortname = 'Williams' and season = '2025'), 7 union all
    select 55, (select id from drivers where name = 'Carlos Sainz Jr.'), (select id from formula_one_teams where shortname = 'Williams' and season = '2025'), 8
) d
cross join formula_one_sessions s
where s.event in (
    select id from formula_one_events where season = '2025'
);
