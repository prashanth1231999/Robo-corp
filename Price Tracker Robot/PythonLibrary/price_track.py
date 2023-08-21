import tkinter as tk
from tkinter import messagebox
import datetime
import sqlite3
import csv


def price_drop_notification():
    # Create a root window (you can make it invisible)
    root = tk.Tk()
    root.withdraw()

    # Display a notification
    messagebox.showinfo("Notification", "Price Drop")

    # Close the root window
    root.destroy()



# Open the file in append mode and write the data
def append_to_the_csv(file_path, product, price):
    with open(file_path, "a") as file:
        # Add a newline character to separate rows
        datetime_obj = datetime.datetime.now()
        file.write(f'{datetime_obj}, {product}, {price}' + "\n")

def write_to_database():
    db_file = 'stores.db'

    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()

    # Create a table if it doesn't exist
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS prices (
            date TEXT,
            product_name TEXT,
            current_price TEXT
        )
    ''')

    #writing to the csv 
    csv_file = 'prices.csv'

    with open(csv_file, 'r') as file:
        csv_reader = csv.reader(file)
        for row in csv_reader:
            cursor.execute('''
                INSERT INTO prices (date, product_name, current_price)
                VALUES (?, ?, ?)
            ''', row)

    # Commit the changes and close the database connection
    conn.commit()
    conn.close()




