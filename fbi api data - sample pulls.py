# ------------------------------------
# FBI UCR/NIBRS API data
# queries to get crime/arrest numbers from public API page
# 
# accessing FBI API:
# PATH = https://api.usa.gov/crime/fbi/sapi/<whatever>?api_key=<key>
# see https://crime-data-explorer.fr.cloud.gov/api for table names
# ------------------------------------

# load packages needed to import/export data
import requests
import json
import pandas

# define macros for accessing data - API and key will not change
api = 'https://api.usa.gov/crime/fbi/sapi'
key = '?api_key=get your own key!'

# define file path for saved data
file_path = 'Raw data files/FBI API data - UCR and NIBRS/'

# define years for queries - API path format is "since_yr/until_yr" 
# if looking at one year only, put it as since_yr & until_yr
since_yr = 2019
until_yr = 2019

# define year(s) for file names - only include until_yr if timeframe is more than one year
if since_yr != until_yr:
	file_yrs = str(since_yr) + '-' + str(until_yr)
elif since_yr == until_yr:
	file_yrs = str(since_yr)
print(file_yrs)

# create state and offense lists for loops:
# state abbreviations 
statelist = (['AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY'])

# NIBRS offenses for tkm table
tkm_nibrsoffs = (['aggravated-assault','burglary','larceny','motor-vehicle-theft','homicide','rape','robbery','arson','violent-crime','property-crime'])

# arrest offenses
arrestoffs = (['aggravated-assault','all-other-offenses','arson','burglary','curfew','disorderly-conduct','dui','drug-grand-total','drug-possession-marijuana','drug-possession-opium','drug-possession-other','drug-possession-subtotal','drug-possession-synthetic','drug-sales-marijuana','drug-sales-opium','drug-sales-other','drug-sales-subtotal','drug-sales-synthetic','drunkenness','embezzlement','forgery','fraud','gambling-all-other','gambling-bookmaking','gambling-numbers','gambling-total','human-trafficking-commercial','human-trafficking-servitude','larceny','liquor-laws','motor-vehicle-theft','murder','offense-against-family','prostitution','prostitution-assisting','prostitution-prostitution','prostitution-purchasing','rape','robbery','runaway','sex-offenses','simple-assault','stolen-property','suspicion','vagrancy','vandalism','weapons'])


# ------------------------------------
# UCR CRIME NUMBERS BY STATE
# ------------------------------------
# summary-controller : Endpoints pertaining to UCR Estimated Crime Data
# State level UCR Estimated Crime Data Endpoint: /api/estimates/states/{stateAbbr}/{since}/{until}
# returns: reported crime by offense for specified state & year(s)

# define table for URL path
tbl = '/api/estimates/states/'

# define since/until years for URL path
years = str(since_yr) + '/' + str(until_yr)

# create empty data list - will extend to include each state's info in loop
data_list = []

# loop through statelist to pull data for each state and add to data_list
for stateabbr in statelist:
	# combine macros into URL (api, key, and years are defined at top of syntax)
	url = api + tbl + stateabbr + '/' + years + key
	print('URL = ' + url)

	# pull data from API
	data_raw = requests.get(url).json()

	# store "results" section of results in a list object - drop any metadata or extra info
	raw_list = data_raw.get('results',[])
	
	# FOR TESTING ONLY - check data - use json to show in better layout
	#print(json.dumps(raw_list, indent=4))
	
	# add raw list to data_list so that all states are in one list
	data_list.extend(raw_list)
	
# use pandas to convert json data list to frame w/ rows & columns
# do this outside of loop so that you only create a frame with all states data
data_frame = pandas.read_json(json.dumps(data_list))

# view data to make sure it looks ok before saving
data_frame

# save data frame as stata file (saves to current directory)
stata_file = file_path + 'UCR Estimated Crime Data Endpoint - by state ' + str(file_yrs) + '.dta'
print('Saving as "' + stata_file + '"')
data_frame.to_stata(stata_file)


# ------------------------------------
# NIBRS CRIME NUMBERS BY STATE
# ------------------------------------
# offense-tkm-controller : Endpoints pertaining to NIBRS Offense Demographic data
# State level NIBRS Offense Count Endpoint: /api/nibrs/{offense}/offense/states/{stateAbbr}/{variable} 
# offense = SEE nibrsoffs_tkm LIST
# variable = count: incident counts by year for 1991 forward

# define table for URL path
tbl = '/api/nibrs/'

# create empty data list - will extend to include each state's info
data_list = []

