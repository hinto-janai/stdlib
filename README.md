# stdlib
>a standard library for Bash

![bash](https://user-images.githubusercontent.com/101352116/179367439-68a06efc-56bf-4899-82d9-1fe8d21b11fc.svg)

## Contents
- [About](#About)
- [Development](#Development)
- [Usage](#Usage)
- [trace()](#trace)
- [List](#List)

## About
This is a library of boilerplate functions meant for general-purpose Bash programming. Requires at least Bash v4.4+ (2016), but Bash v5+ is recommended (2018). For reference, current **old-old Debian** (Stretch 9) uses Bash v4.4-5, while current stable Debian (Bullseye 11) uses Bash v5.1.4.

All functions have usage and more fine-grain documentation within the file it belongs to.

## Development
The all-in-one `stdlib.sh` file containing all library functions is created using [hbc, a Bash compiler.](https://github.com/hinto-janaiyo/hbc) hbc itself relies on portions of this library as well, leading to a symbiotic relationship between the two. You don't need to use hbc to use this library, however.

## Usage
Function groups are seperated by files, you can directly source them, copy+paste the functions directly into your own scripts [or preferably, use hbc to "compile" this library together with your script.](https://github.com/hinto-janaiyo/hbc) If you'd like to use the entire library, the entire set of functions has already been built as `stdlib.sh`.

First, clone:
```bash
git clone https://github.com/hinto-janaiyo/stdlib
```

Sourcing a single function set:
```bash
source stdlib/src/crypto.sh
```

Sourcing everything:
```bash
source stdlib/stdlib.sh

hash::md5 "hello"
log::ok   "all functions"
array     "are[0]=sourced"
```

Using [hbc](https://github.com/hinto-janaiyo/hbc):
```bash
#include <stdlib/log.sh>

log::ok "click above to see more info on hbc"
```

## trace()
This is a very special function in the stdlib, most likely the most useful and most important.

`trace()` is the very much needed Bash error-handler. It's written 100% with Bash builtins (no external binaries). It catches any command that has errored in-between the function pair, traces everything, prints detailed information (including an inline view of your code), then exits, terminating any sub-shells.

While every stdlib file only needs itself to operate correctly, some stdlib functions contain a small variable export ($STD_TRACE_RETURN) that lets `trace()` print just a little bit more information on stdlib-related errors. If you do not use `trace()`, the variable export will be harmless and do nothing instead.

EXAMPLE CODE:
```
___BEGIN___ERROR___TRACE___      <-- this function initiates trace()

echo "good command"              <-- these commands will run fine
echo "this is fine"

VAR=$(null_command)              <-- this null_command will FAIL and trigger
                                     trace + debug + exit. without trace(), $VAR
                                     would now be NULL or "", making the next
                                     command catastrophic.

rm -rf $VAR/*                    <-- this dangerous rm won't execute because
                                     trace() exit on the last command. without it,
                                     this would remove your /* root directory.

___ENDOF___ERROR___TRACE___      <-- this closes, and disables trace()
```
EXAMPLE OUTPUT:
![trace](https://user-images.githubusercontent.com/101352116/179367505-7f781c94-ca0c-4fa9-8f94-33fde38e113e.png)

## List
Brief summaries on each library file.

### [ask()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/ask.sh)
```
Prompt for user input.
````
### [color()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/color.sh)
```
Permanently set terminal text color, 100x-200x~ faster than tput.
```
### [crypto()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/crypto.sh)
```
Generate crypto.
```
### [date()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/date.sh)
```
Format the date in useful ways. Includes UNIX time and a translator.
```
### [debug()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/debug.sh)
```
A better set -x. Traces and prints every command in the style of trace().
```
### [guard()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/guard.sh)
```
Self-calculate the hash of the script running, return error on modified hash.
Useful for preventing tampering of a script.
```
### [hash()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/hash.sh)
```
Hash stdin or input with:
MD5 - SHA1 - SHA256 - SHA512
```
### [is()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/is.sh)
```
Check if input is an integer, postive, negative, etc.
```
### [lock()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/lock.sh)
```
Create and manage a lock file to prevent multiple script/function instances.
```
### [log()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/log.sh)
```
Print formatted messages to the terminal.
```
### [panic()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/panic.sh)
```
Print error information and enter endless loop to prevent further code execution.
```
### [$readonly](https://github.com/hinto-janaiyo/stdlib/blob/main/src/readonly.sh)
```
Common global variables set as readonly, includes COLOR variables:
$RED - $BRED - $BGREEN, etc
```
### [safety()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/safety.sh)
```
Safety functions to disarm potentially dangerous shell operations.
```
### [trace()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/trace.sh)
```
Detailed error handler for Bash, using 100% builtins.

Function pair much like try & catch. Catches any error between it, traces it,
prints detailed debug info, and exits.
```
### [type(), free()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/type.sh) & [const()](https://github.com/hinto-janaiyo/stdlib/blob/main/src/const.sh)
```
Safely initialize GLOBAL variables with certain types. Will return error if
the variable is already found to exist.

free() unsets variables.

const() converts already initialized variables into constants (readonly).
```
