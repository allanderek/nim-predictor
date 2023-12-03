with
    race_entrants as
    ( select entrants.id, drivers.name
      from entrants
      inner join drivers on entrants.driver = drivers.id
      where race = 17
    )
    select 
        users.username, 
        pole_entrants.id, pole_entrants.name,
        fam_entrants.id, fam_entrants.name,
        fl_entrants.id, fl_entrants.name,
        hgc_entrants.id, hgc_entrants.name,
        first_entrants.id, first_entrants.name,
        second_entrants.id, second_entrants.name,
        third_entrants.id, third_entrants.name,
        fdnf_entrants.id, fdnf_entrants.name,
        predictions.safety_car
    from predictions
    inner join users on predictions.user = users.id 
    inner join race_entrants as pole_entrants on pole_entrants.id == predictions.pole
    inner join race_entrants as fam_entrants on fam_entrants.id == predictions.fam
    inner join race_entrants as fl_entrants on fl_entrants.id == predictions.fl
    inner join race_entrants as hgc_entrants on hgc_entrants.id == predictions.hgc
    inner join race_entrants as first_entrants on first_entrants.id == predictions.first
    inner join race_entrants as second_entrants on second_entrants.id == predictions.second
    inner join race_entrants as third_entrants on third_entrants.id == predictions.third
    inner join race_entrants as fdnf_entrants on fdnf_entrants.id == predictions.fdnf
    ;
