# valera-rozuvan-net

personal site of Valera Rozuvan

## about

See live version at [https://valera.rozuvan.net/](https://valera.rozuvan.net/).

## requirements

You need [Bash](https://www.gnu.org/software/bash/), [Pandoc](https://pandoc.org/), and [Ruby](https://www.ruby-lang.org/).

On a Debian-based system:

```shell
sudo aptitude install pandoc pandoc-data ruby-full
```

## building

Use the provided script [build.sh](./build.sh):

```shell
./build.sh "https://valera.rozuvan.net" "/home/user/some/path"
```

## testing

To check for broken links, you can use [broken-link-checker-local](https://www.npmjs.com/package/broken-link-checker-local).

```shell
blcl "https://valera.rozuvan.net" -ro
```

---

## license

The project `'valera-rozuvan-net'` is licensed under the CC0-1.0.

See [LICENSE](./LICENSE) for more details.

The latest source code can be retrieved from one of several mirrors:

1. [github.com/valera-rozuvan/valera-rozuvan-net](https://github.com/valera-rozuvan/valera-rozuvan-net)

2. [gitlab.com/valera-rozuvan/valera-rozuvan-net](https://gitlab.com/valera-rozuvan/valera-rozuvan-net)

3. [git.rozuvan.net/valera-rozuvan-net](https://git.rozuvan.net/valera-rozuvan-net)

Copyright (c) 2013-2022 [Valera Rozuvan](https://valera.rozuvan.net/)
