import jwt
import uvicorn
from fastapi import FastAPI, HTTPException, Depends
from starlette.middleware.cors import CORSMiddleware
from tinydb import TinyDB, Query
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from models.models import UserModel, NotesModel, TokenModel, MeModel, DetailModel

app = FastAPI()
db = TinyDB('db.json')
users = db.table('users')
User = Query()
security = HTTPBearer()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    try:
        payload = jwt.decode(token, 'secret', algorithms=['HS256'])
        return payload
    except:
        raise HTTPException(status_code=400, detail='Неверный токен')


@app.post('/entrance')
async def entrance(body: UserModel) -> TokenModel:
    result = users.search((User.login == body.login) & (User.password == body.password))
    if not result:
        raise HTTPException(status_code=404, detail='Неверный логин или пароль')
    id = result[0].doc_id
    token = jwt.encode({'id': id}, 'secret', algorithm='HS256')
    return {'token': token}


@app.post('/register')
async def register(body: UserModel) -> TokenModel:
    result = users.search(User.login == body.login)
    if result:
        raise HTTPException(status_code=409, detail='Такой логин уже используется')
    id = users.insert({'login': body.login, 'password': body.password, 'notes': []})
    token = jwt.encode({'id': id}, 'secret', algorithm='HS256')
    return {'token': token}


@app.get('/me')
async def me(token=Depends(verify_token)) -> MeModel:
    user = users.get(doc_id=token['id'])
    return {'login': user['login']}

@app.put('/notes')
async def notes(body: NotesModel, token=Depends(verify_token)) -> DetailModel:
    users.update({'notes': body.notes}, doc_ids=[token['id']])
    return {'detail': 'Заметки успешно обновлены'}

@app.get('/notes')
async def notes(token=Depends(verify_token)) -> NotesModel:
    notes = users.get(doc_ids=[token['id']])[0]['notes']
    return {'notes': notes}


if __name__ == '__main__':
    uvicorn.run('main:app', host='0.0.0.0', port=8000, reload=True)
