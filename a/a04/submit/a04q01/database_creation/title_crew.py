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

filename = '../imdb_/imdb-datasets/title.crew.tsv'
list_indices = [1, 2]  
num_fields = 3
batch_size = 1000  

crew_data = []
director_data = []
writer_data = []
count = 0

with open(filename, 'r', encoding='utf-8') as f:
    f.readline()  # Ignore header
    
    for line in f:
        count += 1
        items = line.strip().split('\t')
        newitems = [cleanup(items[i], i in list_indices) for i in range(num_fields)]
        tconst, directors, writers = newitems
        
        crew_data.append((tconst, directors, writers))

        # **Batch Insert**
        if count % batch_size == 0:
            print(f"Inserting batch {count // batch_size}...")

            # Insert crew records
            cursor.executemany("INSERT INTO crew (tconst) VALUES (%s)", [(tconst,) for tconst, _, _ in crew_data])
            
            # Retrieve inserted crew_id values
            cursor.execute("SELECT id as crew_id, tconst FROM crew WHERE tconst IN %s",
                           (tuple(tconst for tconst, _, _ in crew_data),))
            crew_map = {row["tconst"]: row["crew_id"] for row in cursor.fetchall()}  # Mapping tconst -> crew_id

            # Prepare director and writer data
            director_data = [(crew_map[tconst], director) for tconst, directors, _ in crew_data for director in directors]
            writer_data = [(crew_map[tconst], writer) for tconst, _, writers in crew_data for writer in writers]

            # Insert director and writer records
            cursor.executemany("INSERT INTO director (crew_id, director_name) VALUES (%s, %s)", director_data)
            cursor.executemany("INSERT INTO writer (crew_id, writer_name) VALUES (%s, %s)", writer_data)

            db.commit()

            # Clear lists
            crew_data.clear()
            director_data.clear()
            writer_data.clear()

# **Insert remaining data (if any)**
if crew_data:
    print("Inserting final batch...")

    cursor.executemany("INSERT INTO crew (tconst) VALUES (%s)", [(tconst,) for tconst, _, _ in crew_data])

    cursor.execute("SELECT id, tconst FROM crew WHERE tconst IN %s",
                   (tuple(tconst for tconst, _, _ in crew_data),))
    crew_map = {row["tconst"]: row["id"] for row in cursor.fetchall()}

    director_data = [(crew_map[tconst], director) for tconst, directors, _ in crew_data for director in directors]
    writer_data = [(crew_map[tconst], writer) for tconst, _, writers in crew_data for writer in writers]

    cursor.executemany("INSERT INTO director (crew_id, director_name) VALUES (%s, %s)", director_data)
    cursor.executemany("INSERT INTO writer (crew_id, writer_name) VALUES (%s, %s)", writer_data)

    db.commit()

cursor.close()
db.close()
print("Data inserted successfully!")
