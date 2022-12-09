FROM lopsided/archlinux:devel

ENV SHELL /bin/bash
ADD mirrorlist /etc/pacman.d/mirrorlist
RUN yes | pacman -Syu
RUN yes | pacman -S git zsh curl

RUN mkdir -p /root/.config
VOLUME ["/root/repos"]

# prezto
RUN zsh -c 'git clone https://code.aliyun.com/412244196/prezto.git "$HOME/.zprezto"' &&\
	zsh -c 'setopt EXTENDED_GLOB' &&\
	zsh -c 'for rcfile in "$HOME"/.zprezto/runcoms/z*; do ln -s "$rcfile" "$HOME/.${rcfile:t}"; done'
# end

# node & pnpm
ENV PNPM_HOME /root/.local/share/pnpm
ENV PATH $PNPM_HOME:$PATH
RUN touch /root/.config/.npmrc; ln -s /root/.config/.npmrc /root/.npmrc; \
	yes | pacman -Syy && yes | pacman -S nodejs-lts-gallium npm &&\
	corepack enable &&\
	pnpm setup &&\
	pnpm i -g yrm
# end

## nvm
ADD nvm /root/.nvm/
ENV NVM_DIR /root/.nvm
RUN echo 'export NVM_DIR="$HOME/.nvm"'                                       >> /root/.zshrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'    							 >> /root/.zshrc
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"' >> /root/.zshrc
# end

# z
ADD z /root/.z_lib
RUN echo '. /root/.z_lib/z.sh'	>> /root/.zshrc
# end

ENTRYPOINT [ "/bin/zsh" ]
