from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app) 

db_config = {
    'host': '',
    'user': '',
    'password': '',
    'database': '',
}

def get_database_connection():
    connection = mysql.connector.connect(**db_config)
    return connection

@app.route('/messages', methods=['GET'])
def get_messages():
    connection = get_database_connection()
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM messages')
    result = cursor.fetchall()
    messages = [{'id': row[0], 'content': row[1]} for row in result]
    cursor.close()
    connection.close()
    return jsonify(messages)

@app.route('/messages', methods=['POST'])
def create_message():
    content = request.json['content']

    connection = get_database_connection()
    cursor = connection.cursor()
    cursor.execute('INSERT INTO messages (content) VALUES (%s)', (content,))
    connection.commit()
    message_id = cursor.lastrowid
    cursor.close()
    connection.close()
    return jsonify({'id': message_id, 'content': content}), 201

@app.route('/messages/<int:message_id>', methods=['DELETE'])
def delete_message(message_id):
    connection = get_database_connection()
    cursor = connection.cursor()
    cursor.execute('DELETE FROM messages WHERE id = %s', (message_id,))
    connection.commit()
    cursor.close()
    connection.close()
    return jsonify({'message': 'Message deleted'})

if __name__ == '__main__':
    app.run()
