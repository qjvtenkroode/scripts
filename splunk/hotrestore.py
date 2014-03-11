import os
import sys

SPLUNK_HOME = "/opt/splunk/"
SPLUNK_DB = "/opt/splunk/var/lib/splunk/"
BACKUP_FILE = "/opt/backup/hotbackup.tar.gz"

def restorebucket(path):
    # strip rawdata/journal.gz from path.
    bucket = os.path.dirname(os.path.dirname(path))
    print("\tRebuilding bucket: " + bucket)
    os.system(SPLUNK_HOME + '/bin/splunk rebuild ' + bucket)
    # get list of tsidx files
    tsidx = [ f for f in os.listdir(bucket) if f.endswith(".tsidx") ]
    for tsidxname in tsidx:
        print("\t\tFound tsidx files: " + tsidxname)
    # get min and max
    minlist = []
    maxlist = []
    for t in tsidx:
        n = t.split("-")
        maxlist.append(n[0])
        minlist.append(n[1])
    print("\t\tGetting min and max for folder name")
    tsidx_min = min(minlist)
    tsidx_max = max(maxlist)
    # get index path
    index = os.path.dirname(bucket)
    buck = os.path.basename(bucket)
    # get new bucket number
    bucketnr = buck.split("_")[2]
    print("\t\tNew bucket number: " + bucketnr)
    # rename the bucket
    print("\t\tNew bucket is called: " + index + "/db_" + tsidx_max + "_" + tsidx_min + "_" + bucketnr)
    print("\t\tRenaming bucket: cp -r " + bucket + " " + index + "/db_" + tsidx_max + "_" + tsidx_min + "_" + bucketnr)
    os.system('cp -r ' + bucket + ' ' + index + '/db_' + tsidx_max + '_' + tsidx_min + '_' + bucketnr)
    print("\t\tDeleting the renamed hot bucket: " + bucket)
    os.system('rm -rf ' + bucket)
    print("\n")

def main():
	print("Stopping Splunk...")
	os.system(SPLUNK_HOME + '/bin/splunk stop')
	# empty list for storing the paths to hot directories
	hots_paths = []
	# get a list of paths
	for dirname, dirnames, filenames in os.walk(SPLUNK_DB):
	# get path to all hot directories
		for dir in dirnames:
			if "hot_" in dir.lower():
				hots_paths.append(os.path.join(dirname, dir))
	for h in hots_paths:
		print("Deleting left over hot bucket: " + h)
		os.system('rm -rf ' + h)

	if os.path.isfile(BACKUP_FILE):
		print("Extracting tar file")
		os.system('tar -xvf ' + BACKUP_FILE + ' -C ' + SPLUNK_DB)
		# empty list for storing the paths to journal.gz files
		journal_paths = []
		# get a list of paths
		for dirname, dirnames, filenames in os.walk(SPLUNK_DB):
			# get path to all journal.gz files
			for filename in filenames:
				if filename.endswith(".gz"):
					if "hot" in dirname.lower():
						journal_paths.append(os.path.join(dirname, filename))

		print("\n")
		# iterate over the paths to restore all the buckets
		for p in journal_paths:
			print("Restoring bucket: " + p)
			restorebucket(p)
		print('Done!')
		print('Starting Splunk...')
		os.system(SPLUNK_HOME + '/bin/splunk start')
	else:
		print("Exiting: Backup file does not exists!")
		sys.exit()


##### Main loop #####
print("Backup file is located in: " + BACKUP_FILE)
validation = raw_input("Is this correct? yes/no: ")
validation = validation.strip()
if validation.lower() == 'no':
	BACKUP_FILE = raw_input("Full path to backup file: ")
	main()
elif validation.lower() == 'yes':
	main()
else:
	print("Usage: yes or no are the only keywords supported")
