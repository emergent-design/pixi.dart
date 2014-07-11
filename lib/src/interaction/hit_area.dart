part of pixi;


abstract class HitArea
{
	bool contains(num x, num y);
}


class HitRectangle implements HitArea
{
	num x;
	num y;
	num width;
	num height;

	HitRectangle(this.x, this.y, this.width, this.height);

	bool contains(num x, num y)
	{
		return this.width > 0 && this.height > 0 && x >= this.x && x < (this.x + this.width) && y >= this.y && y < (this.y + this.height);
	}
}


class HitCircle implements HitArea
{
	num x;
	num y;
	num radius;

	HitCircle(this.x, this.y, this.radius);

	bool contains(num x, num y)
	{
		return this.radius > 0 && ((this.x - x) * (this.x - x) + (this.y - y) * (this.y - y)) < this.radius * this.radius;
	}
}


class HitPolygon implements HitArea
{
	List<Point> points;

	HitPolygon(this.points);

	bool contains(num x, num y)
	{
		bool inside = false;

		for (var i=0, j=this.points.length - 1; i < this.points.length; j=i++)
		{
			var xi = this.points[i].x, yi = this.points[i].y;
			var xj = this.points[j].x, yj = this.points[j].y;

			if (((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi))
			{
				inside = !inside;
			}
		}

		return inside;
	}
}

