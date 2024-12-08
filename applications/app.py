from flask import Flask, request, jsonify
import psycopg2
import redis
import logging
import os

app = Flask(__name__)

# PostgreSQL bağlantısı
pg_conn = psycopg2.connect(
    dbname=os.environ.get('POSTGRES_DBNAME', 'default_db'),  # Eğer environment variable yoksa default değer kullanılır
    user=os.environ.get('POSTGRES_USER', 'default_user'),
    password=os.environ.get('POSTGRES_PASSWORD', 'default_password'),
    host=os.environ.get('POSTGRES_HOST', 'localhost'),
    port=os.environ.get('POSTGRES_PORT', 5432)
)

# Redis bağlantısı
redis_client = redis.StrictRedis(
    host=os.environ.get('REDIS_HOST', 'localhost'),
    port=os.environ.get('REDIS_PORT', 6379),
    password=os.environ.get('REDIS_PASSWORD', 'default_password'),
    decode_responses=True 
)

@app.route('/set_cache', methods=['POST'])
def set_cache():
    data = request.json
    redis_client.set(data['key'], data['value'])
    app.logger.info(f"Cache set: {data['key']} = {data['value']}")
    return jsonify({"message": "Cache set successfully"})

@app.route('/get_cache/<key>', methods=['GET'])
def get_cache(key):
    value = redis_client.get(key)
    return jsonify({"key": key, "value": value})

@app.route('/db_insert', methods=['POST'])
def db_insert():
    data = request.json
    try:
        with pg_conn.cursor() as cursor:
            cursor.execute("INSERT INTO my_table (name) VALUES (%s)", (data['name'],))
            pg_conn.commit()
        return jsonify({"message": "Data inserted successfully"})
    except Exception as e:
        pg_conn.rollback()  # Eğer bir hata oluşursa işlemi geri al
        return jsonify({"error": str(e)}), 500

@app.route('/')
def home():
    return "Hello, World!"

@app.route('/db_fetch', methods=['GET'])
def db_fetch():
    with pg_conn.cursor() as cursor:
        cursor.execute("SELECT * FROM my_table")
        rows = cursor.fetchall()
    return jsonify({"data": rows})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

