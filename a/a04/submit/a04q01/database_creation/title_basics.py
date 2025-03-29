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
    cursorclass=pymysql.cursors.DictCursor
)
cursor = db.cursor()

filename = '../imdb_/imdb-datasets/title.basics.tsv'
list_indices = [8]  # Genre field is a list
num_fields = 9
count = 0
batch_size = 1000  # Insert data in batches

# **Step 1: Preload genre names into a Python dictionary**
cursor.execute("SELECT id, name FROM genre")
genre_dict = {row['name']: row['id'] for row in cursor.fetchall()}

# Open file for reading
with open(filename, 'r', encoding='utf-8') as f:
    f.readline()  # Ignore header
    
    title_data = []
    title_genre_data = []
    
    for line in f:
        count += 1
        print(count)
        items = line.strip().split('\t')
        newitems = [cleanup(items[i], i in list_indices) for i in range(num_fields)]
        tconst, title_type, primary_title, original_title, is_adult, start_year, end_year, runtime_minutes, genres = newitems

        # Ensure is_adult is stored as a BIT-compatible value (binary format)
        is_adult = b'\x01' if is_adult == '1' else b'\x00'

        # Collect title insert data
        title_data.append((tconst, title_type, primary_title, original_title, is_adult, start_year, end_year, runtime_minutes))

        # Process genres
        for genre in genres:
            if genre not in genre_dict:
                cursor.execute("INSERT INTO genre (name) VALUES (%s)", (genre,))
                db.commit()
                genre_dict[genre] = cursor.lastrowid
            
            title_genre_data.append((tconst, genre_dict[genre]))

        # **Step 2: Batch Insert**
        if count % batch_size == 0:
            print(f"Inserting batch {count // batch_size}...")
            cursor.executemany("""
                INSERT INTO title (tconst, title_type, primary_title, original_title, is_adult, start_year, end_year, runtime_minutes)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, title_data)
            cursor.executemany("""
                INSERT INTO titles_basic_genre (tconst, genre_id) VALUES (%s, %s)
            """, title_genre_data)
            db.commit()

            # Clear lists to free up memory
            title_data.clear()
            title_genre_data.clear()

    # **Insert remaining data (if any)**
    if title_data:
        cursor.executemany("""
            INSERT INTO title (tconst, title_type, primary_title, original_title, is_adult, start_year, end_year, runtime_minutes)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, title_data)
        cursor.executemany("""
            INSERT INTO titles_basic_genre (tconst, genre_id) VALUES (%s, %s)
        """, title_genre_data)
        db.commit()

db.close()
print("Data inserted successfully!")
