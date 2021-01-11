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

|                | DB endpoint (rps) | Non-DB endpoint (rps) |
|----------------|-------------------|-----------------------|
| Elixir Phoenix | 6,136             | 11,353                |
| Django DRF     | 596               | 2,813                 |

### Phoenix Result

```shell
$ hey -z 30s http://localhost:8000/api/healthz

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



$ hey -z 30s http://localhost:8000/api/todos/


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
$ hey -z 30s http://localhost:8000/api/healthz/

Summary:
  Total:	30.0123 secs
  Slowest:	0.6489 secs
  Fastest:	0.0018 secs
  Average:	0.0178 secs
  Requests/sec:	2813.9459
  
  Total data:	1351248 bytes
  Size/request:	16 bytes

Response time histogram:
  0.002 [1]	|
  0.066 [84381]	|■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.131 [28]	|
  0.196 [26]	|
  0.261 [5]	|
  0.325 [1]	|
  0.390 [0]	|
  0.455 [0]	|
  0.519 [3]	|
  0.584 [5]	|
  0.649 [3]	|


Latency distribution:
  10% in 0.0109 secs
  25% in 0.0134 secs
  50% in 0.0165 secs
  75% in 0.0207 secs
  90% in 0.0257 secs
  95% in 0.0292 secs
  99% in 0.0378 secs

Details (average, fastest, slowest):
  DNS+dialup:	0.0005 secs, 0.0018 secs, 0.6489 secs
  DNS-lookup:	0.0001 secs, 0.0000 secs, 0.0094 secs
  req write:	0.0001 secs, 0.0000 secs, 0.0120 secs
  resp wait:	0.0167 secs, 0.0013 secs, 0.6412 secs
  resp read:	0.0004 secs, 0.0000 secs, 0.0610 secs

Status code distribution:
  [200]	84453 responses


$ hey -z 30s http://localhost:8000/api/todos/

Summary:
  Total:	30.1113 secs
  Slowest:	0.3073 secs
  Fastest:	0.0341 secs
  Average:	0.0837 secs
  Requests/sec:	596.3874
  
  Total data:	6841998 bytes
  Size/request:	381 bytes

Response time histogram:
  0.034 [1]	|
  0.061 [2800]	|■■■■■■■■■■
  0.089 [10855]	|■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  0.116 [1330]	|■■■■■
  0.143 [1736]	|■■■■■■
  0.171 [838]	|■■■
  0.198 [260]	|■
  0.225 [93]	|
  0.253 [36]	|
  0.280 [7]	|
  0.307 [2]	|


Latency distribution:
  10% in 0.0593 secs
  25% in 0.0643 secs
  50% in 0.0717 secs
  75% in 0.0870 secs
  90% in 0.1344 secs
  95% in 0.1507 secs
  99% in 0.1914 secs

Details (average, fastest, slowest):
  DNS+dialup:	0.0002 secs, 0.0341 secs, 0.3073 secs
  DNS-lookup:	0.0000 secs, 0.0000 secs, 0.0029 secs
  req write:	0.0001 secs, 0.0000 secs, 0.0185 secs
  resp wait:	0.0832 secs, 0.0157 secs, 0.3070 secs
  resp read:	0.0002 secs, 0.0000 secs, 0.0260 secs

Status code distribution:
  [200]	17958 responses

```

## Please contribute

If anyone has experience in building Todo list app using Ruby on Rails, NestJS, Laravel, Go Buffalo, etc., feel free to submit a PR to this repo together with production settings (and Docker Compose file) for the app. I would love to see the performance for these frameworks as well.

## References

- [Benchmarking Phoenix by Saša Jurić](https://www.theerlangelist.com/article/phoenix_latency)
