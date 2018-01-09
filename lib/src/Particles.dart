@JS('PIXI.particles')
library pixi.particles;

import 'package:js/js.dart';
import 'Core.dart';

@JS()
@anonymous
class ParticleProperties
{
	external factory ParticleProperties({
		bool scale,
		bool vertices,
		bool position,
		bool rotation,
		bool uvs,
		bool tint,
		bool alpha
	});
}

@JS()
class ParticleContainer extends Container
{
	external ParticleContainer([num maxSize, ParticleProperties properties, num batchSize, bool autoResize]);

	external num get tint;
	external set tint(num value);
}
