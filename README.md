# docker-json

A docker image for json: [http://trentm.com/json/]

## Usage with Docker run

Use this Docker image from the comamnd line in the same way you would with json.

First build the image:

```sh
docker build -t json .
```

Now use the image to call json with `docker run -i --rm json`:

```sh
echo '{"a":1}
{"b": 2}' | docker run -i --rm json -g
```

```sh
echo '[{"name":"trent","age":38},
         {"name":"ewan","age":4}]' | json -a name age
```

## Make it easier with an alias

Add this to your `.bashrc` or `.zshrc` file:

```bash
alias json='docker run -i --rm json'
```
