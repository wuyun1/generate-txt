# read the doc: https://huggingface.co/docs/hub/spaces-sdks-docker
# you will also find guides on how best to write your Dockerfile

FROM nvidia/cuda:10.0-runtime-ubuntu18.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# FROM python:3.9

# WORKDIR /code

# COPY ./requirements.txt /code/requirements.txt
# RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# COPY . .

RUN rm -rf /etc/apt/sources.list.d/* && apt-get update -y && apt-get install -y python3 python3-pip && apt-get clean && \
    rm -fr /tmp/* /var/lib/apt/lists

RUN useradd -ms /bin/bash qhduan
USER qhduan
WORKDIR /home/qhduan/app

VOLUME [ "/home/qhduan/.cache" ]

ENV torch_device=cpu

ENV PATH="/home/qhduan/.local/bin:${PATH}"

RUN python3 -m pip install --upgrade --user pip -i https://pypi.tuna.tsinghua.edu.cn/simple && python3 -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

COPY --chown=qhduan:qhduan ./requirements.txt .

RUN python3 -m pip install --user -r requirements.txt

COPY --chown=qhduan:qhduan ./main.py .
COPY --chown=qhduan:qhduan ./answer.py .
COPY --chown=qhduan:qhduan ./scripts ./scripts

EXPOSE 8000
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1

# ENTRYPOINT ["/home/qhduan/app/scripts/run.sh"]

CMD [ "bash", "-c", "/home/qhduan/app/scripts/run.sh" ]

# docker build -t qhduan/onnx-cpm-gen:0.1 .
# docker run -e torch_device=cpu -v $(cd ~;pwd)/.cache:/home/qhduan/.cache -p 8000:8000 --rm --name ai-test -ti qhduan/onnx-cpm-gen:0.1
# docker run --gpus all -e torch_device=cuda -v $(cd ~;pwd)/.cache:/home/qhduan/.cache -p 8000:8000 --rm --name ai-test -ti qhduan/onnx-cpm-gen:0.1
