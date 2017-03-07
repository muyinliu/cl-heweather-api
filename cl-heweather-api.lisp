;;;; cl-heweather-api.lisp
;;;; Please read this document http://docs.heweather.com/222344

(defpackage cl-heweather-api
  (:use :cl)
  (:nicknames :heweather-api :heweather)
  #+:sbcl (:shadow :defconstant :search)
  #+:sb-package-locks (:lock t)
  (:export #:*api-key*
           #:+supported-language-list+

           ;; Weather APIs
           #:forecast
           #:now
           #:hourly
           #:suggestion
           #:alarm
           #:weather
           #:scenic
           #:historical
           #:search))

(in-package :cl-heweather-api)

(defmacro defconstant (name value &optional doc)
  "Make sure VALUE is evaluated only once \(to appease SBCL)."
  `(cl:defconstant ,name (if (boundp ',name) (symbol-value ',name) ,value)
     ,@(when doc (list doc))))

(defvar *free-api-url-head*     "https://free-api.heweather.com/v5")
(defvar *non-free-api-url-head* "https://api.heweather.com/v5")

(defvar *api-key* nil) ;; Please use your own API key

;; Supported language list
(defconstant +supported-language-list+
  '("zh-cn" "zh-tw" "en" "in" "th"))

;; Weather API URLs
(defvar *api-forecast-uri* "/forecast"
  "最长10天天气预报数据（大客户可达14天），天气预报已经包含日出日落，月升月落等常规数据")

(defvar *api-now-uri* "/now"
  "包括多种气象指数的实况天气，每小时更新")

(defvar *api-hourly-uri* "/hourly"
  "最长未来10天每三小时、每一小时天气预报数据")

(defvar *api-suggestion-uri* "/suggestion"
  "目前提供7大生活指数，每三小时更新（仅提供国内数据）")

(defvar *api-alarm-uri* "/alarm"
  "为全国2560个城市灾害预警信息，包括台风、暴雨、暴雪、寒潮、大风、沙尘暴、高温、干旱、雷电、冰雹、霜冻、霾、道路结冰、寒冷、灰霾、雷电大风、森林火险、降温、道路冰雪、干热风、低温、冰冻等灾害类型。每15分钟更新一次，建议用户每30-60分钟获取一下信息。（仅提供国内数据）")

(defvar *api-weather-uri* "/weather"
  "包括7-10天预报、实况天气、每小时天气、灾害预警、生活指数、空气质量，一次获取足量数据")

(defvar *api-scenic-uri* "/scenic"
  "全国4A和5A级景点共2000＋的7天天气预报（仅提供国内数据）")

(defvar *api-historical-uri* "/historical"
  "支持2010年1月1日至今的全国城市历史天气数据（仅提供国内数据）")

(defvar *api-search-uri* "/search"
  "通过此接口获取城市信息，例如通过名称获取城市ID，建议使用城市ID获取天气数据，避免重名城市导致的混淆（若使用模糊查询，则可能返回多个城市数据）")

;; Utilities
(defun request (api-uri &key (api-key *api-key*)
                          (api-url-head *free-api-url-head*)
                          city
                          lang
                          parameters)
  ;; Check api-key
  (restart-case
      (unless api-key
        (error "api-key can NOT be nil."))
    (use-value (value)
      :report (lambda (stream)
                (format stream "Use another api-key instead."))
      :interactive (lambda ()
                     (format *query-io* "Enter api-key: ")
                     (finish-output *query-io*)
                     (list (read-line *query-io*)))
      (setf *api-key* value
            api-key   value)))
  
  ;; Check language
  (when lang
    (assert (find lang +supported-language-list+ :test #'equal)))

  ;; Deal with parameters
  (when parameters
    (setf parameters
          (loop for (key . value) in parameters
             when value
             collect (cons key
                           (if (stringp value)
                               value
                               (write-to-string value))))))
  
  (let ((request-url (format nil "~A~A" api-url-head api-uri)))
    (multiple-value-bind (data status-code)
        (drakma:http-request request-url
                             :parameters (append (list (cons "key" api-key))
                                                 (when city
                                                   (list (cons "city" city)))
                                                 (when lang
                                                   (list (cons "lang" lang)))
                                                 parameters))
      (values (flex:octets-to-string data :external-format :utf-8)
              status-code))))

;; Weather APIs
(defun forecast (city &key lang)
  "最长10天天气预报数据（大客户可达14天），天气预报已经包含日出日落，月升月落等常规数据"
  (request *api-forecast-uri*
           :city city
           :lang lang))

(defun now (city &key lang)
  "包括多种气象指数的实况天气，每小时更新"
  (request *api-now-uri*
           :city city
           :lang lang))

(defun hourly (city &key lang)
  "最长未来10天每三小时、每一小时天气预报数据"
  (request *api-hourly-uri*
           :city city
           :lang lang))

(defun suggestion (city)
  "目前提供7大生活指数，每三小时更新（仅提供国内数据）"
  (request *api-suggestion-uri*
           :city city))

(defun alarm (city)
  "为全国2560个城市灾害预警信息，包括台风、暴雨、暴雪、寒潮、大风、沙尘暴、高温、干旱、雷电、冰雹、霜冻、霾、道路结冰、寒冷、灰霾、雷电大风、森林火险、降温、道路冰雪、干热风、低温、冰冻等灾害类型。每15分钟更新一次，建议用户每30-60分钟获取一下信息。（仅提供国内数据）"
  (request *api-alarm-uri*
           :city city))

(defun weather (city &key lang)
  "包括7-10天预报、实况天气、每小时天气、灾害预警、生活指数、空气质量，一次获取足量数据"
  (request *api-weather-uri*
           :city city
           :lang lang))

(defun scenic (city &key lang)
  "全国4A和5A级景点共2000＋的7天天气预报（仅提供国内数据，收费）"
  (request *api-scenic-uri*
           :city city
           :lang lang))

(defun historical (city date)
  "支持2010年1月1日至今的全国城市历史天气数据（仅提供国内数据，收费）"
  (request *api-historical-uri*
           :city city
           :parameters (list (cons "date" date))))

(defun search (city)
  "通过此接口获取城市信息，例如通过名称获取城市ID，建议使用城市ID获取天气数据，避免重名城市导致的混淆（若使用模糊查询，则可能返回多个城市数据）"
  (request *api-search-uri*
           :city city))
