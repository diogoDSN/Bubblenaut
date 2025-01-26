# Bubblenaut
A game developed for a GameJam with the theme "Bubbles".

## Setup (Mac)
To set up the game on a Mac, run the following commands:

```bash
brew install lua
brew install love
```

## Running the Game
To run the game, execute the following command:

```bash
love .
```

## Assets
The assets used in this game are stored in the `archive` directory. The game assets have a resolution of `128x128px`.
The background has a width of `512px`.

## Resizing the Window
This is handled by the `push` library. The game is designed to run at a resolution of `512x640px`.

## Screens

- Menu Screen
- Game Screen
- Game Over Screen
- Win Screen

## Building

To build a game for all systems use just with the target:
```sh
just build
```
This will create:
* A MacOs app in `build/mac/Bubblenauts.app`