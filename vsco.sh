#!/bin/bash

# Get Token JSON - NOTE: this uses older VSCO api to get token, 3486, but seems ok, works with later requests of the latest version
# Using Authorization token from - https://github.com/Mila432/VSCO_Private_Api/blob/master/main.py - note, can use your own
username="your_vsco_username"
password="your_vsco_password"
tkndata=`curl -s 'https://api.vsco.co/2.0/oauth/passwordgrant' \
  -H 'Authorization: Basic dnV6ZWRhemViZWp1Z2UzeWh1Z3k5ZXFlbWE1YTV1cmU5dTJ1c2FyYTpyeWplNXlydXBlemUyZXN5YmVyeQ==' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'x-client-platform: ios' \
  -H 'Accept-Language: en-GB, de-DE, da-DK, en-US, ru-RU' \
  -H 'x-client-build: 3486' \
  -H 'X-CLIENT-LOCALE: en' \
  -H 'User-Agent: VSCO/3486 CFNetwork/808.2.16 Darwin/16.3.0' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data "username=$username&password=$password&phone=&app_id=C7E7697B-92DA-A3F0-DDB4-2AF9D50A9722&grant_type=password" `

# Strip token value from JSON
token=`echo "$tkndata" | egrep -o 'access_token.*?,' | sed 's#access_token":"##g' | sed 's#",##g'`

# Perform search
QUERY="Johnny"
curl -H 'Host: api.vsco.co' -H 'User-Agent: VSCO/4199 CFNetwork/758.2.8 Darwin/15.0.0' -H 'x-client-build: 4199' -H 'x-client-platform: ios' -H 'Accept: */*' -H 'Accept-Language: en-US' -H "Authorization: Bearer $token" -H 'X-CLIENT-LOCALE: en' --compressed "https://api.vsco.co/2.0/search/grids?page=0&query=$QUERY&size=30"


# Get user profile (by id, site-id is the user id stupidly) can just increment starting from 1 or use search to get value
SITEID=1052 # johnny
curl -H 'Host: api.vsco.co' -H 'User-Agent: VSCO/4199 CFNetwork/758.2.8 Darwin/15.0.0' -H 'x-client-build: 4199' -H 'x-client-platform: ios' -H 'Accept: */*' -H 'Accept-Language: en-US' -H "Authorization: Bearer $token" -H 'X-CLIENT-LOCALE: en' --compressed "https://api.vsco.co/2.0/sites/$SITEID"

# Get media for user - must pass site-id and page number. not sure yet how to tell how many pages, seems like "total" is not an honest value
curl -H 'Host: api.vsco.co' -H 'User-Agent: VSCO/4199 CFNetwork/758.2.8 Darwin/15.0.0' -H 'x-client-build: 4199' -H 'x-client-platform: ios' -H 'Accept: */*' -H 'Accept-Language: en-US' -H "Authorization: Bearer $token" -H 'X-CLIENT-LOCALE: en' --compressed "https://api.vsco.co/2.0/medias?page=1&site_id=$SITEID&size=30"

# Can pull images from the 'responsive_url' attribute for each image in media for a user
# Sometimes have to accept a forward. For example:
# http://im.vsco.co/1/51ba944cbb43d1052/55363ffae955158f178b457a/vsco_042115.jpg
# forwards to =>
# http://image.vsco.co/1/51ba944cbb43d1052/55363ffae955158f178b457a/vsco_042115.jpg




# Web API ruby script - https://github.com/HuggableSquare/vsco-dl/blob/master/vsco-dl.rb
# Create a random uuid version 4 here - https://www.uuidgenerator.net/version4
#UUID="74eb3a76-7339-424c-8d5f-cb8586ab9b6e"
#INITIAL_SITEID=1052
#tkndata=`curl -s https://vsco.co/content/Static/userinfo -H "Cookie: vs_anonymous_id=$UUID" -H "Referer: https://vsco.co/${INITIAL_SITEID}/images/1"`
#token=`echo "$tkndata" | egrep -o 'tkn.*,' | sed 's#tkn":"##g' | sed 's#",##g'`


# GET TOKEN - weird current mobile api way
#curl -H ':method: POST' -H ':scheme: https' -H ':path: /v1/open' -H ':authority: api.branch.io' -H 'accept: */*' -H 'content-type: application/json' -H 'user-agent: VSCO/4199 CFNetwork/758.2.8 Darwin/15.0.0' -H 'content-length: 647' -H 'accept-language: en-us' -H 'accept-encoding: gzip, deflate' --data-binary '{"facebook_app_link_checked":0,"metadata":{},"screen_height":1136,"app_version":"45","update":1,"ad_tracking_enabled":0,"brand":"Apple","retryNumber":0,"uri_scheme":"vsco","identity_id":"42899284224244242","os":"iOS","hardware_id":"somehardwareuuidv4_notmineplz","screen_width":640,"ios_bundle_id":"co.visualsupply.cam","ios_vendor_id":"vendor_id_here_notmineplz","hardware_id_type":"idfa","instrumentation":{"/v1/close-brtt":"459"},"debug":0,"is_hardware_id_real":1,"os_version":"9.2.1","model":"iPhone6,1","branch_key":"key_live_mhkjewgawegaewihgawegwe","device_fingerprint_id":"42899284224244242","sdk":"ios0.12.7"}' 'https://api.branch.io/v1/open'

