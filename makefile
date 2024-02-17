
FD = fd

all: backend frontend
backend: src/backend
frontend: static/main.js

src/backend: $(shell ${FD} . 'src/' -e nim)
	nim compile src/backend.nim

run:
	nim compile -r src/backend.nim --config=config.debug.env

deploy:
	nim compile -d:release -r src/backend.nim --config=config.prod.env


static/main.js: elm.json $(shell ${FD} . 'src/frontend' -e elm)
	elm make src/frontend/Main.elm --output=static/main.js

.PHONY: all backend frontend
