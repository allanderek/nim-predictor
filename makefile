
all:
	nim compile src/backend.nim

run:
	nim compile -r src/backend.nim --config=config.debug.env

deploy:
	nim compile -r src/backend.nim --config=config.prod.env


