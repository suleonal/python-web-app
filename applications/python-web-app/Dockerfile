FROM python:3.9-slim AS base

WORKDIR /app
COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt

RUN groupadd -g 1000 appuser && useradd -r -u 1000 -g appuser appuser
USER appuser

CMD ["python3", "app.py"]
