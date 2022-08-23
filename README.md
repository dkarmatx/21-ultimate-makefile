# Utlimate 21 school makefile
My 21 school projects are Makefile based. I've created this makefile "framework" on my own purpose, but everyone could use it for their one.
It works simply, just define source files and target name and then build your project easily.

# Example
Let's imagine that we have such makefile
```mk
TARGET       = ft_program
SOURCE_FILES = main.c dir/file1.c dir/file2.c
BIN_DIR      = .

include 21.mk
```

Then just press rules and be happy
```
make release
make debug
make re
make red # fclean + debug
make clean
make help
```

# Contributors
dkarmatx - (https://github.com/dkarmatx)
