# name_basics.py
# Nathan Cochran

import pymysql

def cleanup(x, islist=False):
    x = x.strip()
    if x == r'\N':
        return [] if islist else None
    elif islist:
        x = x.split(',')
        return [item.strip() for item in x if item]
    return x

# Connect to MySQL
db = pymysql.connect(
    host="localhost",
    user="root", 
    password="root", 
    database="movie_db",
    charset='utf8mb4',
    cursorclass=pymysql.cursors.DictCursor
)
cursor = db.cursor()

filename = '../imdb_/imdb-datasets/name.basics.tsv'
list_indices = [4, 5]  # Professions and known titles are lists
num_fields = 6
batch_size = 1000

# Preload professions into a dictionary to avoid redundant queries
cursor.execute("SELECT id, job_desc FROM profession")
profession_dict = {row['job_desc']: row['id'] for row in cursor.fetchall()}

# Create dict for titles to ensure no data inconsistencies exist in our
# database (known_title requires title exists)
existing_tconsts = set()
batch_size_t = 10000
offset = 0
while True:
    cursor.execute(f"SELECT tconst FROM title LIMIT {batch_size_t} OFFSET {offset}")
    rows = cursor.fetchall()
    
    if not rows:  # Stop when no more rows are returned
        break
    
    # Add tconst values to the set
    existing_tconsts.update(row['tconst'] for row in rows)

    # Move to the next batch
    offset += batch_size_t
    print(offset)



name_data = []
name_basic_profession_data = []
known_title_data = []
count = 0

with open(filename, 'r', encoding='utf-8') as f:
    f.readline()  # Ignore header
    
    for line in f:
        count += 1
        items = line.strip().split('\t')
        newitems = [cleanup(items[i], i in list_indices) for i in range(num_fields)]
        nconst, full_name, birth_year, death_year, professions, known_titles = newitems

        # Split full_name into first_name and last_name
        name_parts = full_name.split(' ', 1)
        first_name = name_parts[0] if name_parts else None
        last_name = name_parts[1] if len(name_parts) > 1 else None

        # Collect name data
        name_data.append((nconst, first_name, last_name, birth_year, death_year))

        # Process professions
        for profession in professions:
            if profession not in profession_dict:
                cursor.execute("INSERT INTO profession (job_desc) VALUES (%s)", (profession,))
                db.commit()
                profession_dict[profession] = cursor.lastrowid
            
            name_basic_profession_data.append((nconst, profession_dict[profession]))
            
        # Process known titles
        for tconst in known_titles:
            if tconst in existing_tconsts:
                known_title_data.append((nconst, tconst))

        # **Batch Insert**
        if count % batch_size == 0:
            print(f"Inserting batch {count // batch_size}...")

            cursor.executemany("""
                INSERT INTO name (nconst, first_name, last_name, year_of_birth, year_of_death)
                VALUES (%s, %s, %s, %s, %s)
            """, name_data)

            cursor.executemany("""
                INSERT INTO name_basic_profession (nconst, profession_id) 
                VALUES (%s, %s)
            """, name_basic_profession_data)

            cursor.executemany("""
                INSERT INTO known_title (nconst, tconst) VALUES (%s, %s)
            """, known_title_data)

            db.commit()

            # Clear lists to free up memory
            name_data.clear()
            name_basic_profession_data.clear()
            known_title_data.clear()

# **Insert remaining data (if any)**
if name_data:
    cursor.executemany("""
        INSERT INTO name (nconst, first_name, last_name, year_of_birth, year_of_death)
        VALUES (%s, %s, %s, %s, %s)
    """, name_data)

    cursor.executemany("""
        INSERT INTO name_basic_profession (nconst, profession_id) 
        VALUES (%s, %s)
    """, name_basic_profession_data)

    cursor.executemany("""
        INSERT INTO known_title (nconst, tconst) VALUES (%s, %s)
    """, known_title_data)

    db.commit()

cursor.close()
db.close()
print("Data inserted successfully!")
