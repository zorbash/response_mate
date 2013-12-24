## Milestone 0.1.0
- Make the list command prompt you to perform any of the listed requests ✓
- Recording is optional, you may just perform requests to inspect their
- output. [Done]
- Support mustache templates in favor of erb ✓
- Extract Manifest to a separate class ✓
- Add usage instructions in README.md [Done]
- Remove support for .yml.erb request manifests [Done]
- Export Connection as a separate class [Done]
- Export Tape as a separate class [Done]

## Milestone 0.2.0
- Request helpers (random ids, uuids).
- Paraller requests.
- Expectations, a expectations.yml file will contain a list of keys and
- status codes to match against the recordings.
- response_mate server command that serves the recorded responses when
- requests matching requests.yml are replayed.
- Curl exporter.
- Export environment.yml to postman format
- Accept extra params/headers from cli
- Support request types: [:raw, urlencoded]
