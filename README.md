# Lstage - Stage concurrency kit for Lua
Lstage is a Lua library for bulding parallel, non-linear pipelines based on the concepts of the SEDA (Staged Event-Driven Architecture).

# Compiling and Installing
Lstage is compatible with Lua version 5.1

Leda requires Threading Building Blocks (TBB) to work properly.

For more information on the TBB library: http://threadingbuildingblocks.org/

To install all dependencies on a Debian like linux (Ubuntu, mint, etc) do: 

```
sudo apt-get update
sudo apt-get install libtbb-dev libevent-dev libpthread-stubs0-dev lua5.1-dev lua5.1 g++ make git
```

To clone git repository:

```
git clone https://github.com/brenoriba/lstage.git
```

To build Lstage:

```
make
sudo make install
```

# Testing installation

To test if the installation was successful type this command:

```
$ lua -l lstage
```

You should get the lua prompt if lstage is installed properly or the error message "module 'lstage' not found" if it cannot be loaded 

# Installing Image Processing Project

Install dependencies:

```
sudo apt-get install aptitude lua-filesystem-dev
sudo aptitude install libopencv-dev libopencv-highgui-dev libimlib2-dev
```

Build project:

```
make
```

Run:

```
lua run.lua
```

# Installing HTTP Server Project

Install dependencies:

```
sudo apt-get install lua-socket-dev
```

Build project:

```
make
```

Run server:

```
lua server.lua
```

Run client:

```
lua client.lua
```

Or you can test directly from your browser using one of the URL's bellow:

```
To run a script inside the server      : http://127.0.0.01:8080/index.lua
To read a static page inside the server: http://127.0.0.01:8080/index.html
```

Or you can use httperf to run a bunch of queries:

Installing:

```
https://rtcamp.com/tutorials/benchmark/httperf/
```

Follow this steps:

```
unzip master.zip (inside apps/http/)
cd httperf-master
autoreconf -i
mkdir build
cd build
../configure
make 
make install
```

Testing:

```
httperf --client=0/1 --server=127.0.0.1 --port=8080 --uri=/index.html --send-buffer=4096 --recv-buffer=16384 --num-conns=1000 --num-calls=1
```
