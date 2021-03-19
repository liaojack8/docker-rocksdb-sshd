# docker-rocksdb-sshd
Alpine Linux image with compiled and installed RocksDB with all compression libraries with ssh

## Usage

```
git clone https://github.com/liaojack8/docker-rocksdb-sshd && cd docker-rocksdb-sshd
bash build.sh
```
![](./pics/example1.png)

```terminal
ssh root@localhost -p 2222 //login password:rocksdb
cd /tmp
g++ -o example example.cpp -pthread -lrocksdb -std=c++11 && ./example
```