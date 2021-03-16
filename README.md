# docker-rocksdb
Alpine Linux image with compiled and installed RocksDB with all compression libraries

```terminal
cd /tmp
g++ -o example example.cpp -pthread -lrocksdb -std=c++11 && ./example
```