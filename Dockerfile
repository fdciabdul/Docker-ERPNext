FROM frappe/erpnext:latest

USER frappe

WORKDIR /home/frappe/frappe-bench

RUN export PYENV_ROOT="$HOME/.pyenv" && \
    export PATH="$PYENV_ROOT/bin:$PATH"
