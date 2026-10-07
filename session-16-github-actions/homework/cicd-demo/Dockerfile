FROM python:3.12-slim
WORKDIR /srv
COPY app ./app
USER 1000
EXPOSE 8000
CMD ["python", "-m", "app.server"]
