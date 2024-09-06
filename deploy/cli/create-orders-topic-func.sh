env=$1
rnd=$RANDOM
grp=az400-$env
loc=westeurope
topic=foodorder-topic-$rnd
storage=orderprocessor$rnd
app=order-processor-$rnd
acaenv=az400acaenv
image=order-processor:latest

az group create --name $grp --location $loc

# create topic
az eventgrid topic create --resource-group $grp --name $topic --location $loc
endpoint=$(az eventgrid topic show --name $topic -g $grp --query "endpoint" --output tsv)
key=$(az eventgrid topic key list --name $topic -g $grp --query "key1" --output tsv)

# create function app which will host the consumer
az storage account  create -n $storage -g $grp
az functionapp create -n $app -g $grp -s $storage --environment $acaenv --runtime dotnet --functions-version 4
