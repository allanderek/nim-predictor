with
race_entrants as
( select entrants.id, drivers.name
  from entrants
  inner join drivers on entrants.driver = drivers.id
)
select
   users.fullname,
   predictions.race,
   pole_entrants.name as pole,
   fam_entrants.name as fam,
   fl_entrants.name as fl,
   hgc_entrants.name as hgc,
   first_entrants.name as first,
   second_entrants.name as second,
   third_entrants.name as third,
   fdnf_entrants.name as fdnf,
   predictions.safety_car 
from
predictions
inner join users on predictions.user = users.id
inner join races on predictions.race = races.id
inner join race_entrants as pole_entrants on pole_entrants.id == predictions.pole
inner join race_entrants as fam_entrants on fam_entrants.id == predictions.fam
inner join race_entrants as fl_entrants on fl_entrants.id == predictions.fl
inner join race_entrants as hgc_entrants on hgc_entrants.id == predictions.hgc
inner join race_entrants as first_entrants on first_entrants.id == predictions.first
inner join race_entrants as second_entrants on second_entrants.id == predictions.second
inner join race_entrants as third_entrants on third_entrants.id == predictions.third
inner join race_entrants as fdnf_entrants on fdnf_entrants.id == predictions.fdnf
where races.season = "2023-24"
;


-- insert into temp_entries (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) values
