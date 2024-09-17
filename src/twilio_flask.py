from flask import Flask, request

app = Flask(__name__)

@app.route('/incoming', methods=['POST'])
def incoming_message():
    incoming_msg = request.form.get('BODY', '')
    sender_number = request.form.get('From', '')
    print(f"Received message from {sender_number}: {incoming_message}")
    return 200, ''

if __name__ == '__main__':
    app.run(debug=True)
