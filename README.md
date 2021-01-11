# Benchmark Web Frameworks

This project is inspired by [Phoenix Showndown](https://github.com/mroth/phoenix-showdown).

I have created simple todo list applications in both Elixir Phoenix and Django DRF that query for all data in the database. I'm interested in these frameworks because they both offers 'high productivity' development methodology (scaffolding, ORM, router, etc. comes out of the box) and built for development speed and happiness.

Both applications took ~15 minutes to build and another 1 hour to optimize for production set up.

## Lessons learned

- After optimizing the Elixir Phoenix app setup to production mode, I see almost 10x improvement from **455 RPS to 5,107 RPS**. The optimizations I did:
  - Set the `MIX_ENV=prod`
  - Compile the source code 
  - Set the `max_keepalive` parameter in `config/prod.exs`
  - Set the logger verbosity to `warn`
- After optimizing the set up to production mode for the Django DRF app, I see 58x improvements from **14 RPS to 816 RPS**. The optimizations I did:
  - Use Gunicorn and set the correct number of workers for Gunicorn
  - Set `DEBUG=False` in `settings.py`
- Elixir Phoenix is superior in speed compared to Django at 6x. This is a huge difference when translated to infra expense.
- Always run everything in production mode to get the full speed!
- There are many things that is neglected here: avoiding N + 1 query, background job, database optimization, indexing, authentication & authorization in middleware, etc.

## How to run API servers

### How to run Phoenix

```shell
$ make start-phoenix
$ make seed-phoenix
$ make run-curl
$ make run-benchmark
```

### How to run Django REST Framework (DRF)


```shell
$ make start-django
$ cd todo_django
$ docker-compose exec web sh
$ ./manage.py shell < seed.py
$ exit
$ cd ..
$ make run-curl
$ make run-benchmark
```

## Benchmark Result

This is the benchmark is running on my machine with the following spec: 8 cores 16 threads Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz and 16GB of RAM.

### Phoenix Result

```shell
fadhil@fadhil-ThinkPad-T470p Downloads $ ./hey_linux_amd64 -z 30s http://localhost:8000/api/healthz

Summary:
  Total:	30.0071 secs
  Slowest:	0.2314 secs
  Fastest:	0.0004 secs
  Average:	0.0044 secs
  Requests/sec:	11353.5627
  
  Total data:	5110305 bytes
  Size/request:	15 bytes

Response time histogram:
  0.000 [1]	|
  0.023 [340366]	|■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.047 [113]	|
  0.070 [106]	|
  0.093 [0]	|
  0.116 [2]	|
  0.139 [50]	|
  0.162 [0]	|
  0.185 [5]	|
  0.208 [0]	|
  0.231 [44]	|


Latency distribution:
  10% in 0.0025 secs
  25% in 0.0032 secs
  50% in 0.0040 secs
  75% in 0.0050 secs
  90% in 0.0065 secs
  95% in 0.0078 secs
  99% in 0.0114 secs

Details (average, fastest, slowest):
  DNS+dialup:	0.0000 secs, 0.0004 secs, 0.2314 secs
  DNS-lookup:	0.0000 secs, 0.0000 secs, 0.0103 secs
  req write:	0.0000 secs, 0.0000 secs, 0.0307 secs
  resp wait:	0.0043 secs, 0.0003 secs, 0.2313 secs
  resp read:	0.0001 secs, 0.0000 secs, 0.0241 secs

Status code distribution:
  [200]	340687 responses



fadhil@fadhil-ThinkPad-T470p Downloads $ ./hey_linux_amd64 -z 30s http://localhost:8000/api/todos/


Summary:
  Total:	30.0414 secs
  Slowest:	0.0621 secs
  Fastest:	0.0007 secs
  Average:	0.0081 secs
  Requests/sec:	6136.7042
  
  Total data:	2027905 bytes
  Size/request:	11 bytes

Response time histogram:
  0.001 [1]	|
  0.007 [72247]	|■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.013 [99559]	|■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.019 [10664]	|■■■■
  0.025 [1323]	|■
  0.031 [292]	|
  0.038 [99]	|
  0.044 [41]	|
  0.050 [9]	|
  0.056 [34]	|
  0.062 [86]	|


Latency distribution:
  10% in 0.0049 secs
  25% in 0.0060 secs
  50% in 0.0076 secs
  75% in 0.0095 secs
  90% in 0.0120 secs
  95% in 0.0138 secs
  99% in 0.0192 secs

Details (average, fastest, slowest):
  DNS+dialup:	0.0000 secs, 0.0007 secs, 0.0621 secs
  DNS-lookup:	0.0000 secs, 0.0000 secs, 0.0030 secs
  req write:	0.0000 secs, 0.0000 secs, 0.0165 secs
  resp wait:	0.0080 secs, 0.0007 secs, 0.0620 secs
  resp read:	0.0001 secs, 0.0000 secs, 0.0317 secs

Status code distribution:
  [200]	184355 responses
```

### Django + Django REST Framework (DRF) Result

```shell
$ make run-benchmark 
ab -n 1000 -c 100 localhost:8000/api/todos/
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


Server Software:        gunicorn/20.0.4
Server Hostname:        localhost
Server Port:            8000

Document Path:          /api/todos/
Document Length:        381 bytes

Concurrency Level:      100
Time taken for tests:   1.225 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      669000 bytes
HTML transferred:       381000 bytes
Requests per second:    816.13 [#/sec] (mean)
Time per request:       122.529 [ms] (mean)
Time per request:       1.225 [ms] (mean, across all concurrent requests)
Transfer rate:          533.20 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   2.2      0      11
Processing:    19  114  17.6    118     136
Waiting:       13  114  17.7    118     136
Total:         24  115  15.7    118     137

Percentage of the requests served within a certain time (ms)
  50%    118
  66%    120
  75%    122
  80%    123
  90%    125
  95%    127
  98%    130
  99%    132
 100%    137 (longest request)
```

## Please contribute

If anyone has experience in building Todo list app using Ruby on Rails, NestJS, Laravel, Go Buffalo, etc., feel free to submit a PR to this repo together with production settings (and Docker Compose file) for the app. I would love to see the performance for these frameworks as well.

## References

- [Benchmarking Phoenix by Saša Jurić](https://www.theerlangelist.com/article/phoenix_latency)
