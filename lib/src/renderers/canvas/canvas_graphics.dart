part of pixi;


class _CanvasGraphics
{

	static void renderGraphics(Graphics graphics, CanvasRenderingContext2D context)
	{
		var alpha = graphics.worldAlpha;

		for (_Path p in graphics._data)
		{
			context.strokeStyle = p.lineColor.html;
			context.lineWidth	= p.lineWidth;

			if (p.type == _Path.RECTANGLE)
			{
				renderRectangle(alpha, p, context);
			}
			else
			{
				switch (p.type)
				{
					case _Path.POLY:		renderPoly(p, context);				break;
					case _Path.CIRCLE:		renderCircle(p, context);			break;
					case _Path.ELLIPSE:		renderEllipse(p, context);			break;
				}

				if (p.filling)
				{
					context.globalAlpha = p.fillAlpha * alpha;
					context.fillStyle	= p.fillColor.html;
					context.fill();
				}

				if (p.lineWidth > 0)
				{
					context.globalAlpha = p.lineAlpha * alpha;
					context.stroke();
				}
			}
		}
	}


	static void renderPoly(_Path p, CanvasRenderingContext2D context)
	{
		var points	= p.points;
		var size	= points.length;
		context.beginPath();
		context.moveTo(points[0], points[1]);

		for (int i=2; i<size; i+=2)
		{
			context.lineTo(points[i], points[i+1]);
		}

		if (points[0] == points[size - 2] && points[1] == points[size-1])
		{
			context.closePath();
		}
	}


	static void renderRectangle(double alpha, _Path p, CanvasRenderingContext2D context)
	{
		if (p.filling)
		{
			context.globalAlpha = p.fillAlpha * alpha;
			context.fillStyle	= p.fillColor.html;
			context.fillRect(p.points[0], p.points[1], p.points[2], p.points[3]);
		}

		if (p.lineWidth > 0)
		{
			context.globalAlpha = p.lineAlpha * alpha;
			context.strokeRect(p.points[0], p.points[1], p.points[2], p.points[3]);
		}
	}


	static void renderCircle(_Path p, CanvasRenderingContext2D context)
	{
		context.beginPath();
		context.arc(p.points[0], p.points[1], p.points[2], 0, 2 * PI);
		context.closePath();
	}


	static void renderEllipse(_Path p, CanvasRenderingContext2D context)
	{
		var w = p.points[2] * 2;
		var h = p.points[3] * 2;
		var x = p.points[0] - w / 2;
		var y = p.points[1] - w / 2;

		context.beginPath();

		var kappa	= .5522848,
			ox		= (w / 2) * kappa, // control point offset horizontal
			oy		= (h / 2) * kappa, // control point offset vertical
			xe		= x + w,           // x-end
			ye		= y + h,           // y-end
			xm		= x + w / 2,       // x-middle
			ym		= y + h / 2;       // y-middle

		context.moveTo(x, ym);
		context.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
		context.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
		context.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
		context.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
		context.closePath();
	}
}
