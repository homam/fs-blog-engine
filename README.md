# Live Demo
* Markdown

# Execute the Program

```
nvm use 5.3.0 
npm install
npm configure
gulp
```

# Technology Choices

## LiveScript
* String interpolation similar to Perl
* Functional Programming style (ideal for React)
* Object extension and merge operator `<<<`
* Bound functions `~>`

# async-ls
ES6 Promises function similar to Monads.

I developed [https://github.com/homam/async-ls](async-ls) with a funcionality similar to [https://github.com/caolan/async](Async.js) but more suitable for FP programming with LiveScript and (Lazy) Promises.


# Scalability

* Dependency Injection (Storage)
* React Stateless Reusable Component


# Unit Tests

* `$ mocha test/index.ls --compilers ls:livescript`


# Misc
* Type annotation

# Whishlist