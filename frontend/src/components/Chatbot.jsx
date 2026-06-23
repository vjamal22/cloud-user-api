import { useState } from 'react'

import { fetchAuthSession } from 'aws-amplify/auth'
import { sendChatMessage } from '../api'

function Chatbot() {
  const [message, setMessage] = useState('')
  const [messages, setMessages] = useState([
    {
      sender: 'Bot',
      text: 'Hi! I am your fitness assistant.',
    },
  ])

const handleSend = async () => {
  if (!message.trim()) {
    return
  }

  const userMessageText = message

  const newMessage = {
    sender: 'You',
    text: userMessageText,
  }

  setMessages([...messages, newMessage])
  setMessage('')

  try {
    const session = await fetchAuthSession()
    const token = session.tokens?.idToken?.toString()

    const result = await sendChatMessage(userMessageText, token)

    const botReply = {
      sender: 'Bot',
    text: result.reply || result.messages?.[0]?.content || 'No response received from chatbot backend.',
    }

    setMessages((currentMessages) => [...currentMessages, botReply])
  } catch (error) {
    console.error('Chatbot Error:', error)

    const errorReply = {
      sender: 'Bot',
      text: 'Sorry, the chatbot backend request failed.',
    }

    setMessages((currentMessages) => [...currentMessages, errorReply])
  }
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