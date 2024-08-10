#!/usr/bin/env python
"""
./scrape-theapplewiki-id.py Macmini6,2
Mac mini (Late 2012)
"""

#python -m pip install requests
#python -m pip install requests-cache
#python -m pip install beautifulsoup4

import sys
import time
import requests
import requests_cache
from bs4 import BeautifulSoup

ID = sys.argv[1].lower()

# Use a cache database so we don't keep requesting the exact same page data
requests_cache.install_cache('~/.py_requests_cache/cache')

URL = "https://theapplewiki.com/wiki/Models"
page = requests.get(URL)
soup = BeautifulSoup(page.content, "html.parser")

# Find every element that mentions the model identifier we want
hits = soup.find_all(string=lambda text: f"{ID}" in text.lower())
for hit in hits:
	hitparent = hit.parent.parent

	# find all elements that have "20" (as in 2001, 2011, 2021) in their text
	phits = hitparent.find_all(string=lambda text: f"20" in text.lower())
	for phit in phits:
		print(phit.text)
