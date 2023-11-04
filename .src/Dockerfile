FROM alpine:latest

WORKDIR /workspace

RUN apk update \
    && apk add python3 py-pip

RUN pip install poetry

RUN poetry new app

WORKDIR /workspace/app

COPY bin .

RUN ./requirements.sh

RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-interaction --no-ansi

CMD [ "poetry", "run", "gunicorn", "-b", "0.0.0.0:5000", "main:app" ]