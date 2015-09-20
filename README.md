# Tools for Unreal Tournament

#### Windows
Get the game from Steam: http://store.steampowered.com/app/13240/ and use a newer renderer: http://www.cwdohnal.com/utglr/ (OpenGL) or http://kentie.net/article/d3d10drv/ (Direct3D 10).

Set `FrameRateLimit=60` under `[OpenGLDrv.OpenGLRenderDevice]` in `UnrealTournament.ini` if the game runs too fast when using the OpenGL renderer.

Use the registry fixer from http://www.pseudorandom.co.uk/2001/paradox/utmodsfaq/#install-umod to install UMOD packages.

#### OS X
Get a prebuilt Wineskin from http://unrealosx.webs.com/downloads.htm

#### Linux
winetricks + Steam + the replacement OpenGL renderer works, or use `install_wine.sh` and the OS X download above.

The native Linux client is now very old, difficult to install, and doesn't get the benefits of a newer renderer.

After running `install_umodpack.sh`, `umod -b <path to install>`, `umod -i <some mod>.umod`

#### Hosting a LAN Server
Downloading custom maps or mutators is really slow by default. `redirect-server.js` serves files out of your UT install directory over HTTP and modifies `UnrealTournament.ini` so that clients know where to look (`http://<local-ip>:3000/`).

Run `npm install`, then `UT_HOME=<path to install> ./redirect-server.js` before launching UT.
