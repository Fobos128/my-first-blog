FROM python:3.10
ENV PYTHONUNBUFFERED 1 

RUN mkdir -p /webapp 
RUN mkdir -p /webapp/static 

RUN apt update
RUN apt install gettext -y

WORKDIR /webapp

COPY ./requirements.txt /webapp/requirements.txt

RUN pip install -U pip && pip install -U setuptools && pip install -r requirements.txt

