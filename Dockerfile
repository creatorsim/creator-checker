FROM ubuntu:20.04

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /

RUN apt update && apt-get install -y \
	sudo \
	curl \
	git \
	npm \
	vim \
	zip \
	unzip

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && apt install -y nodejs

RUN git clone https://github.com/creatorsim/creator.git && \
	cd creator && \
	npm install terser jshint colors yargs readline-sync

RUN mkdir -p /ec_p1_corrector && \
	cd ec_p1_corrector && \
	ln -s /creator creator

CMD ["/usr/bin/sleep","infinity"]