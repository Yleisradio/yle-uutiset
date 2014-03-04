#!/usr/bin/env python
# -*- coding: UTF8 -*-
# @See http://www.python.org/dev/peps/pep-0263

#######
# ABOUT
#######

# Script for scraping Etuovi data.

########
# AUTHOR
########

# Teemo Tebest (teemo.tebest@gmail.com)

#########
# LICENSE
#########

# CC-BY-SA 4.0 Yle Uutiset / Teemo Tebest

#######
# USAGE
#######

# python scraper_vuokraovi.py [start_page] [end_page]

# See:
# - http://www.vuokraovi.com/vuokra-asunnot
# - http://www.vero.fi/fi-FI/Syventavat_veroohjeet/Verohallinnon_paatokset/Verohallinnon_paatos_vuodelta_2012_toimi%2819141%29 

#################
# VERSION HISTORY
#################

# Version 1.0
# - Initial version.

#############################################################

# Import pymongo for storing up values
import pymongo
# Import requests for making http requests.
import requests
# Import BeautifulSoup for handling html contents.
from BeautifulSoup import BeautifulSoup
# Import re for making regular experssions.
import re
# Import sys for reading arguments.
import sys

if len(sys.argv) < 3:
  print("\033[1mProvide a starting and ending page.\033[0m\nUsage \"python scraper_etuovi.py [start_page] [end_page]\"")
  exit()
else:
  start_page = int(sys.argv[1])
  end_page = int(sys.argv[2]) + 1

# Create mongodb connection
from pymongo import Connection
connection = Connection('localhost', 27017)

database = connection.housing_data

table = database.etuovi

if len(sys.argv) == 4:
  if sys.argv[3] == 'true':
    print '\033[1mRemoved all existing records!\033[0m\n'
    table.remove()

cookie = {'org.springframework.mobile.device.site.CookieSitePreferenceRepository.SITE_PREFERENCE':'NORMAL','JSESSIONID':'183EE2F12C128B603790A0D5D1558022','evid_0006':'87ccc59d-4b80-489f-98cf-be92d6591fa6','evid_0006_ref':'false','adptseg_0006':'kv1001#a-kv1002#c-kv1003#d-kv1004#d-kv1005#c-kv1006#a:b-kv1008#c-kv1009#17-kv1010#b-kv1011#f-kv1012#c-kv1013#a-kv1016#1:11:13:2:7-kv1017#2-','adptset_0006':'1','evid_0006_set':'2','__utma':'82691985.304271103.1385626909.1385642039.1385658686.4','__utmb':'82691985.9.8.1385658723878','__utmc':'82691985','__utmz':'82691985.1385626909.1.1.utmcsr=kuluttaja.etuovi.com|utmccn=(referral)|utmcmd=referral|utmcct=/crometapp/product/realties/common/public/frontpage2/search_in_progress_to_vuokraovi.jsp','slbp_80':'2265258762.20480.0000','slbp_443':'2265258762.47873.0000'}

data_added = 0
data_existed = 0

# First we get data from the pages that list the apartments. 
# Ex. http://www.vuokraovi.com/vuokra-asunnot?page=1
for page in range(start_page, end_page):
  if (start_page > 0):
    print 'Parsing page: ' + str(page) 
    html = requests.post('http://www.vuokraovi.com/vuokra-asunnot?page=' + str(page), cookies=cookie, data={'listorder':11, 'perpage':30})

    parsed_html = BeautifulSoup(html.text)
    rows = parsed_html.find('table', {'id':'itemList'}).find('tbody').findAll('tr', {'class': ['evenRow', 'oddRow']})

    row_index = 0
    for row in rows:
      row_index = row_index + 1
      column_index = 0
      apartment = dict() 
      columns = row.findAll('td')
      for column in columns:
        column_index = column_index + 1
        # apartment image.
        if column_index == 1:
          m = re.search('(\d+)\?entryPoint', column.find('div').find('a')['href'])
          apartment['aid'] = m.group(1)
          apartment['url'] = column.find('div').find('a')['href']
        # apartment type.
        if column_index == 2:
          apartment['type'] = column.text
        # Apartment size.  
        if column_index == 3:
          apartment['size'] = column.text
          if apartment['size'] == '':
            apartment['size'] = '0'
          if apartment['size'] == 'm2':
            apartment['size'] = '0'
        # Apartment rent.  
        if column_index == 4:
          apartment['rent'] = column.text
          if apartment['rent'] == '':
            apartment['rent'] = '0'
        # Apartment location.  
        if column_index == 6:
          apartment['location'] = column.text
      if apartment['aid'] != '':
        if not table.find({'aid': apartment['aid']}).count():
          data_added = data_added + 1
          # Push the collected data to db.
          table.insert({
            'build_year': '', 
            'rental_service': '', 
            'aid': apartment['aid'], 
            'type': apartment['type'],
            'size': apartment['size'],
            'url': apartment['url'],
            'size_nr': float(re.sub(r'[^0-9.]', '', apartment['size'].replace('m2', '').replace(',', '.'))),
            'rent': apartment['rent'],
            'rent_nr': float(re.sub(r'[^0-9.]', '', apartment['rent'].replace(' &euro;/kk', '').replace(' &euro;/vko', '').replace(',', '.'))),
            'location': apartment['location']
          })
        else:
          data_existed = data_existed + 1

