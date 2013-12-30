## ResponseMate
[![Build Status](https://travis-ci.org/Zorbash/response_mate.png?branch=master)](https://travis-ci.org/Zorbash/response_mate)
[![Code Climate](https://codeclimate.com/github/Zorbash/response_mate.png)](https://codeclimate.com/github/Zorbash/response_mate)
[![Dependencies tatus](https://gemnasium.com/Zorbash/response_mate.png)](https://gemnasium.com/Zorbash/response_mate)
[[Coverage Status](https://coveralls.io/repos/Zorbash/response_mate/badge.png?branch=master)](https://coveralls.io/r/Zorbash/response_mate?branch=master)

ResponseMate is a command line tool that aims to make inspecting and
recording HTTP requests/responses. It is designed with APIs in mind.

It is a cli supplement/replacement of [postman](https://github.com/a85/POSTMan-Chrome-Extension)

#### Install
`gem install response_mate`

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

# Licence
Released under the MIT License. See the
[LICENSE](https://github.com/Zorbash/response_mate/blob/master/LICENSE) file
for further details.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Zorbash/response_mate/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

