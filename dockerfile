FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    build-essential libpq-dev git gettext curl && \
    apt-get clean

WORKDIR /app

RUN git clone https://github.com/wger-project/wger.git /app

RUN pip install -r requirements.txt gunicorn psycopg2-binary
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

RUN echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='mdrysdale').exists() or User.objects.create_superuser('mdrysdale', 'mdrysdale9663@gmail.com', 'drysdaleadmin2025')" | python manage.py shell

CMD gunicorn wsgi:application --bind 0.0.0.0:8000
