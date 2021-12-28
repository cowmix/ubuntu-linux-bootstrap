# ubuntu-linux-bootstrap

Script for getting a ubuntu box into dev mode from new install to useful in ~10 minutes...

Last run against `Ubuntu 21.10`.

> Do note that it is best-effort and by no means definitive, these things are hard to test! I just update things when I am doing a new build etc and some issues I spot fix, others are missed...

## Simple Bootstrap

A recent build of Ubuntu (at first 16, then 18, and now 21) gave rise to the need for a few tools etc.

By no means exhaustive, run as yourself (you will immediately be prompted for your password via sudo), then have a coffee:

    ./bootstrap.sh

## Main Packages

* Chrome and other browsers
* Docker, Docker Compose
* Visual Studio Code
* .NET Core
* Go
* Node/npm/yarn
* zsh (and ohmyzsh)

Reminders about git setup etc

---

## Notes

### Docker

For docker, you will most likely need to log out and log in again for all the user/group settings to apply.

### VS Code

If you are running this in a VM of sorts you may need to disable the GPU when running VS Code for it to work happily:

    code --disable-gpu

> https://code.visualstudio.com/docs/supporting/FAQ#_vs-code-is-blank

### Go

If using VS Code (assuming you installed the suggested extensions such as `golang.go`) run the helper command "GO: Install/Update tools" to get the rest of the Golang goodies.
