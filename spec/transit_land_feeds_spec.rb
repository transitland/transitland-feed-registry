describe TransitLandFeeds do
  context 'validation' do
    it 'succeeds on a complete feed' do
      validation_results = TransitLandFeeds.validate_feed('
        {
          "url": "http://www.actransit.org/wp-content/uploads/gtfsdec072014b.zip",
          "feedFormat": "gtfs",
          "tags": {
            "license": "Creative Commons Attribution 3.0 Unported License",
            "licenseUrl": "http://www.actransit.org/data-terms-and-conditions/"
          },
          "operatorsInFeed": [
            {
              "operator": {
                "name": "Alameda-Contra Costa Transit District",
                "tags": {
                  "us_national_transit_database_id": 9014,
                  "website": "http://www.actransit.org",
                  "timezone": "America/Los_Angeles"
                },
                "identifiers": [
                  { "identifier": "AC Transit" }
                ],
                "onestop_id": "o-9q9-ACTransit",
                "geometry": {"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-122.4219466,37.7728291],[-122.2998181,37.5351863],[-122.1487153,37.3938421],[-122.1458932,37.3934467],[-121.9001573,37.4138609],[-121.8941378,37.4317001],[-121.91129,37.530161],[-122.251045,37.9667104],[-122.2533713,37.9682723],[-122.3028331,37.9915676],[-122.3038451,37.9917478],[-122.3485642,37.9966206],[-122.349579,37.996726],[-122.3545248,37.9931709],[-122.3867859,37.9288703],[-122.4219466,37.7728291]]]}}
              },
              "gtfsAgencyId": "AC Transit"
            }
          ]
        }
      ')
      expect(validation_results.count).to eq 0
    end

    it 'catch a missing OnestopID' do
      validation_results = TransitLandFeeds.validate_feed('
        {
          "url": "http://www.actransit.org/wp-content/uploads/gtfsdec072014b.zip",
          "feedFormat": "gtfs",
          "tags": {
            "license": "Creative Commons Attribution 3.0 Unported License",
            "licenseUrl": "http://www.actransit.org/data-terms-and-conditions/"
          },
          "operatorsInFeed": [
            {
              "operator": {
                "name": "Alameda-Contra Costa Transit District",
                "tags": {
                  "us_national_transit_database_id": 9014,
                  "website": "http://www.actransit.org",
                  "timezone": "America/Los_Angeles"
                },
                "identifiers": [
                  { "identifier": "AC Transit" }
                ],
                "geometry": {"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-122.4219466,37.7728291],[-122.2998181,37.5351863],[-122.1487153,37.3938421],[-122.1458932,37.3934467],[-121.9001573,37.4138609],[-121.8941378,37.4317001],[-121.91129,37.530161],[-122.251045,37.9667104],[-122.2533713,37.9682723],[-122.3028331,37.9915676],[-122.3038451,37.9917478],[-122.3485642,37.9966206],[-122.349579,37.996726],[-122.3545248,37.9931709],[-122.3867859,37.9288703],[-122.4219466,37.7728291]]]}}
              },
              "gtfsAgencyId": "AC Transit"
            }
          ]
        }
      ')
      expect(validation_results.count).to be > 0
      expect(validation_results[0][:fragment]).to eq '#/operatorsInFeed/0/operator'
      expect(validation_results[0][:message]).to include "The property '#/operatorsInFeed/0/operator' did not contain a required property of 'onestop_id'"
    end

    it 'catch a badly formed OnestopID' do
      validation_results = TransitLandFeeds.validate_feed('
        {
          "url": "http://www.actransit.org/wp-content/uploads/gtfsdec072014b.zip",
          "feedFormat": "gtfs",
          "tags": {
            "license": "Creative Commons Attribution 3.0 Unported License",
            "licenseUrl": "http://www.actransit.org/data-terms-and-conditions/"
          },
          "operatorsInFeed": [
            {
              "operator": {
                "name": "Alameda-Contra Costa Transit District",
                "tags": {
                  "us_national_transit_database_id": 9014,
                  "website": "http://www.actransit.org",
                  "timezone": "America/Los_Angeles"
                },
                "identifiers": [
                  { "identifier": "AC Transit" }
                ],
                "onestop_id": "9q9-ACTransit",
                "geometry": {"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-122.4219466,37.7728291],[-122.2998181,37.5351863],[-122.1487153,37.3938421],[-122.1458932,37.3934467],[-121.9001573,37.4138609],[-121.8941378,37.4317001],[-121.91129,37.530161],[-122.251045,37.9667104],[-122.2533713,37.9682723],[-122.3028331,37.9915676],[-122.3038451,37.9917478],[-122.3485642,37.9966206],[-122.349579,37.996726],[-122.3545248,37.9931709],[-122.3867859,37.9288703],[-122.4219466,37.7728291]]]}}
              },
              "gtfsAgencyId": "AC Transit"
            }
          ]
        }
      ')
      expect(validation_results.count).to be > 0
      expect(validation_results[0][:fragment]).to eq '#/operatorsInFeed/0/operator/onestop_id'
      expect(validation_results[0][:message]).to include "The property '#/operatorsInFeed/0/operator/onestop_id' must start with \"o-\" as its 1st component, must include 3 components separated by hyphens (\"-\"), must include a valid geohash as its 2nd component, after \"o-\""
    end
  end
end
