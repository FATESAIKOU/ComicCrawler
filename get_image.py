#!/usr/bin/env python3

import os
import sys
import json
from selenium import webdriver


def crawl_image(url):
    print(f"[Init Options]", file=sys.stderr)

    # 設定於 Docker 中啟動瀏覽器的必要參數
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--proxy-server=socks5://localhost:8079')

    # 設定 logging 相關參數
    chrome_options.add_argument('--enable-logging')
    chrome_options.add_argument('--log-level=0')

    # 更換 chromedriver.log 輸出位置
    chrome_options.add_argument('--homedir=/tmp')

    try:
        # Launch Browser
        print(f"[Launch Browser]", file=sys.stderr)
        driver = webdriver.Chrome(options=chrome_options)

        # 前往目標集數
        driver.get(url)
        driver.implicitly_wait(10)

        # 爬取頁數
        page_num = int(driver.execute_script("""
            return document.querySelector('#pageindex > option:last-child').value
        """))
        image_urls = []

        # 根據頁數爬取每一頁圖片的 url
        for i in range(1, page_num + 1):

            # 前往第 i 頁
            print(f"[Go to] {url}-{i}", file=sys.stderr)
            driver.get(f"{url}-{i}")

            # 抽取目標圖片網址
            image_urls.append(driver.execute_script("""
                return document.getElementById('TheImg').src;
            """))
            print(f"[Get Page: {i}] {image_urls[-1]}", file=sys.stderr)

        # 關閉網頁
        driver.close()
    except Exception as e:
        # 如果出錯，於銀幕輸出錯誤內容
        print(f"[Error] {e}", file=sys.stderr)

        # 如果 Chrome 有輸出 log 就輸出(但如果在啟動之前就失敗就不會有 log)
        if os.path.exists('/tmp/chromedriver.log'):
            with open('/tmp/chromedriver.log', 'r') as logfile:
                print(f"[Browser Log] {logfile.read()}", file=sys.stderr)

        image_urls = []
        page_num = 0

    return image_urls, page_num


if __name__== '__main__':
    episode_url = sys.argv[1]
    
    image_urls, page_num = crawl_image(episode_url)

    print(json.dumps({
        'page_num': page_num,
        'image_urls': image_urls
    }), end='')

