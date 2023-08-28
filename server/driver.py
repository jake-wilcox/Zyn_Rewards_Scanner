import time
import random
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC 
from webdriver_manager.chrome import ChromeDriverManager

from HLISA.hlisa_action_chains import HLISA_ActionChains
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
        # options.add_argument('--headless')
        # options.add_argument("--start-maximized");
        # options.add_argument('--window-size=1920,1080')
        options.add_argument("--lang=en-US,en")
        options.add_argument("--disable-audio")
        options.add_argument("--disable-gpu")  # Required when running on Windows

        driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
        return driver

    def login(self):
        print('logging in')
        self.actions = HLISA_ActionChains(self.driver)
        self.driver.get("https://us.zyn.com/ZYNRewards/")
        # time.sleep(random.randrange(3,5))
        login_modal = self.driver.find_element("xpath", "/html/body/div[5]/div/div/div/div/button")
        self.actions.move_to_element(login_modal)
        self.actions.click(login_modal)
        # time.sleep(random.randrange(1, 3))
        print('entering credentials')
        email_field = self.driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/div[1]/input")
        password_field = self.driver.find_element("xpath", "/html/body/div[6]/form/div/div[1]/div[2]/input")
        self.actions.move_to_element(email_field)
        self.actions.send_keys(os.getenv('EMAIL'), email_field)
        self.actions.move_to_element(email_field)
        self.actions.send_keys(os.getenv('PASSWORD'), password_field)


        # time.sleep(random.randrange(5, 10))
        login_button = self.driver.find_element("xpath", "//button[@type='submit']")
        self.actions.move_to_element(login_button)
        # time.sleep(random.randrange(1, 3))
        # self.driver.find_element('xpath', '/html/body/div[6]/form/div/div[1]/div[3]/div').click()
        # time.sleep(random.randrange(30, 36))
        # print('clicking button')
        self.actions.perform()
        self.driver.save_screenshot("headless_screenshot.png")
        for i in range(3):
            print('clicking login button')
            time.sleep(random.randrange(1, 2))
            self.actions.double_click(login_button).perform()
            time.sleep(random.randrange(1, 2))
            print('checking url')
            print(self.driver.current_url)
            if self.driver.current_url == "https://us.zyn.com/ZYNRewards/?loggedIn=true":
                break
        # login_button.click()
        # print(self.driver.current_url)

    def accept_cookies(self):
        print('accepting cookies')
        print(self.driver.current_url)
        cookies_bar = self.driver.find_element("xpath", "/html/body/div[13]/i")
        time.sleep(random.randrange(1, 2))
        cookies_bar.click()


    def get_points(self):
        print('getting points')
        points_element = self.driver.find_element("xpath", "/html/body/div[2]/a[2]/span[1]")
        print('found points element')
        print(points_element.get_attribute('innerHTML'))
        return(points_element.get_attribute('innerHTML'))




    def enter_code(self, code):
        self.driver.find_element("xpath", "/html/body/div[8]/div/div[1]/form/div[1]/input").clear()
        time.sleep(random.randrange(0, 1))
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

