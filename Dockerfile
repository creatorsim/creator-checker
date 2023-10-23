FROM ubuntu:22.04

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /

RUN apt update && apt-get install -y \
	sudo \
	wget \
	curl \
	git \
	npm \
	vim \
	7zip \
	rar \
	unrar \
	zip \
	unzip

RUN git clone https://github.com/creatorsim/creator.git && \
    cd creator && \
    npm install terser jshint colors yargs readline-sync

RUN mkdir -p /ec_p1_corrector && \
    cd       /ec_p1_corrector && \
    ln -s    /creator creator

CMD ["/usr/bin/sleep","infinity"]

