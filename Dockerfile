FROM ubuntu:24.04

RUN apt-get -y update && apt-get -y install curl git fish

RUN useradd -ms /usr/bin/fish derf
USER derf
WORKDIR /home/derf
RUN curl -fsSL https://raw.githubusercontent.com/fredsmith/dotfiles/master/install.sh | bash
SHELL ["/usr/bin/fish", "-c"]
CMD ["fish"]
