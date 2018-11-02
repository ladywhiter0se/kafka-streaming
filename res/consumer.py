import time
import os
from flask import Flask, Response, render_template
from kafka import KafkaConsumer
import socket

# Connect to Kafka, asking for the topic we want to consume
KAFKA_IP = os.environ['KAFKA_CLIENT_ADDRESS']
checkKafka = True
print('Consumer checking: ' + KAFKA_IP)
while checkKafka:
    try:
        consumer = KafkaConsumer('video', bootstrap_servers=KAFKA_IP, auto_offset_reset='earliest')
        checkKafka = False # If we don't get an exception, then Kafka is available
    except:
        time.sleep(2)

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/video')
def video():
    return Response(kafkastream(), mimetype='multipart/x-mixed-replace; boundary=frame')

def kafkastream():
    try:
        for msg in consumer:
            print('Reading message ' + msg)
            yield (b'--frame\r\n'
                  b'Content-Type: image/jpg\r\n\r\n' + msg.value + b'\r\n\r\n')
    except:
        print('Failed reading consumed messages')
    finally:
        consumer.close()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True)
