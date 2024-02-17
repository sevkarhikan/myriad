FROM mcr.microsoft.com/dotnet/sdk:8.0.100-1-jammy

RUN apt-get update && apt-get upgrade -y && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common \
    && apt-get install -y build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev openssl libssl-dev pkg-config libxml2-utils xsltproc ccache  \
    && apt install -y libclang-dev
    # the above lines are due to
    # https://github.com/pgcentralfoundation/pgrx/blob/develop/README.md
    # https://wiki.postgresql.org/wiki/Compile_and_Install_from_source_code
    # i.e. I added the requirements of pgrx to the ubuntu image.

# Install OpenSSH Server
RUN apt-get install -y openssh-server

# Set up configuration for SSH
RUN mkdir /var/run/sshd
RUN echo 'root:pwd_098*' | chpasswd
#RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise, user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose the SSH port
EXPOSE 3782    
# Run SSH won't work from here. don't know why, so I moved it to postcreate in devcontainer.json
#CMD ["sudo /usr/sbin/sshd", "-D"]
RUN mkdir /startup
COPY startup.sh /startup/startup.sh
RUN chmod +x /startup/startup.sh
# I'm using devcontainer.json/postStartCommand to start this
# ENTRYPOINT [ "/startup/startup.sh" ]
