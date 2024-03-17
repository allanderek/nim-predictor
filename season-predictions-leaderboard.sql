with
    results as (select * from formula_one_prediction_lines where user == ""),
    scored_lines as (
    select 
        sessions.name as session_name,
        case 
            when sessions.name = "race" then
                case 
                    when results.position = 1 then 25
                    when results.position = 2 then 18
                    when results.position = 3 then 15
                    when results.position = 4 then 12
                    when results.position = 5 then 10
                    when results.position = 6 then 8
                    when results.position = 7 then 6
                    when results.position = 8 then 4
                    when results.position = 9 then 2
                    when results.position = 10 then 1
                else 0
                end 
            when sessions.name = "sprint" then
                case 
                    when results.position = 1 then 8
                    when results.position = 2 then 7
                    when results.position = 3 then 6
                    when results.position = 4 then 5
                    when results.position = 5 then 4
                    when results.position = 6 then 3
                    when results.position = 7 then 2
                    when results.position = 8 then 1
                else 0
                end 
        end
        +
        case when results.fastest_lap = "true" and sessions.name == "race" then 1 else 0 end
            as score,
        teams.shortname as team_name,
        teams.id as team_id
        from results
        inner join formula_one_sessions as sessions on results.session = sessions.id
        inner join formula_one_events as events on sessions.event == events.id and events.season == "2024"
        inner join formula_one_entrants as entrants on results.entrant == entrants.id
        inner join formula_one_teams as teams on entrants.team == teams.id
    ),
    constructors as (
    select 
        row_number() over (order by sum(score) desc) as position,
        team_name,
        team_id,
        sum (score) as total
        from scored_lines
        group by team_id
        order by total desc
    ),
    predictions as (
        select
            constructors.team_id as team_id,
            constructors.total as total,
            lines.position as position,
            lines.user as user
            from constructors
            inner join formula_one_season_prediction_lines as lines on constructors.team_id = lines.team
    )
select
    predictions.position as position,
    users.id as user,
    users.fullname as fullname,
    teams.shortname as team,
    max(0, constructors.total - predictions.total) as difference
    from predictions
    inner join constructors on predictions.position = constructors.position
    inner join formula_one_teams as teams on predictions.team_id = teams.id
    inner join users on predictions.user = users.id
    order by predictions.position asc
    ;
