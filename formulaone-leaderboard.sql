with
    predictions as (select * from formula_one_prediction_lines where user != "" and position <= 10),
    results as (select * from formula_one_prediction_lines where user == ""),
    scored_lines as (
    select 
        users.id as user_id,
        users.fullname as user_fullname,
        sessions.name as session_name,
        case when predictions.position <= 10 and results.position <= 10 
            then
                case when predictions.position == results.position 
                    then 4 
                    else 
                        case when predictions.position + 1 == results.position  or predictions.position - 1 == results.position
                        then 2
                        else 1
                        end
                    end +
                case when sessions.fastest_lap == true and results.fastest_lap = "true" and predictions.fastest_lap = "true" 
                    then 1
                    else 0
                    end
            else
                0
            end
            as score
        from predictions
        inner join results on results.session == predictions.session and results.entrant == predictions.entrant
        inner join formula_one_sessions as sessions on predictions.session = sessions.id
        inner join formula_one_events as events on sessions.event == events.id and events.season == "2024"
        inner join users on predictions.user = users.id
    )
select 
    user_id,
    user_fullname,
    sum(
        case when session_name == "sprint-shootout" then score else 0 end
    ) as sprint_shootout,
    sum(
        case when session_name == "sprint" then score else 0 end
    ) as sprint,
    sum(
        case when session_name == "qualifying" then score else 0 end
    ) as qualifying,
    sum(
        case when session_name == "race" then score else 0 end
    ) as race,
    sum(score) as total
    from scored_lines
    group by user_id
    order by total desc
    ;
