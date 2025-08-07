FROM rocker/r-ver:4.4

RUN apt-get update && apt-get install -y \
    build-essential curl git libssl-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libffi-dev zlib1g-dev liblzma-dev wget llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH

RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && echo 'eval "$(pyenv init --path)"' >> /root/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> /root/.bashrc

RUN /bin/bash -c "source /root/.bashrc && pyenv install 3.11.10 && pyenv global 3.11.10"

RUN wget https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux64 -O /usr/local/bin/jq

RUN chmod +x /usr/local/bin/jq

RUN apt-get update && apt-get install -y libjq-dev

RUN R -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"

RUN R -e "remotes::install_version('jsonlite', version = '2.0.0', \
                                   repos = 'https://cloud.r-project.org')"

RUN R -e "remotes::install_version('RcppSimdJson', version = '0.1.13', \
                                   repos = 'https://cloud.r-project.org')"
                                   
RUN R -e "remotes::install_version('jqr', version = '1.4.0', \
                                   repos = 'https://cloud.r-project.org')"                                
