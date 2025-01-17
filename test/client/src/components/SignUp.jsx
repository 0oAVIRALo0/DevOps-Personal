import React, { useState } from "react";
import axios from "axios";
import { Navigate } from "react-router-dom";

const API_URL = "https://visitor-management-system"; // Replace with your backend URL

// SignUp Component
const SignUp = () => {
  const navigate = Navigate();
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");

  const handleSignUp = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post(`${API_URL}/signup`, {
        username,
        password,
      });
      setMessage(response.data.message);
      if (response.status === 200) {
        navigate("/login");
      }
    } catch (error) {
      setMessage(
        error.response?.data?.message || "Error occurred during sign up"
      );
    }
  };

  return (
    <div>
      <h2>Sign Up</h2>
      <form onSubmit={handleSignUp}>
        <div>
          <label>Username:</label>
          <input
            type="text"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
        </div>
        <div>
          <label>Password:</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <button type="submit">Sign Up</button>
      </form>
      {message && <p>{message}</p>}
    </div>
  );
};

export default SignUp;
