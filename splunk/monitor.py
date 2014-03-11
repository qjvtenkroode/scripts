#!/opt/splunk/bin/python
import sys
import os
import splunk.Intersplunk

results = splunk.Intersplunk.readResults(None, None, True)
search = sys.argv[1]

if(search == "license manager"):
	tag="#SPLUNK--A000015"
	message="Connection lost with the License manager: "
elif(search == "indexer"):
	tag="#SPLUNK--A000013"
	message="Indexer Down: "
elif(search == "deployment server"): 
	tag="#SPLUNK--A000014"
	message="Deployment Server or Client Down: "
elif(search == "forwarder"):
	tag="#SPLUNK--A000012"
	message="Forwarder within the Backbone Down/not sending data: "
elif(search == "license"):
	tag="#SPLUNK--A000018"
	message="License limit Exceeded: "
else:
	tag = "#SPLUNK--A000000"
	message = "unknown"

for res in results:
	os.system("logger -t " + tag + " -p local7.err -- " + message + res['peer'])
	os.system("echo `date` SPLUNK CRIT " + message + res['peer'] + " >> /opt/splunk/splunkhealth.log")
