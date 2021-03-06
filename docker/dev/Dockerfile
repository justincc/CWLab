FROM ubuntu:18.04

LABEL author="Kersten Breuer, Cancer Epigenomics, Plass Team, DKFZ 2020" \
    maintainer="kersten-breuer@outlook.com"

# Package versions/links:
ENV CWLTOOL_VERSION 1.0.20181012180214
ENV SINGULARITY_VERSION 3.3.0

# Install essential dependencies:
RUN apt-get update -qq -y --fix-missing
RUN apt-get install -y build-essential \
    python3-dev \
	python3-pip \
    wget \
    nodejs \
    tar \
	curl \
	libtool \
	libz-dev \
    libssl-dev \
	libcurl4-openssl-dev

# Install singularity:
ENV DEBCONF_FRONTEND noninteractive
RUN echo "console-setup   console-setup/charmap47 select  UTF-8" > encoding.conf && \
	debconf-set-selections encoding.conf && \
	rm encoding.conf
RUN apt-get install -qq -y \
	squashfs-tools \
	uuid-dev \
	libgpgme11-dev \
	libseccomp-dev \
	pkg-config \
	git

ENV GOPATH /usr/local/go_path
ENV PATH /usr/local/go/bin:${PATH}:${GOPATH}/bin
RUN wget https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz && \
	tar -C /usr/local -xzvf go1.12.7.linux-amd64.tar.gz && \
    rm go1.12.7.linux-amd64.tar.gz && \
	go get -u github.com/golang/dep/cmd/dep

RUN cd /usr/local/ && \
	wget -O singularity.tar.gz https://github.com/singularityware/singularity/releases/download/v${SINGULARITY_VERSION}/singularity-${SINGULARITY_VERSION}.tar.gz && \
	tar xzvf singularity.tar.gz && \
	rm singularity.tar.gz && \
	cd singularity && \
	./mconfig && \
	make -C ./builddir && \
	make -C ./builddir install

ENV PATH /usr/local/singularity/:${PATH}

# Install cwlab:
RUN python3 -m pip install cwltool==${CWLTOOL_VERSION}  && \
	mkdir /cwlab && \
	git clone -b development https://github.com/CompEpigen/CWLab.git /cwlab/src && \
	cd /cwlab/src && \
	python3 -m pip install .

# Configure cwlab:
RUN mkdir -p \
        /cwlab/tmp \
        /cwlab/worlflows \
        /cwlab/exec \
        /cwlab/input \
        /cwlab/database && \
    chmod -R 777 /cwlab

COPY config.yaml /cwlab/config.yaml

# Default command when starting:
CMD ["cwlab", "up", "-c", "/cwlab/config.yaml"]