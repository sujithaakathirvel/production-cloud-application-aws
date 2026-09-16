from flask import Flask, jsonify, render_template
import os
from routes.tasks import tasks_bp
import psycopg2

app = Flask(__name__)

def get_db_connection():
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        database=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"]
    )

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "service": "pipeline working "
    })

@app.route("/db-test")
def db_test():
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("""
        CREATE TABLE IF NOT EXISTS test (
            id SERIAL PRIMARY KEY,
            name TEXT
        );
    """)

    cur.execute("INSERT INTO test (name) VALUES ('Suji ');")
    conn.commit()

    cur.execute("SELECT * FROM test;")
    rows = cur.fetchall()

    cur.close()
    conn.close()

    return {"data": rows}

app.register_blueprint(tasks_bp, url_prefix="/tasks")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

    