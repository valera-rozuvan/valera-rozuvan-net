# valera-rozuvan-net

Personal site of Valera Rozuvan. See live version at [https://valera.rozuvan.net/](https://valera.rozuvan.net/).

## Requirements

You need [Bash](https://www.gnu.org/software/bash/), [Pandoc](https://pandoc.org/), and [Ruby](https://www.ruby-lang.org/).

## Building

Use the provided script [build.sh](./build.sh):

```shell
./build.sh "https://valera.rozuvan.net" "/home/user/some/path"
```

## Testing

To check for broken links, you can use [broken-link-checker-local](https://www.npmjs.com/package/broken-link-checker-local).

```shell
blcl "https://valera.rozuvan.net" -ro
```
