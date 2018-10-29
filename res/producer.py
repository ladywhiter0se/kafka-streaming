import time
import cv2
import os
from kafka import KafkaProducer

# Connecting to Kafka and assigning a topic
KAFKA_VERSION=(0,10)
producer = KafkaProducer(bootstrap_servers=os.environ['KAFKA_CLIENT_ADDRESS'], api_version=KAFKA_VERSION)
topic = 'video'

# Reading and emitting the video to the broker
def video_emitter(video):
    video = cv2.VideoCapture(video)
    print('emitting.....')

    if video.isOpened:
        while (video.isOpened):
            success, image = video.read()

            if not success:
                print('bad read...')
                break
            else:
                ret, jpeg = cv2.imencode('.jpg', image)
                if ret:
                    producer.send_messages(topic, jpeg.tobytes())
                    time.sleep(0.2) # Reduce CPU usage
                else:
                    print('not converted...')
                    break
    else:
        print('video not opened...')

    video.release()
    print('done emitting')

if __name__ == '__main__':
    try:
        video_emitter('video.mp4')
    finally:
        producer.close()
