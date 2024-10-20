set shell := ["powershell.exe", "-c"]

build:
  pdc source game.pdx

run: build
  PlaydateSimulator.exe game.pdx
