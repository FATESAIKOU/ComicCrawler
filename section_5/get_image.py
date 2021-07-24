#!/usr/bin/env python3
import sys
import json
from selenium import webdriver


def crawl_image(url):
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--proxy-server=socks5://localhost:8079')

    driver = webdriver.Chrome(options=chrome_options)

    driver.get(url)
    driver.implicitly_wait(10)

    page_num = int(driver.execute_script("""
        return document.querySelector('#pageindex > option:last-child').value
    """))
    image_urls = []
    for i in range(1, page_num + 1):
        driver.get(f"{url}-{i}")
        image_urls.append(driver.execute_script("""
            return document.getElementById('TheImg').src;
        """))

    driver.close()

    return image_urls, page_num


if __name__ == '__main__':
    episode_url = sys.argv[1]

    image_urls, page_num = crawl_image(episode_url)

    print(json.dumps({
        'page_num': page_num,
        'image_urls': image_urls
    }), end='')
