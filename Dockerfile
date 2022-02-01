FROM python:3.8-slim-buster

WORKDIR /usr/src/app

ENV FLASK_APP=app.py
COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app .

EXPOSE 80

CMD ["ddtrace-run","gunicorn", "--workers", "4", "--bind", "0.0.0.0:80", "wsgi:app"]
