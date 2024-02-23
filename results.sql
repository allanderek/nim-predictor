
with
race_entrants as
( select entrants.id, drivers.name
  from entrants
  inner join drivers on entrants.driver = drivers.id
)
select
   results.race,
   pole_entrants.name as pole,
   fam_entrants.name as fam,
   fl_entrants.name as fl,
   hgc_entrants.name as hgc,
   first_entrants.name as first,
   second_entrants.name as second,
   third_entrants.name as third,
   fdnf_entrants.name as fdnf,
   results.safety_car 
from
results
inner join races on results.race = races.id
inner join race_entrants as pole_entrants on pole_entrants.id == results.pole
inner join race_entrants as fam_entrants on fam_entrants.id == results.fam
inner join race_entrants as fl_entrants on fl_entrants.id == results.fl
inner join race_entrants as hgc_entrants on hgc_entrants.id == results.hgc
inner join race_entrants as first_entrants on first_entrants.id == results.first
inner join race_entrants as second_entrants on second_entrants.id == results.second
inner join race_entrants as third_entrants on third_entrants.id == results.third
inner join race_entrants as fdnf_entrants on fdnf_entrants.id == results.fdnf
where races.season = "2023-24"
;
