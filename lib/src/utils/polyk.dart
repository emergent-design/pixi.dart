/*
	PolyK library
	url: http://polyk.ivank.net
	Released under MIT licence.

	Copyright (c) 2012 Ivan Kuckir

	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.

	This is an amazing lib!

	slightly modified by mat groves (matgroves.com);
	ported to Dart by Dan Parnham
*/

part of pixi;


class _PolyK
{
	static List<int> triangulate(List<num> p)
	{
		bool earFound;
		int i, j, al, i0, i1, i2;
		num ax, ay, bx, by, cx, cy;
		List<int> result	= [];
		bool sign			= true;
		int n 				= p.length>>1;

		if (n<3) return [];

		List<int> avl = [];
		for(i=0; i<n; i++) avl.add(i);

		i	= 0;
		al	= n;

		while (al > 3)
		{
			i0 = avl[(i+0)%al];
			i1 = avl[(i+1)%al];
			i2 = avl[(i+2)%al];

			ax = p[2*i0];  ay = p[2*i0+1];
			bx = p[2*i1];  by = p[2*i1+1];
			cx = p[2*i2];  cy = p[2*i2+1];

			earFound = false;
			if (_convex(ax, ay, bx, by, cx, cy, sign))
			{
				earFound = true;
				for(j=0; j<al; j++)
				{
					var vi = avl[j];
					if (vi==i0 || vi==i1 || vi==i2) continue;
					if (_pointInTriangle(p[2*vi], p[2*vi+1], ax, ay, bx, by, cx, cy))
					{
						earFound = false;
						break;
					}
				}
			}

			if (earFound)
			{
				result.addAll([ i0, i1, i2 ]);
				avl.removeAt((i+1)%al);
				al--;
				i = 0;
			}
			else if (i++ > 3 * al)
			{
				// need to flip flip reverse it!
				// reset!
				if (sign)
				{
					result	= [];
					avl		= [];
					for(i=0; i<n; i++) avl.add(i);

					i		= 0;
					al		= n;
					sign	= false;
				}
				else
				{
					print("Warning: shape too complex to fill");
					return [];
				}
			}
		}

		result.addAll( [ avl[0], avl[1], avl[2] ]);

		return result;
	}


	static bool _pointInTriangle(num px, num py, num ax, num ay, num bx, num by, num cx, num cy)
	{
		num v0x = cx-ax;
		num v0y = cy-ay;
		num v1x = bx-ax;
		num v1y = by-ay;
		num v2x = px-ax;
		num v2y = py-ay;

		num dot00 = v0x*v0x+v0y*v0y;
		num dot01 = v0x*v1x+v0y*v1y;
		num dot02 = v0x*v2x+v0y*v2y;
		num dot11 = v1x*v1x+v1y*v1y;
		num dot12 = v1x*v2x+v1y*v2y;

		num invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
		num u = (dot11 * dot02 - dot01 * dot12) * invDenom;
		num v = (dot00 * dot12 - dot01 * dot02) * invDenom;

		// Check if point is in triangle
		return (u >= 0) && (v >= 0) && (u + v < 1);
	}

	static bool _convex(num ax, num ay, num bx, num by, num cx, num cy, bool sign)
	{
		return ((ay-by)*(cx-bx) + (bx-ax)*(cy-by) >= 0) == sign;
	}

}

