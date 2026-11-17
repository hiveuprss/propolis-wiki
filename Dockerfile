FROM python:3.12-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends libpq5 \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml README.md ./
COPY wiki ./wiki
COPY wsgi.py wiki.sh ./

RUN pip install --no-cache-dir .

EXPOSE 5000

CMD ["flask", "--app", "wiki", "run", "--host=0.0.0.0", "--port=5000"]
