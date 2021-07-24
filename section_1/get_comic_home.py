#!/usr/bin/env python3

import requests
import urllib
import json
import sys

from bs4 import BeautifulSoup as Soup


def doRequest(url):
    # 從港澳台以外的 IP 爬取需要設 cookie, 詳情請見：
    # [關於我想看漫畫卻不想看廣告這檔事 (2) — 靜態網站反爬蟲解法比較]
    return requests.get(url, cookies={'RI': '0'})


def searchComic(pattern):
    resp = doRequest(
        'https://comicbus.com/member/search.aspx?' +
        urllib.parse.urlencode({"k": pattern}, encoding='big5'))

    page = Soup(resp.content.decode(
        'big5', errors='ignore'), features="html.parser")
    rows = page.find_all(
        'td', style="border-bottom:1px dotted #cccccc; line-height:18px; padding-left:5px ")

    results = []
    for row in rows:
        results.extend(row.find_all('a', href=True))

    ret = {}
    for r in results:
        title = r.find('font').getText()
        if title == pattern:
            return 'https://comicbus.com' + r['href']

    return None


if __name__ == '__main__':
    print(searchComic(sys.argv[1]))
