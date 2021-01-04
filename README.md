# Benchmark Web Frameworks

## How to run API servers

Prerequisites:

- Elixir & Phoenix are installed

How to run Phoenix

```shell
$ make start_db
$ make start_phoenix
$ make seed_phoenix
$ curl -i localhost:4000/api/todos/
```

How to run Django REST Framework (DRF)

Prerequisites:

- Python 3 is installed
- Django, django-rest-framework & psycopg2 pips are installed

```shell
$ make start_db
$ make start_django
$ make seed_django
$ curl -i localhost:8000/api/todos/
```

## Benchmark Result

This is the benchmark is running on my machine with the following spec: 8 cores Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz and 16GB of RAM.

### Phoenix Result

```shell
$ ab -n 1000 -c 100 localhost:4000/api/todos/
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        Cowboy
Server Hostname:        localhost
Server Port:            4000

Document Path:          /api/todos/
Document Length:        461 bytes

Concurrency Level:      100
Time taken for tests:   2.194 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      708000 bytes
HTML transferred:       461000 bytes
Requests per second:    455.69 [#/sec] (mean)
Time per request:       219.449 [ms] (mean)
Time per request:       2.194 [ms] (mean, across all concurrent requests)
Transfer rate:          315.06 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.7      0       7
Processing:    56  198  35.7    209     250
Waiting:       56  198  35.7    208     250
Total:         56  199  35.6    209     250

Percentage of the requests served within a certain time (ms)
  50%    209
  66%    215
  75%    218
  80%    220
  90%    226
  95%    230
  98%    237
  99%    242
 100%    250 (longest request)
```

### Django + Django REST Framework (DRF) Result

```shell
$ ab -n 1000 -c 100 127.0.0.1:8000/api/todos/
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 127.0.0.1 (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        WSGIServer/0.2
Server Hostname:        127.0.0.1
Server Port:            8000

Document Path:          /api/todos/
Document Length:        381 bytes

Concurrency Level:      100
Time taken for tests:   71.310 seconds
Complete requests:      1000
Failed requests:        10
   (Connect: 0, Receive: 0, Length: 10, Exceptions: 0)
Total transferred:      661674 bytes
HTML transferred:       380238 bytes
Requests per second:    14.02 [#/sec] (mean)
Time per request:       7131.034 [ms] (mean)
Time per request:       71.310 [ms] (mean, across all concurrent requests)
Transfer rate:          9.06 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   96 299.2      0    1031
Processing:    13 1421 7252.6     46   70005
Waiting:        9 1276 6586.1     39   53069
Total:         13 1518 7414.0     46   70005

Percentage of the requests served within a certain time (ms)
  50%     46
  66%     49
  75%     52
  80%     54
  90%     77
  95%   4396
  98%  27707
  99%  54082
 100%  70005 (longest request)

```
