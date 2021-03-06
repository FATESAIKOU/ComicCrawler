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
        'https://comicbus.com/member/search.aspx?' +
        urllib.parse.urlencode({"key": pattern}, encoding='utf-8'))

    page = Soup(resp.content.decode(
        'utf-8', errors='ignore'), features="html.parser")
    rows = page.find_all('div', class_="cat2_list text-center mb-4")

    results = []
    for row in rows:
        title = row.find('span').getText()

        if title == pattern:
            return 'https://comicbus.com' + row.find('a', href=True)['href']

    return None


if __name__ == '__main__':
    comic_name = sys.argv[1]

    comic_url = searchComic(comic_name)
    print(json.dumps(comic_url), end='')
