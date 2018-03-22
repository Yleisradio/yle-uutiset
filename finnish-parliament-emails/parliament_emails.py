#!/usr/bin/env python
# -*- coding: UTF8 -*-
# @See http://www.python.org/dev/peps/pep-0263

#######
# ABOUT
#######

# Script for scraping Finnish parliament members email addresses.

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

# python parliament_email.py

# See: https://www.eduskunta.fi/FI/kansanedustajat/Sivut/Kansanedustajat-aakkosjarjestyksessa.aspx

#################
# VERSION HISTORY
#################

# Version 2.0
# - Second version. Now uses static urls.

# Version 1.0
# - Initial version.

#############################################################

# Python 2/3 compatible print
from __future__ import print_function

# Import requests for making http requests.
import requests
# Import BeautifulSoup for handling html contents.
from bs4 import BeautifulSoup

# Scraped from https://www.eduskunta.fi/FI/kansanedustajat/Sivut/Kansanedustajat-aakkosjarjestyksessa.aspx
urls = ['https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1346.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1306.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/392.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/914.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/786.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1310.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/127.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/917.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1313.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/351.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/923.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1093.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1094.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1317.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1096.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1099.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1320.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/778.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/931.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/451.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1100.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/116.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/926.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/538.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/118.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1322.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1107.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1324.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1326.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1328.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/363.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/805.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/938.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/967.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/768.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/941.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1119.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1331.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/797.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1333.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/565.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1334.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1276.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1121.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1122.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1124.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1335.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/972.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1056.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/157.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1129.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/930.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/772.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/402.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/953.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/170.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/175.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/954.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1133.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1336.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/921.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/771.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/939.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1135.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/573.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/791.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1137.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/960.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1138.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/779.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1155.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1142.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/959.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1337.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1338.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1339.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1340.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1341.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1144.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1348.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/202.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1342.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/479.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1343.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/934.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/935.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1344.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1279.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/582.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1146.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1147.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/583.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1148.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1149.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1150.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1345.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1151.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1297.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1152.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1349.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1298.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1153.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1299.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/802.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1300.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/203.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1154.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1301.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/940.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/214.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1087.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1091.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1092.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/856.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/956.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1302.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/769.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/943.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/936.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/971.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/947.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/887.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1095.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/925.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/811.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1304.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1303.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/212.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1097.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1098.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1101.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/242.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/946.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1305.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1307.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1275.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/592.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1374.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/541.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1274.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/809.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1308.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/375.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1309.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1282.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1311.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/499.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1041.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1157.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/259.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1102.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1312.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/612.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/784.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1314.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1106.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1315.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1108.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1219.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1316.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/767.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1318.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1111.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1319.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/952.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1321.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1323.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1325.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1327.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1347.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/790.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/932.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1114.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1116.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1118.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1120.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1378.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1372.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/357.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1126.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1128.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/800.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/507.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/808.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/609.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/910.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1131.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/414.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1329.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1330.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/962.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/508.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/511.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1134.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/913.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/948.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1136.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1332.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/301.aspx',
        'https://www.eduskunta.fi/FI/kansanedustajat/Sivut/1141.aspx',
        ]

for url in urls:
    html = requests.get(url)
    parsed_html = BeautifulSoup(html.text, "lxml")
    email = parsed_html.find('table', {'class': 'mopPersonTable'}).findAll(
        'td', {'class': 'mopDataData'})[2].find('a')
    print(email)
