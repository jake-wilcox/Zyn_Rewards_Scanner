from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import driver


class Code(BaseModel):
    code: str

app = FastAPI()

# origins = ['https://localhost:3000',
#            'http://localhost:3000']
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins = origins,
#     allow_credentials = True,
#     allow_methods = ['*'],
#     allow_headers = ['*'], 
#     )


@app.get("/")
def root():
    return{'hello': 'world'}

@app.get('/login')
def zyn_login():
    #also get the session experation cookie and change is_logged_in based on that?
    global s, is_logged_in
    s = driver.Session() 
    s.login()
    # points = s.get_points()
    # return {'points': points}
    return {"success": True}


@app.get('/getPoints')
def get_points():
    points = s.get_points()
    return {'points': points} 

@app.post('/enterCode')
def _enter_code(code: Code):
    print(code.code)
    s.enter_code(code.code)
    message = s.is_sucess()
    return message

