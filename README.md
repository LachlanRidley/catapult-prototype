# catapult-prototype

## build tools

This repo includes some simple build tools.

To run:

```sh
lua -l setup tools.lua run
```

## levels

Levels are built using [LDtk](https://ldtk.io/). The world file is located in source.

When loading assets referenced by the world file, make sure that these aren't relatively referenced in a way that goes outside of the `source` folder (e.g. `../source/tiles.png`). The LDtk loader will complain about this as all files required by the game must be inside the source folder.
