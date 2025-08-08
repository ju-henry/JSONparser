FROM rocker/r-ver:4.4

RUN apt-get update && apt-get install -y \
    build-essential curl git libssl-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libffi-dev zlib1g-dev liblzma-dev wget llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libjq-dev time \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH

RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv \
    && echo 'eval "$(pyenv init --path)"' >> /root/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> /root/.bashrc \
    && echo 'eval "$(pyenv virtualenv-init -)"' >> /root/.bashrc

RUN /bin/bash -c "\
    source /root/.bashrc && \
    pyenv install 3.11.10 && \
    pyenv virtualenv 3.11.10 parsepy && \
    pyenv activate parsepy && \
    pip install pysimdjson==7.0.2 && \
    pyenv global parsepy"

RUN wget https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux64 -O /usr/local/bin/jq

RUN chmod +x /usr/local/bin/jq

RUN R -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"

RUN R -e "remotes::install_version('jsonlite', version = '2.0.0', \
                                   repos = 'https://cloud.r-project.org')"

RUN R -e "remotes::install_version('RcppSimdJson', version = '0.1.13', \
                                   repos = 'https://cloud.r-project.org')"
                                   
RUN R -e "remotes::install_version('jqr', version = '1.4.0', \
                                   repos = 'https://cloud.r-project.org')"    

WORKDIR /usr/src/app

COPY fetch* parse* produce* get* .
RUN chmod +x *

RUN ./fetch_twitter_json.sh && ./produce_base_data.sh \
    && ./produce_heavy_data.sh && ./produce_many_data.sh

RUN ./get_results.sh && Rscript get_median_results.R

