#!/usr/bin/python
# -*- coding: UTF8 -*-
# @See http://www.python.org/dev/peps/pep-0263/

#######
# ABOUT
#######

# Script organize Finnish tax data.

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

# python tax_data_organizer.py [folder]

# Define county numbers.
counties = {
  1:'Uusimaa',
  2:'Varsinais-Suomi',
  4:'Satakunta',
  5:'Kanta-Häme',
  6:'Pirkanmaa',
  7:'Päijät-Häme',
  8:'Kymenlaakso',
  9:'Etelä-Karjala',
  10:'Etelä-Savo',
  11:'Pohjois-Savo',
  12:'Pohjois-Karjala',
  13:'Keski-Suomi',
  14:'Etelä-Pohjanmaa',
  15:'Pohjanmaa',
  16:'Keski-Pohjanmaa',
  17:'Pohjois-Pohjanmaa',
  18:'Kainuu',
  19:'Lappi',
  21:'Ahvenanmaan maakunta'
}

# Define some format helper vars.
b_open = "\033[1m"
b_close = "\033[0m"

# Import sys.
import sys

# Store folder name.
try:
  folder = sys.argv[1]
except:
  print (b_open + "Provide folder." + b_close + "\nUsage \"python tax_data_organizer.py {folder}\"")
  exit()

# Import glob.
import glob

# Get .csv files within given folder.
filenames = glob.glob(folder + "/*.csv")

# Import csv.
import csv

# Initialize MongoDB
from pymongo import Connection
connection = Connection('localhost', 27017)
db = connection.taxday_2013
county_db = db.county
country_db = db.country
# Clear databases.
county_db.remove({})
country_db.remove({})

def formatNumber(n,d):
  if d > 0:
    return str(round(n, d))
  else:
    return str(int(round(n, 0)))

