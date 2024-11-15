import os
import json
from google.cloud import firestore

# Set up Firestore client
project_id = os.environ["FIRESTORE_PROJECT"]
client = firestore.Client(project=project_id)

def main(request):
    # Define document data
    data = {
        "id": "123",
        "message": "Hello from Google Cloud Function v2 to Firestore"
    }
    # Add data to Firestore collectionasdasd
    try:
        client.collection("messages").add(data)  # Adds to a "messages" collection
        return json.dumps({"message": "Data inserted into Firestore", "data": data}), 200
    except Exception as e:
        return json.dumps({"message": "Failed to insert data", "error": str(e)}), 500