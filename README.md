### ResponseMate

ResponseMate is a command line tool that aims to make inspecting and
recording HTTP requests/responses. It is designed with APIs in mind.

It is a cli supplement/replacement of [postman](https://github.com/a85/POSTMan-Chrome-Extension)

#### Install
`gem install response_mate-0.0.1.gem`

More info [Design Doc of the now deprecated rake task](https://github.com/skroutz/apiv3/wiki/ResponseMate-Design-Document)


## Usage

## Setup
A specific directory structure must be present to store the recordings.
To scaffold it do:
`response_mate setup`

ResponseMate's tasks heavily depend on a manifest file where you declare 
the requests to be made. The default expected filename of this manifest
is `requests.yml`.
The expected format of this file is like [this](https://gist.github.com/anonymous/8055040)

Example:

```yaml
base_url: http://localhost:3000/api
default_headers:
  accept: 'application/vnd.github.beta+json'
requests:
  -
    key: user_repos
    request: 'GET /user/repos'
  -
    key: user_issues
    request:
      path: '/user/issues'
      params:
        sort: 'updated'
  -
    key: users_repos
    request: 'GET /users/{{some_user_id}}/repos'

```

## Record
### Default
Record all the keys of the requests manifest file being `requests.yml`

`response_mate record`

### Specific key(s)

`response_mate -k key1 key2`

### Specify a different request manifest

`response_mate -r foo_api.yml`

### Specify a different base url for the requests

`response_mate -b http://api.foo.com`

## Clear

Remove any existing recordings

`response_mate clear`

## List

Lists existing recordings

`response_mate list`

## Export

Exports a requests manifest file to a different format
(currently only postman is supported)

`response_mate export -f postman`

### Export in pretty json

`response_mate export -f postman -p`

### Specify a different request manifest

`response_mate export -f postman -r foo_api.yml`


# List of contributors

- [zorbash](https://github.com/zorbash)
- [jimmikarily](https://github.com/jimmykarily)
