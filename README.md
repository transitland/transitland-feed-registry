[![Circle CI](https://circleci.com/gh/transitland/transitland-feed-registry.svg?style=svg)](https://circleci.com/gh/transitland/transitland-feed-registry)

# Transitland Feed Registry

The Transitland Feed Registry is a directory of URLs and IDs for data feeds from transit agencies around the world. It's machine-readable, and it's simple for contributors to add and edit feeds from the registry.

Each feed is represented by a JSON file in the `[/feeds](/feeds)` directory. Each file provides enough information for the [Transitland Datastore](https://github.com/transitland/transitland-datastore) -- or for your own scripts/services/applications -- to federate authoritative feeds by:

1. fetching the feed file (at present, only a GTFS zip archive)
2. mapping transit operators/agencies in the feed files against IDs from other sources
3. linking to terms of use, license, and other information about the feed (included as a tag hash)

Each feed is identified by:

- a [Onestop ID](https://github.com/transitland/onestop-id-scheme)), like `f-9q9-bayarearapidtransit`. This ID is globally unique and stable.
- [US National Transit Database](http://www.ntdprogram.gov/) ID, when available.
- [GTFS Data Exchange](http://www.gtfs-data-exchange.com/) ID, when available.

Would additional IDs be helpful? We welcome your contributions. Please [contact us](#contact).

## Contributing

**If you're unfamiliar with Github**: Please [open a Github issue](https://github.com/transitland/transitland-feed-registry/issues/new) with as much of the following information as you're able to specify:

Information to provide | Example
---------------------- | -------
feed URL               | `http://www.bart.gov/dev/schedules/google_transit.zip`
URL for license/terms  | `http://www.sfmta.com/about-sfmta/reports/gtfs-transit-data`
NTD ID (for US public transit agencies)  | `9013`

Or, feel free to [contact us](#contact) for assistance.

**If you're familiar with Github and a command-line interface**:

1. Fork this repository and create a new branch for your contribution.
2. Clone your fork of the repository to your computer.
2. Make sure you have Python 2.7 and Ruby 2.0 available in your terminal.
3. Install a copy of [Transitland Python Client](https://github.com/transitland/transitland-python-client): `pip install transitland`
4. Create a new feed file by typing in its public URL and specifying a name. For example: `python -m transitland.bootstrap --url http://www.bart.gov/dev/schedules/google_transit.zip  --feedname bayarearapidtransit` This command will compute the appropriate Onestop ID for the feed and bootstrap a new JSON file for it. (More information about this command is available in the [Transitland Python Client documentation](https://github.com/transitland/transitland-python-client#bootstrapping-a-feed-from-a-gtfs-source).
5. Open your new feed file in a text editor. For example: `vim feeds/f-9q9-bayarearapidtransit.json`
6. For US-based public agencies, look up the appropriate ID from the [US NTD monthly database](http://www.ntdprogram.gov/ntdprogram/data.htm) for each operator in the feed. For example: `operatorsInFeed[0].identifiers: ["usntd://9013"]`
7. Add a link to license/terms for the feed to `tags.licenseUrl`
8. Run the [test and validation scripts](#test-and-validation) and make sure they pass.
9. Open a pull request.
10. Please be ready for a bit of discussion on the pull request. This project is in its early stages, so we'll be manually checking contributions and also asking questions along the way to refine the process.

## Test and Validation

Before opening pull requests, please validate your edits. You'll need Ruby 2.0 or later installed to run these scripts:

````
cd validate
bundle install
bundle exec rake validate
````

Note that [our continuous-integration service](https://circleci.com/gh/transitland/transitland-feed-registry) will run the validation scripts again, after you open a pull request. We won't merge in additions until the tests are "green" and pass.

---

## Contact

Transitland is sponsored by [Mapzen](http://mapzen.com). Contact us with your questions, comments, or suggestions: [transitland@mapzen.com](mailto:transitland@mapzen.com).
