import time
import os
from flask import Flask, Response
from kafka import KafkaConsumer

KAFKA_IP = os.environ['KAFKA_CLIENT_ADDRESS']
# Connect to Kafka, asking for the topic we want to consume
checkKafka = True
print('Checking Kafka connection')
while checkKafka:
    print('consumer')
    try:
        consumer = KafkaConsumer('video', bootstrap_servers=KAFKA_IP, auto_offset_reset='earliest')
        app = Flask(__name__)
        checkKafka = False # If we don't get an exception, then Kafka is available
    except:
        print('Kafka is unavailable, trying again...')
        time.sleep(2)

@app.route('/', methods=['GET'])
def index():
    return Response(kafkastream(), mimetype='multipart/x-mixed-replace; boundary=frame')

def kafkastream():
    try:
        for msg in consumer:
           yield (b'--frame\r\n'
                  b'Content-Type: image/jpg\r\n\r\n' + msg.value + b'\r\n\r\n')
    finally:
        consumer.close()

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True)
