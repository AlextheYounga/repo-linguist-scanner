# Linguist Repo Scanner

## Scripts to Scan All Repositories on a Machine and Calculate Language Data

These are currently disconnected scripts, but they could easily be binded together into a single script

1. Find all repos
`./find_repos.sh /path/to/scan`

2. Calculate linguist data
`./linguist.sh`

3. Compile linguist data
`python -m main`

4. (Optional) Post the data to an API route
`python -m post`
