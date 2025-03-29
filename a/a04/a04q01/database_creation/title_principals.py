# title_principals.py
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

filename = '../imdb_/imdb-datasets/title.principals.tsv'
num_fields = 6
batch_size = 1000

# Load existing tconsts
# cursor.execute("SELECT tconst FROM title")
# existing_tconsts = {row['tconst'] for row in cursor.fetchall()}

# # Load existing nconsts
# cursor.execute("SELECT nconst FROM name")
# existing_nconsts = {row['nconst'] for row in cursor.fetchall()}

principal_data = []
count = 0

with open(filename, 'r', encoding='utf-8') as f:
    f.readline()  # Ignore header

    for line in f:
        count += 1
        items = line.strip().split('\t')
        tconst, ordering, nconst, category, job, character_name = [cleanup(items[i]) for i in range(num_fields)]

        #if tconst not in existing_tconsts or nconst not in existing_nconsts:
        #    continue  # Skip entries with missing foreign keys

        principal_data.append((tconst, ordering, nconst, category, job, character_name))

        # Batch insert
        if count % batch_size == 0:
            print(f"Inserting batch {count // batch_size}...")

            cursor.executemany("""
                INSERT INTO principal (tconst, ordering, nconst, category, job, character_name)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, principal_data)

            db.commit()

            # Clear lists
            principal_data.clear()

# Insert remaining data
if principal_data:
    cursor.executemany("""
    INSERT INTO principal (tconst, ordering, nconst, category, job, character_name)
    VALUES (%s, %s, %s, %s, %s, %s)
    """, principal_data)

    db.commit()

cursor.close()
db.close()
print("Data inserted successfully!")
