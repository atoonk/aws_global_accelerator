#!/usr/bin/env python

##########################################################
# Andree Toonk
# Sept 1, 2019
# Simple visualation tool that takes a ripe atlas measurement
# as input and creates a geojon output
# add that json in for example a github gist and it 
# will be rendered as a geo map.
# Example geojson rendered with this script can be found here: 
# ./create_atlas_geomap.py 22698168
# https://github.com/atoonk/aws_global_accelerator/blob/master/ripeatlas-22698168.geojson
##########################################################


import urllib, json
import random
import sys

##########################################################
#Prefered colors, otherwise autogen in get_color()
##########################################################

colors = {
	"eu-central-1" : "#31e140",
	"us-west-2": "#f52097",
	"us-east-1": "#4157b5",
	"ap-southeast-1": "#e9bc1f"
}


##########################################################
# Check Input, expecting a ripe atlas measurement id
##########################################################
if len(sys.argv) < 2:
	print "expecting numeric argument: ./" + sys.argv[0] + " <ripe atlast measurment_id>"
	sys.exit(2)

measurement_id = sys.argv[1]
if not measurement_id.isdigit():
	print "expecting numeric argument: ./" + sys.argv[0] + " <ripe atlast measurment_id>"
	sys.exit(2)

##########################################################
# function to get Probe details, GPS coordinates
##########################################################

def get_gps_for_probe(probe_id):
	url = "https://atlas.ripe.net//api/v2/probes/" + str(probe_id)
	probe_response = urllib.urlopen(url)
	probe_data = json.loads(probe_response.read())
	if "error" in probe_data:
		print "probe data error"
		print probe_data
		return False
	else:
		return probe_data['geometry']['coordinates']

##########################################################
# function to get map marker color for region
##########################################################

def get_color(region):
	if region not in colors:
		color = "%06x" % random.randint(0, 0xFFFFFF)
		colors[region] = "#" + color

	return colors[region] 

##########################################################
# Main work happens here, parse measurement data
# append to results
##########################################################
	
def process_measurement(measurement):

	probe_id = measurement['prb_id']
	if "error" in measurement:
		return False
	
	if measurement['result']['ANCOUNT'] > 0:
		answer_str = str(measurement['result']['answers'][0]['RDATA'][0])
		rt = str(measurement['result']['rt']) + "ms"
		if answer_str.startswith('i-'):
			#i-055f489213e36990c.eu-central-1b
			words = answer_str.split(".")
			region=words[1] 
			region = region[:-1]
			gps_list = get_gps_for_probe(probe_id)
			if not gps_list:
				print "error fetching GPS"
				return False

			dotOnMap = {
				"type": "Feature",
				"geometry": {
					"type": "Point",
					"coordinates": gps_list
				},
				"properties": {
					"region":region,
					"time":rt,
					"marker-color": get_color(region),
				}
			}
			return dotOnMap

##########################################################
#Fetch measurement
##########################################################

url = "https://atlas.ripe.net//api/v2/measurements/" + measurement_id + "/results/?format=json"
response = urllib.urlopen(url)
data = json.loads(response.read())
if "error" in data:
	print "error fetching measurment data: " + url
	print data
	sys.exit(2)

##########################################################
# Loop through all data
##########################################################

all_dots = []
for i in data:
        dotOnMap = process_measurement(i)
        if dotOnMap:
                all_dots.append(dotOnMap)

##########################################################
#create GeoJson
##########################################################

geojson = {
        "type": "FeatureCollection",
        "features": all_dots
}

app_json = json.dumps(geojson,indent=4, separators=(',', ': '))

filename = "ripeatlas-"  +measurement_id + ".geojson"
f = open(filename, "w")
f.write(app_json +"\n")
f.close()

print "Done!"
print "result can be found in the file: " + filename

##########################################################
# And done :)
##########################################################
