# Assumes that the procedured 'p' is already created in the database 'test'


import pymysql

conn = pymysql.connect(user='root', passwd='root')
cursor = conn.cursor(pymysql.cursors.DictCursor)
cursor.execute('use test')
cursor.execute("call p1(10)")
records = cursor.fetchall()

for r in records:
    print(r)
