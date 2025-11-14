-- AI Chatbot Database Schema
-- Run this script to create your database

CREATE DATABASE IF NOT EXISTS ai_chatbot;
USE ai_chatbot;

-- Users table to store user information
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Chat sessions table
CREATE TABLE chat_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    session_name VARCHAR(100) DEFAULT 'New Chat',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Messages table to store all chat messages
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT,
    user_id INT,
    message_type ENUM('user', 'bot') NOT NULL,
    message_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- API usage tracking (optional)
CREATE TABLE api_usage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    tokens_used INT DEFAULT 0,
    request_count INT DEFAULT 0,
    date_used DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert sample data for testing
INSERT INTO users (username, email, password) VALUES 
('testuser', 'test@example.com', 'hashed_password_here'),
('demo', 'demo@example.com', 'demo_password');

-- User preferences table
CREATE TABLE user_preferences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    preference_key VARCHAR(50) NOT NULL,
    preference_value TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert default preferences
INSERT INTO user_preferences (user_id, preference_key, preference_value) 
SELECT id, 'theme', 'light' FROM users;

INSERT INTO user_preferences (user_id, preference_key, preference_value) 
SELECT id, 'language', 'english' FROM users;

-- Create indexes for better performance
CREATE INDEX idx_messages_session ON messages(session_id);
CREATE INDEX idx_messages_user ON messages(user_id);
CREATE INDEX idx_sessions_user ON chat_sessions(user_id);
CREATE INDEX idx_preferences_user ON user_preferences(user_id);