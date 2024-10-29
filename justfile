set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

build:
    pdc source game.pdx

run: build
    PlaydateSimulator game.pdx