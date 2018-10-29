# Use an official Python runtime as a parent image
FROM python:2.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install -r res/requirements.txt


# Do a bunch of retarded shit to get OpenCV to work.
RUN apt-get update && \
    apt-get -y install sudo

#RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo


RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker

RUN sudo apt-get -y install libglib2.0-0 libsm6 libxrender1 libxext6

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV KAFKA_CLIENT_ADDRESS='localhost:9092'

# Run consumer.py and producer.py when the container launches
CMD res/parallel_commands.sh "python res/consumer.py" "python res/producer.py"