import React, { useState } from "react";

const ChatInput = ({ onSend, isLoading = false }) => {
  const [message, setMessage] = useState("");

  const handleSend = () => {
    if (!message.trim() || isLoading) return;
    onSend(message);
    setMessage("");
  };

  const handleKeyPress = (e) => {
    if (e.key === "Enter" && !e.shiftKey && !isLoading) {
      e.preventDefault();
      handleSend();
    }
  };

  return (
    <div className="input-area">
      <input
        value={message}
        onChange={(e) => setMessage(e.target.value)}
        onKeyPress={handleKeyPress}
        placeholder="Ask me about products, prices, ratings..."
        disabled={isLoading}
        autoFocus
      />
      <button onClick={handleSend} disabled={isLoading || !message.trim()}>
        {isLoading ? "..." : "Send"}
      </button>
    </div>
  );
};

export default ChatInput;