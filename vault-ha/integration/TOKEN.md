# Token for applicatino

## create token

```sh
$ vault token create -policy="secret-read-only" -ttl=24h
Key                  Value
---                  -----
token                ****************
token_accessor       9cLQBFlActXiw44DJOfaLBUN
token_duration       24h
token_renewable      true
token_policies       ["default" "secret-read-only"]
identity_policies    []
policies             ["default" "secret-read-only"]
```

## lookup token

```sh
$ vault token lookup "****************"
Key                 Value
---                 -----
accessor            eH83XT6NafWvADNIO2gkL87C
creation_time       1768886287
creation_ttl        24h
display_name        token
entity_id           n/a
expire_time         2026-01-21T14:18:07.218684721+09:00
explicit_max_ttl    0s
id                  ****************
issue_time          2026-01-20T14:18:07.218688547+09:00
meta                <nil>
num_uses            0
orphan              false
path                auth/token/create
policies            [default secret-read-only]
renewable           true
ttl                 23h59m45s
type                service
```

## revoke token

```sh
$ vault token revoke "****************"
```
