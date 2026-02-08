import React, { useState, useEffect, useRef } from "react";
import MessageBubble from "./MessageBubble";
import ChatInput from "./ChatInput";
import { sendChatMessage } from "../services/api";
import "./Chat.css";

const ChatWindow = () => {
  const [messages, setMessages] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const chatBoxRef = useRef(null);

  // Show welcome message on load
  useEffect(() => {
    setMessages([
      {
        text: "👋 Welcome to AI Commerce Chatbot! I can help you find the perfect products. Ask me about items, prices, ratings, or special offers!",
        sender: "bot",
      },
    ]);
  }, []);

  // Auto-scroll to bottom when new messages arrive
  useEffect(() => {
    if (chatBoxRef.current) {
      chatBoxRef.current.scrollTop = chatBoxRef.current.scrollHeight;
    }
  }, [messages]);

  const handleSend = async (text) => {
    const userMsg = { text, sender: "user" };
    setMessages((prev) => [...prev, userMsg]);
    setIsLoading(true);

    try {
      const botReply = await sendChatMessage(text);
      const botMsg = { text: botReply, sender: "bot" };
      setMessages((prev) => [...prev, botMsg]);
    } catch (error) {
      const errorMsg = {
        text: "Sorry, I encountered an error. Please try again.",
        sender: "bot",
      };
      setMessages((prev) => [...prev, errorMsg]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="chat-container">
      <h2>🛍️ AI Commerce Chatbot</h2>

      <div className="chat-box" ref={chatBoxRef}>
        {messages.map((msg, index) => (
          <MessageBubble key={index} text={msg.text} sender={msg.sender} />
        ))}
      </div>

      <ChatInput onSend={handleSend} isLoading={isLoading} />
    </div>
  );
};

export default ChatWindow;