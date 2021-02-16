#command to execute this code -> python3 parse.py http.xml

from xml.dom import minidom
from geolite2 import geolite2
import sys
import csv

#use reader from geolite2 to get country name
reader = geolite2.reader();

#declare a dictionary to store the countries and their frequencies
d = {}

#take the command line argument in sys.argv[1]
# print(sys.argv[1])
xmldoc = minidom.parse(sys.argv[1])

#extract pdml element by its tag name
pdml = xmldoc.getElementsByTagName('pdml')[0]

#extract all packets of the pdml element
packets = pdml.getElementsByTagName('packet')

#iterate in packets
for packet in packets:

	#get the element prs (or protos) by using tag name
	prs = packet.getElementsByTagName('proto')

	for pr in prs:

		#the data of our interest is contained in field tags inside pr tags
		fields = pr.getElementsByTagName('field')

		#declare a boolean variable check. we will set check = 1 if the user accessed the servie through proxy
		check = 0
		
		for field in fields:
			if(field.getAttribute('showname') == 'Via: Internet.org\\r\\n'):
				check = 1
				break

		for field in fields:
			#if check is 1, ie, user accessed the service via proxy 
			if(field.getAttribute('name') == 'http.x_forwarded_for' and check == 1):
				#get the ip address
				ip = field.getAttribute('show')
				value = reader.get(ip)

				#get the country from the ip address
				country = value['country']['names']['en']

				#check if country already exists in the dictionary, if so, then increment its count by 1
				if(country in d.keys()):
					d[country] += 1
				else:
					d[country] = 1


#sort the dictionary in descending order of frequencies of countries
d = dict(sorted(d.items(), key=lambda item: item[1], reverse=True))

#finally, open/create the data.csv file
file = open("data.csv", "w")
csvwriter = csv.writer(file)

#write the data to data.csv file in format {country, frequency}
for key, value in d.items():
	csvwriter.writerow([key, value])

file.close()
