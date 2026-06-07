import { useState } from 'react'

function Chatbot() {
  const [message, setMessage] = useState('')
  const [messages, setMessages] = useState([
    {
      sender: 'Bot',
      text: 'Hi! I am your fitness assistant.',
    },
  ])

  const handleSend = () => {
    if (!message.trim()) {
      return
    }

    const newMessage = {
      sender: 'You',
      text: message,
    }

   const botReply = {
  sender: 'Bot',
  text: 'Thanks for your message. Chatbot backend connection is coming next.',
}

setMessages([...messages, newMessage, botReply])
    setMessage('')
  }

  return (
    <section>
      <h2>Fitness Chatbot</h2>

      <div>
        {messages.map((chatMessage, index) => (
          <p key={index}>
            <strong>{chatMessage.sender}:</strong> {chatMessage.text}
          </p>
        ))}
      </div>

      <p>
  <strong>Ask a fitness question:</strong>
</p>

      <input
  type="text"
  value={message}
  placeholder="Type your message here..."
  onChange={(e) => setMessage(e.target.value)}
  onKeyDown={(e) => {
    if (e.key === 'Enter') {
      handleSend()
    }
  }}
  style={{ width: '70%', padding: '8px' }}
/>

      <button onClick={handleSend}>
        Send
      </button>
    </section>
  )
}

export default Chatbot