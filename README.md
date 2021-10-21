# scripts to use genuine ssh-agent on macOS

Since ssh-agent comes with macOS is old, customized by
Apple[^apple-ssh-agent] and protected by SIP, using ed25519-sk (or
ecdsa-sk) is a little annoying. I tried two methods and
succeeded. This is the second method.

cf. [the first method](/fmrns/launchd-sock-proxy)

## setup

1. Put files.

```
cp -p ssh-agent-homebrew.sh ~/bin/
chmod a-w,a+x ~/bin/ssh-agent-homebrew.sh
cp -p local.method2.ssh-agent.plist ~/Library/LaunchAgent/
```

2. Edit .plist appropriately. Especially change '/Users/est/' to your
user name, and enable it.

```
plutil ~/Library/LaunchAgent/local.method1.plist
launchctl unload -w ~/Library/LaunchAgent/local.method1.plist
launchctl   load -w ~/Library/LaunchAgent/local.method1.plist
```

3. Refer to .*x*shrc files to put initialization of environmental
variables. You can choose one of -a, -b, and -c.

-a files: Overwrite environmental variables.

-b files: Instead of overwriting environmental variables, set them at
 running time.

-c files: Like -b, set them at running time by scripts.

enjoy!

[^apple-ssh-agent]: for example: [ssh-agent](https://opensource.apple.com/source/OpenSSH/OpenSSH-240.40.1/openssh/ssh-agent.c.auto.html)
