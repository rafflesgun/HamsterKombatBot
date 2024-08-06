#Build: docker buildx build --platform linux/amd64,linux/arm64 --push -t rafflesg/hamsterkombatbot-1:latest .
FROM python:3.11.9-slim as builder
LABEL org.opencontainers.image.source=https://github.com/shamhi/HamsterKombatBot
WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    build-essential \
    libssl-dev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip3 install --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir -r requirements.txt

FROM python:3.11.9-slim

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY . .

ENV PATH="/opt/venv/bin:$PATH"
CMD ["python", "main.py", "--action", "2"]
