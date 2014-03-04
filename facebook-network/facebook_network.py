#######
# ABOUT
#######

# Script for creating a network from given user list by Teemo Tebest

#########
# LISENCE
#########

# CC-BY-SA 4.0 Yle Uutiset / Teemo Tebest

#######
# USAGE
#######

# python facebook_network.py [filename] ({use_existing = True|False})

# See:
# - https://m.facebook.com/friends/?id=764732976
# - https://graph.facebook.com/
# - https://graph.facebook.com/teelmo

##############
# DEPENDENCIES
##############

# - Facebook: 'easy_install pyfacegraph' (https://github.com/iplatform/pyFaceGraph)
# - Pymongo: 'easy_install pymongo' (http://api.mongodb.org/python/current/)

#################
# VERSION HISTORY
#################

# Version 0.7 (TODO)
# - Add connections to requested person.

# Version 0.6
# - Added possibilitity to add new Facebook access token while fetching the edges.

# Version 0.5
# - Added an argument for not using databased results 
# - The script resaves the newly fetched data

# Version 0.4
# - Fixed script for accounts that have very many friends.

# Version 0.3
# - Removed DB from connections while the algorithm doesn't work properly when results are saved.

# Version 0.2
# - Now script only makes the network from the given users, not from all that are found from DB.
# - Output filename now depends on given filename.

# Version 0.1
# - Implemented Gexf output.
# - Implemented MongoDB.
# - Implemented pyFaceGraph.

#############################################################

# Import sys
import sys
# Check that a source file was given.
if len(sys.argv) < 2:
  print("\033[1mProvide a filename with Facebook profile URIs.\033[0m\nUsage \"python facebook_network.py [filename] ({use_existing})\"")
  exit()

if len(sys.argv) == 3:
  use_existing = sys.argv[2]
else:
  use_existing = 'True'

# Check that the source file exists
try:
  input_file = open(sys.argv[1], 'r')
except:
  print "\033[1mGiven filename was incorrect\033[0m\n"
  exit()

# Import re
import re
# Import datetime
import datetime
# Import requests
import requests
# Import json
import json
# Import time
import time

# Initialize MongoDB
from pymongo import Connection
connection = Connection('localhost', 27017)
db = connection.spotlight_network
users = db.users
connections = db.connections

# Initialize FB Graph API (https://github.com/iplatform/pyFaceGraph)
from facegraph import Graph
g = Graph()

# Get Facebook user access token from raw input
access_token = raw_input("\033[1mGive Facebook user access token:\033[0m\n")

# Helper function for constructing the fql query
def implode(pieces, glue = ''):
  if isinstance(pieces, list) or isinstance(pieces , set):
    return glue.join( pieces)
  elif isinstance(pieces, dict):
    return glue.join(pieces.values())
  return False

#######
# Begin
#######

