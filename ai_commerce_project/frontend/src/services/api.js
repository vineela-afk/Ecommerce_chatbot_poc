import axios from "axios";

const API_URL = "http://localhost:8000";

export const sendChatMessage = async (message) => {
  try {
    const response = await axios.post(`${API_URL}/chat`, {
      input: message
    });

    return response.data.response;
  } catch (error) {
    return "Error connecting to AI service";
  }
};