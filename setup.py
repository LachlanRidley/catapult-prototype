from setuptools import setup

setup(
    name="playdatetools",
    version="0.1.0",
    py_modules=["tools"],
    install_requires=[
        "Click",
    ],
    entry_points={
        "console_scripts": [
            "pdt = tools:cli",
        ],
    },
)
