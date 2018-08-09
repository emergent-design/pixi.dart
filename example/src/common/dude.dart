part of pixi.examples;


// Holds metadata for Sprite objects
class Dude
{
	double direction;
	double turningSpeed;
	double speed;
	double offset;

	Dude({ this.direction, this.turningSpeed, this.speed, this.offset });

	// Helper function to update a sprite based on the metadata
	static void move(Sprite dude, Rectangle bounds, { double scale(num offset) : null, double rotationOffset: -pi / 2 })
	{
		var meta = dude.userdata as Dude;
		meta.direction += meta.turningSpeed * 0.01;
		dude.rotation = -meta.direction + rotationOffset;

		if (scale != null)
		{
			var factor = scale(meta.offset);
			dude.x += sin(meta.direction) * meta.speed * factor;
			dude.y += cos(meta.direction) * meta.speed * factor;
		}
		else
		{
			dude.x += sin(meta.direction) * meta.speed;
			dude.y += cos(meta.direction) * meta.speed;
		}

		if (dude.x < bounds.x)
		{
			dude.x += bounds.width;
		}
		else if (dude.x > bounds.x + bounds.width)
		{
			dude.x -= bounds.width;
		}
		if (dude.y < bounds.y)
		{
			dude.y += bounds.height;
		}
		else if (dude.y > bounds.y + bounds.height)
		{
			dude.y -= bounds.height;
		}
	}
}