# Initialise variables
line_num = 0
user = False
error = []
user_list = {}
# Read the given file line by line
print "\033[1mEnumerating profiles\033[0m\n"
for line in input_file:
  line_num = line_num + 1
  line_num_str = str(line_num) 
  # Deal with pages
  if re.search("/pages/", line):
    m = re.search("/pages/", line)
    print line_num_str + ". " + "\033[1mGiven line contains a page and is skipped\033[0m"
    continue
  # Deal with pages
  elif re.search("/groups/", line):
    m = re.search("/groups/", line)
    print line_num_str + ". " + "\033[1mGiven line contains a group and is skipped\033[0m"
  # Deal with IDs
  elif re.search("(/chat/messages\.php\?id=)(\d+)&(.*)", line):
    m = re.search("(/chat/messages\.php\?id=)(\d+)&(.*)", line)
    fuid = m.group(2)
    # Check if current ID is already in DB
    if not users.find({"fuid": fuid}).count() or use_existing == 'False':
      try:
        user = g[fuid]()
        if user:
          if users.find({"fuid": fuid}).count():
            users.remove({"fuid": fuid})
            print "Removed old data for %s friends" % fuid
          print line_num_str + ". " + user.name + " \033[1m***Added to DB***\033[0m"
          users.insert({"fuid": user.id, "data": user})
        else:
          print "\033[1m******ERROR! Incorrect Facebook ID***\033[0m\n" + line_num_str + ". " + line
          error.append(line_num_str + ". " + line)
          continue
        time.sleep(1)
      except:
        print "\033[1m******ERROR! Incorrect Facebook username***\033[0m\n" + line_num_str + ". " + line
        error.append(line_num_str + ". " + line)
        continue
    # Get user's data from DB even if it was fetched from FB
    for values in users.find({"fuid": fuid}):
      user = values['data']
      break
    user_list[user['id']] = user
    print line_num_str + ". " + user['name'] + " (" + user['id'] + ")"
  # Deal with usernames
  elif re.search("(/)([^\?\s\/]+)", line):
    m = re.search("(/)([^\?\s\/]+)", line)
    fusername = m.group(2)
    # Check if current username is already in DB
    if not users.find({"data.username": fusername}).count() or use_existing == 'False':
      try:
        user = g[fusername]()
        if user:
          if users.find({"data.username": fusername}).count():
            users.remove({"fuid": fusername})
            print "Removed old data for %s friends" % fusername
          print line_num_str + ". " + user.name + " \033[1m***Added to DB***\033[0m"
          users.insert({"fuid": user.id, "data": user})
        else:
          print "\033[1m******ERROR! Incorrect Facebook username***\033[0m\n" + line_num_str + ". " + line
          error.append(line_num_str + ". " + line)
          continue
        time.sleep(1)
      except:
        print "\033[1m******ERROR! Incorrect Facebook username***\033[0m\n" + line_num_str + ". " + line
        error.append(line_num_str + ". " + line)
        continue
    # Get user's data from DB even if it was fetched from FB
    for values in users.find({"data.username": fusername}):
      user = values['data']
      break
    user_list[user['id']] = user
    print line_num_str + ". " + user['name'] + " (" + user['id'] + ")"
  else:
    print "\033[1m******ERROR! Reqular experssion mismatch***\033[0m\n" + line_num_str + ". " + line
    error.append(line_num_str + ". " + line)
if error:
  print "\n\033[1mYou had errors in lines:\033[0m"
  for e in error:
    print e
  print "\nPlease check your data for those parts."

#####################
# Initialize the file
#####################

filename_sub = sys.argv[1].split('.')
now = datetime.datetime.now()
filename = ("%s_graph_%s.gexf" % (filename_sub[0], now.strftime("%Y-%m-%d")))
out = open(filename, "w")
out.write("""<?xml version="1.0" encoding="UTF-8"?>
<gexf xmlns="http://www.gexf.net/1.2draft"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
      xsi:schemaLocation="http://www.gexf.net/1.2draft 
      http://www.gexf.net/1.2draft/gexf.xsd" version="1.2">
<meta lastmodifieddate="%s">
  <creator>Teemo Tebest / @teelmo</creator>
  <description>Facebook network</description>
</meta>
<graph defaultedgetype="undirected" timeformat="double" mode="dynamic">
  <attributes class="node">
    <attribute id="0" title="id" type="float" />
    <attribute id="1" title="name" type="string" />
    <attribute id="2" title="username" type="string" />
    <attribute id="3" title="first_name" type="string" />
    <attribute id="4" title="last_name" type="string" />
    <attribute id="5" title="gender" type="string" />
    <attribute id="6" title="locale" type="string" />
  </attributes>
""" % now.strftime("%Y-%m-%d"))

#################
# Write the nodes
#################

