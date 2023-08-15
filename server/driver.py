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


#Do I need to initiate a new session for every login attempt?

class Session():
    #Initalizing webdriver and signing into zyn
    def __init__(self):
        #TODO: exception handeling for webdriver, loading inital page, and logging in,
        #checking if code went through. might be done easier on the front end tho... -> if (initial points == points after a code is entered){return 'fuck'} 
        self.driver = self._start_driver()
        print('driver started')

    def _start_driver(self):
        print('starting driver')
        ua = UserAgent()
        options = Options()
        #detach option keeps browser open after runnning script & trying to get around 403 error
        options.add_experimental_option("detach", True)
        options.add_argument('--disable-blink-features=AutomationControlled')
        options.add_argument("--disable-extensions")
        options.add_argument("--window-size=1500x900");
        options.add_argument(f'user-agent={ua.random}')
        driver = webdriver.Chrome(service=Service(ChromeDriverManager("114.0.5735.16").install()), options=options)
        return driver

    def login(self):
        print('logging in')
        self.driver.get("https://us.zyn.com/ZYNRewards/")
        time.sleep(random.randrange(3,5))
        self.driver.find_element("xpath", "/html/body/div[5]/div/div/div/div/button").click()
        time.sleep(random.randrange(1, 3))
        self.driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/div[1]/input").send_keys(os.getenv('EMAIL'))
        self.driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/div[2]/input").send_keys(os.getenv('PASSWORD'))
        time.sleep(random.randrange(5, 10))
        login_button = self.driver.find_element("xpath", "//button[@type='submit']")
        time.sleep(random.randrange(1, 3))
        self.driver.find_element('xpath', '/html/body/div[6]/form/div/div[1]/div[3]/div').click()
        time.sleep(random.randrange(15, 16))
        login_button.click()

    def get_points(self):
        points_element = self.driver.find_element("xpath", "/html/body/div[2]/a[2]/span[1]")
        print(points_element.get_attribute('innerHTML'))
        return(points_element.get_attribute('innerHTML'))


    def enter_code(code):
        time.sleep(random.randrange(7, 10))
        self.driver.find_element("xpath", "/html/body/div[7]/div/div[1]/form/div[1]/input").send_keys(code)
        self.driver.find_element("xpath", "/html/body/div[7]/div/div[1]/form/div[1]/button").click()

