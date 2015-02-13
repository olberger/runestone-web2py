Running RuneStone Interactive with web2py in a Docker container
---------------------------------------------------------------

This will allow to build a docker container to test [RuneStone
Interactive](http://runestoneinteractive.org/).

The container will run a RuneStone tools server (based on
https://github.com/bnmnetp/runestone) as a web2py application, thus
reusing the web2py container (using the upstream web2py version) ---
see its [dedicated repo, on the 'upstream'
branch](https://github.com/olberger/docker-web2py-debian/tree/upstream)).

To build :

 1. clone the 'upstream' branch of the docker-web2py-debian repo :

```sh
git clone -b upstream https://github.com/olberger/docker-web2py-debian.git
cd docker-web2py-debian
docker build -t debian-web2py:jessie .
```

 2. build the container

docker build -t runstone-web2py .

 3. run

docker run  -d -p 8080:80 -p 8443:443 -h localrunestone runstone-web2py

We use as many Debian packages as possible for the Python
dependencies, so only a few modules are pulled with pip from the
requirements.txt of RuneStone.

The web2py admin password is set in the docker-web2py-debian container
(see its documentation).

Test by connecting to https://localhost:8443/runestone/ (or https://localhost:8443/).
