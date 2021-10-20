import requests
import urllib
import json
import sys
import re
import os

from selenium import webdriver
from bs4 import BeautifulSoup as Soup


def doRequest(url):
    return requests.get(url, cookies={'RI': '0'})


def getComicHome(pattern):
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


def getEpisodes(comic_url):
    resp = doRequest(comic_url)

    page = Soup(resp.content.decode(
        'utf-8', errors='ignore'), features="html.parser")
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


def getImages(episode_url):
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--proxy-server=socks5://localhost:8079')

    chrome_options.add_argument('--enable-logging')
    chrome_options.add_argument('--log-level=0')

    chrome_options.add_argument('--homedir=/tmp')

    try:
        driver = webdriver.Chrome(options=chrome_options)

        driver.get(episode_url)
        driver.implicitly_wait(10)

        page_num = int(driver.execute_script("""
            return document.querySelector('#pageindex > option:last-child').value
        """))
        image_urls = []

        for i in range(1, page_num + 1):
            print(f"Download Image: {episode_url}-{i}", file=sys.stderr)
            driver.get(f"{episode_url}-{i}")

            image_urls.append(driver.execute_script("""
                return document.getElementById('TheImg').src;
            """))

        driver.close()
    except Exception as e:
        if os.path.exists('/tmp/chromedriver.log'):
            with open('/tmp/chromedriver.log', 'r') as logfile:
                print(f"[Browser Log] {logfile.read()}", file=sys.stderr)

        image_urls = []
        page_num = 0

    return image_urls
