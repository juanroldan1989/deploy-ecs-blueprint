FROM python:3.9.2-alpine

# upgrade pip
RUN pip install --upgrade pip

# get curl for healthchecks
# using `apk` because of `alpine` based image
RUN apk add curl

# use `apt-get` on `ubuntu` based image
# RUN apt-get update -qq && \
#   apt-get install --no-install-recommends -y curl && \
#   rm -rf /var/lib/apt/lists /var/cache/apt/archives

# permissions and nonroot user for tightened security
RUN adduser -D nonroot
RUN mkdir /home/app/ && chown -R nonroot:nonroot /home/app
RUN mkdir -p /var/log/flask-app && touch /var/log/flask-app/flask-app.err.log && touch /var/log/flask-app/flask-app.out.log
RUN chown -R nonroot:nonroot /var/log/flask-app
WORKDIR /home/app
USER nonroot

# copy all the files to the container
COPY --chown=nonroot:nonroot . .

# venv
ENV VIRTUAL_ENV=/home/app/venv

# python setup
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN export FLASK_APP=app.py
RUN pip install --no-cache-dir -r requirements.txt

# define the port number the container should expose
# EXPOSE 5000
EXPOSE 8000

# CMD ["python", "app.py"]
# To solve issue:
# runc create failed: unable to start container process: exec: "gunicorn -w 3 -t 60 -b 0.0.0.0:8000 app:app": executable file not found in $PATH
CMD ["gunicorn", "-w 3", "-t 60", "-b 0.0.0.0:8000", "app:app"]