# loop through statelist to pull data for each state and add to data_list
for stateabbr in statelist:
	# loop through offenses for each state
	for offense in tkm_nibrsoffs:
		# combine macros into URL (api, key, and years are defined at top of syntax)
		url = api + tbl + offense + '/offense/states/' + stateabbr + '/count' + key
		print('URL = ' + url)

		# pull data from API - separate .get and .json steps to avoid errors
		data_raw = requests.get(url)
				
		# put data in json format so it's easier to work with
		data_raw_j = data_raw.json()
		
		# FOR TESTING ONLY - check body of request
		#print(json.dumps(data_raw_j, indent=4))
		
		# if "data" section is empty, create a dummy list with state and offense 
		# if "data" section is not empty, get results and drop any metadata or extra info
		if not data_raw_j.get('data'):
			print('no data in API')
			raw_list = [{'offense': offense, 'state_abbr': stateabbr}]
		else:
			raw_list = data_raw_j.get('data',[])
		
			# add offense name column
			raw_list[0]['offense'] = offense
			
			# add state abbreviation column
			raw_list[0]['state_abbr'] = stateabbr
		
		# FOR TESTING ONLY - check data - use json to show in better layout
		#print(json.dumps(raw_list, indent=4))
		
		# add raw list to data_list so that all states are in one list
		data_list.extend(raw_list)

# use pandas to convert json data list to frame w/ rows & columns
data_frame = pandas.read_json(json.dumps(data_list))

# view data to make sure it looks ok before saving
data_frame

# save data frame as stata file (saves to current directory)
stata_file = file_path + 'NIBRS Offense Count Endpoint_tkm - by state.dta'
print('Saving as "' + stata_file + '"')
data_frame.to_stata(stata_file)


# ------------------------------------
# ARREST NUMBERS BY STATE
# ------------------------------------
# arrest-data-controller : Endpoints pertaining to Arrest Demographic data
# State level Arrest Demographic Count Endpoint: /api/data/arrest/states/offense/{stateAbbr}/{variable}/{since}/{until} 
# variable = all: annual counts by offense

# define table for URL path
tbl = '/api/data/arrest/states/offense/'

# define since/until years for URL path
years = str(since_yr) + '/' + str(until_yr)

# create empty data list - will extend to include each state's info
data_list = []

# loop through statelist to pull data for each state and add to data_list
for stateabbr in statelist:
	# combine macros into URL (api, key, and years are defined at top of syntax)
	url = api + tbl + stateabbr + '/all/' + years + key
	print('URL = ' + url)

	# pull data from API
	data_raw = requests.get(url).json()

	# store "results" section of results in a list object - drop any metadata or extra info
	raw_list = data_raw.get('results',[])
	
	# add state abbreviation column
	raw_list[0]['state_abbr'] = stateabbr

	# FOR TESTING ONLY - check data - use json to show in better layout
	#print(json.dumps(raw_list, indent=4))
	
	# add raw list to data_list so that all states are in one list
	data_list.extend(raw_list)
	
# use pandas to convert json data list to frame w/ rows & columns
data_frame = pandas.read_json(json.dumps(data_list))

# view data to make sure it looks ok before saving
data_frame

# save data frame as stata file (saves to current directory)
stata_file = file_path + 'Arrest Demographic Count Endpoint - by state ' + str(file_yrs) + '.dta'
print('Saving as "' + stata_file + '"')
data_frame.to_stata(stata_file)

# --------
# State level Arrest Demographic Count Endpoint: /api/data/arrest/states/offense/{stateAbbr}/{variable}/{since}/{until} 
# variable = monthly: monthly counts by offense and year

# define table for URL path
tbl = '/api/data/arrest/states/offense/'

# define since/until years for URL path
years = str(since_yr) + '/' + str(until_yr)

# create empty data list - will extend to include each state's info
data_list = []

# loop through statelist to pull data for each state and add to data_list
for stateabbr in statelist:
	# combine macros into URL (api, key, and years are defined at top of syntax)
	url = api + tbl + stateabbr + '/monthly/' + years + key
	print('URL = ' + url)

	# pull data from API
	data_raw = requests.get(url).json()

	# store "results" section of results in a list object - drop any metadata or extra info
	raw_list = data_raw.get('results',[])
	
	# add state abbreviation column - note that only 1st month row has state info, will fill in later when formatting
	raw_list[0]['state_abbr'] = stateabbr

	# FOR TESTING ONLY - check data - use json to show in better layout
	#print(json.dumps(raw_list, indent=4))
	
	# add raw list to data_list so that all states are in one list
	data_list.extend(raw_list)
	
# use pandas to convert json data list to frame w/ rows & columns
data_frame = pandas.read_json(json.dumps(data_list))

# view data to make sure it looks ok before saving
data_frame

# save data frame as stata file (saves to current directory)
stata_file = file_path + 'Arrest Demographic Count Endpoint - monthly by state ' + str(file_yrs) + '.dta'
print('Saving as "' + stata_file + '"')
data_frame.to_stata(stata_file)
