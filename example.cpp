#include <cassert>
#include <iostream>
#include <string>
#include <rocksdb/db.h>
using namespace std;

int main() {
  rocksdb::DB* db;
  rocksdb::Options options;
  options.create_if_missing = true;
  rocksdb::Status status = rocksdb::DB::Open(options, "/tmp/testdb", &db);
  assert(status.ok());

  string key = "A";
  string value = "Airplane";
  string get;
  rocksdb::Status s = db->Put(rocksdb::WriteOptions(), key, value);
  
  if (s.ok()) s = db->Get(rocksdb::ReadOptions(), key, &get);
  if (s.ok()) cout << "Read in RocksDB (k,v) = (" << key << "," << get << ")" << endl;
  else cout << "Read Failed!" << endl;
 
  delete db;
 
  return 0;
}