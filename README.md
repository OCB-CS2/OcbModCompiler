# OCB Mod compiler and BepInEx preload patching for City Skylines 2

This is still work in progress but already usable!

Based on https://github.com/OCB7D2D/OcbModCompiler

## What does it do

This repo adds a few utilities for local development and a
github action do auto compile and release a mod via CI/CD.

## Local compiler helpers

The main helper script is `MC-CS2`, which is used to compile
the given source files and "link" it against the actual game.

### Required environment variables

In order for the utilities to be available and globally callable,
you need to add the `utils` path to your global `path` environment
variable (please check google if you don't know how).

```bat
set PATH_CS2_MANAGED=X:\Install\Folder\Cities2_Data\Managed
```

Note that BepInEx dependency must already be installed at the
expected location (e.g. at `X:\Install\Folder\BepInEx`). If
all the prerequisites are met, compiling a mod is simple.

Additionally you may want to change the path to the roslyn compiler
(look for csc.exe), although auto detected path may just work fine.

```bat
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn
```

### Compiling a HarmonyX runtime patcher mod

Harmony mods are the easiest code mods one can do. Check the
relevant sources, e.g. [BepInEx runtime patching docs][1]. I
recommend to create a small batch file within your mod repo:

```bat
call MC-CS2 MyModName.dll Harmony\*.cs ^
  /reference:"%PATH_CS2_MANAGED%\Game.dll" && ^
echo Successfully compiled MyModName.dll
```

You can pass multiple input files and wildcards as arguments.
The additional reference is needed in order to choose against
which Game.dll you want to compile it. This becomes important
once you start to use BepInEx Game.dll preload-patching.

Note that you still need to write a BepInEx plugin in order
to apply the Harmony patches on runtime (in MyPlugin.Awake).

[1]: https://docs.bepinex.dev/master/articles/dev_guide/runtime_patching.html

### Advanced BepInEx Game.dll preload-patching

With BepInEx you can use preload patcher plugins, which will alter
the targeted dll before it is even loaded and used. This allows to
do a lot more than simple harmony patchers, as you can e.g. change
access permissions to classes and methods. Note: It needs to be
checked if IL transpiler patching of methods with [BurstCompile]
attribute will work as one could expect (fingers crossed).

### Create a patched dll to link you mods against

When you alter access permissions for certain classes or methods,
you want some way to see this changes directly in your IDE, so you
can actually use and write the code as if the changes where there.

To achieve this, the repo contains the `AP-CS2.exe`, which will
load the Game.dll and then apply all preload patchers it can find.
Finally it will write the resulting game.patched.dll to disk. You
can now reference that dll instead in your development and when
compiling the mod for release.

## Some dev insights into how BepInEx works

We use [BepInEx][1] to patch the main game assembly `Game.dll` before
it is actually loaded by the Unity Game Engine. In order to do this,
BepInEx uses [Unity Doorstop][2]. It uses a trick as at least one Unity
dependency or library tries to load `winhttp.dll`. This file is normally
not there (which is silently ignored), but once we put one in place, it
is loaded and initialized before the actual game dlls are loaded. At this
stage BepInEx will apply all preloader patchers from the Mods directory.
This happens all in memory, before Unity actually loads the game dll.
Unity then loads the in-memory changed versions of the game dll.

### Execution order

- On windows we hook via winhttp.dll
- On Linux we need define a few LD settings
- The Game starts and loads the hooked library
- This `doorstep` now loads the `BepInEx` preloader
- The preloader is configured to load `MultiFolderLoader` patcher
- The `MultiFolderLoader` scan all directories under `baseDir`
  See `doorstop_config.ini` for `[MultiFolderLoader]` section
- For each found dll the patch methods are called and applied
- Game starts with all applied in-memory dll patches

### Additional Strategy for Developers/Modders

Once you add a new field to a class, you probably also want to use it.
The true dynamic approach would be to utilize a runtime FieldDefinition:

```csharp
FieldInfo field = AccessTools.Field(typeof(BaseClass), "CurrentSpoilage");
Klass currentSpoilage = (Klass) field.GetValue(__instance); // needs cast
field.SetValue(__instance, currentSpoilage);
```

This is a bit tedious and doesn't help with readability. So it is
recommended you just use the approach above and reference and compile
against a patched Game.dll directly.

### Assembly Patcher Command-Line Utility

I create a very basic cli-utility to load the `Game.dll` file, apply a
given list of `patchers` and write the result to disk. You can then use
that patched assembly as reference to compile your code. You don't need
to deploy this patched dll, it's only needed to compile your mod.

```bat
AP-CS2 [CS2\Cities2_Data\Managed] [Output] [PatcherDLL1]...
AP-CS2 "%PATH_CS2_MANAGED%" "build\Game.dll" "patchers\MyModPatch.dll"
```

### Additional batch utilities

In order to streamline the whole compilation, I created two additional
batch files that help with compiling the preloader patchers and the
final (harmony) module dll. Finally there is a wrapper script that
executes all necessary steps to compile your mod (similar to DMT).

- CM-CS2.bat is the main compiler utility (for preload patching)
- Calls PC-CS2.bat to compile BepInEx preloader patcher dll
- Calls AP-CS2.exe to create a patched assembly-csharp dll
- Calls MC-CS2.bat to compile mod against patched assembly

```batch
CM-CS2 [NAME] [SOURCES] [PATCHERS]
CM-CS2 MyModName Harmony\*.cs patchers\*.cs
```

Note that you can only pass one argument for sources and patchers, but that
argument can be one wildcard. Better argument passing might come in the future.
It should work ok if you stick each type into its own folder. Patcher dlls
must be placed in the `patchers` folder in order for BepInEx to find them.
