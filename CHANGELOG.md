# CHANGELOG

---

## [1.0.0] - 2022-03-16
 
- 저장소 생성
- ufoym/deepo:all-jupyter-cu113
- Jupyter Lab 3.3.1
- Python 3.8.10 
 
### 추가사항

- Dockerfile CMD Jupyter Lab 자동실행 설정
- jupyter_lab_config.py 사전설정
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
 
### 수정사항

---

## [1.1.0] - 2022-03-18
 
- 주요 업데이트
- ufoym/deepo:all-jupyter-cu113
- Jupyter Lab 3.3.1
- Python 3.8.10 
 
### 추가사항

- SSL 인증서 기본 적용
  - 자가서명 인증서, 730일동안 유효
  - /root/.jupyter 경로에 위치

### 수정사항

- Jupyter Lab이 도커 CMD로 실행되는 것이 아닌 ENTRYPOINT로 실행됨
- 더이상 non-TLS (http)로 접속이 불가능함

---

## [1.2.0] - 2022-03-19
 
- 주요 업데이트
- nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
- Jupyter Lab 3.3.2
- Python 3.8.10 
 
### 추가사항

### 수정사항

- 더이상 ufoym/Deepo 이미지에 의존하지 않음
  - Deepo가 CUDA 11.2 이미지 태그를 제공하지 않기 때문
  - 이제 nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04 기반으로, Deepo의 적용사항들을 적용함
- CUDA 11.2 서버에서 CUDA가 정상적으로 작동함

---

## [1.2.1] - 2022-04-18

- 주요 업데이트
- nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04
- Jupyter Lab 3.3.2
- Python 3.8.10

### 추가사항

### 수정사항

-  기본 `jupyter_lab_config.py`의 표기 오류로 인한 실행 불가 문제 해결
  - 인증서 `certfile`이 `.pem`으로 잘못 기재된 문제 해결
- `CHANGELOG.md` 가독성 개선  
