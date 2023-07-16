import React, { useState, useEffect } from 'react';
import './App.css';
import axios from 'axios';

function App() {
  const [messages, setMessages] = useState([]);
  const [newMessage, setNewMessage] = useState('');

  useEffect(() => {
    axios.get('http://api-service:5000/messages')
      .then(response => {
        setMessages(response.data);
      })
      .catch(error => {
        console.error('Error retrieving messages:', error);
      });
  }, []);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (newMessage.trim() !== '') {
      axios.post('http://api-service:5000/messages', { content: newMessage })
        .then(response => {
          setMessages([...messages, response.data]);
          setNewMessage('');
        })
        .catch(error => {
          console.error('Error creating message:', error);
        });
    }
  };

  const handleDelete = (messageId) => {
    axios.delete(`http://api-service:5000/messages/${messageId}`)
      .then(() => {
        setMessages(messages.filter(message => message.id !== messageId));
      })
      .catch(error => {
        console.error('Error deleting message:', error);
      });
  };

  return (
    <div className="App">
      <h1>Message Board</h1>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={newMessage}
          onChange={(e) => setNewMessage(e.target.value)}
          placeholder="Enter your message..."
        />
        <button type="submit" className="post-button">
          Post Message
        </button>
      </form>
      <div className="message-list">
        {messages.map(message => (
          <div key={message.id} className="message-item">
            <span>{message.content}</span>
            <button onClick={() => handleDelete(message.id)}>Delete</button>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;
