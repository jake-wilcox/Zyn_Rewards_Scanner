# Use an official Python runtime as the base image
FROM python:3.9

# Install required packages for adding Google Chrome repository
RUN apt-get update && apt-get install -y curl gnupg

# Add Google Chrome repository and install Chrome browser
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable xvfb

# Set the working directory in the container
WORKDIR /app

# Copy the rest of your application's code into the container
COPY ./requirements.txt /app/
COPY ./main.py /app/
COPY ./driver.py /app/
COPY ./.env /app/

RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that your FastAPI app runs on
EXPOSE 8000

# Define the command to run your FastAPI app
CMD ["sh", "-c", "xvfb-run uvicorn main:app --host 0.0.0.0 --port 8000"]
