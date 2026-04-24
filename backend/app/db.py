import pyodbc
import os
from dotenv import load_dotenv

load_dotenv()

def get_connection():
    conn = pyodbc.connect(
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={os.getenv('DB_SERVER')};"
        f"DATABASE={os.getenv('DB_NAME')};"
        f"Trusted_Connection=yes;"
    )
    return conn

def execute_query(query, params=(), fetchall=True):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    if fetchall:
        rows = cursor.fetchall()
        columns = [col[0] for col in cursor.description]
        conn.close()
        return [dict(zip(columns, row)) for row in rows]
    conn.commit()
    conn.close()
