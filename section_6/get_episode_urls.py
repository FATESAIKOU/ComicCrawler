#!/usr/bin/env python3

import requests
import urllib
import json
import sys
import re

from bs4 import BeautifulSoup as Soup


def doRequest(url):
    return requests.get(url, cookies={'RI': '0'})


def searchEpisode(comic_url):
    resp = doRequest(comic_url)

    page = Soup(resp.content.decode(
        'big5', errors='ignore'), features="html.parser")
    rows = page.find_all('a', {"href": "#", "class": re.compile(r"Ch|Vol")})

    episodes = {}
    for row in rows:
        t = row.find('font')
        if t:
            title = t.getText().strip()
        else:
            title = row.getText().strip()
        episode_infos = \
            re.search('\'([\w|\d|-]*.html)\',(\d*),(\d*)',
                      row['onclick']).groups()
        episodes[title] = 'https://comicabc.com/online/new-' + \
            episode_infos[0].replace('.html', '').replace('-', '.html?ch=')

    return episodes


if __name__ == '__main__':
    comic_url = sys.argv[1]
    episode_urls = searchEpisode(comic_url)

    print(json.dumps(episode_urls), end='')
