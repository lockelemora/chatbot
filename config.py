import os
from dotenv import load_dotenv

load_dotenv()

def load_config():
    load_dotenv()
    twilio_account_sid = os.getenv('TWILIO_ACCOUNT_SID')
    twilio_auth_token = os.getenv('TWILIO_AAUTH_TOKEN')
    twilio_phone_number = os.getenv('TWILIO_PHONE_NUMBER')
    openai_api_key = os.getenv('OPENAI_API_KEY')

    return {
        'openai_api_key': openai_api_key,
        'twilio_account_sid': twilio_account_sid,
        'twilio_auth_token': twilio_auth_token,
        'twilio_phone_number': twilio_phone_number
    }
