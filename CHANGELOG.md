# v0.0.4 (2013-11-14)

This is a merge of the simple-render branch into the master and includes the following changes:

* Switched to a simpler rendering method by walking the scenegraph instead of maintaining a linked list.
* Removed the linked list sprite batching and implemented a simple batcher with fixed-size buffers.
* Extended the simple batcher with an optional one that supports multiple textures.
* TilingSprite is now derived from Sprite and can be rendered by the batching system so the TilingSprite specific renderer and shader has been deprecated.
* All GL related resources are now owned and maintained by the GL renderer which will make it possible to use them with multiple renderers and will ease the development of context loss management.
* The shaders have been pulled out into separate classes which are derived from a base shader class.
