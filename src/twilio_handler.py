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

#Load environment variables
load_dotenv()

#Get Twilio credentials from environment variables
twilio_account_sid = os.getenv('TWILIO_ACCOUNT_SID')
twilio_auth_token = os.getenv('TWILIO_AUTH_TOKEN')
twilio_phone_number = "+14155238886"

#twilio access
twilio_client = TwilioClient(twilio_account_sid, twilio_auth_token)

#Start Flask app
app = Flask(__name__)
#Create route to handle incoming messages
@app.route("/webhook", methods=['POST'])
def incoming_message():
    print("\nReceived webhook call:")
    print(json.dumps(request.form.to_dict(), indent=2))
    return 'OK'

def start_webhook():
    print("Webhook started. Ready to receive messages")
    app.run(debug=False, port=5000, use_reloader=False)

def run_webhook_in_background():
    webhook_thread = threading.Thread(target=start_webhook)
    webhook_thread.start()



def send_whatsapp_message(to_number, message_body):
    try:
        message = twilio_client.messages.create(
            body = message_body,
            from_ = f'whatsapp:{twilio_phone_number}',
            to=f'whatsapp:{to_number}'
        )
        print(f"Message sent. SID: {message.sid}")
    except Exception as e:
        print(f"Error sending message")

run_webhook_in_background()
to_number = input("Enter your whatsapp number: ")
while True:
    message_body = input("Enter your message: ")
    send_whatsapp_message(to_number, message_body)
