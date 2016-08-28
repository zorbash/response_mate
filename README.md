## ResponseMate

[![Gem version](https://badge.fury.io/rb/response_mate.png)](http://badge.fury.io/rb/response_mate)
[![Code Climate](https://codeclimate.com/github/Zorbash/response_mate.png)](https://codeclimate.com/github/Zorbash/response_mate)
[![Dependencies tatus](https://gemnasium.com/Zorbash/response_mate.png)](https://gemnasium.com/Zorbash/response_mate)
[![Coverage Status](https://coveralls.io/repos/Zorbash/response_mate/badge.png?branch=master)](https://coveralls.io/r/Zorbash/response_mate?branch=master)
[![Build Status](https://travis-ci.org/Zorbash/response_mate.svg)](https://travis-ci.org/Zorbash/response_mate)

ResponseMate is a command line tool that helps inspecting and
recording HTTP requests/responses from a terminal.

It is designed with APIs in mind.

#### Install
`gem install response_mate`

## Commands

* [record](#record)
* [list](#list)
* [inspect](#inspect)
* [export](#export)
* [version](#version)

## Usage

For a list of available commands run `response_mate help`  
For help on a command run `response_mate help some_command`

## Requests Manifest

Most ResponseMate's tasks depend on a manifest file where you declare
the requests to be made.  
The default filename of this manifest is `requests.yml`.  
You may specify another file using the `-r` option.
This file has to be in [YAML](http://yaml.org/) format (but keep in mind
that JSON is a valid compatible subset of YAML).


Example:

```yaml
default_headers:
  accept: 'application/vnd.{{app_name}}.beta+json'
requests:
  -
    key: user_issues
    request:
      url: 'http://someapi.com/users/42/issues'
  -
    key: user_friends
    request:
      url: 'http://someapi.com/users/42/friends'
      params:
        since: 'childhood'
        honest: '{{are_my_friends_honest}}'
```

Expressions inside `{{}}` will be evaluated as
[Mustache templates](http://mustache.github.io/mustache.5.html) using values from a file 
named `environment.yml`.

You may specify a different location for the environment file using the
`-e` option.

Example:

```shell
response_mate inspect issues_show -e ./response_mate/production_environment.yml
```

If your requests manifest does not contain
[Mustache](http://mustache.github.io/mustache.5.html) tags you don't
need an environment file.


## Environment File

In this file (default location: `./environment.yml`) you may place
variables to be used in the [requests manifest](#requests-manifest).
Where applicable you may configure the location of the environment file
using the `-e` option.

Example

```yaml
response_mate record -e ./github/production_environment.yml
```

This file has to be in [YAML](http://yaml.org/) format (but keep in mind
that JSON is a valid compatible subset of YAML).


```yaml
# environment.yml
base_url: http://api.github.com
repo: rails/rails
```

Then in the [requests manifest](#requests-manifest) any values of keys
declared in the environment file can be used as follows.

```yaml
# requests.yml
requests:
  -
    key: repos_show
    url: {{base_url}}/repos/{{repo}}
```

## Record

Records the responses of HTTP requests declared in a [requests
manifest](#requests-manifest) file.

```shell
response_mate record
```

> By default responses are stored in the current working directory, but the
output directory is configurable using the `-o` option.

### Default Behavior

Without any arguments / options it records all the keys of the [requests manifest](#requests-manifest).

### Recording Specific Key(s)

If you wish to record the responses of a subset of the declared requests
in the [requests manifest](#requests-manifest), you may use the `-k`
option. You have to provide a space separated list of keys to be recorded.

```shell
response_mate record -k key1 key2
```

### Custom Manifest Location

The requests are expected to be declared in a file named `requests.yml`
in the current working directory.

You may have many request files to use for various purposes.
To specify the one to be used you may supply the `-r` option.

```shell
response_mate record -r github_api.yml
```

## Inspect

Performs the request and displays the output without recording

`response_mate inspect some_key`

## List

Lists recording keys, prompting either to record or to inspect

`response_mate list`

Same as in the [record](#record) command you may specify the output
directory using the `-o` option.

## Export

Exports either the [requests manifest](#requests-manifest) or the environment file
to a different format (currently only [postman](http://getpostman.com) is supported)

```
response_mate export
```

### Export in pretty json

```shell
response_mate export -f postman -p
```

### Custom Manifest Location

```shell
response_mate export -f postman -r github_requests.yml
```

### Export the Environment File

```shell
response_mate export --resource=environment
```

### Upload the exported and get a link

```shell
response_mate export --resource=environment --upload
```

## Version

Displays the version

# Licence
Released under the MIT License. See the
[LICENSE](https://github.com/Zorbash/response_mate/blob/master/LICENSE) file
for further details.
