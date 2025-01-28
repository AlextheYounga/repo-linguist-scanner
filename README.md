# Linguist Repo Scanner

## Scripts to Scan All Repositories on a Machine and Calculate Language Data

This currently runs nightly on an external server of mine, calculates all my language statistics, and then pushes them to my website. 

https://alextheyounger.me/

1. Find all repos
`./find_repos.sh /path/to/scan`

2. Calculate linguist data
`./linguist.sh`

3. Compile linguist data
`python -m main`

4. (Optional) Post the data to an API route
`python -m post`
