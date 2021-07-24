#!/usr/bin/env python3

from selenium import webdriver

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')

driver = webdriver.Chrome(options=chrome_options)
driver.get("https://google.com.tw")
driver.save_screenshot("google_homepage.png")
driver.close()
