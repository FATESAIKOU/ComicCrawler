#!/usr/bin/env python3

import os
import sys

from storage import Mysql
from crawler_utils import getComicHome, getEpisodes, getImages

from pprint import pprint

DB_HOST = os.environ['db_host']
DB_PORT = os.environ['db_port']
DB_USER = os.environ['db_user']
DB_PASS = os.environ['db_pass']


def main(crawl_limit):
    mysql_storage = Mysql('comicdb', DB_HOST, int(DB_PORT), DB_USER, DB_PASS)

    cnt = 0

    for comic in mysql_storage.get('comics'):
        print(f"Download Comic: {comic['comic_name']}", file=sys.stderr)
        comic_home = getComicHome(comic['comic_name'])
        episodes = getEpisodes(comic_home)

        downloaded_episode_names = [
            e['episode_name'] for e in mysql_storage.get('episodes', where=f"comic_id={comic['id']}")
        ]

        for e_name, e_url in episodes.items():
            if e_name in downloaded_episode_names:
                continue

            if cnt >= crawl_limit:
                return

            print(f"Download Episode: {e_name}", file=sys.stderr)
            mysql_storage.save_entire_episode(
                comic['comic_name'],
                e_name,
                getImages(e_url)
            )

            cnt += 1


if __name__ == '__main__':
    crawl_limit = int(sys.argv[1])
    main(crawl_limit)
