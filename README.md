# Live App
Please check the live app at: [https://fs-blog-engine.herokuapp.com/](https://fs-blog-engine.herokuapp.com/)

# Features

* Add / Remove / Update posts
* The index route fetches the updates the content in realtime using Socket.IO
* Restoring deleted posts
* Markdown support

# Run the App locally

```
$ nvm use 5.3.0 
$ npm install
$ npm configure
$ gulp
```

# Technology Choices

## LiveScript

The program is written entirely in [LiveScript](http://livescript.net/), which is a descendent of CoffeeScript and compiles to ES5.

LiveScript makes the devleopment of Node / React apps easy and fast because of:

* String interpolation similar to Perl
* Functional Programming style (ideal for React with immutable data)
* Object extension and merge operator `<<<`
* Bound functions `~>`
* Back-call `<-`: used for binding async functions together (avoiding nesting)

## async-ls
ES6 Promises are similar to Monads in FP.

I developed [async-ls](https://github.com/homam/async-ls) with a similar funcionality to [Async.js](https://github.com/caolan/async). async-ls is more suitable for FP programming with LiveScript and (Lazy) Promises.


# Scalability

* Dependency Injection (Storage)
* React Stateless Reusable Components


# Unit Tests

```
$ mocha test/index.ls --compilers ls:livescript
```

Or just `$ npm run test`

# Misc
* Type annotation (Haskell style)