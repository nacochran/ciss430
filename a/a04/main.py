# main.py
# Description: Reads data from name.basics.tsv and converts a line of data in the text file to a python list of values where each value is a string, None, or a list of strings

# Resources & Tips:
# head -n 100 ../imdb_/imdb-datasets/title.principals.tsv > title_principals.txt 


def cleanup(x, islist=False):
    x = x.replace('\n', '')
    if x == r'\N':
        if islist:
            x = []
        else: x = None
    elif islist:
        x = x.split(',')
        if x == ['']: x = []
    return x

#==============================================================================
# Demonstrates how to read name.basics.tsv and for each line of text, convert
# it into a list of values where each value is a string or list of strings. The
# list is printed.
#==============================================================================
filename = 'imdb_/imdb-datasets/title.crew.tsv'
list_indices = [] # indices where the value should be a list
num_fields = 3 # number of fields
max_count = 25 # how many rows do you want to collect?

f = open(filename, 'r')

f.readline() # ignore first line
professions = set([]) # professions as a set

count = 0
for line in f:
    count += 1
    if count % 1000000 == 0:
        print(count)

    items = line.split('\t')
    newitems = []
    for index, item in enumerate(items):
        if index not in list_indices:
            newitems.append(cleanup(item))
        else:
            newitems.append(cleanup(item, islist=True))
    items = newitems

    if len(items) != num_fields:
        print("This row does not have", num_fields, "fields:", items)

    try:
        professions |= set(items[4])
    except Exception as e:
        print("Exception:", e)
        print("items:", items)

    print(items)
    if count > max_count:
        break

professions = list(professions) # convert professions to a list
print("professions", professions)
