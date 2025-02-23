alter table formula_one_sessions add column fastest_lap integer default 0;

-- Update 2024 sessions - set fastest_lap to 1 for race sessions
update formula_one_sessions
set fastest_lap = 1
where name = 'race'
and event in (
    select id from formula_one_events where season = '2024'
);

-- For completeness, ensure all 2025 sessions have fastest_lap set to 0
update formula_one_sessions
set fastest_lap = 0
where event in (
    select id from formula_one_events where season = '2025'
);
