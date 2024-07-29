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


@cli.command()
def assets():
    if shutil.which("Aseprite") is None:
        raise Exception("Aseprite is not on path; install Aseprite")

    # TODO delete contents of image folder before rebuilding

    subprocess.run(
        [
            "Aseprite",
            "-b",
            "support/spike.aseprite",
            "--save-as",
            "source/images/spike.png",
        ]
    )


def build():
    if shutil.which("pdc") is None:
        raise Exception("pdc is not on path; install PlayDate SDK")

    subprocess.run(["pdc", "source", "game.pdx"])


def run_internal():
    if shutil.which("PlaydateSimulator") is None:
        raise Exception("PlaydateSimulator is not on path; install PlayDate SDK")

    subprocess.Popen(["PlaydateSimulator", "game.pdx"])
