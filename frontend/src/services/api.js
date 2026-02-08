import axios from "axios";

const API_URL = process.env.REACT_APP_API_URL || "http://localhost:8081"; // Spring Boot
const AI_URL = process.env.REACT_APP_AI_URL || "http://localhost:8000"; // AI service

export const sendChatMessage = async (message) => {
  try {
    const response = await axios.post(`${AI_URL}/chat`, { input: message });
    return response.data.response;
  } catch (error) {
    return "Error connecting to AI service";
  }
};

export const login = async (credentials) => {
  try {
    const res = await axios.post(`${API_URL}/auth/login`, credentials);
    return res.data; // token string in current backend
  } catch (e) {
    throw e;
  }
};

export const createOrder = async (order, token) => {
  try {
    const headers = token ? { Authorization: `Bearer ${token}` } : {};
    const res = await axios.post(`${API_URL}/orders`, order, { headers });
    return res.data;
  } catch (e) {
    throw e;
  }
};

export const makePayment = async (paymentInfo, token) => {
  try {
    const headers = token ? { Authorization: `Bearer ${token}` } : {};
    const res = await axios.post(`${API_URL}/payments`, paymentInfo, { headers });
    return res.data;
  } catch (e) {
    throw e;
  }
};