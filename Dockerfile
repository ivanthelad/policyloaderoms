FROM ubuntu
ENV SUBSCRIPTION=""
ENV SP_ID=""
ENV SP_PASSWORD=""
ENV TENANT_ID=""
ENV WORKSPACE_ID=""
ENV WORKSPACE_KEY=""
RUN  apt-get update; apt-get install lsb-release -y;  apt-get install curl gnupg2 -y 
RUN AZ_REPO=$(lsb_release -cs); echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
     tee /etc/apt/sources.list.d/azure-cli.list; apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893;curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -;  apt-get install apt-transport-https -y; apt-get update  &&  apt-get install azure-cli -y; apt-get install python -y;

RUN mkdir /oms
WORKDIR /oms
RUN  apt-get install python-pip -y; pip install requests ;
ADD importjson.py /oms/importjson.py
ADD entryload.sh /oms/entryload.sh
ENTRYPOINT ["/oms/entryload.sh"]
