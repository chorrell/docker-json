# docker-json

A docker image for json: [http://trentm.com/json/]

## Usage with Docker run

Use this Docker image from the command line in the same way you would with json.

First build the image:

```sh
docker build -t json .
```

Now use the image to call json with `docker run -i --rm json`:

Version check:

```sh
docker run -i --rm json
```

Grouping:

```sh
echo '{"a":1}
{"b": 2}' | docker run -i --rm json -g
```

Itemizing:

```sh
echo '[{"name":"trent","age":38},
         {"name":"ewan","age":4}]' | docker run -i --rm json -a name age
```

## Make it easier with an alias

Add this to your `.bashrc` or `.zshrc` file:

```bash
alias json='docker run -i --rm json'
```

## Using the GitHub Container Registry image

The lateset version of this image is published to the GitHub Container Registry. You can use it like this:

```sh
docker pull ghcr.io/chorrell/json:latest

docker run -i --rm ghcr.io/chorrell/json:latest
```

And setup an alias like this:

```bash
alias json='docker run -i --rm ghcr.io/chorrell/json:latest'
```
