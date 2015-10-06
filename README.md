[![Circle CI](https://circleci.com/gh/transitland/transitland-feed-registry.svg?style=svg)](https://circleci.com/gh/transitland/transitland-feed-registry)

# Transitland Feed Registry

## Deprecation Announcement
<span style="color:red;">As of October 2015, we're deprecating this repository.</span> Transitland will now store and serve out feed and operator information from the Datastore API at:

* [http://transit.land/api/v1/feeds](http://transit.land/api/v1/feeds)
* [http://transit.land/api/v1/feeds.geojson](http://transit.land/api/v1/feeds.geojson)
* [http://transit.land/api/v1/operators](http://transit.land/api/v1/operators)
* [http://transit.land/api/v1/operators.geojson](http://transit.land/api/v1/operators.geojson)

Query these endpoints any time you'd like. Save local copies of these data if you'd like. Use these data in your applications however you see fit. Feed and operator data will continue to be available under the [Public Domain Dedication and License v1.0](http://opendatacommons.org/licenses/pddl/summary/) in the Datastore API.

Soon we'll be releasing web interfaces that enable everyone to add and edit the feeds and operators in the Datastore. This will happen through the Datastore's [changeset API](https://github.com/transitland/transitland-datastore/blob/master/doc/changesets.md), making it simple to track the collective progress that we all make cataloging the world's GTFS feeds and public transit operators. These new user interfaces and API endpoints will enable all sorts of new possibilities.

We'll post an update here with links to the new user interfaces. In the meantime, please follow [@transitland](https://twitter.com/transitland) and feel free to e-mail us with your ideas and questions at [transitland@mapzen.com](mailto:transitland@mapzen.com).

Thanks to all of those who have tried out this experiment. We hope to see you reading from the Datastore API soon, and writing to it soon after!

---

## Historical Readme

The Transitland Feed Registry is a directory of URLs and IDs for data feeds from transit agencies around the world. It's machine-readable, and it's simple for contributors to add and edit feeds from the registry.

Each feed is represented by a JSON file in the [/feeds](/feeds) directory. Each file provides enough information for the [Transitland Datastore](https://github.com/transitland/transitland-datastore) -- or for your own scripts/services/applications -- to federate authoritative feeds by:

1. Fetching the feed file (at present, a GTFS zip archive)
2. Relating transit operators in the feed to identifiers from other sources
3. Linking to terms of use, license, and other information about the feed (included as a tag hash)

Each feed is identified by:

- a [Onestop ID](https://github.com/transitland/onestop-id-scheme), like `f-9q9-bayarearapidtransit`. This ID is globally unique and stable.
- [US National Transit Database](http://www.ntdprogram.gov/) ID, when available.
- [GTFS Data Exchange](http://www.gtfs-data-exchange.com/) ID, when available.

Would additional IDs be helpful? We welcome your contributions. Please [contact us](#contact).

## Contributing

**If you're unfamiliar with Github**: Please [open a Github issue](https://github.com/transitland/transitland-feed-registry/issues/new) with as much of the following information as you're able to specify:

Information to provide | Example
---------------------- | -------
Feed URL               | `http://www.bart.gov/dev/schedules/google_transit.zip`
URL for license/terms  | `http://www.sfmta.com/about-sfmta/reports/gtfs-transit-data`
NTD ID (for US public transit agencies)  | `9013`

Or, feel free to [contact us](#contact) for assistance.

**If you're familiar with Github and a command-line interface**:

1. Fork this repository and create a new branch for your contribution.
2. Clone your fork of the repository to your computer.
3. Make sure you have Python 2.7 and Ruby 2.0 available in your terminal.
4. Install a copy of [Transitland Python Client](https://github.com/transitland/transitland-python-client): `pip install transitland`
5. The `transitland.bootstrap` command will help bootstrap a new feed file based on an existing GTFS source. It will calculate the correct Onestop ID for the feed, and save a file for further manual editing. To run the command, specify a url to a GTFS file with `--url` and a name for the feed with `--feedname`, for example: `python -m transitland.bootstrap --url http://www.bart.gov/dev/schedules/google_transit.zip  --feedname bayarearapidtransit` (More information about this command is available in the [Transitland Python Client documentation](https://github.com/transitland/transitland-python-client#bootstrapping-a-feed-from-a-gtfs-source).
6. Copy the resulting feed file, e.g. f-9q9-bayarearapidtransit.json, to the /feeds directory.
7. Open your new feed file in a text editor. For example: `vim f-9q9-bayarearapidtransit.json`
8. For US-based public agencies, look up the appropriate ID from the [US NTD monthly database](http://www.ntdprogram.gov/ntdprogram/data.htm) for each operator in the feed. For example: `operatorsInFeed[0].identifiers: ["usntd://9013"]`
9. Add a link to license/terms for the feed to `tags.licenseUrl`
10. Run the [test and validation scripts](#test-and-validation) and make sure they pass.
11. Open a pull request.
12. Please be ready for a bit of discussion on the pull request. This project is in its early stages, so we'll be manually checking contributions and also asking questions along the way to refine the process.

## Test and Validation

Before opening pull requests, please validate your edits. You'll need Ruby 2.0 or later installed to run these scripts:

Change the directory to the validator folder:

````
cd validator
````

Get bundler if not installed:

````
gem install bundler
````

````
bundle install
bundle exec rake validate
````

Note that [our continuous-integration service](https://circleci.com/gh/transitland/transitland-feed-registry) will run the validation scripts again, after you open a pull request. We won't merge in additions until the tests are "green" and pass.

---

## Contact

Transitland is sponsored by [Mapzen](http://mapzen.com). Contact us with your questions, comments, or suggestions: [transitland@mapzen.com](mailto:transitland@mapzen.com).
