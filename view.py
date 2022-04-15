import mysql.connector
from mysql.connector import errorcode
import numpy as np
from prettytable import PrettyTable


def operations(op):
    switch={
       '1': "aujourdhui",
       '2': "faineant",
       '3': "perf",
       '4': "teachers_pet",
       '5': "top_clubs",
       '6': "top_president",
       '7': "trouble_fête",
       '8': "vaut_mieux_acheter",
       }
    return switch.get(op,'Choissisez la vue que vous voulez afficher : ')


try:
    con = mysql.connector.connect(
        user='root',
        password='root',
        host='localhost',
        database='clubs_efrei',
        port='8889')
    print("\nConnecter à la base de données\n")
except mysql.connector.Error as e:
    if e.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Mauvaises informations utilisateurs")
    elif e.errno == errorcode.ER_BAD_DB_ERROR:
        print("La base de donnée n'existe pas")
    else:
        print(e)     


rep = True
while rep == True:
    print("\nEntrez le numéro de la vue que vous voulez afficher :\n\n"
        "   1: aujourd'hui\n"
        "   2: faineant\n"
        "   3: perf\n" 
        "   4: teachers_pet\n"
        "   5: top_clubs\n"
        "   6: top_president\n"
        "   7: trouble_fête\n"
        "   8: vaut_mieux_acheter") 

    vue = operations(str(input()))
    try:
        #Donnes
        
        mycursor = con.cursor()
        mycursor.execute("select * from "+vue)
        tab = mycursor.fetchall()
        mycursor.close()
        #titre colonne
        mycursor = con.cursor()
        mycursor.execute("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '"+vue+"'")
        titre = mycursor.fetchall()
        mycursor.close()
    except mysql.connector.Error as e:
        print(e)
        continue
    
    x = PrettyTable()
    tabTitre = []
    for t in titre:
        tabTitre.append(t[0])
    x.field_names = tabTitre
    for i in tab:
        x.add_rows([i])
    print(x)
    print("\nTapez n'importe quelle touche pour continuer ou 'stop' pour arrêter")
    repStr = str(input())
    if repStr == "stop": rep = False
    else: continue

con.close()
