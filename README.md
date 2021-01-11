# Benchmark Web Frameworks

This project is inspired by [Phoenix Showndown](https://github.com/mroth/phoenix-showdown).

I have created simple todo list applications in both Elixir Phoenix and Django DRF that query for all data in the database. I'm interested in these frameworks because they both offers 'high productivity' development methodology (scaffolding, ORM, router, etc. comes out of the box) and built for development speed and happiness.

Both applications took ~15 minutes to build and another 1 hour to optimize for production set up.

## Lessons learned

- After optimizing the Elixir Phoenix app setup to production mode, I see almost 10x improvement from **455 RPS to 4,010 RPS**. All I did was 
  - Set the `MIX_ENV=prod`
  - Compile the source code 
  - Set the `max_keepalive` parameter in `config/prod.exs`
  - Set the logger verbosity to `warn`
- After optimizing the set up to production mode for the Django DRF app, I see 28x improvements from **14 RPS to 400 RPS**. All I did was 
  - Use Gunicorn and set the correct number of workers for Gunicorn
  - Set `DEBUG=False` in `settings.py`
- Elixir Phoenix is superior in speed compared to Django at almost 10x. This is a huge difference when translated to infra expense.
- Always run everything in production mode to get the full speed!
- There are many things that is neglected here: avoiding N + 1 query, background job, database optimization, indexing, etc.

## How to run API servers

### How to run Phoenix

```shell
$ cd todo_phoenix
$ docker-compose build
$ docker-compose up
$ curl -i localhost:4000/api/todos/
```

### How to run Django REST Framework (DRF)


```shell
$ cd todo_django
$ docker-compose build
$ docker-compose up
$ curl -i localhost:8000/api/todos/
```

## Benchmark Result

This is the benchmark is running on my machine with the following spec: 8 cores 16 threads Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz and 16GB of RAM.

### Phoenix Result

```shell
$ ab -n 10000 -c 100 localhost:4000/api/todos/
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        Cowboy
Server Hostname:        localhost
Server Port:            4000

Document Path:          /api/todos/
Document Length:        11 bytes

Concurrency Level:      100
Time taken for tests:   1.619 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      2570000 bytes
HTML transferred:       110000 bytes
Requests per second:    6176.04 [#/sec] (mean)
Time per request:       16.192 [ms] (mean)
Time per request:       0.162 [ms] (mean, across all concurrent requests)
Transfer rate:          1550.04 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   1.2      1      12
Processing:     2   15   4.8     14      42
Waiting:        1   14   4.7     14      40
Total:          2   16   4.7     16      43

Percentage of the requests served within a certain time (ms)
  50%     16
  66%     17
  75%     19
  80%     19
  90%     22
  95%     25
  98%     28
  99%     30
 100%     43 (longest request)
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

## Please contribute

If anyone has experience in building Todo list app using Ruby on Rails, NestJS, Laravel, Go Buffalo, etc., feel free to submit a PR to this repo together with production settings (and Docker Compose file) for the app. I would love to see the performance for these frameworks as well.

## References

- [Benchmarking Phoenix by Saša Jurić](https://www.theerlangelist.com/article/phoenix_latency)
