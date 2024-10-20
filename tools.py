import subprocess
import click
import shutil

@click.group()
def cli():
    pass

@cli.command()
def build():
    build_internal()

@cli.command()
def run():
    build_internal()
    subprocess.run(["PlaydateSimulator", "game.pdx"])

def build_internal():
    if shutil.which("pdc") is None:
        raise Exception("pdc is not on path; install PlayDate SDK")

    subprocess.run(["pdc", "source", "game.pdx"])

if __name__ == '__main__':
    cli()
