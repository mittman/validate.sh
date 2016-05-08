# validate.sh
Utility to easily run webapp validation tests

## Getting Started
In the development directory, create `.webapp` containing the path to each file
```
html=("index.html" "about.html")
css=("style.css")
js=("js/app.js" "server.js")
```

## NodeJS
* Add to `package.json`
```
  "scripts": {
    "test": "validate.sh"
  },
```
* $ `npm test`

## Copyright and License
Copyright &copy; 2016 [mittman](https://github.com/mittman)

[validate.sh](https://github.com/mittman/validate.sh/blob/master/validate.sh) is dual licensed under the [MIT](LICENSE) (aka X11) and [GPLv2](COPYING) licenses.
