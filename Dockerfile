FROM alpine:latest

# Install python, pip, and venv dependencies
RUN apk add --no-cache --update python3 py3-pip py3-virtualenv bash

# Create and activate a virtual environment
RUN python3 -m venv /opt/venv

# Copy requirements
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies inside the virtual environment
RUN /opt/venv/bin/pip install --no-cache-dir -q -r /tmp/requirements.txt

# Add the app code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Use non-root user
RUN adduser -D myuser
USER myuser

# Run the app with the venv Python path
CMD /opt/venv/bin/gunicorn --bind 0.0.0.0:$PORT wsgi
