import sys
import csv

# Check if the correct number of command-line arguments are provided
if len(sys.argv) != 2:
    print("Usage: python convert_csv_to_sql.py <csv_file>")
    sys.exit(1)

# Parse the CSV file name from the command-line argument
csv_file = sys.argv[1]

# Define the SQL table structure
table_name = "temp_entries"
# table_name = "temp_results"
user = "James"

# Initialize variables
round_number = 0  # Start with the first round
sql_inserts = []


valid_driver_names = {
        "Stoffel Vandoorne",
        "Jean-Éric Vergne",
        "Sérgio Sette Câmara",
        "Dan Ticktum",
        "Robin Frijns",
        "Kelvin van der Linde",
        "Nico Müller",
        "Jake Hughes",
        "René Rast",
        "Maximilian Günther",
        "Edoardo Mortara",
        "Oliver Rowland",
        "Roberto Merhi",
        "Lucas di Grassi",
        "Mitch Evans",
        "Sam Bird",
        "António Félix da Costa",
        "Pascal Wehrlein",
        "Sébastien Buemi",
        "Nick Cassidy",
        "Norman Nato",
        "Sacha Fenestraz",
        "Jake Dennis",
        "André Lotterer",
        "David Beckmann",
        '' # for first-dnf
    }

unrecognised_names = []

def driver_name(driver_name):
    driver_name_mapping = {
        "Vandoorne": "Stoffel Vandoorne",
        "Eric Vergne": "Jean-Éric Vergne",
        "Sette Camara": "Sérgio Sette Câmara",
        "Dicktum": "Dan Ticktum",
        "Frijns": "Robin Frijns",
        "Van der Linde": "Kelvin van der Linde",
        "Mueller": "Nico Müller",
        "Hughes": "Jake Hughes",
        "Rast": "René Rast",
        "Gunther": "Maximilian Günther",
        "Mortara": "Edoardo Mortara",
        "Rowland": "Oliver Rowland",
        "Merhi": "Roberto Merhi",
        "di Grassi": "Lucas di Grassi",
        "Evans": "Mitch Evans",
        "Bird": "Sam Bird",
        "Da Costa": "António Félix da Costa",
        "Wehrlein": "Pascal Wehrlein",
        "Buemi": "Sébastien Buemi",
        "Cassidy": "Nick Cassidy",
        "Nato": "Norman Nato",
        "Fenestraz": "Sacha Fenestraz",
        "Dennis": "Jake Dennis",
        "Lotterer": "André Lotterer",
        "Beckmann": "David Beckmann",
        '#####': '',
    }
    converted_name = driver_name_mapping.get(driver_name, driver_name)
    if converted_name not in valid_driver_names:
        unrecognised_names.append(converted_name)

    return converted_name


try:
    with open(csv_file, 'r') as file:
        csv_reader = csv.reader(file)
        
        for row in csv_reader:
            if row[0].startswith("Round"):
                # Extract the round number from the row
                round_number = int(row[0].split(" ")[1])
            elif row[0].startswith("Prediction"): 
            # elif row[0].startswith("Actual Result"):
                # Extract prediction and actual result data
                pole = driver_name(row[1])
                first_attack_mode = driver_name(row[2])
                fastest_lap = driver_name(row[3])
                highest_grid_climber = driver_name(row[4])
                win = driver_name(row[5])
                second_place = driver_name(row[6])
                third_place = driver_name(row[7])
                first_dnf = driver_name(row[8])
                full_safety_car = (row[9]).lower()

                # Generate SQL INSERT statement
                sql_insert = f"    ('{user}', {round_number}, '{pole}', '{first_attack_mode}', '{fastest_lap}', '{highest_grid_climber}', '{win}', '{second_place}', '{third_place}', '{first_dnf}', '{full_safety_car}'),"
                # sql_insert = f"    ({round_number}, '{pole}', '{first_attack_mode}', '{fastest_lap}', '{highest_grid_climber}', '{win}', '{second_place}', '{third_place}', '{first_dnf}', '{full_safety_car}'),"
                sql_inserts.append(sql_insert)

    # Print the generated SQL INSERT statements
    print (f"insert into {table_name} (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) values")
    for sql_insert in sql_inserts:
        print(sql_insert)
    print("    ;")
    for unrecognised_name in unrecognised_names:
        print(f'Unrecognised name: {unrecognised_name}')

except FileNotFoundError:
    print(f"Error: The specified CSV file '{csv_file}' was not found.")
    sys.exit(1)

