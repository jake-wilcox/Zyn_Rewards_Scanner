import time
import random
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC 
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
        options.add_argument(f'user-agent={ua.random}')
        driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
        return driver

    def login(self):
        print('logging in')
        self.driver.get("https://us.zyn.com/ZYNRewards/")
        time.sleep(random.randrange(3,5))
        self.driver.find_element("xpath", "/html/body/div[5]/div/div/div/div/button").click()
        time.sleep(random.randrange(1, 3))
        print('entering credentials')
        self.driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/div[1]/input").send_keys(os.getenv('EMAIL'))
        self.driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/div[2]/input").send_keys(os.getenv('PASSWORD'))


        # time.sleep(random.randrange(5, 10))
        # login_button = self.driver.find_element("xpath", "//button[@type='submit']")
        # time.sleep(random.randrange(1, 3))
        # self.driver.find_element('xpath', '/html/body/div[6]/form/div/div[1]/div[3]/div').click()
        # time.sleep(random.randrange(30, 36))
        # print('clicking button')
        # login_button.click()
        # login_button.click()
        # print(self.driver.current_url)


    def get_points(self):
        print(self.driver.current_url)
        print('getting points')
        points_element = self.driver.find_element("xpath", "/html/body/div[2]/a[2]/span[1]")
        print('found points element')
        time.sleep(random.randrange(1, 2))
        self.driver.find_element("xpath", "/html/body/div[13]/i").click()
        print(points_element.get_attribute('innerHTML'))
        return(points_element.get_attribute('innerHTML'))




    def enter_code(self, code):
        self.driver.find_element("xpath", "/html/body/div[8]/div/div[1]/form/div[1]/input").clear()
        time.sleep(random.randrange(1, 2))
        self.driver.find_element("xpath", "/html/body/div[8]/div/div[1]/form/div[1]/input").send_keys(code)
        time.sleep(random.randrange(1, 2))
        self.driver.find_element("xpath", "/html/body/div[8]/div/div[1]/form/div[1]/button").click()



    def is_sucess(self):
        time.sleep(random.randrange(1, 2))
        sucess_location = self.driver.find_element("xpath", "/html/body/div[8]/div/div[1]/form/div[2]/div/p")
        sucess_paragraph = str(sucess_location.get_attribute('innerHTML'))
        print(sucess_paragraph[:8]) 
        if sucess_paragraph[0] == 'S':
            message = 'SUCCESS!'
            status_code = 0
        else:
            message = 'Whoops! The code you entered is invalid or has already been used.'
            status_code = 1
        return {'message': message, 'status_code': status_code}

