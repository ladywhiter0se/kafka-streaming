# Use an official Python runtime as a parent image
FROM python:2.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install -r res/requirements.txt

# Make a user and grant them sudo privileges so we can install the OpenCV dependencies
RUN apt-get update && \
    apt-get -y install sudo

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker

RUN sudo apt-get -y install libglib2.0-0 libsm6 libxrender1 libxext6

# Remove sudo privileges since we won't need them anymore
RUN sudo deluser docker sudo

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable for the Kafka client
ENV KAFKA_CLIENT_ADDRESS='localhost:9092'

# Run consumer.py and producer.py in parallel when the container launches
#CMD res/parallel_commands.sh "python res/producer.py" "python res/consumer.py"
CMD python res/producer.py && python res/consumer.py