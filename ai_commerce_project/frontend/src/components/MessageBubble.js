import React from "react";
import "./Chat.css";

const MessageBubble = ({ text, sender }) => {
  return (
    <div className={`bubble ${sender}`}>
      {text}
    </div>
  );
};

export default MessageBubble;