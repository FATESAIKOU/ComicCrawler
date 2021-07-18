#!/usr/bin/env python3

import requests
import urllib
import json
import sys

from bs4 import BeautifulSoup as Soup


def doRequest(url):
    return requests.get(url, cookies={'RI': '0'})


def searchComic(pattern):
    resp = doRequest(
            'https://comicbus.com/member/search.aspx?' + \
            urllib.parse.urlencode({"k": pattern}, encoding='big5'))

    page = Soup(resp.content.decode('big5', errors='ignore'), features="html.parser")
    rows = page.find_all('td', style="border-bottom:1px dotted #cccccc; line-height:18px; padding-left:5px ")

    results = []
    for row in rows:
        results.extend(row.find_all('a', href=True))

    ret = {}
    for r in results:
        title = r.find('font').getText()
        if title == pattern:
            return 'https://comicbus.com' + r['href']

    return None


if __name__== '__main__':
    comic_name = sys.argv[1]

    comic_url = searchComic(comic_name)
    print(json.dumps(comic_url), end = '')

