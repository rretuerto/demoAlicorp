FROM python:3.9.5-slim-buster

ENV PIP_DEFAULT_TIMEOUT 100
ENV PIP_DISABLE_PIP_VERSION_CHECK 'on'
ENV PIP_NO_CACHE_DIR 'on'
ENV PYTHON_ENV 'local'
ENV SAPNWRFC_HOME '/usr/local/sap/nwrfcsdk'
ENV TZ 'America/Lima'
ENV PYTHONDONTWRITEBYTECODE 1

RUN \
	ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install locales-all -y && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY lib/nwrfc750P_8-70002752/nwrfcsdk $SAPNWRFC_HOME
RUN \
  echo $SAPNWRFC_HOME'/lib' > /etc/ld.so.conf.d/nwrfcsdk.conf && \
  ldconfig

COPY lib/pyrfc-2.4.2-cp39-cp39-linux_x86_64.whl lib/
COPY requirements.txt .
RUN \
	pip install pip==21.1.2 && \
	pip install -r requirements.txt && \
	pip install lib/pyrfc-2.4.2-cp39-cp39-linux_x86_64.whl

CMD python main.py