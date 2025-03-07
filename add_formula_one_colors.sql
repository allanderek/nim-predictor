ALTER TABLE formula_one_teams
ADD COLUMN secondary_color text;

-- Mercedes
UPDATE formula_one_teams
SET color = '#000000', secondary_color = '#27F4D2'
WHERE id = 18 AND season = '2025';

-- Red Bull Racing
UPDATE formula_one_teams
SET color = '#3671C6', secondary_color = '#1B3963'
WHERE id = 11 AND season = '2025';

-- Ferrari
UPDATE formula_one_teams
SET color = '#DC0000', secondary_color = '#DC0000'
WHERE id = 14 AND season = '2025';

-- McLaren
UPDATE formula_one_teams
SET color = '#FF8700', secondary_color = '#0055FF'
WHERE id = 17 AND season = '2025';

-- Aston Martin
UPDATE formula_one_teams
SET color = '#006C66', secondary_color = '#DFFF00'
WHERE id = 13 AND season = '2025';

-- Alpine
UPDATE formula_one_teams
SET color = '#FF69B4', secondary_color = '#0055A4'
WHERE id = 12 AND season = '2025';

-- Williams
UPDATE formula_one_teams
SET color = '#041E42', secondary_color = '#00A3E0'
WHERE id = 20 AND season = '2025';

-- Haas
UPDATE formula_one_teams
SET color = '#000000', secondary_color = '#E10600'
WHERE id = 15 AND season = '2025';

-- Stake (Sauber)
UPDATE formula_one_teams
SET color = '#000000', secondary_color = '#00FF00'
WHERE id = 16 AND season = '2025';

-- Racing Bulls (RB)
UPDATE formula_one_teams
SET color = '#FFFFFF', secondary_color = '#FF0000'
WHERE id = 19 AND season = '2025';