print '\033[1mNew records:\033[0m ' + str(data_added)
print '\033[1mExisting records:\033[0m ' + str(data_existed)

print '\n\033[1mWill now search for additional data.\033[0m\n'

apartment_index = 0
# Second we get data from individual aparment pages.
# We need to do this while not all the information like build year
# is not available on the apartment listning page.
# Ex. http://www.vuokraovi.com/vuokra-asunto/helsinki/kalasatama/kerrostalo/yksio/484562?entryPoint=fromSearch&rentalIndex=1
print 'Fetching data for: ' + str(table.find({'build_year': ''}).count()) + ' houses.\n'
for apartment in table.find({'build_year': ''}):
  apartment_index = apartment_index + 1
  html = requests.get('http://www.vuokraovi.com' + apartment['url'], cookies=cookie)
  parsed_html = BeautifulSoup(html.text)
  try:
    apartment['rental_service'] = parsed_html.find('div', {'id':'rentalCardTenantInfo'}).find('a').text
  except:
    #print '\n\033[1mFailed to fetch rental service data for url:\n\033[0m http://www.vuokraovi.com' + apartment['url']
    apartment['rental_service'] = ''
  #print apartment['rental_service']
  try:
    rows = parsed_html.find('table', {'class':'rentaltable'}).find('tbody').findAll('tr', {'class': ['evenRow', 'odd']})
    row_index = 0
    apartment['street_address'] = apartment['postal_code'] = apartment['building'] = apartment['description'] = apartment['build_year'] = ''
    for row in rows:
      row_index = row_index + 1
      heading = row.find('th').text
      # Apartment address.
      if heading == 'Sijainti:':
        apartment['street_address'] = row.find('td').find('span', {'itemprop': 'streetAddress'}).text
        m = re.search('([0-9]{5})', row.find('td').find('span', {'itemprop': 'addressLocality'}).text)
        apartment['postal_code'] = m.group(1)
      # Apartment type.
      if heading == 'Tyyppi:':
        apartment['building'] = row.find('td').text
      # Apartment type.
      if heading == 'Kuvaus:':
        apartment['description'] = row.find('td').text
      # Apartment build year.
      if heading == 'Rakennusvuosi:':
        apartment['build_year'] = row.find('td').text
    if apartment['aid'] != '':
      # Update the existing database record
      # with the new data we've fetched.
      table.update({'aid':apartment['aid']}, {
        '$set': {
          'street_address': apartment['street_address'],
          'postal_code': apartment['postal_code'],
          'building': apartment['building'],
          'description': apartment['description'],
          'rental_service': apartment['rental_service'],
          'build_year': apartment['build_year']
        }
      })
    if (apartment_index % 10) == 0:
      print 'Fetched data for ' + str(apartment_index) + ' houses.'
  except:
    print '\n\033[1mFailed to fetch data for url:\n\033[0m http://www.vuokraovi.com' + apartment['url']

print '\n\033[1mAll done! Bye bye.\n\033[0m'

# You can export the data from database with this kind of command.
# mongoexport --db housing_data --collection etuovi  --csv -f aid,street_address,postal_code,building,description,rent_nr,size_nr,build_year,url > data.csv