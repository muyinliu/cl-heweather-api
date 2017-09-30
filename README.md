# cl-heweather-api
cl-heweather-api is a Common Lisp SDK of
[HeWeather API](http://www.heweather.com) to get weather
information(include air information).

Note: Some of the API is NOT free.

## License
Copyright(c) 2017 Muyinliu Xing Released under the ISC License.

## Dependencies
Relax, usually Quicklisp will download all these packages for you :)

* flexi-streams
* drakma

## Install and load with QuickLisp
In shell:
```shell
git clone https://github.com/muyinliu/cl-heweather-api.git
cp -r cl-heweather-api ~/quicklisp/local-projects/cl-heweather-api
```

Then in Common Lisp:
```lisp
(ql:quickload 'cl-heweather-api)
```

## Usage
Note: Please use your own `*api-key*` comes from [HeWeather](http://www.heweather.cn/), for example:
```lisp
(setf heweather:*api-key* "your-api-key")
```

### Get current weather information
```lisp
(heweather:now "beijing")
```

Result example:
```
"{\"HeWeather5\":[{\"basic\":{\"city\":\"北京\",\"cnty\":\"中国\",\"id\":\"CN101010100\",\"lat\":\"39.904000\",\"lon\":\"116.391000\",\"update\":{\"loc\":\"2017-03-07 13:51\",\"utc\":\"2017-03-07 05:51\"}},\"now\":{\"cond\":{\"code\":\"100\",\"txt\":\"晴\"},\"fl\":\"6\",\"hum\":\"17\",\"pcpn\":\"0\",\"pres\":\"1023\",\"tmp\":\"6\",\"vis\":\"10\",\"wind\":{\"deg\":\"332\",\"dir\":\"北风\",\"sc\":\"6-7\",\"spd\":\"36\"}},\"status\":\"ok\"}]}"
200
```

Note: More result example should check directory `/result-examples/`
and [HeWeather API Document](https://www.heweather.com/documents/api/v5)

Note: More function please read file **cl-heweather-api.lisp**


## More
Welcome to reply.
