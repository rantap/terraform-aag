import os
import azure.functions as func
import json
from azure.cosmos import CosmosClient

# Cosmos DB connection setup
cosmos_url = os.environ["COSMOSDB_URL"]
cosmos_key = os.environ["COSMOSDB_KEY"]
client = CosmosClient(cosmos_url, cosmos_key)

database_name = os.environ["COSMOSDB_DATABASE"]
container_name = os.environ["COSMOSDB_CONTAINER"]
database = client.get_database_client(database_name)
container = database.get_container_client(container_name)

# Define the Azure Function app
app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.route(route="http_trigger")
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    item = {
        "id": "123",
        "message": "Hello from Azure Function to CosmosDB"
    }
    try:
        # Insert the item into Cosmos DB container
        container.upsert_item(body=item)
        response_body = json.dumps({"message": "Item inserted into CosmosDB", "data":  item})
        return func.HttpResponse(response_body, status_code=200)
    except Exception as e:
        error_body = json.dumps({"message": "Failed to insert item", "error": str(e)})
        return func.HttpResponse(error_body, status_code=500)