for file_name in filenames:
  if "1.csv" in file_name: 
    file_type = 'income_work'
  elif "2.csv" in file_name:
    file_type = 'income_capital'
  elif "3.csv" in file_name:
    file_type = 'income_total'
  if "maa" in file_name: 
    data_type = 'koko_maa'
    with open(file_name, 'r') as csv_file:
      index = 0
      csv_rows = csv.reader(csv_file, delimiter=';', quotechar="'")
      for row in csv_rows:
        if index != 0:
          this_county_id = row[0].strip()
          country_db.insert({
            "county_id":int(row[0].strip()), # Maakuntanumero.
            "county":row[1].strip(), # Maakunnan nimi.
            "person_name":row[2].strip(), # Henkilön nimi.
            "birth_year":int(row[3].strip()), # Syntymävuosi.
            "income_work":float(row[4].strip().replace(",", ".")), # Valtionverotus, verotettava ansiotulo.
            "income_capital":float(row[5].strip().replace(",", ".")), # Valtionverotus, verotettava pääomatulo.
            # row[6] is empty.
            "income_work_tax":float(row[7].strip().replace(",", ".")), # Tulovero (ennen Tulo- ja varallisuusvero).
            "community_tax_taxable":float(row[8].strip().replace(",", ".")), # Kunnallisverotuksen verotettava.
            "community_tax":float(row[9].strip().replace(",", ".")), # Kunnallisvero.
            "tax_total":float(row[10].strip().replace(",", ".")), # Verot ja maksut yhteensä.
            "advances_total":float(row[11].strip().replace(",", ".")), # Ennakot yhteensä.
            "tax_return":float(row[12].strip().replace(",", ".")), # Veronpalautus.
            "arrears":float(row[13].strip().replace(",", ".")), # Jäännösvero.
            "tax_year":int(row[14].strip()), # Verovuosi.
            'income_total':float(row[4].strip().replace(',', '.')) + float(row[5].strip().replace(',', '.')),
            "type":file_type,
            "data_type":data_type
          })
        index = index + 1
    with open('clean/00_' + file_type + '.csv', 'wb') as csvfile:
      csv_writer = csv.writer(csvfile, delimiter=',',quotechar='"', quoting=csv.QUOTE_MINIMAL)
      csv_writer.writerow(['person_name','birth_year','income_work','income_capital','total','tax_percent','county'])
      for values in country_db.find({'type':file_type}).sort([(file_type, -1)]).limit(100):
        income_total = values['income_work'] + values['income_capital']
        tax_total = values['tax_total'] / (income_total) * 100
        if values['birth_year'] > 1994:
          values['person_name'] = u'alaikäinen henkilö'
        csv_writer.writerow([values['person_name'].encode('utf-8'),values['birth_year'],formatNumber(values['income_work'],0),formatNumber(values['income_capital'],0),formatNumber(income_total,0),formatNumber(tax_total,1),values['county'].encode('utf-8')])
  else: 
    data_type = 'maakunta'
    with open(file_name, 'r') as csv_file:
      index = 0
      csv_rows = csv.reader(csv_file, delimiter=';', quotechar="'")
      for row in csv_rows:
        if index != 0:
          this_county_id = row[0].strip()
          county_db.insert({
            'county_id':int(row[0].strip()), # Maakuntanumero.
            'county':row[1].strip(), # Maakunnan nimi.
            'person_name':row[2].strip(), # Henkilön nimi.
            'birth_year':int(row[3].strip()), # Syntymävuosi.
            'income_work':float(row[4].strip().replace(',', '.')), # Valtionverotus, verotettava ansiotulo.
            'income_capital':float(row[5].strip().replace(',', '.')), # Valtionverotus, verotettava pääomatulo.
            # row[6] is empty.
            'income_work_tax':float(row[7].strip().replace(',', '.')), # Tulovero (ennen Tulo- ja varallisuusvero).
            'community_tax_taxable':float(row[8].strip().replace(',', '.')), # Kunnallisverotuksen verotettava.
            'community_tax':float(row[9].strip().replace(',', '.')), # Kunnallisvero.
            'tax_total':float(row[10].strip().replace(',', '.')), # Verot ja maksut yhteensä.
            'advances_total':float(row[11].strip().replace(',', '.')), # Ennakot yhteensä.
            'tax_return':float(row[12].strip().replace(',', '.')), # Veronpalautus.
            'arrears':float(row[13].strip().replace(',', '.')), # Jäännösvero.
            'tax_year':int(row[14].strip()), # Verovuosi.
            'income_total':float(row[4].strip().replace(',', '.')) + float(row[5].strip().replace(',', '.')),
            'type':file_type,
            'data_type':data_type
          })
        index = index + 1
    with open('clean/' + this_county_id + '_' + file_type + '.csv', 'wb') as csvfile:
      if "3.csv" in file_name:
        csv_writer = csv.writer(csvfile, delimiter=',',quotechar='"', quoting=csv.QUOTE_MINIMAL)
        csv_writer.writerow(['person_name','birth_year','income_work','income_capital','total','tax_percent'])
        for values in county_db.find({'county_id':int(this_county_id),'type':file_type}).sort([(file_type, -1)]).limit(30):
          income_total = values['income_work'] + values['income_capital']
          tax_total = values['tax_total'] / (income_total) * 100
          if values['birth_year'] > 1994:
            values['person_name'] = u'alaikäinen henkilö'
          csv_writer.writerow([values['person_name'].encode('utf-8'),values['birth_year'],formatNumber(values['income_work'],0),formatNumber(values['income_capital'],0),formatNumber(income_total,0),formatNumber(tax_total,1)])
      else:
        csv_writer = csv.writer(csvfile, delimiter=',',quotechar='"', quoting=csv.QUOTE_MINIMAL)
        csv_writer.writerow(['person_name','birth_year','income_work','income_capital','total','tax_percent'])
        for values in county_db.find({'county_id':int(this_county_id),'type':file_type}).sort([(file_type, -1)]).limit(30):
          income_total = values['income_work'] + values['income_capital']
          tax_total = values['tax_total'] / (income_total) * 100
          if values['birth_year'] > 1994:
            values['person_name'] = u'alaikäinen henkilö'
          csv_writer.writerow([values['person_name'].encode('utf-8'),values['birth_year'],formatNumber(values['income_work'],0),formatNumber(values['income_capital'],0),formatNumber(income_total,0),formatNumber(tax_total,1)])
