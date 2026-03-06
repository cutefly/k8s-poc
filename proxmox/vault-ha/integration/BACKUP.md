# Medusa importing and exporting cli tool

## build medusa

```sh
$ git clone https://github.com/jonasvinther/medusa.git
$ cd medusa
$ go build .

$ ./medusa -h
```

## export secret

```sh
$ ./medusa export secret --address="${VAULT_ADDR}" --token="${VAULT_TOKEN}" --format="json" --insecure > output.json\n
$ cat output.json
```

## import secret

```sh
./medusa import secret/import ./output.json --address="${VAULT_ADDR}" --token="${VAULT_TOKEN}" --insecure
```
