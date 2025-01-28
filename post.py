import os
import json
import requests


def load_dotenv():
	with open('.env') as file:
		for line in file:
			key, value = line.strip().split('=')
			os.environ[key] = value

def main():
	api_url = os.getenv('API_URL')
	print(api_url)
	repositories = json.loads(open('./out/repositories.json', 'r').read())
	headers = {
		"Content-Type": "application/json",
		"Authorization": f"Bearer {os.getenv('API_KEY')}"
	}
	response = requests.post(api_url, headers=headers, json={"repositories": repositories})
	print(response.text)

if __name__ == '__main__':
	print('Posting data to API...')
	load_dotenv()
	main()
