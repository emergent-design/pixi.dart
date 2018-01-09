library pixi.examples;

import 'dart:html' hide Point, Rectangle, Text;
import 'dart:math' hide Point, Rectangle;
import 'package:pixi/pixi.dart';
import 'package:js/js.dart';
import 'webfont.dart' as WebFont;

part 'common/dude.dart';

part 'basics/basics.dart';
part 'basics/container.dart';
part 'basics/spritesheet.dart';
part 'basics/click.dart';
part 'basics/tiling-sprite.dart';
part 'basics/text.dart';
part 'basics/graphics.dart';
part 'basics/video.dart';
part 'basics/render-texture.dart';
part 'basics/textured-mesh.dart';
part 'basics/custom-filter.dart';

part 'demos/animated-sprite.dart';
part 'demos/interactivity.dart';
part 'demos/dragging.dart';
part 'demos/text.dart';
part 'demos/render-texture.dart';
part 'demos/graphics.dart';
part 'demos/masking.dart';
part 'demos/mask-render-texture.dart';
part 'demos/blend-modes.dart';
part 'demos/tinting.dart';
part 'demos/particle-container.dart';
part 'demos/cache-as-bitmap.dart';
part 'demos/strip.dart';
part 'demos/texture-swap.dart';
part 'demos/texture-rotate.dart';
part 'demos/alpha-mask.dart';

part 'filters/filter.dart';
part 'filters/blur.dart';
part 'filters/displacement.dart';

// part 'picture/overlay.dart';


abstract class Example
{
	final Random random = new Random();

	void run(CanvasElement canvas);
}


class Examples
{
	static Map<String, Map<String, String>> groups = {
		'BASICS': {
			'basics':				'Basics',
			'container':			'Container',
			'container-pivot':		'Container Pivot',
			'spritesheet':			'SpriteSheet Animation',
			'click':				'Click',
			'tiling-sprite':		'Tiling Sprite',
			'text':					'Text',
			'graphics':				'Graphics',
			'video':				'Video',
			'render-texture':		'Render Texture',
			'textured-mesh':		'Textured Mesh',
			'custom-filter':		'Custom Filter'
		},

		'DEMOS': {
			'animated-sprite':		'AnimatedSprite',
			'interactivity': 		'Interactivity',
			'transparent':			'Transparent Background',
			'dragging':				'Dragging',
			'text-demo':			'Text',
			'render-texture-demo':	'RenderTexture',
			'graphics-demo':		'Graphics',
			'masking-demo':			'Masking',
			'mask-render-demo':		'Mask + RenderTexture',
			'blend-modes':			'BlendModes',
			'tinting':				'Tinting',
			'particle-container':	'Particle Container',
			'cache-as-bitmap':		'CacheAsBitmap',
			'strip':				'Strip',
			'texture-swap':			'Texture Swap',
			'texture-rotate':		'Texture Rotate',
			'alpha-mask':			'Alpha Mask'
		},

		'FILTERS': {
			'filter':				'Filter',
			'blur-filter':			'Blur',
			'displacement-filter':	'Displacement Map'
		},

		// 'PICTURE': {
		// 	'overlay-blend':		'Overlay BlendMode'
		// }
	};


	static String title(Map parameters)
	{
		return groups.containsKey(parameters['group'])
			? groups[parameters['group']][parameters['example']]
			: "Unknown";
	}


	static Example create(String name)
	{
		switch (name)
		{
			case 'basics':				return new BasicsExample();
			case 'container':			return new ContainerExample();
			case 'container-pivot':		return new ContainerExample(true);
			case 'spritesheet':			return new SpriteSheetExample();
			case 'click':				return new ClickExample();
			case 'tiling-sprite':		return new TilingSpriteExample();
			case 'text':				return new TextExample();
			case 'graphics':			return new GraphicsExample();
			case 'video':				return new VideoExample();
			case 'render-texture':		return new RenderTextureExample();
			case 'textured-mesh':		return new TexturedMeshExample();
			case 'custom-filter':		return new CustomFilterExample();

			case 'animated-sprite':		return new AnimatedSpriteDemo();
			case 'interactivity':		return new InteractivityDemo();
			case 'transparent':			return new BasicsExample(true);
			case 'dragging':			return new DraggingDemo();
			case 'text-demo':			return new TextDemo();
			case 'render-texture-demo':	return new RenderTextureDemo();
			case 'graphics-demo':		return new GraphicsDemo();
			case 'masking-demo':		return new MaskingDemo();
			case 'mask-render-demo':	return new MaskingRenderTextureDemo();
			case 'blend-modes':			return new BlendModesDemo();
			case 'tinting':				return new TintingDemo();
			case 'particle-container':	return new ParticleContainerDemo();
			case 'cache-as-bitmap':		return new CacheAsBitmapDemo();
			case 'strip':				return new StripDemo();
			case 'texture-swap':		return new TextureSwapDemo();
			case 'texture-rotate':		return new TextureRotateDemo();
			case 'alpha-mask':			return new AlphaMaskDemo();

			case 'filter':				return new FilterDemo();
			case 'blur-filter':			return new BlurFilterDemo();
			case 'displacement-filter':	return new DisplacementFilterDemo();

			// case 'overlay-blend':		return new OverlayBlendModeDemo();

			default:					return new BasicsExample();
		}
	}
}
