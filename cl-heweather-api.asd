(asdf:defsystem :cl-heweather-api
  :version "0.0.1"
  :description "HeWeather weather API for Common Lisp."
  :author "Muyinliu Xing <muyinliu@gmail.com>"
  :depends-on (:flexi-streams
               :drakma)
  :components ((:static-file "cl-heweather-api.asd")
               (:file "cl-heweather-api")))
