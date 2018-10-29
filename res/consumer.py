import os
from flask import Flask, Response
from kafka import KafkaConsumer
KAFKA_VERSION = (0,10)
# Connect to Kafka, asking for the topic we want to consume
consumer = KafkaConsumer('video', group_id='view', bootstrap_servers=os.environ['KAFKA_CLIENT_ADDRESS'], api_version=KAFKA_VERSION)
app = Flask(__name__)

@app.route('/')
def index():
    return Response(kafkastream(), mimetype='multipart/x-mixed-replace; boundary=frame')

def kafkastream():
    for msg in consumer:
        yield (b'--frame\r\n'
               b'Content-Type: image/png\r\n\r\n' + msg.value + b'\r\n\r\n')

if __name__ == "__main__":
    app.run(port=8080, debug=True)
