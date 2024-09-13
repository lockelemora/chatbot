import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import time
from config import load_config
from twilio.rest import Client as TwilioClient


#twilio access
twilio_client = TwilioClient(twilio_account_sid, twilio_account_token)

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

while True:
    to_number = input("Enter your whatsapp number: ")
    message_body = input("Enter your message: ")
    send_whatsapp_message(to_number, message_body)
