PRG = worktime
SRC = timew_worktime.c
LDFLAGS = -lcjson

${PRG}: ${SRC}
	gcc -o ${PRG} ${SRC} ${LDFLAGS}

debug: ${SRC}
	gcc -o ${PRG} ${SRC} ${LDFLAGS} -g -DDEBUG

tags: ${SRC}
	ctags -R .

install: ${PRG}
	install ${PRG} $$HOME/.timewarrior/extensions

clean:
	rm -rf ${PRG}

distclean: clean
	rm -rf tags

.PHONY: clean distclean
