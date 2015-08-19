# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

## Added

* `record`, `inspect`, `list` commands accept `-e` option to specify the
  environment file
* Warning when a manifest contains no requests
* ResponseMate::Environment#exists? to check if an environment file
  exists
* List command now accepts `-o` option to specify the output directory
  of recordings

## Changed

* The verb key in the recorded response is now lower cased Symbol (was
  upper case String)
* Manifests are preprocessed as Mustache templates only if they are
  identified as Mustache
* ResponseMate::Manifest#requests_for_keys returns empty array for any
  kind of blank input
* ResponseMate::Manifest#parse becomes private
* ResponseMate::Environment#parse does not exit when the file is missing
* The default output directory for the recordings is the current working
  directory (used to be `./output/responses/`)

## Fixed

* Exception handling for ManifestMissing, OutputDirError, KeysNotFound
  in bin/response_mate

## [0.3.3] - 2015-03-02

### Changed

* Force internal and external encoding to UTF-8