user_ids = []
out.write("  <nodes>\n")
node_list = dict(user_list)
for node in node_list:
  data = node_list[node]
  user_ids.append("uid2 = %s" % data['id'])
  out.write("    <node id=\"fuid-%d\" label=\"%s\">\n" % (int(data['id']), data['name'].encode("utf-8")))
  out.write("      <attvalue for=\"0\" value=\"%d\"/>\n" % int(data['id']))
  out.write("      <attvalue for=\"1\" value=\"%s\"/>\n" % data['name'].encode("utf-8"))
  if 'username' in data:
    out.write("      <attvalue for=\"2\" value=\"%s\"/>\n" % data['username'].encode("utf-8"))
  else:
    out.write("      <attvalue for=\"2\" value=\"%s\"/>\n" % 'unknown')
  if 'first_name' in data:
    out.write("      <attvalue for=\"3\" value=\"%s\"/>\n" % data['first_name'].encode("utf-8"))
  else:
    out.write("      <attvalue for=\"3\" value=\"%s\"/>\n" % 'unknown')
  if 'last_name' in data:
    out.write("      <attvalue for=\"4\" value=\"%s\"/>\n" % data['last_name'].encode("utf-8"))
  else:
    out.write("      <attvalue for=\"4\" value=\"%s\"/>\n" % 'unknown')
  if 'gender' in data:
    out.write("      <attvalue for=\"5\" value=\"%s\"/>\n" % data['gender'])
  else:
    out.write("      <attvalue for=\"5\" value=\"%s\"/>\n" % 'unknown')
  if 'locale' in data:
    out.write("      <attvalue for=\"6\" value=\"%s\"/>\n" % data['locale'])
  else:
    out.write("      <attvalue for=\"6\" value=\"%s\"/>\n" % 'unknown')
  out.write("    </node>\n")
out.write("  </nodes>\n")

#################
# Write the edges
#################

print "\033[1mEnumerating connections\033[0m\n"
out.write("  <edges>\n")

# Initialize variables
idx1 = 0
idx2 = 0
edge_id = 0
line_num = 0
lenght = 300
item_count = len(user_ids)
user_ids_query = []
# Divide queries into multiple.
while True:
  idx2 = idx2 + lenght
  if idx2 >= item_count:
    user_ids_query.append(implode(user_ids[idx1:item_count], ' OR '))
    break
  else:
    user_ids_query.append(implode(user_ids[idx1:idx2], ' OR '))
  idx1 = idx1 + lenght

edge_list = dict(user_list)
while True:
  row_count = 1
  query_count = 1
  r_tmp = {}
  for node in edge_list:
    line_num = line_num + 1
    line_num_str = str(line_num)
    data = node_list[node]
    uid1 = data['id']
    domain = "https://graph.facebook.com"
    for query in user_ids_query:
      fql_query = "SELECT uid2 FROM friend WHERE uid1 = %s and (%s)" % (uid1, query)
      fql = "/fql?q=%s&access_token=%s" % (fql_query, access_token)
      try:
        r = requests.get(domain + fql)
      except:
        print "\033[1mError occured will try again\033[0m" 
        r = requests.get(domain + fql)
      connections_json = json.loads(r.text)
      if 'error' in connections_json:
        print "\033[1mError\033[0m"
        print connections_json
        access_token = raw_input("\033[1mGive new Facebook user access token:\033[0m\n")
        fql = "/fql?q=%s&access_token=%s" % (fql_query, access_token)
        r = requests.get(domain + fql)
        connections_json = json.loads(r.text)
      query_count = query_count + 1
      # Store the edges
      for connection_data in connections_json['data']:
        if connection_data['uid2'] in edge_list:
          out.write("    <edge id=\"edge-%s\" source=\"fuid-%s\" target=\"fuid-%s\" />\n" % (edge_id, uid1, connection_data['uid2']))
          edge_id = edge_id + 1
    print line_num_str + ". " + data['name'] + " (" + str(len(user_ids_query)) + " queries)"
    row_count = row_count + 1
    #time.sleep(1)
  if row_count >= len(user_list):
    break

out.write("  </edges>\n")

###################
# Finalize the file
###################

out.write("""</graph>\n</gexf>""")
out.close()

print "\033[1mAll done. Enjoy. Output: %s\033[0m" % filename
