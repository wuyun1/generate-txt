

import traceback
from typing import Union


from fastapi import FastAPI
from fastapi import Request

from pydantic import BaseModel

app = FastAPI()

class Question(BaseModel):
    text: str = "你好啊"
    # description: Union[str, None] = None
    max_len: Union[float, None] = 50
    temperature: Union[float, None] = 1.0
    top_p: Union[float, None] = 0.95
    sample: Union[None, bool] = True
    
    
from answer import answer


@app.post('/api/generate')
async def api_generate(q: Question, request: Request):
    """
    curl -XPOST http://localhost:8000/api/generate \
        -H 'Content-Type: applicaton/json' \
        -d '{"text": "用户: 用 markdown 格式写一篇介绍 python 冒泡排序的文章\n小元: ", "max_len": 4096}'
    """
    data = await request.json()
    if 'text' not in data or not isinstance(data['text'], str):
        return {
            'ok': False,
            'error': 'Invalid text in post data',
        }
    try:
        ret = answer(
            data['text'],
            max_new_tokens = data.get('max_len', 50),
            temperature = data.get('temperature', 1.0),
            top_p = data.get('top_p', 0.95),
            sample = data.get('sample', True)
            # top_k = data.get('top_k', 50)
        )
        return {
            'ok': True,
            'text': ret,
        }
    except Exception:
        return {
            'ok': False,
            'error': traceback.format_exc(),
        }


@app.get('/')
async def hello():
    return {
        'hello': 'world',
    }


# python3 -m uvicorn main:app --host 0.0.0.0 --port 8000