c = get_config()

c.ServerApp.allow_origin = '*'
c.ServerApp.ip = '*'
c.ServerApp.port = 8888
c.ServerApp.terminado_settings={'shell_command': ['/bin/bash']}

c.ServerApp.open_browser = False
c.ServerApp.allow_root = True
c.ServerApp.root_dir = '/root/.jupyter/lab/workspaces'

c.ServerApp.password_required = False
c.ServerApp.token = ''
c.ServerApp.password = ''
#c.ServerApp.certfile = u'/root/.jupyter/jupyterlab.pem'
#c.ServerApp.keyfile = u'/root/.jupyter/jupyterlab.pem'
