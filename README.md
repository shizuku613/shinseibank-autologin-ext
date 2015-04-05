shinseibank-autologin-ext
-------------------------

[![Build Status](https://travis-ci.org/shizuku613/shinseibank-autologin-ext.svg?branch=master)](https://travis-ci.org/shizuku613/shinseibank-autologin-ext)

## Build

```sh
$ npm install
$ npm install -g crx

$ crx keygen .
$ npm run newkey

$ cp userdata/userdata.json.example userdata/userdata.json
$ vim userdata/userdata.json
# Please edit user settings and .key file URL

$ npm run build
# Please install .crx file to your Google Chrome
```

## License
MIT License<br />
Copyright (c) 2015 Shizuku Kono