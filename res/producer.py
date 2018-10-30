import time
import cv2
import os
from kafka import KafkaProducer

KAFKA_IP=os.environ['KAFKA_CLIENT_ADDRESS']
# Connecting to Kafka and assigning a topic
while KafkaProducer(bootstrap_server=KAFKA_IP) = false:
    print('Kafka is unavailable, trying again...')
    time.sleep(2)
else:
    producer = KafkaProducer(bootstrap_servers=KAFKA_IP)
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
        # emit video 5 times
        for x in range(5):
            video_emitter('video.mp4')
    finally:
        producer.close()
