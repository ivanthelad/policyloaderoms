# policyloaderoms
a script to load policy definition objects into oms for later use with queries

The script creates a table called policyname_CL in the target oms workspace 
it can be used as basis for policy analytics. the following scripts joins the azureActivity table to the policyname table
'
let policynames = policyname_CL  | summarize by displayName_s, name_g;
AzureActivity
| where ( Type == "AzureActivity" )
| where ( Category == "Policy" )
| extend js = extractjson("$.[0].policyDefinitionEffect", tostring(parse_json(Properties).policies)) 
| extend nameid = extractjson("$.[0].policyDefinitionName", tostring(parse_json(Properties).policies)) 
| join kind=inner    ( policynames) on  $left.nameid == $right.name_g
| summarize  count ()  by  displayName_s, bin(TimeGenerated, 1d)
| render  barchart   

'

## Parameters and configuration 
The container is configured using environment varaibles 

### SUBSCRIPTION 
The subscription where the the servers are running.  
To get the subscription id execute ```az account list -o table``

### SP_ID
the serivce principle app_id. The service principle is used to query the api for the VM ip addresses. To create a new Service principle that only has readonly rights 

``` az ad sp create-for-rbac --role=Reader ```
this command will output  the following. Where app_id can is passed as the SP_ID environment variable. It is recommend to note the information down 
```
{
  "appId": "XXXXXXX",
  "displayName": "XXXXX",
  "name": "XXXXX",
  "password": "XXXXXXX",
  "tenant": "XXXXXXX"
}
```
For more info on service principle creation see https://docs.microsoft.com/en-us/cli/azure/ad/sp#create-for-rbac

### SP_PASSWORD
This is the password of the service principle output from the previous step 
### SP_TENANT
This is the TENANT of the service principle output from the previous step 

#building 
run docker -t policyloaderoms  .
#Running 
docker run  policyloaderoms \
 -e SUBSCRIPTION=XXXX \
            -e SP_ID=XXXX \
            -e SP_PASSWORD=XXXX \
            -e SP_TENANT=XXXX\
            -e WORKSPACE_ID=XXXx\
            -e WORKSPACE_KEY=XXXX 
