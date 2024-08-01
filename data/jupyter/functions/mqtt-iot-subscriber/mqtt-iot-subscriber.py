import os
import json
import requests
import paho.mqtt.client as mqtt
from flask import Flask, request, jsonify, render_template_string

app = Flask(__name__)

# Environment variables for configuration
MQTT_BROKER = os.getenv('MQTT_BROKER', 'cloud.tbz.ch')
MQTT_PORT = int(os.getenv('MQTT_PORT', 1883))
MQTT_TOPICS = os.getenv('MQTT_TOPICS', 'default_topic').split(',')
FORWARD_URL = os.getenv('FORWARD_URL', 'https://example.com')

# List to store received messages
received_messages = []

# MQTT client setup
client = mqtt.Client()

def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT broker with result code {rc}")
    for topic in MQTT_TOPICS:
        client.subscribe(topic)
        print(f"Subscribed to topic: {topic}")

def on_message(client, userdata, msg):
    payload = msg.payload.decode('utf-8')
    print(f"Received message on {msg.topic}: {payload}")
    event = {'topic': msg.topic, 'message': payload}
    received_messages.insert(0, event)  # Insert at the beginning to keep the latest message on top
    # forward_event(json.loads(payload), msg.topic)

client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)

# Flask health check endpoint
@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'})

def forward_event(event, topic):
    try:
        url = f"{FORWARD_URL}/{topic}"
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, json=event, headers=headers)
        response.raise_for_status()
        print(f"Event forwarded to {FORWARD_URL}/{topic}")
    except requests.exceptions.RequestException as e:
        print(f"Failed to forward event to {FORWARD_URL}/{topic}: {e}")


# HTML template for displaying messages
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Received MQTT Messages</title>
    <style>
        body { font-family: Arial, sans-serif; }
        h1 { color: #333; }
        ul { list-style-type: none; padding: 0; }
        li { padding: 10px; margin: 5px 0; background: #f9f9f9; border: 1px solid #ddd; }
        li strong { color: #555; }
    </style>
</head>
<body>
    <h1>Received MQTT Messages</h1>
    <ul>
    {% for message in messages %}
        <li><strong>{{ message.topic }}</strong>: {{ message.message }}</li>
    {% endfor %}
    </ul>
</body>
</html>
"""

# Endpoint to display received messages as HTML
@app.route('/messages', methods=['GET'])
def display_messages():
    return render_template_string(HTML_TEMPLATE, messages=received_messages)


if __name__ == '__main__':
    # Start the MQTT client loop in a separate thread
    client.loop_start()

    port = int(os.getenv('PORT', 8080))
    app.run(host='0.0.0.0', port=port)






