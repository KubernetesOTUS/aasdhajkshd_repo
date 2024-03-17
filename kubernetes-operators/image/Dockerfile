FROM python:3.12
COPY templates ./templates
COPY requirements.txt ./requirements.txt
COPY mysql-operator.py ./mysql-operator.py
RUN apt update && apt -y install iproute2 dialog vim
RUN pip install kopf kubernetes pyyaml jinja2
CMD kopf run /mysql-operator.py --verbose
