import requests

# Credentials
url = "http://192.168.1.131:4000/api"
token = "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ2YWxpb3RfYXBwIiwiZXhwIjoxNTQzMTA4MzgxLCJpYXQiOjE1NDA2ODkxODEsImlzcyI6InZhbGlvdF9hcHAiLCJqdGkiOiJhMzJiNWQzZS1hNjExLTRhN2ItYmZkMy00YzJmZjZmMDQ3ODQiLCJuYmYiOjE1NDA2ODkxODAsInN1YiI6IjEiLCJ0eXAiOiJhY2Nlc3MifQ.Wo5v7xsn_DgFvwd6WhDh239W7XtDD8noqSwQTXVoxXE4R8H9VQK-ZGFdKJfP2Vny34IQBX8rPYHyNe5j-rjzxg"
headers = {
    "Authorization": token
}

def query(url, payload):
  query = {"query": payload}
  response = requests.post(url, headers=headers, json=query)
  print(response)
  try:
    data = json.loads(response.text)
    pprint(data)
    return data
  except:
    print('Error desconocido al recibir query. Mensaje original: ')
    print(response.text)
    return None

payload = "query{projects{name}}"