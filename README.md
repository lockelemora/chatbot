# ChatBot Project Documentation

## 1. Project Overview

This project implements a chatbot that integrates OpenAI's GPT model with Twilio's WhatsApp API. It allows users to interact with an AI assistant via WhatsApp messages. The system processes incoming messages, sends them to the OpenAI API for a response, and then sends the AI's response back to the user through WhatsApp.

## 2. File Structure

```
chatbot/
│
├── src/
│   ├── openai_handler.py
│   └── twilio_handler.py
│
├── requirements.txt
│
└── .env (not in repository - needs to be created)
```

## 3. Dependencies

The project relies on the following main libraries:
- OpenAI
- Twilio
- Flask
- python-dotenv

All dependencies are listed in `requirements.txt`.

## 4. Configuration

The project uses environment variables for configuration. These should be stored in a `.env` file in the root directory. Required variables include:
- OPENAI_API_KEY
- TWILIO_ACCOUNT_SID
- TWILIO_AUTH_TOKEN

## 5. Main Components

### 5.1 OpenAI Handler (openai_handler.py)

This module handles interactions with the OpenAI API. Key functions include:

- `create_thread()`: Initializes a new conversation thread with OpenAI.
- `add_message()`: Adds a user message to the conversation thread.
- `create_run()`: Sends the conversation to the AI model and retrieves the response.

### 5.2 Twilio Handler (twilio_handler.py)

This module manages the Twilio integration and Flask web server. Key components include:

- Flask application setup
- Webhook route for incoming WhatsApp messages
- Functions to send WhatsApp messages via Twilio
- Integration with OpenAI handler to process messages

## 6. Workflow

1. A user sends a WhatsApp message to the Twilio number.
2. Twilio forwards the message to our Flask webhook.
3. The webhook processes the message and sends it to OpenAI via the OpenAI handler.
4. The AI generates a response.
5. The response is sent back to the user via Twilio's WhatsApp API.

## 7. Setup and Running

1. Install dependencies: `pip install -r requirements.txt`
2. Set up environment variables in `.env` file
3. Run the Flask application: `python src/twilio_handler.py`

The application will start a Flask server on port 5000, ready to receive webhook calls from Twilio.

## 8. Important Notes

- Ensure that the Twilio webhook URL is set to `http://your-server-address:5000/webhook`
- The OpenAI assistant ID is hardcoded and may need to be updated if a new assistant is created
- The application uses threading to run the Flask server alongside the main program

