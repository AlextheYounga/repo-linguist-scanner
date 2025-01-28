import os
import json

def write_repo_file(data: dict):
	with open(f'./out/repositories.json', 'w') as file:
		file.write(json.dumps(data))

def main():
	repositories = []
	for repo_file in os.listdir('./out'):
		if repo_file.endswith('.json'): continue

		try:
			contents = open(f'./out/{repo_file}', 'r').readlines()
			repo_path = contents[0].strip()
			git_size = int(contents[1].split(' ')[0].strip())
			repo_data = json.loads(contents[2])
			repo_name = os.path.basename(repo_path).replace('.git', '')
			repo =  {
				'name': repo_name,
				'path': repo_path,
				'languages': repo_data,
				'totalSize': git_size
			}
			repositories.append(repo)
		except Exception as e:
			print(f'Error parsing {repo_file}: {e}')
			continue

	return write_repo_file(repositories)

if __name__ == '__main__':
	print('Parsing repository data...')
	main()
