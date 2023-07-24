import time
import random
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

options = Options()
options.add_experimental_option("detach", True)
driver = webdriver.Chrome(service=Service(ChromeDriverManager("114.0.5735.90").install()), options=options)

email = "jakewilcox242@gmail.com"
password = "Quhkud-5qorpa-nonqad"

driver.get("https://us.zyn.com/ZYNRewards/")
time.sleep(6)
driver.find_element("xpath", "/html/body/div[5]/div/div/div/div/button").click()

time.sleep(3)
driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/div[1]/input").send_keys(email)
driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/div[2]/input").send_keys(password)
driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/button").click()
