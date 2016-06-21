# Pipelite
The most over-engineered CI build-light software on the planet.

[![Build status](https://badge.buildkite.com/da22a33757c42fc1ff5c50cc1e53b5da64ff314ecf83897df9.svg?branch=master)](https://buildkite.com/ferocia/pipelite)

***

## What is this?

Probably useless! But also the most over-engineered CI build-light system ever.

## What does it do?

Pipelite is web-app that collects and displays information about our CI system, it also supports performing actions when certain events occur on CI (for example changing the colour of a light in the office!).

Pipelite consists of several core services, namely an API and UI service.

The API is written in [Elixir](http://elixir-lang.org/) using [Phoenix](http://www.phoenixframework.org/), and the UI is written in Javascript and is a progressive, server-renderable React app, using Redux that streams state from the backend via websocket.

Things that are currently being worked on, were started and abandoned because I got bored, or just things I threw away are:

- failing log collection, aggregation and filtering in elastic search (I wanted to play with it)

#### It looks like this in a browser:

![](/../master/doc/browser.png?raw=true)

#### ...and it could look something like this on a wall:

![](/../master/doc/wall.jpg?raw=true)

## :point_up: Note:

Pipelite is really just a hack project that I ([@plasticine](https://github.com/plasticine)) was using to mess around outside of office-hours at [@Ferocia](https://github.com/Ferocia), that somehow became somewhat—perhaps questionably—useful.

The original intent of this project was really just to give me an excuse to mess around in my spare time with a few languages and tecniques that I was curious about at the time. Some of them were completely new to me, others were just things that I wanted to experiement and try and learn from. Buzzwords I was curious about in particular were;
- Elixir,
- Server JS SPA architecture,
- Streaming application state from backend -> frontend,
- Docker,
- Microservices,
- AWS
- ...and a bunch of other stuff...

Given the above disclaimer it should hopefully be apparent that this code is all hackey as hell, and held together with bubblegum, hopes, and a bunch of dreams (so don’t judge me if you read the code!). :)

That said, it all works and works pretty damn well most of the time(see pics below), and looks pretty awesome.

So why open source this? I dunno, why not? Really though it’s mostly because [@joho](https://github.com/joho) rightly [called me out for being a secretive jerk](https://twitter.com/johnbarton/status/743736597074456576).
