# Use a Python image that has OpenCV in it
#FROM valian/docker-python-opencv-ffmpeg

# Set the working directory to /app
#WORKDIR /app

# Copy the current directory contents into the container at /app
#COPY . /app

# Install any needed packages specified in requirements.txt
#RUN pip install -r res/requirements.txt

# Make port 8080 available to the world outside this container
#EXPOSE 8080

# Define environment variable for the Kafka client
#ENV KAFKA_CLIENT_ADDRESS='localhost:9092'

# Run consumer.py and producer.py in parallel when the container launches
#CMD res/parallel_commands.sh "python res/producer.py" "python res/consumer.py"
#CMD python res/producer.py && python res/consumer.py

#Use an official Python image
FROM python:2.7

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Various Python and C/build deps
RUN apt-get update && apt-get install -y \ 
    wget \
    build-essential \ 
    cmake \ 
    git \
    unzip \ 
    pkg-config \
    python-dev \ 
    python-opencv \ 
    libopencv-dev \ 
    libav-tools  \ 
    libjpeg-dev \ 
    libpng-dev \ 
    libtiff-dev \ 
 #   libjasper-dev \ 
    libgtk2.0-dev \ 
    python-numpy \ 
    python-pycurl \ 
    libatlas-base-dev \
    gfortran \
    webp \ 
    python-opencv \ 
    qt5-default \
    libvtk6-dev \ 
    zlib1g-dev 

# Install Open CV - Warning, this takes absolutely forever
RUN mkdir -p ~/opencv cd ~/opencv && \
    wget https://github.com/Itseez/opencv/archive/3.0.0.zip && \
    unzip 3.0.0.zip && \
    rm 3.0.0.zip && \
    mv opencv-3.0.0 OpenCV && \
    cd OpenCV && \
    mkdir build && \ 
    cd build && \
    cmake \
    -DWITH_QT=ON \ 
    -DWITH_OPENGL=ON \ 
    -DFORCE_VTK=ON \
    -DWITH_TBB=ON \
    -DWITH_GDAL=ON \
    -DWITH_XINE=ON \
    -DBUILD_EXAMPLES=ON .. && \
    make -j4 && \
    make install && \ 
    ldconfig

# Install any needed packages specified in requirements.txt
RUN pip install -r res/requirements.txt

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable for the Kafka client
ENV KAFKA_CLIENT_ADDRESS='localhost:9092'

# Run consumer.py and producer.py in parallel when the container launches
CMD res/parallel_commands.sh "python res/producer.py" "python res/consumer.py"
#CMD python res/producer.py && python res/consumer.py
