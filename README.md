[![Circle CI](https://circleci.com/gh/transit-land/transit-land-feeds.svg?style=svg)](https://circleci.com/gh/transit-land/transit-land-feeds)

# TransitLandFeeds

This is a machine-readable directory of authoritative transit network feeds. In the `/data` directory, you'll find one JSON file per feed. Each JSON file provides enough information for [TransitLand Onestop](https://github.com/transit-land/onestop)---or your own scripts/services/applications---to federate authoritate feeds by:

1. fetching the feed file (at present, only a [GTFS](https://developers.google.com/transit/gtfs/) zip archive)
2. mapping transit operators/agencies in the feed against:

    a. global, immutable OnestopID's
    b. [National Transportation Database](http://www.ntdprogram.gov/ntdprogram/) ID's, if in the United States

3. supplying a boundary for the geographic bounds of each operator/agency (as GeoJSON)
4. linking to terms of use, license, and other information about the feed (included as tags)

## Adding a Feed

We welcome additions:

**If you're familiar with Github**, please open a pull request with a JSON file named `data/COUNTRY-STATE-OPERATOR.json` where `COUNTRY` is a [two-letter country code](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2), `STATE` is a [two- or three-letter code for state/province](http://en.wikipedia.org/wiki/ISO_3166-2), and `OPERATOR` is a short form of the operator/agency's name. All parts of the file name should be lowercase.

We recommend copying one of the existing files and customizing its contents. In particular, you'll need to:

- Look up the NTD ID for public agencies in the United States (available in [this spreadsheet](http://www.ntdprogram.gov/ntdprogram/pubs/MonthlyData/October%202014%20Raw%20Database.xls)).
- Determine a polygon that defines the coverage area of the operator/agency and include it as [GeoJSON](http://geojson.org/). If the operator/agency doesn't supply this information, you can use our [GTFS Agency to Convex Hull tool](http://transit-land.github.io/gtfs-agency-to-convex-hull/) to compute this.
- Give each operator/agency a OnestopID (TransitLand's system of global immutable identifiers). For example: `o-9q9-ACTransit` and `o-9q8y-SFMTA`. Note that all operator OnestopID's begin with `o-`, include a [geohash](http://en.wikipedia.org/wiki/Geohash) that bounds the operator's coverage area, and end with a short form of the operator's name. You can use our [GTFS Agency to Convex Hull tool](http://transit-land.github.io/gtfs-agency-to-convex-hull/) to compute the geohash.

Before opening your pull request, please run the included validation scripts. You'll need Ruby 2.0 or later installed to run these scripts:

````
bundle install
bundle exec rake
````

Note that our continuous-integration service will run the validation scripts again, after you open a pull request. We won't merge in additions until the tests all pass.

**If you're unfamiliar with Github**, please open an issue with as much of the above information as you're able to specify, or e-mail us at the address below.

## Future Functionality

- [ ] support feed formats besides GTFS (like TransXChange)
- [ ] for agencies that change their feed URLs (e.g., to include the date in the GTFS file name), instead specify directions that a web scraper can use to find and follow the current download link
- [ ] map stop/station locations in feeds against OnestopID's

## Contact

This project is sponsored by [Mapzen](http://mapzen.com). Please contact us with your questions, comments, or suggests: [hello@mapzen.com](mailto:hello@mapzen.com.
