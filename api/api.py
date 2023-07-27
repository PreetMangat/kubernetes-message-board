from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
import os

app = Flask(__name__)
CORS(app) 

db_config = {
    'host': os.getenv('DB_HOST_NAME'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_NAME')
}

def get_database_connection():
    connection = mysql.connector.connect(**db_config)
    return connection

@app.route('/messages', methods=['GET'])
def get_messages():
    try:
        with get_database_connection() as connection, connection.cursor() as cursor:
            cursor.execute('SELECT * FROM messages')
            result = cursor.fetchall()
            messages = [{'id': row[0], 'content': row[1]} for row in result]
            return jsonify(messages), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/messages', methods=['POST'])
def create_message():
    content = request.json.get('content')
    if not content:
        return jsonify({'error': 'Content is missing'}), 400

    try:
        with get_database_connection() as connection, connection.cursor() as cursor:
            cursor.execute('INSERT INTO messages (content) VALUES (%s)', (content,))
            connection.commit()
            message_id = cursor.lastrowid
            return jsonify({'id': message_id, 'content': content}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/messages/<int:message_id>', methods=['DELETE'])
def delete_message(message_id):
    try:
        with get_database_connection() as connection, connection.cursor() as cursor:
            cursor.execute('DELETE FROM messages WHERE id = %s', (message_id,))
            connection.commit()
            return jsonify({'message': 'Message deleted'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
