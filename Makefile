
.PHONY: run all

run: all
	love build	

all:
	cd source && moonc -t ../build .

