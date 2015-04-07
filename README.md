## A Docker container for the Phoenix framework

It features Phoenix 0.10.0 with Elixir compiled from master branch source code and Erlang 17.5

![Phoenix Logo](https://www.filepicker.io/api/file/9prSmznZTiaRRmI3t89E)

Phoenix is a framework for building scalable web applications with realtime connectivity across all your devices. It relies on the Elixir language for making the development of maintainable applications productive and fun.

### How to use this image

    docker run -it -v `pwd`:/code -w '/phoenix' marcelocg/phoenix mix phoenix.new /code/my_new_app

