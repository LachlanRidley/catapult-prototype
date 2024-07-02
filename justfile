set shell := ["powershell.exe", "-c"]

run: build
    PlaydateSimulator.exe game.pdx

build:
    pdc source game.pdx
