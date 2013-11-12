part of pixi;


class Colour
{
	final int r;
	final int g;
	final int b;

	int get integer	=> (r & 0xff) << 16 | (g & 0xff) << 8 | (b & 0xff);
	String get html	=> '#${_hex(r)}${_hex(g)}${_hex(b)}';
	String get rgb	=> 'rgb($r, $g, $b)';
	String rgba(double alpha) => 'rgba($r, $g, $b, $alpha)';


	const Colour(this.r, this.g, this.b);


	factory Colour.fromInt(int colour)
	{
		return new Colour(colour >> 16 & 0xff, colour >> 8 & 0xff, colour & 0xff);
	}


	factory Colour.fromHtml(String colour)
	{
		colour = colour.trim();
		int r = 0, g = 0, b = 0;

		if (colour.startsWith('#'))
		{
			if (colour.length == 4)
			{
				r = int.parse(colour[1] + colour[1], radix: 16);
				g = int.parse(colour[2] + colour[2], radix: 16);
				b = int.parse(colour[3] + colour[3], radix: 16);
			}
			else if (colour.length == 7)
			{
				r = int.parse(colour.substring(1, 3), radix: 16);
				g = int.parse(colour.substring(3, 5), radix: 16);
				b = int.parse(colour.substring(5, 7), radix: 16);
			}
		}
		else if (colour.startsWith('rgb'))
		{
			var m = new RegExp(r'rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)').firstMatch(colour);

			if (m != null)
			{
				r = int.parse(m.group(1), radix: 10);
				g = int.parse(m.group(2), radix: 10);
				b = int.parse(m.group(3), radix: 10);
			}
		}

		return new Colour(r, g, b);
	}


	// Produces a padded hex value
	String _hex(int value)
	{
		var h = (value & 0xff).toRadixString(16);
		return h.length == 1 ? '0$h' : h;
	}
}