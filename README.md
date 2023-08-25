# zyn_Rewards_Scanner

Zyn Rewards Scanner uses machine learning to automate the tedious task of manually entering Zyn codes. This native application utilizes Flutter, FastAPI, and Selenium to capture an image of your rewards code and submit it to Zyn. 🚀

https://github.com/jake-wilcox/zyn_Rewards_Scanner/assets/91049035/f5a0fd13-1e3e-4685-911f-86333cb1127a

## Frontend
#### Flutter
This was my first Flutter application, and I found the development experience to be very enjoyable. The wide variety of libraries and outstanding documentation made developing this app (mostly) a breeze.

#### Camera Manipulation
The key feature of this app was the camera integration. Getting the camera running was relatively easy, but implementing the camera overlay, cropping, and processing the image to be ready for OCR was definitely a challenge. Although I am happy with the result, I think that the camera overlay could still use a bit of work.

#### Google ML Kit
When starting this project, I thought that the most challenging part would be the Optical Character Recognition, but Google's Machine Learning Kit made it the easiest part of the project.

## Backend
The backend of Zyn Rewards Scanner is built with FastAPI and Selenium. It is designed to handle requests from my Flutter application, log in, and submit codes to Zyn.com. Designing the backend of this project came with some challenges, some of which I am still trying to overcome.

#### FastAPI
My backend needs to serve a few pieces of information to the Flutter app. It needs to be able to...
- Log in to Zyn when requested
- Get the current number of points on the account
- Submit the codes and check if submission succeeded.

#### Selenium
Zyn doesn't have a public API, and they use an invisible CAPTCHA to ensure no web scraping takes place on their site. I figured since I am only using the site for its intended purpose, I could ethically try to get around these prohibiting factors. The solution I landed on was to use Selenium Webdriver with Python to handle the login and submission process.
Working around Zyn's CAPTCHA is tricky and is still something that I am working on improving. After hours of troubleshooting, the login process still only works around half of the time; however, I have some ideas that might be able to increase those numbers.
I would also like to explore cutting back on Selenium usage and only using it for login, and using pure requests for code submission. But I am not sure if this is possible yet.
