ifdef OS
HOST:=windows
else
ifeq ($(shell uname),Darwin)
HOST:=mac
else
ifeq ($(shell uname),Linux)
HOST:=linux
endif
endif
endif
