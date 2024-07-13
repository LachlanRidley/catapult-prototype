import subprocess
import click
import shutil


@click.group()
def cli():
    pass


@cli.command()
def run():
    build()
    run_internal()


def build():
    if shutil.which("pdc") is None:
        raise Exception("pdc is not on path; install PlayDate SDK")

    subprocess.run(["pdc", "source", "game.pdx"])


def run_internal():
    if shutil.which("PlaydateSimulator") is None:
        raise Exception("PlaydateSimulator is not on path; install PlayDate SDK")

    subprocess.Popen(["PlaydateSimulator", "game.pdx"])
