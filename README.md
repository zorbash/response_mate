## ResponseMate

[![Gem version](https://badge.fury.io/rb/response_mate.png)](http://badge.fury.io/rb/response_mate)
[![Code Climate](https://codeclimate.com/github/Zorbash/response_mate.png)](https://codeclimate.com/github/Zorbash/response_mate)
[![Dependencies tatus](https://gemnasium.com/Zorbash/response_mate.png)](https://gemnasium.com/Zorbash/response_mate)
[![Coverage Status](https://coveralls.io/repos/Zorbash/response_mate/badge.png?branch=master)](https://coveralls.io/r/Zorbash/response_mate?branch=master)
[![Build Status](https://travis-ci.org/Zorbash/response_mate.svg)](https://travis-ci.org/Zorbash/response_mate)

ResponseMate is a command line tool that helps inspecting and
recording HTTP requests/responses. It is designed with APIs in mind.

It is a cli supplement/replacement of [postman](https://github.com/a85/POSTMan-Chrome-Extension)

#### Install
`gem install response_mate`

## Usage

For a list of available commands run `response_mate help`
For help on a command run `response_mate help some_command`

## Setup

A specific directory structure must be present to store the recordings.
By default responses are stored in the current working directory, but the
output directory is configurable using the `-o` option.

Most ResponseMate's tasks depend on a manifest file where you declare
the requests to be made. The default expected filename of this manifest
is `requests.yml`. You may specify another file using the `-r` option.

Example:

```yaml
default_headers:
  accept: 'application/vnd.{{app_name}}.beta+json'
requests:
  -
    key: user_issues
    request:
      url: 'http://someapi.com/users/42/issues
  -
    key: user_friends
    request:
      url: 'http://someapi.com/users/42/friends'
      params:
        since: 'childhood'
        honest: '{{are_my_friends_honest}}'
```

Expressions inside `{{}}` will be evaluated as Mustache templates using
values from a file `environment.yml`.

## Record
### Default

Record all the keys of the requests manifest file being `requests.yml`

`response_mate record`

### Specific key(s)

`response_mate record -k key1 key2`

### Specify a different request manifest

`response_mate record -r foo_api.yml`

## Clear

Remove any existing recordings

`response_mate clear`

## Inspect

Performs the request and displays the output without recording

`response_mate inspect some_key`

## List

Lists existing recordings

`response_mate list`

## Export

Exports a requests manifest file to a different format
(currently only postman is supported)

`response_mate export`

### Export in pretty json

`response_mate export -f postman -p`

### Specify a different request manifest

`response_mate export -f postman -r foo_api.yml`

### Export the environment.yml

`response_mate export --resource=environment`

### Upload the exported and get a link

`response_mate export --resource=environment --upload`

# Licence
Released under the MIT License. See the
[LICENSE](https://github.com/Zorbash/response_mate/blob/master/LICENSE) file
for further details.
