FROM ubuntu:18.04
ENV TZ=America/Mexico_City
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get -y update
RUN apt-get install -y build-essential python3.6 python3-pip python3-dev
RUN apt install -y libsm6 libxext6
RUN apt-get -y install cmake protobuf-compiler
RUN apt-get install -y libsm6 libxrender1 libfontconfig1
RUN apt-get install -y  libpq-dev
RUN apt-get install -y libopenmpi-dev
RUN apt-get install -y python3-pil python3-lxml python3-tk
RUN apt install -y curl 
RUN apt install -y sl 
RUN apt install -y zip unzip
RUN apt install -y nano
RUN apt install -y git
RUN pip3 install --upgrade pip
RUN pip3 install opencv-python
RUN pip3 install botocore
RUN pip3 install scikit-learn
RUN pip3 install matplotlib
RUN pip3 install mpi4py
RUN pip3 install pandas
RUN pip3 install setuptools
RUN pip3 install tensorflow==1.14.0
RUN pip3 install syspath
RUN pip3 install lockfile
RUN pip3 install tokenizer
RUN pip3 install tokenizers
RUN pip3 install Keras
RUN pip3 install boto3
RUN pip3 install imutils
RUN pip3 install Cython
RUN pip3 install contextlib2
RUN pip3 install tf_slim
RUN pip3 install pillow
RUN pip3 install lxml
RUN pip3 install pycocotools
RUN mkdir -p /root/workspace
RUN mkdir -p ~/.aws 

WORKDIR /root
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

COPY credentials .aws
COPY config .aws

RUN git clone https://github.com/tzutalin/labelImg.git
WORKDIR /root/labelImg
RUN apt-get install -y pyqt5-dev-tools
RUN pip3 install -r requirements/requirements-linux-python3.txt
RUN make qt5py3

WORKDIR /root
RUN git clone https://github.com/tensorflow/models.git
RUN cd models/research \
    && protoc object_detection/protos/*.proto --python_out=. \
    && cp object_detection/packages/tf1/setup.py . \
    && python3 -m pip install . \
    && python3 object_detection/builders/model_builder_tf1_test.py

ENV PYTHONPATH=$PYTHONPATH:/tensorflow/models:/tensorflow/models/slim
