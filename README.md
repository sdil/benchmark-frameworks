# Benchmark Web Frameworks

This project is inspired by [Phoenix Showndown](https://github.com/mroth/phoenix-showdown).

I have created simple todo list applications in both Elixir Phoenix and Django DRF that query for all data in the database. I'm interested in these frameworks because they both offers 'high productivity' development methodology (scaffolding, ORM, router, etc. comes out of the box) and built for development speed and happiness.

Both applications took ~15 minutes to build and another 1 hour to optimize for production set up.

## Lessons learned

- After optimizing the Elixir Phoenix app setup to production mode, I see almost 10x improvement from **455 RPS to 6,112RPS**. The optimizations I did:
  - Set the `MIX_ENV=prod`
  - Compile the source code 
  - Set the `max_keepalive` parameter in `config/prod.exs`
  - Set the logger verbosity to `warn`
- After optimizing the set up to production mode for the Django DRF app, I see 58x improvements from **14 RPS to 816 RPS**. The optimizations I did:
  - Use Gunicorn and set the correct number of workers for Gunicorn
  - Set `DEBUG=False` in `settings.py`
- Elixir Phoenix is superior in speed compared to Django at 7x. This is a huge difference when translated to infra expense.
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
fadhil@fadhil-ThinkPad-T470p benchmark-frameworks (main) $ make run-benchmark 
echo "Benchmarking non-database endpoint"
Benchmarking non-database endpoint
ab -n 1000 -c 100 localhost:8000/api/healthz
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
Server Port:            8000

Document Path:          /api/healthz
Document Length:        15 bytes

Concurrency Level:      100
Time taken for tests:   0.143 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      261000 bytes
HTML transferred:       15000 bytes
Requests per second:    6989.34 [#/sec] (mean)
Time per request:       14.308 [ms] (mean)
Time per request:       0.143 [ms] (mean, across all concurrent requests)
Transfer rate:          1781.46 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2   2.2      2      11
Processing:     1   11   4.1     11      28
Waiting:        1   10   4.1      9      26
Total:          4   13   4.1     12      30

Percentage of the requests served within a certain time (ms)
  50%     12
  66%     14
  75%     15
  80%     16
  90%     19
  95%     21
  98%     24
  99%     26
 100%     30 (longest request)
echo "Benchmarking database endpoint"
Benchmarking database endpoint
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


Server Software:        Cowboy
Server Hostname:        localhost
Server Port:            8000

Document Path:          /api/todos/
Document Length:        11 bytes

Concurrency Level:      100
Time taken for tests:   0.164 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      257000 bytes
HTML transferred:       11000 bytes
Requests per second:    6112.28 [#/sec] (mean)
Time per request:       16.361 [ms] (mean)
Time per request:       0.164 [ms] (mean, across all concurrent requests)
Transfer rate:          1534.04 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   1.1      1       5
Processing:     2   14   5.6     14      34
Waiting:        1   13   5.5     13      34
Total:          5   16   5.3     15      35

Percentage of the requests served within a certain time (ms)
  50%     15
  66%     17
  75%     18
  80%     19
  90%     23
  95%     26
  98%     30
  99%     31
 100%     35 (longest request)
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
