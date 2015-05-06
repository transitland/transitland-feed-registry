[![Circle CI](https://circleci.com/gh/transitland/onestop-id-registry.svg?style=svg)](https://circleci.com/gh/transitland/onestop-id-registry)
[![Coverage Status](https://coveralls.io/repos/transitland/onestop-id-registry/badge.svg)](https://coveralls.io/r/transitland/onestop-id-registry)

# Onestop ID Registry

## Feeds

In the `/feeds` directory, you'll find one JSON file per feed. Each JSON file provides enough information for the [Transitland Feed Aggregator](#TODO) -- or for your own scripts/services/applications -- to federate authoritative feeds by:

1. fetching the feed file (at present, only a GTFS zip archive)
2. mapping transit operators/agencies in the feed files against records from other sources (using Onestop IDs for operators)
3. linking to terms of use, license, and other information about the feed (included as a tag hash)

## Contributing

**If you're unfamiliar with Github**: Please [open a Github issue](https://github.com/transitland/onestop-id-registry/issues/new) with as much of the following information as you're able to specify, or [contact us](#contact) for assistance.

### Contributing a Feed

1. Fork this repository and create a new branch for your contribution.
2. Decide on a Onestop ID for the feed that:
  * is unique
  * begins with `f-`
  * includes a geohash for the approximate coverage area of the feed. (You can use our [GTFS Agency to Convex Hull tool](http://transitland.github.io/gtfs-agency-to-convex-hull/) to compute this from a GTFS `.zip` or `stops.txt` file.)
  * ends with a brief name (with no spaces or punctuation)
3. Create a JSON file named `feeds/ONESTOP_ID.json` where `ONESTOP_ID` is your proposed Onestop ID for the feed. Better yet, duplicate and rename an existing file in that directory---it will give you a template to follow.
4. Include a public URL for the GTFS `.zip` file.
5. Look up and include the as many of the following as possible for the `"tags"` hash:

  tag key | tag value
  ------- | ---------
  `licenseUrl` | a webpage or PDF that gives license, terms, conditions for the feed
  `downloadPageUrl` | where you found the GTFS feed's URL
  `gtfs_data_exchange_id` | if this feed is included on [GTFS Data Exchange's master list](http://www.gtfs-data-exchange.com/agencies), include that ID here (the ID is last part of the URL. <p> For example, `a-reich-gmbh-busbetrieb` is the ID part of http://www.gtfs-data-exchange.com/agency/a-reich-gmbh-busbetrieb/)
  
6. Include a [Onestop ID](#onestop-ids) for each operator/agency listed in the GTFS feed's `agencies.txt`. First look in `/operators/` to see if your operator/agency already has a Onestop ID defined.
7. Run the [test and validation scripts](#test-and-validation) and make sure they pass.
8. Open a pull request.
9. Please be ready for a bit of discussion on the pull request. This project is in its early stages, so we'll be manually checking contributions and also asking questions along the way to refine the process.
10. After being merged into master, the feed record will be read by the [Onestop Updater](https://github.com/transitland/onestop-updater) and an operator GeoJSON file will be created.

## Test and Validation

Before opening pull requests, please validate your edits using the `[onestop-id-registry-validator](https://github.com/transitland/onestop-id-registry-validator)` library. You'll need Ruby 2.0 or later installed to run these scripts:

````
gem install onestop_id_registry_validator
onestop-id-registry-validator
````

Note that [our continuous-integration service](https://circleci.com/gh/transitland/onestop-id-registry) will run the validation scripts again, after you open a pull request. We won't merge in additions until the tests are "green" and pass.

---

## Licenses

**Code**: Unless otherwise indicated, the code used to build and maintain this registry is Copyright (C) 2014-2015 Mapzen and released under the [MIT license](http://opensource.org/licenses/MIT).

**Registry Data and Onestop IDs**: Unless otherwise indicated, all data in this registry repository (including JSON files and Onestop IDs) are made available under the [Public Domain Dedication and License v1.0](http://opendatacommons.org/licenses/pddl/summary/). By opening a pull request, you consent to release your contributions under these license terms as well.

**Feeds**: The Onestop ID Registry links to feeds that are offered under various terms and conditions. In the future, we hope to help standardize the licensing of feeds. (Please [contact us](#contact) if you are involved in similar efforts.) In the meantime, each [feed entity definition](#feeds) should include a `tags[].licenseUrl` property. Please access and review that document before making use of the feed and its data in your application.

## Contact

Transitland is sponsored by [Mapzen](http://mapzen.com). Contact us with your questions, comments, or suggestions: [transitland@mapzen.com](mailto:transitland@mapzen.com).
