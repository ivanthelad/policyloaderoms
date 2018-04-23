#!/bin/sh
###

#export SUBSCRIPTION=""
#export SP_ID=""
#export SP_PASSWORD=""
#export SP_TENANT=""
#export CUSTOM_DOMAIN=""
#export UPSTREAM_DNS=""
valset=0
## check params 
if [ -z ${SUBSCRIPTION+x} ]; then echo "SUBSCRIPTION is unset";valset="1"; else echo " subscription is set to '$SUBSCRIPTION'"; fi

if [ -z ${SP_ID+x} ]; then echo "SP_ID is unset";valset="1"; else echo "SP_ID is set to '$SP_ID'"; fi

if [ -z ${SP_PASSWORD+x} ]; then echo "SP_PASSWORD is unset"; valset="1"; else echo "password has been set'"; fi

if [ -z ${SP_TENANT+x} ]; then echo "SP_TENANT is unset"; valset="1"; else echo "TENAT is set to '$SP_TENANT'"; fi

if [ -z ${WORKSPACE_ID+x} ]; then echo "WORKSPACE_ID is unset"; valset="1"; else echo "WORKSPACE_ID is set to '$CUSTOM_DOMAIN'"; fi
if [ -z ${WORKSPACE_KEY+x} ]; then echo "WORKSPACE_KEY is unset"; valset="1"; else echo "WORKSPACE_KEY HAS BEEN set "; fi



if [ "$valset" -eq "1" ]; then
   echo "not all params set";
   exit;
fi
echo loggin user 
## first backup pr

az login  --service-principal -u $SP_ID -p $SP_PASSWORD --tenant $SP_TENANT
az account set --subscription=$SUBSCRIPTION


az  policy definition list  --query '[].{displayName:displayName, name:name}' > myinput.json

 python2 importjson.py

