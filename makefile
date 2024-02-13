
all:
	nim compile src/backend.nim

run:
	nim compile -r src/backend.nim --config=config.debug.env

deploy:
	nim compile -d:release -r src/backend.nim --config=config.prod.env

frontend: src/frontend/Main.elm
	elm make src/frontend/Main.elm --output=static/main.js
