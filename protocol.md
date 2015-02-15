# IRC protocol

## Sending commands

```
NICK <nickname>
USER <ident> 8 * :<real name>
JOIN #channel
PART #channel
PRIVMSG #channel :foo bar
PRIVMSG nick :foo bar
```

## Receiving stuff

```
PING /(?<rest>.*)/
PONG <rest>

/(?!= ).*/ (JOIN|PART) #channel ;; someone joined #channel
/(?!= ).*/ QUIT :message ;; someone left

/(?!= ).*/ PRIVMSG #channel :message
/(?!= ).*/ PRIVMSG <my nickname> :message ;; someone pinged me

/(?!= ).*/ NOTICE * :message ;; status notice

/(?!= ).*/ /\d+/ /(?!=:).*/ :rest ;; show in status

/(?!= ).*/ 433 * <my nickname> :Nickname is already in use
```
