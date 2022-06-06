# til-queue

## Build

1. `make`

## Usage

```tcl
queue | as q
queue 16 | as q2

push $q alfa
push $q beta
push $q gama

assert ([pop $q] == alfa)
assert ([pop $q] == beta)
assert ([pop $q] == gama)
```
