# read the doc: https://huggingface.co/docs/hub/spaces-sdks-docker
# you will also find guides on how best to write your Dockerfile

FROM python:3.9

# WORKDIR /code

# COPY ./requirements.txt /code/requirements.txt
# RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# COPY . .

RUN useradd -ms /bin/bash qhduan
USER qhduan
WORKDIR /home/qhduan

VOLUME [ "/home/qhduan/.cache" ]

ENV torch_device=cpu

# ENV PATH="/home/qhduan/.local/bin:${PATH}"

RUN pip install --upgrade --user pip -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

COPY --chown=qhduan:qhduan ./requirements.txt .

RUN pip install --user -r requirements.txt

COPY --chown=qhduan:qhduan ./main.py .
COPY --chown=qhduan:qhduan ./answer.py .
COPY --chown=qhduan:qhduan ./scripts ./scripts

EXPOSE 8000
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1

# ENTRYPOINT ["/home/qhduan/scripts/run.sh"]

CMD [ "bash", "-c", "/home/qhduan/scripts/run.sh" ]

# docker build -t qhduan/onnx-cpm-gen:0.1 .
# docker run -e torch_device=cpu -v /home/qhduan/.cache:$(cd ~;pwd)/.cache -p 8000:8000 --rm --name ai-test -ti qhduan/onnx-cpm-gen:0.1
