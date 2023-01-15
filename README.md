---
title: PaddlePaddle Plato Mini
emoji: 📚
colorFrom: pink
colorTo: pink
sdk: docker
pinned: false
---

- 进入项目目录，建立虚拟环境，并安装依赖

```python
# python3 -m venv venv
# source venv/bin/activate


curl https://pyenv.run | bash
pyenv update

export PYTHON_VERSION=3.10.0

pyenv install $PYTHON_VERSION
pyenv global $PYTHON_VERSION
pyenv rehash

pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt


```


