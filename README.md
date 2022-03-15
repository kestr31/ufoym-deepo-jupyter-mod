# ufoym/deepo Jupyter Mod

## 개요

- 서버 환경에서 Jupyter Lab을 활용할 수 있도록 사전 설정을 수행한 도커 이미지 생성을 위한 저장소
- [ufoym/deepo](https://hub.docker.com/r/ufoym/deepo) 이미지 기반
<br/>

- ufoym/deepo에도 Jupyter가 명시된 Tag를 가진 이미지의 경우 Jupyter Lab 실행을 위한 준비가 갖춰져 있다
- 그러나 별도의 설정을 진행하거나 컨테이너 생성 시 별도의 CMD 명령어를 부여해야 하는 불편함이 존재
- 또한 Jupyter Lab Extension이 전혀 설치되어 있지 않아 사용자 편의성이 떨어짐
- 본 도커 이미지는 그러한 단점을 보완하고자 함

## 개선사항

- Dockerfile CMD 설정을 통한 컨테이너 생성시 Jupyter Lab 자동실행
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

### 빌드 후 사용

- 본 저장소를 clone한 뒤 다음 명령어를 통해 빌드를 수행한다
- 이미지명과 태그명은 식별이 가능하도록 사용자 임의로 결정한다

```shell
docker build --no-cache -t <image_name>:<tag> .
```

- 이후 다음 명령어를 통해 컨테이너 이미지를 생성한다
- 실행 이후 http://서버_IP:user_port로 접속하면 Jupyter Lab이 실행된다

```shell
docker run -d --gpus all \
    -p <user_port>:8888 \
    -v /root/.jupyter/lab/workspaces:<absolute_user_directory> \
    --name jupyter_test \
    jupyter:test
```

|설정값|설명|비고|
|<user_port>|Jupyter Lab 에 접속할 포트|10000번대 이상을 권장|
|<absolute_user_directory>|Jupyter Lab 작업 공간|절대경로로 설정할 것|
