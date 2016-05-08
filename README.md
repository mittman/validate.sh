# validate.sh
Utility to easily run webapp validation tests

## Getting Started
In the development directory, create `.webapp` containing the path to each file
```
html=("index.html" "about.html")
css=("style.css")
js=("js/app.js" "server.js")
list="jshint csslint tidy whitespace stylish"
```

## Tests
* [csslint](https://www.npmjs.com/package/csslint) --- CSS validator
* [jshint](https://www.npmjs.com/package/jshint) --- Javascript validator
* [tidy](https://github.com/htacg/tidy-html5/tree/master/README) --- HTML validator
* whitespace (`built-in`) --- white-space validator
* stylish (`built-in`) --- programming style validator

## NodeJS
* Add to `package.json`
```
  "scripts": {
    "test": "/path/to/validate.sh"
  },
```
* $ `npm test`

## Copyright and License
Copyright &copy; 2016 [mittman](https://github.com/mittman)

[validate.sh](https://github.com/mittman/validate.sh/blob/master/validate.sh) is dual licensed under the [MIT](LICENSE) (aka X11) and [GPLv2](COPYING) licenses.
