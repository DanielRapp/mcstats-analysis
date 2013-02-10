import json
import csv
import sys

with open(sys.argv[1], 'r') as input_file, open(sys.argv[1]+'.csv', 'w') as output_file:
	fields = json.loads( input_file.readline() ).keys()

	file_writer = csv.writer(output_file, quoting=csv.QUOTE_NONNUMERIC)
	file_writer.writerow( list(fields) )

	for line in input_file:
		try:
			line_json = json.loads(line)
			values = [line_json[field] for field in fields]
			file_writer.writerow(values)
		except:
			continue
