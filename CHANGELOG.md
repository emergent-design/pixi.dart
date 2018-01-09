v4.6.2-0 (2018-01-09)

* Complete refactor as a JS interop wrapper for pixijs.
* Versioning is now based on the underlying pixijs version.
* Official build of minified pixijs is provided as part of the package.

v0.1.3 (2014-09-13)

* Switched from package js to dart:js for the examples.
* Removed the unittest dependency for now.
* Added a clearEvents method to interactive objects.
* Fixed an issue with colour referencing in the Graphics display object.

v0.1.2 (2014-07-14)

* Fixed an issue with interaction states getting missed.


v0.1.1 (2014-07-14)

* Added the missing onClick implementation.


v0.1.0 (2014-07-11)

Initial release of the interaction implementation:

* It works for mouse and touch events (and should even support multi-touch).
* The appropriate examples have been ported from pixi.js.
* Sprites will have an automatic hit area unless explicitly assigned one.
* Non-sprites should assign a hit area if required.
* A few basic hit shapes are provided (rectangle, circle and polygon).


v0.0.5 (2014-02-05)

* Fix around issues that occur only when compiled to javascript.
* Initial interaction manager design.
* Some renaming to avoid clashes with existing Dart classes.


v0.0.4 (2013-11-14)

This is a merge of the simple-render branch into the master and includes the following changes:

* Switched to a simpler rendering method by walking the scenegraph instead of maintaining a linked list.
* Removed the linked list sprite batching and implemented a simple batcher with fixed-size buffers.
* Extended the simple batcher with an optional one that supports multiple textures.
* TilingSprite is now derived from Sprite and can be rendered by the batching system so the TilingSprite specific renderer and shader have been deprecated.
* All GL related resources are now owned and maintained by the GL renderer which will make it possible to use them with multiple renderers and will ease the development of context loss management.
* The shaders have been pulled out into separate classes which are derived from a base shader class.
