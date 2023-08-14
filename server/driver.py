import time
import random
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
import os
from dotenv import load_dotenv
from fake_useragent import UserAgent
load_dotenv()


#Dont think I need to restart driver for every login attempt but having a fresh start and not having

class Session():
    #Initalizing webdriver and signing into zyn
    #Could make these two functions but I want to display points on homepage so every session should be logged in regardless
    def __init__(self):
        #TODO: exception handeling for webdriver, loading inital page, and logging in
        self.driver = self._start_driver()
        print('driver started')
        self._login() 

    def _start_driver(self):
        print('starting driver')
        ua = UserAgent()
        options = Options()
        #detach option keeps browser open after runnning script & trying to get around 403 error
        options.add_experimental_option("detach", True)
        options.add_argument('--disable-blink-features=AutomationControlled')
        options.add_argument(f'user-agent={ua.random}')

        driver = webdriver.Chrome(service=Service(ChromeDriverManager("114.0.5735.90").install()), options=options)
        return driver

    def _login(self):
        print('logging in')
        self.driver.get("https://us.zyn.com/ZYNRewards/")
        time.sleep(random.randrange(5,10))
        self.driver.find_element("xpath", "/html/body/div[5]/div/div/div/div/button").click()
        self.driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/div[1]/input").send_keys(os.getenv('EMAIL'))
        self.driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/div[2]/input").send_keys(os.getenv('PASSWORD'))
        time.sleep(random.randrange(10, 13))
        self.driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/button").click()


    def enter_code(code):
        time.sleep(random.randrange(7, 10))
        self.driver.find_element("xpath", "/html/body/div[7]/div/div[1]/form/div[1]/input").send_keys(code)
        self.driver.find_element("xpath", "/html/body/div[7]/div/div[1]/form/div[1]/button").click()

s = Session()
