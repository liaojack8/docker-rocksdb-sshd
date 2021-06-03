FROM alpine:3.12.4

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >>/etc/apk/repositories
RUN apk add --update --no-cache build-base linux-headers git cmake bash perl #wget mercurial g++ autoconf libgflags-dev cmake bash
RUN apk add --update --no-cache zstd-dev zstd zlib-dev bzip2 bzip2-dev snappy snappy-dev lz4 lz4-dev

#libtbb-dev libtbb # 2021.06.03 libtbb installation error

# installing latest gflags
RUN cd /tmp && \
    git clone https://github.com/gflags/gflags.git && \
    cd gflags && \
    mkdir build && \
    cd build && \
    cmake -DBUILD_SHARED_LIBS=1 -DGFLAGS_INSTALL_SHARED_LIBS=1 .. && \
    make install && \
    cd /tmp && \
    rm -R /tmp/gflags/

# Install Rocksdb
RUN cd /tmp && \
    git clone https://github.com/facebook/rocksdb.git && \
    cd rocksdb && \
    git checkout v6.17.3 && \
    make shared_lib && \
    mkdir -p /usr/local/rocksdb/lib && \
    mkdir /usr/local/rocksdb/include && \
    cp librocksdb.so* /usr/local/rocksdb/lib && \
    cp /usr/local/rocksdb/lib/librocksdb.so* /usr/lib/ && \
    cp -r include /usr/local/rocksdb/ && \
    cp -r include/* /usr/include/
# RUN rm -R /tmp/rocksdb/

# Setup SSH
RUN apk --update add --no-cache openssh bash \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:rocksdb" | chpasswd \
  && rm -rf /var/cache/apk/* \
  && sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config \
  && sed -ri 's/#HostKey \/etc\/ssh\/ssh_host_key/HostKey \/etc\/ssh\/ssh_host_key/g' /etc/ssh/sshd_config \
  && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/g' /etc/ssh/sshd_config \
  && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_dsa_key/HostKey \/etc\/ssh\/ssh_host_dsa_key/g' /etc/ssh/sshd_config \
  && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config \
  && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config \
  && /usr/bin/ssh-keygen -A \
  && ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]

# Create Example
ADD example.cpp /tmp/example.cpp