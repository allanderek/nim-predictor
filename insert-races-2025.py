import json

def generate_sql_statements(json_data):
    # Extract the races list
    races = json_data['MRData']['RaceTable']['Races']
    
    all_statements = []
    
    for race in races:
        # Create the event insert
        event_sql = f"""insert into formula_one_events 
            (round, name, season) 
            values 
            ({race['round']}, '{race['raceName']}', '{race['season']}');"""
        all_statements.append(event_sql)
        
        # Base subquery to get the event id
        event_subquery = f"(select id from formula_one_events where name = '{race['raceName']}' and season = '{race['season']}')"
        
        # Add the main race session
        race_time = f"{race['date']}T{race['time']}"
        session_sql = f"""insert into formula_one_sessions 
            (name, start_time, event) 
            values 
            ('race', '{race_time}', {event_subquery});"""
        all_statements.append(session_sql)
        
        # Add qualifying if present
        if 'Qualifying' in race:
            quali_time = f"{race['Qualifying']['date']}T{race['Qualifying']['time']}"
            session_sql = f"""insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('qualifying', '{quali_time}', {event_subquery});"""
            all_statements.append(session_sql)
        
        # Add sprint if present
        if 'Sprint' in race:
            sprint_time = f"{race['Sprint']['date']}T{race['Sprint']['time']}"
            session_sql = f"""insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint', '{sprint_time}', {event_subquery});"""
            all_statements.append(session_sql)
        
        # Add sprint qualifying (shootout) if present
        if 'SprintQualifying' in race:
            sprint_quali_time = f"{race['SprintQualifying']['date']}T{race['SprintQualifying']['time']}"
            session_sql = f"""insert into formula_one_sessions 
                (name, start_time, event) 
                values 
                ('sprint-shootout', '{sprint_quali_time}', {event_subquery});"""
            all_statements.append(session_sql)

    return all_statements

def print_sql_statements(json_file_path):
    with open(json_file_path, 'r') as f:
        data = json.load(f)
    
    statements = generate_sql_statements(data)
    
    print("-- SQL Statements")
    for stmt in statements:
        print(stmt)

print_sql_statements('races-2025.json')
