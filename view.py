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
    print("Connecter à la base de donnée")
except mysql.connector.Error as e:
    if e.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Mauvaises informations utilisateurs")
    elif e.errno == errorcode.ER_BAD_DB_ERROR:
        print("La base de donnée n'existe pas")
    else:
        print(e)     


rep = True
while rep == True:
    print("Entrer le numéro de la vue que vous voulez afficher :\n"
        "aujourd'hui (1)\n"
        "faineant(2)\n"
        "perf(3)\n" 
        "teachers_pet(4)\n"
        "top_clubs(5)\n"
        "top_president(6)\n"
        "trouble_fête(7)\n"
        "vaut_mieux_acheter(8)") 

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
    print("Voulez-vous en afficher une autre ? (oui/non)")
    repStr = str(input())
    if repStr == "non": rep = False
    elif repStr == "oui": rep=True
    else: continue

con.close()
