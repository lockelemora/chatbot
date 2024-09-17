import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import time
from dotenv import load_dotenv
from config import load_config
from twilio.rest import Client as TwilioClient
from twilio.twiml.messaging_response import MessagingResponse
from flask import Flask, request
import threading
from openai_handler import create_thread, add_message, create_run
from openai import OpenAI

#Load environment variables
load_dotenv()

#Get Twilio credentials from environment variables
twilio_account_sid = os.getenv('TWILIO_ACCOUNT_SID')
twilio_auth_token = os.getenv('TWILIO_AUTH_TOKEN')
twilio_phone_number = "+14155238886"
to_phone_number = "+16507096037"

#twilio access
twilio_client = TwilioClient(twilio_account_sid, twilio_auth_token)

#Initialize OpenAI client
openai_client = OpenAI()
#Create a thread for openai assistant
openai_thread = create_thread(openai_client)

#Assistant ID
assistant_id = "asst_V8PYYXOba0CpeyYEKAzMXZPU"

#Start Flask app
app = Flask(__name__)
#Create route to handle incoming messages
@app.route("/webhook", methods=['POST'])
def incoming_message():
    # Print all incoming data for debugging
    print("Incoming request data:", request.form)

    # Extract incoming message and sender number
    incoming_msg = request.form.get('Body')
    sender_number = request.form.get('From')

    # Check if we received the expected data
    if not incoming_msg or not sender_number:
        print("No message or sender number found.")
        return '', 400  # Bad Request if no data

    print(f'Received message from {sender_number}: {incoming_msg}')

    try:
        #Send message to OpenAI assistant
        add_message(openai_client, openai_thread, incoming_msg)
        create_run(openai_client, openai_thread, assistant_id)

        #Get the latest message from the assistant
        messages = openai_client.beta.threads.messages.list(
            thread_id=openai_thread.id)
        assistant_response = messages.data[0].content[0].text.value

        #Send the assistant response back to whatsapp
        print(f"Assistant response: {assistant_response}")
        send_whatsapp_message(sender_number, assistant_response)
    except Exception as e:
        print(f"Error processing OpenAI: {str(e)}")
        send_whatsapp_message(sender_number, "I'm sorry, I encountered an error. Please try again")

    # Return a proper HTTP response
    return '', 200

def send_whatsapp_message(to_number, message_body):
    try:
        message = twilio_client.messages.create(
            body = message_body,
            from_ = f'whatsapp:{twilio_phone_number}',
            to=to_number
        )
        print(f"Message sent. SID: {message.sid}")
    except Exception as e:
        print(f"Error sending message: {str(e)}")


def run_flask_app():
    app.run(port=5000)
#run_webhook_in_background()

if __name__ == '__main__':
    flask_thread = threading.Thread(target=run_flask_app)
    flask_thread.start()

    message_body = input("Enter your message: ")
    send_whatsapp_message(f'whatsapp:{to_phone_number}', message_body)
    while True:
        message_body = input("Enter your message: ")
        send_whatsapp_message(to_number, message_body)
