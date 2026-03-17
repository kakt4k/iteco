from pydantic import BaseModel

class UserModel(BaseModel):
    login: str
    password: str

class NotesModel(BaseModel):
    notes: list

class TokenModel(BaseModel):
    token: str

class MeModel(BaseModel):
    login: str

class DetailModel(BaseModel):
    detail: str