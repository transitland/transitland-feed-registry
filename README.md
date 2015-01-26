[![Circle CI](https://circleci.com/gh/transit-land/onestop-id-registry.svg?style=svg)](https://circleci.com/gh/transit-land/onestop-id-registry)

# Onestop ID Registry

This is a machine-readable directory of:

- global, immutable [Onestop IDs](#onestop-ids) for transit operators/agencies
- global, immutable [Onestop IDs](#onestop-ids) for transit stops/stations
- authoritative transit-network [feeds](#feeds) available online

which can be used as a "crosswalk" to join data from [GTFS](https://developers.google.com/transit/gtfs/) feeds, the [U.S. National Transportation Database](http://www.ntdprogram.gov/ntdprogram/), the [Transitland Onestop API](https://github.com/transit-land/onestop), [OpenStreetMap](http://openstreetmap.org/), and other public sources of transit and geographic information.

We welcome others to use and contribute to this project.

---

## Onestop IDs

A Onestop ID is an alphanumeric, global, immutable identifer for transit operators/agencies and stops/stations. (In the future, we'll expand Onestop IDs to also cover routes, trips, and other aspects of fixed- and flexible-route public mass transportation.)

For example:

- `o-9q8y-SFMTA` is the Onestop ID for the [San Francisco Municipal Transportation Agency](http://www.sfmta.com/)
- `s-69y7p-RetSta` is the OnestopID for [Retiro Station](http://en.wikipedia.org/wiki/Retiro_railway_station) in Buenos Aires

Every Onestop ID includes three components, separated by hyphens:

1. the entity type:

    - `o` for operators/agencies
    - `s` for stops/stations

2. a [geohash](http://en.wikipedia.org/wiki/Geohash), a set of characters that can be translated into a geographic bounding box around the service area of the operator/agency or the location of the stop/station. The more characters, the more precise and smaller the bounding box. Seven characters of precision is the most recommended for a Onestop ID.

3. an abbreviated name that's short but understandable. No punctuation or special characters.

### Contributing a Onestop ID



You can use our [GTFS Agency to Convex Hull tool](http://transit-land.github.io/gtfs-agency-to-convex-hull/) to compute the geohash.

---

## Feeds

In the `/feeds` directory, you'll find one JSON file per feed. Each JSON file provides enough information for the [TransitLand Onestop API](https://github.com/transit-land/onestop) -- or your own scripts/services/applications -- to federate authoritative feeds by:

1. fetching the feed file (at present, only a GTFS zip archive)
2. mapping transit operators/agencies in the feed against:

    a. [Onestop IDs](#onestop-ids)

    b. NTD IDs, if in the United States

3. supplying a boundary for the geographic bounds of each operator/agency (as GeoJSON)
4. linking to terms of use, license, and other information about the feed (included as tags)

### Adding a Feed: If you're unfamiliar with Github

Please open a Github issue with as much of the above information as you're able to specify, or e-mail us at the address below.

### Adding a Feed: If you're familiar with Github

Please open a pull request with a JSON file named `feeds/COUNTRY-SUBDIVISION-NAME.json` where `COUNTRY` is a [two-letter country code](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2), `SUBDIVISION` is a [two- or three-letter code for state/province/principal subdivision](http://en.wikipedia.org/wiki/ISO_3166-2), and `NAME` is a short form of the name of the operator, agency, or maintainer of the feed. All parts of the file name should be lowercase.

We recommend copying one of the existing files and customizing its contents. In particular, you'll need to:

- Look up the NTD ID for public agencies in the United States (available in [this spreadsheet](http://www.ntdprogram.gov/ntdprogram/pubs/MonthlyData/October%202014%20Raw%20Database.xls)).
- Determine a polygon that defines the coverage area of the operator/agency and include it as [GeoJSON](http://geojson.org/). If the operator/agency doesn't supply this information, you can use our [GTFS Agency to Convex Hull tool](http://transit-land.github.io/gtfs-agency-to-convex-hull/) to compute this.
- Include a [Onestop ID](#onestop-ids) for each operator/agency. (For example: `o-9q9-ACTransit` and `o-9q8y-SFMTA`.) First look in `onestop_ids/operators.csv` to see if your operator/agency already has a Onestop ID defined. If not, follow the instructions above to create one.
- Run the [test and validation scripts](#test-and-validation) and make sure they pass.

---

## Test and Validation

Before opening pull requests, please run the included validation scripts. You'll need Ruby 2.0 or later installed to run these scripts:

````
bundle install
bundle exec rake
````

Note that [our continuous-integration service](https://circleci.com/gh/transit-land/onestop-id-registry) will run the validation scripts again, after you open a pull request. We won't merge in additions until the tests all pass.

---

## Future Functionality

- [ ] support feed formats besides GTFS (like TransXChange)
- [ ] for agencies that change their feed URLs (e.g., to include the date in the GTFS file name), instead specify directions that a web scraper can use to find and follow the current download link
- [ ] map stop/station locations in feeds against Onestop IDs
- [ ] reference stops/stations in the United Kingdom against [NaPTAN](https://www.gov.uk/government/publications/national-public-transport-access-node-schema)

---

## Contact

Transitland is sponsored by [Mapzen](http://mapzen.com). Contact us with your questions, comments, or suggests: [hello@mapzen.com](mailto:hello@mapzen.com).
