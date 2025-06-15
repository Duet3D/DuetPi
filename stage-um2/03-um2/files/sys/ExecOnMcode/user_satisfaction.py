#!/usr/bin/env python
import psycopg2
from psycopg2 import sql

def insert_printer_data(name, board_id):
    # Parametri di connessione
    db_params = {
        'dbname': 'printer_3dforme',
        'user': 'indolab',
        'password': 'asdf',
        'host': '100.87.240.44',
        'port': 5432
    }

    try:
        # Connessione al database
        connection = psycopg2.connect(**db_params)
        cursor = connection.cursor()

        # Query di inserimento
        insert_query = sql.SQL("INSERT INTO printer (name, board_id) VALUES (%s, %s)")

        # Esecuzione della query con i parametri forniti
        cursor.execute(insert_query, (name, board_id))

        # Commit delle modifiche
        connection.commit()

        print("Dati inseriti con successo nella tabella printer")

    except Exception as error:
        print(f"Errore durante l'inserimento dei dati: {error}")

    finally:
        # Chiusura della connessione
        if cursor:
            cursor.close()
        if connection:
            connection.close()

# Esempio di utilizzo della funzione
insert_printer_data('test execonmcode', 123)