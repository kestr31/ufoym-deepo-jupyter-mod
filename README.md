# ufoym/deepo Jupyter Mod

## 개요

- 서버 환경에서 Jupyter Lab을 활용할 수 있도록 사전 설정을 수행한 [ufoym/deepo](https://hub.docker.com/r/ufoym/deepo) 기반 도커 이미지 생성을 위한 저장소
- ufoym/deepo도 Jupyter가 명시된 Tag를 가진 이미지의 경우 Jupyter Lab을 포함함
- 그러나 별도의 설정을 진행하거나 컨테이너 생성 시 별도의 CMD 명령어를 부여해야 하는 불편함이 존재
- 또한 Jupyter Lab Extension이 전혀 설치되어 있지 않아 사용자 편의성이 떨어짐
- 본 도커 이미지는 그러한 단점을 보완하고자 함

## 개선사항

- Dockerfile CMD 설정을 통해 컨테이너 생성시 Jupyter Lab 자동실행
- jupyter_lab_config.py 사전설정
  - localhost 외 IP 접속 가능
  - 터미널 기본 쉘을 bash로 설정
  - 추후 인증 및 SSL 적용을 위한 고려
- Jupyter Lab 3.x과 호환되는 Extension 사전설치
  - [ipympl](https://github.com/matplotlib/ipympl)
  - [ipywidgets](https://github.com/jupyter-widgets/ipywidgets)
  - [aquirdturtle_collapsible_headings](https://github.com/aquirdTurtle/Collapsible_Headings)
  - [jupyterlab-drawio](https://github.com/QuantStack/jupyterlab-drawio)
  - [jupyterlab-git](https://github.com/jupyterlab/jupyterlab-git)
  - [jupyterlab_latex](https://github.com/jupyterlab/jupyterlab-latex)
  - [jupyterlab-lsp](https://github.com/jupyter-lsp/jupyterlab-lsp)
  - [jupyterlab-spreadsheet](https://github.com/quigleyj97/jupyterlab-spreadsheet)
  - [jupyterlab-system-monitor](https://github.com/jtpio/jupyterlab-system-monitor)
  - [lckr-jupyterlab-variableinspector](https://github.com/lckr/jupyterlab-variableInspector)
  - [@krassowski/jupyterlab_go_to_definition](https://github.com/krassowski/jupyterlab-go-to-definition)

## 기본 실행

### 직접 빌드

- 본 저장소를 clone한 뒤 다음 명령어를 통해 빌드를 수행
- 이미지명과 태그명은 식별이 가능하도록 사용자 임의로 결정

```shell
docker build --no-cache -t <image_name>:<tag> .
```

- 이후 다음 명령어를 통해 컨테이너 이미지를 생성한다
- 실행 이후 https://서버_IP:user_port로 접속하면 Jupyter Lab이 실행된다

```shell
docker run -d --gpus all \
    -p <user_port>:8888 \
    -v <absolute_user_directory_to_workspace>:/root/.jupyter/lab/workspaces \
    --name <preferred_name> \
    <image_name>:<tag>
```

|설정값|설명|비고|예시|
|:-|:-|:-|:-|
|<user_port>|Jupyter Lab 에 접속할 포트|10000번대 이상을 권장|10001|
|<absolute_user_directory>|Jupyter Lab 작업 공간|절대경로로 설정할 것|/home/foo/bar/jupyter|

### 저장소 다운로드

- 미리 빌드된 이미지 [kestr3l/deepo-jupyter-mod](https://hub.docker.com/r/kestr3l/deepo-jupyter-mod)를 받아 실행하는 방법
- 다음 명령어를 통해 실행

```shell
docker run -d --gpus all \
    -p <user_port>:8888 \
    -v <absolute_user_directory_to_workspace>:/root/.jupyter/lab/workspaces \
    --name <preferred_name> \
    kestr3l/deepo-jupyter-mod:1.1.0
```

|설정값|설명|비고|예시|
|:-|:-|:-|:-|
|<user_port>|Jupyter Lab 에 접속할 포트|10000번대 이상을 권장|10001|
|<absolute_user_directory>|Jupyter Lab 작업 공간|절대경로로 설정할 것|/home/foo/bar/jupyter|

## 로그인 비밀번호 설정

- 단순 실행과는 실행 절차가 조금 다르다
- 먼저 다음 명령어를 통해 bash 창으로 컨테이너를 실행한다

```shell
docker run -d --rm \
  --name jupyter_pass \
  kestr3l/deepo-jupyter-mod:1.1.0
```

- 이어서 컨테이너 내부의 터미널 창으로 접속한다

```shell
docker exec -it jupyter_pass bash
```

- 해당 터미널에서 다음 명령어를 실행해 비밀번호 Hash 값을 확인한다
  - 명령어 입력 직후 나타나는 입력 창에 직접 입력하도록 한다
  - `passwd()` 내부에 문자열을 넣어 결과를 바로 확인하는 것은 보안상 매우 권장하지 않는다
- 입력해 나오는 결과를 복사해 기록해둔다

```shell
python3 -c "from notebook.auth import passwd;print(passwd())"
```

- `exit`을 입력해 호스트 터미널로 나온 뒤 컨테이너를 중지해 삭제한다

```shell
docker stop jupyter_pass
```

- 본 저장소의 /config 폴더 내의 jupyter_lab_config.py를 복사해 식별할 수 있는 경로에 저장한다
- 그 뒤 그 내용을 아래와 같이 수정한다
  - c.ServerApp.password_required를 True로 수정
  - c.ServerApp.token 주석처리
  - c.ServerApp.password 주석해제 후 전 단계에서 기록한 문자열 입력

```python
c = get_config()

c.ServerApp.allow_origin = '*'
c.ServerApp.ip = '*'
c.ServerApp.port = 8888
c.ServerApp.terminado_settings={'shell_command': ['/bin/bash']}

c.ServerApp.open_browser = False
c.ServerApp.allow_root = True
c.ServerApp.root_dir = '/root/.jupyter/lab/workspaces'

c.ServerApp.password_required = True
#c.ServerApp.token = ''
c.ServerApp.password = '방금_복사한_문자열'
c.ServerApp.certfile = u'/root/.jupyter/jupyter.pem'
c.ServerApp.keyfile = u'/root/.jupyter/jupyter.key'
```

- 마지막으로 다음 명령어를 통해 실행 시 비밀번호 입력이 적용된다

```
docker run -d --gpus all \
    -p <user_port>:8888 \
    -v <absolute_directory_to_jupyter_lab_config.py>:/root/.jupyter/jupyter_lab_config.py \
    -v <absolute_user_directory_to_workspace>:/root/.jupyter/lab/workspaces \
    --name <preferred_name> \
    kestr3l/deepo-jupyter-mod:1.1.0
```
