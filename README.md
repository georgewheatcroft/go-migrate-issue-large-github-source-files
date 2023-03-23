# go migrate issue


## how to run the tests
requires:
- docker
- psql
- locally installed latest go-migrate (as of current: v4.15.2)

do:
```
    make setup-pg-container
    # then run the test using migrate against the running container
    ./do-test.sh

    # tearup/setup convenience methods are in the makefile if you wish to retry this
```

## expected result from tests

...
2023/03/21 21:09:23 Read and execute 1/u create_car_emissions_table
2023/03/21 21:09:23 Finished 1/u create_car_emissions_table (read 14.076442875s, ran 13.365167ms)
2023/03/21 21:09:23 error: unsupported content encoding: none

(it fails to run the large migration file in migrations/000002_insert_car_emissions_demo_data.up.sql)

## apparent cause

seems that there is a difference in what is returned by the github api depending on file size
according to these sources, its becuase of how the github api handles things dependent on file size
https://stackoverflow.com/questions/38910380/how-to-automatically-get-a-certain-file1mb-from-git
https://github.blog/changelog/2022-05-03-increased-file-size-limit-when-retrieving-file-contents-via-rest-api/

the go-migrate tool github source expects that returned filed content should have all the required file content in the response from the go-github function 'GetContents' - however
the api this calls does not have the same behaviour when files are >1MB in size, and does not return the expected response data (i.e. content encoding is '' and there is no direct content data in the
response returned)

### eg when requesting <1MB file - returned content is base64 encoded and can be accessed
```bash
gh api -H "Accept: application/vnd.github.v3+json" repos/georgewheatcroft/go-migrate-issue-large-github-source-files/contents/migrations/000002_insert_car_emissions_demo_data.down.sql
```
output:
```json
{
  "name": "000002_insert_car_emissions_demo_data.down.sql",
  "path": "migrations/000002_insert_car_emissions_demo_data.down.sql",
  "sha": "0107ec0290d07ad95036ad8e37095269da405dda",
  "size": 295,
  "url": "https://api.github.com/repos/georgewheatcroft/go-migrate-issue-large-github-source-files/contents/migrations/000002_insert_car_emissions_demo_data.down.sql?ref=master",
  "html_url": "https://github.com/georgewheatcroft/go-migrate-issue-large-github-source-files/blob/master/migrations/000002_insert_car_emissions_demo_data.down.sql",
  "git_url": "https://api.github.com/repos/georgewheatcroft/go-migrate-issue-large-github-source-files/git/blobs/0107ec0290d07ad95036ad8e37095269da405dda",
  "download_url": "https://raw.githubusercontent.com/georgewheatcroft/go-migrate-issue-large-github-source-files/master/migrations/000002_insert_car_emissions_demo_data.down.sql",
  "type": "file",
  "content": "LS1ub3Qgc3VyZSBpZiBtaWdyYXRlIHNjcmlwdGluZyBpcyB0aGUgZG9uZSB0\naGluZyBmb3IgaW5zZXJ0cyBidXQgaGV5Li4uLiAgICAKRE8gJCQKQkVHSU4K\nICAgSUYgRVhJU1RTICgKICAgICAgU0VMRUNUIEZST00gaW5mb3JtYXRpb25f\nc2NoZW1hLnRhYmxlcwogICAgICBXSEVSRSAgdGFibGVfc2NoZW1hID0gJ2V4\nYW1wbGUnCiAgICAgIEFORCAgdGFibGVfbmFtZSA9ICdjYXJfZW1pc3Npb25z\nJykgVEhFTgogICAgVFJVTkNBVEUgVEFCTEUgRVhBTVBMRS5DQVJfRU1JU1NJ\nT05TOwogICBFTkQgSUY7CkVORCAkJDsKCg==\n",
  "encoding": "base64",
  "_links": {
    "self": "https://api.github.com/repos/georgewheatcroft/go-migrate-issue-large-github-source-files/contents/migrations/000002_insert_car_emissions_demo_data.down.sql?ref=master",
    "git": "https://api.github.com/repos/georgewheatcroft/go-migrate-issue-large-github-source-files/git/blobs/0107ec0290d07ad95036ad8e37095269da405dda",
    "html": "https://github.com/georgewheatcroft/go-migrate-issue-large-github-source-files/blob/master/migrations/000002_insert_car_emissions_demo_data.down.sql"
  }
}
```

### eg when requesting 100MB >=1MB file - content is not returned, the download url must be used instead
```bash
gh api -H "Accept: application/vnd.github.v3+json" repos/georgewheatcroft/go-migrate-issue-large-github-source-files/contents/migrations/000002_insert_car_emissions_demo_data.up.sql
```
output:
```json
{
  "name": "000002_insert_car_emissions_demo_data.up.sql",
  "path": "migrations/000002_insert_car_emissions_demo_data.up.sql",
  "sha": "cd852976a773479f8b5529511cf891ef88b1c048",
  "size": 2400076,
  "url": "https://api.github.com/repos/georgewheatcroft/go-migrate-issue-large-github-source-files/contents/migrations/000002_insert_car_emissions_demo_data.up.sql?ref=master",
  "html_url": "https://github.com/georgewheatcroft/go-migrate-issue-large-github-source-files/blob/master/migrations/000002_insert_car_emissions_demo_data.up.sql",
  "git_url": "https://api.github.com/repos/georgewheatcroft/go-migrate-issue-large-github-source-files/git/blobs/cd852976a773479f8b5529511cf891ef88b1c048",
  "download_url": "https://raw.githubusercontent.com/georgewheatcroft/go-migrate-issue-large-github-source-files/master/migrations/000002_insert_car_emissions_demo_data.up.sql",
  "type": "file",
  "content": "",
  "encoding": "none",
  "_links": {
    "self": "https://api.github.com/repos/georgewheatcroft/go-migrate-issue-large-github-source-files/contents/migrations/000002_insert_car_emissions_demo_data.up.sql?ref=master",
    "git": "https://api.github.com/repos/georgewheatcroft/go-migrate-issue-large-github-source-files/git/blobs/cd852976a773479f8b5529511cf891ef88b1c048",
    "html": "https://github.com/georgewheatcroft/go-migrate-issue-large-github-source-files/blob/master/migrations/000002_insert_car_emissions_demo_data.up.sql"
  }
}

```
the content is empty in this case. To download the content, it should be preferred to use the `Accept: application/vnd.github.v3.raw` header in the request, or make the request and use the download url that is provided
```bash
gh api -H "Accept: application/vnd.github.v3.raw" repos/georgewheatcroft/go-migrate-issue-large-github-source-files/contents/migrations/000002_insert_car_emissions_demo_data.up.sql
```

outputs all of the desired data


## Suggested solution for go-migrate

the go-github client library that the github source uses supports download via 'download url' - go-migrate should use this
instead of GetContents directly https://github.com/google/go-github/blob/31350112a17a67bdc672f2a73865a2985b15fd60/github/repos_contents.go#L120-L128

see my PR where I have fixed the above using this approach - the tool works with my patch for all scripts (both <1MB and the script which is more than 1MB): https://github.com/golang-migrate/migrate/pull/900

