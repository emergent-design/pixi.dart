part of pixi;


class _WebGL
{
	List<double> points	= [];
	List<int> indices	= [];
	int lastIndex		= 0;
	GL.Buffer buffer;
	GL.Buffer indexBuffer;
	//Float32List glPoints;
	//Uint16List glIndices;

	_WebGL(GL.RenderingContext gl)
	{
		this.buffer			= gl.createBuffer();
		this.indexBuffer	= gl.createBuffer();
	}
}


class WebGLGraphics
{
	static void renderGraphics(GL.RenderingContext gl, Graphics graphics, Point projection, Point offset)
	{
		if (graphics.__webgl == null) graphics.__webgl = new _WebGL(gl);

		if (graphics.dirty)
		{
			graphics.dirty = false;

			if (graphics._clearDirty)
			{
				graphics._clearDirty		= false;
				graphics.__webgl.lastIndex	= 0;
				graphics.__webgl.points		= [];
				graphics.__webgl.indices	= [];
			}

			updateGraphics(gl, graphics);
		}

		WebGLShaders.activatePrimitiveShader(gl);

		var m = graphics.worldTransform.clone().transpose();

		gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);

		gl.uniformMatrix3fv(WebGLShaders.primitiveProgram.translationMatrix, false, m._source);

		gl.uniform2f(WebGLShaders.primitiveProgram.projectionVector, projection.x, -projection.y);
		gl.uniform2f(WebGLShaders.primitiveProgram.offset, -offset.x, -offset.y);
		gl.uniform1f(WebGLShaders.primitiveProgram.alpha, graphics.worldAlpha);

		gl.bindBuffer(GL.ARRAY_BUFFER, graphics.__webgl.buffer);

		gl.vertexAttribPointer(WebGLShaders.primitiveProgram.vertexPosition, 2, GL.FLOAT, false, 4 * 6, 0);
		gl.vertexAttribPointer(WebGLShaders.primitiveProgram.colour, 4, GL.FLOAT, false, 4 * 6, 2 * 4);

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, graphics.__webgl.indexBuffer);

		gl.drawElements(GL.TRIANGLE_STRIP, graphics.__webgl.indices.length, GL.UNSIGNED_SHORT, 0);

		WebGLShaders.deactivatePrimitiveShader(gl);
	}


	static void updateGraphics(GL.RenderingContext gl, Graphics graphics)
	{
		for (int i = graphics.__webgl.lastIndex; i < graphics._data.length; i++)
		{
			var data = graphics._data[i];

			if (data.type == _Path.POLY)
			{
				if (data.filling)
				{
					if (data.points.length > 3) buildPoly(data, graphics.__webgl);
				}

				if (data.lineWidth > 0) buildLine(data, graphics.__webgl);
			}
			else if (data.type == _Path.RECTANGLE)
			{
				buildRectangle(data, graphics.__webgl);
			}
			else if (data.type == _Path.CIRCLE || data.type == _Path.ELLIPSE)
			{
				buildCircle(data, graphics.__webgl);
			}
		}

		graphics.__webgl.lastIndex	= graphics._data.length;

		gl.bindBuffer(GL.ARRAY_BUFFER, graphics.__webgl.buffer);
		gl.bufferData(GL.ARRAY_BUFFER, new Float32List.fromList(graphics.__webgl.points), GL.STATIC_DRAW);

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, graphics.__webgl.indexBuffer);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(graphics.__webgl.indices), GL.STATIC_DRAW);
	}


	static void buildPoly(_Path data, _WebGL dst)
	{
		if (data.points.length < 6) return;

		int i;
		var points		= data.points;
		var vertices	= dst.points;
		var indices		= dst.indices;
		var length		= points.length; // / 2;
		var colour		= data.fillColor;
		var alpha		= data.fillAlpha;
		var r			= alpha * colour.r / 255.0;
		var g			= alpha * colour.g / 255.0;
		var b			= alpha * colour.b / 255.0;
		int pos 		= vertices.length ~/ 6;
		var tri			= _PolyK.triangulate(points);

		for (i=0; i<tri.length; i+=3)
		{
			indices.addAll([ tri[i] + pos, tri[i] + pos, tri[i+1] + pos, tri[i+2] + pos, tri[i+2] + pos ]);
		}

		for (i=0; i<length; i+=2)
		{
			vertices.addAll([ points[i].toDouble(), points[i+1].toDouble(), r, g, b, alpha ]);
		}
	}


	static void buildLine(_Path data, _WebGL dst)
	{
		bool wrap	= true;
		var points	= data.points;
		int length	= points.length;

		if (length == 0) return;

		var first	= new Point(points[0], points[1]);
		var last	= new Point(points[length - 2], points[length - 1]);

		if (first.x == last.x && first.y == last.y)
		{
			last = new Point(points[length - 4], points[length - 3]);

			num midX = last.x + (first.x - last.x) * 0.5;
			num midY = last.y + (first.y - last.y) * 0.5;

			points[length - 2] = midX;
			points[length - 1] = midY;
			points.insertAll(0, [ midX, midY ]);
		}

		length			= points.length ~/ 2;
		var vertices	= dst.points;
		var indices		= dst.indices;
		int indexCount	= points.length;
		int indexStart	= vertices.length ~/ 6;

		var width 	= data.lineWidth / 2;
		var colour	= data.lineColor;
		var alpha	= data.lineAlpha;
		var r		= alpha * colour.r / 255.0;
		var g		= alpha * colour.g / 255.0;
		var b		= alpha * colour.b / 255.0;

		int i;
		double px, py, p1x, p1y, p2x, p2y, p3x, p3y;
		double perpx, perpy, perp2x, perp2y, perp3x, perp3y;
		//num ipx, ipy;
		double a1, b1, c1, a2, b2, c2;
		double denom, pdist, dist;

		p1x		= points[0].toDouble();
		p1y		= points[1].toDouble();
		p2x		= points[2].toDouble();
		p2y		= points[3].toDouble();
		perpx	= -(p1y - p2y);
		perpy	=  p1x - p2x;
		dist	= sqrt(perpx*perpx + perpy*perpy);

		perpx /= dist;
		perpy /= dist;
		perpx *= width;
		perpy *= width;

		// start
		vertices.addAll([
			p1x - perpx, p1y - perpy, r, g, b, alpha,
			p1x + perpx, p1y + perpy, r, g, b, alpha
		]);

		for (i = 1; i < length-1; i++)
		{
			p1x = points[(i-1)*2].toDouble();
			p1y = points[(i-1)*2 + 1].toDouble();

			p2x = points[(i)*2].toDouble();
			p2y = points[(i)*2 + 1].toDouble();

			p3x = points[(i+1)*2].toDouble();
			p3y = points[(i+1)*2 + 1].toDouble();

			perpx = -(p1y - p2y);
			perpy = p1x - p2x;

			dist = sqrt(perpx*perpx + perpy*perpy);
			perpx /= dist;
			perpy /= dist;
			perpx *= width;
			perpy *= width;

			perp2x = -(p2y - p3y);
			perp2y = p2x - p3x;

			dist = sqrt(perp2x*perp2x + perp2y*perp2y);
			perp2x /= dist;
			perp2y /= dist;
			perp2x *= width;
			perp2y *= width;

			a1 = (-perpy + p1y) - (-perpy + p2y);
		    b1 = (-perpx + p2x) - (-perpx + p1x);
		    c1 = (-perpx + p1x) * (-perpy + p2y) - (-perpx + p2x) * (-perpy + p1y);
		    a2 = (-perp2y + p3y) - (-perp2y + p2y);
		    b2 = (-perp2x + p2x) - (-perp2x + p3x);
		    c2 = (-perp2x + p3x) * (-perp2y + p2y) - (-perp2x + p2x) * (-perp2y + p3y);

		    denom = a1*b2 - a2*b1;

		    if (denom == 0) {
		    	denom+=1;
		    }

		    px = (b1*c2 - b2*c1)/denom;
		    py = (a2*c1 - a1*c2)/denom;

			pdist = (px -p2x) * (px -p2x) + (py -p2y) + (py -p2y);

			if (pdist > 140 * 140)
			{
				perp3x = perpx - perp2x;
				perp3y = perpy - perp2y;

				dist = sqrt(perp3x*perp3x + perp3y*perp3y);
				perp3x /= dist;
				perp3y /= dist;
				perp3x *= width;
				perp3y *= width;

				vertices.addAll([
					p2x - perp3x, p2y -perp3y, r, g, b, alpha,
					p2x + perp3x, p2y +perp3y, r, g, b, alpha,
					p2x - perp3x, p2y -perp3y, r, g, b, alpha
				]);

				indexCount++;
			}
			else
			{
				vertices.addAll([
					px, py, r, g, b, alpha,
					p2x - (px-p2x), p2y - (py - p2y), r, g, b, alpha
				]);
			}
		}

		p1x = points[(length-2)*2].toDouble();
		p1y = points[(length-2)*2 + 1].toDouble();

		p2x = points[(length-1)*2].toDouble();
		p2y = points[(length-1)*2 + 1].toDouble();

		perpx = -(p1y - p2y);
		perpy = p1x - p2x;

		dist = sqrt(perpx*perpx + perpy*perpy);
		perpx /= dist;
		perpy /= dist;
		perpx *= width;
		perpy *= width;

		vertices.addAll([
			p2x - perpx , p2y - perpy, r, g, b, alpha,
			p2x + perpx , p2y + perpy, r, g, b, alpha
		]);

		indices.add(indexStart);

		for (i=0; i < indexCount; i++)
		{
			indices.add(indexStart++);
		};

		indices.add(indexStart-1);
	}


	static void buildRectangle(_Path data, _WebGL dst)
	{
		double x 		= data.points[0].toDouble();
		double y 		= data.points[1].toDouble();
		double width	= data.points[2].toDouble();
		double height	= data.points[3].toDouble();

		if (data.filling)
		{
			var colour	= data.fillColor;
			var alpha	= data.fillAlpha;
			var r		= alpha * colour.r / 255.0;
			var g		= alpha * colour.g / 255.0;
			var b		= alpha * colour.b / 255.0;

			var vertices	= dst.points;
			var indices		= dst.indices;
			int pos			= vertices.length ~/ 6;

			vertices.addAll([
				x,			y,			r, g, b, alpha,
				x + width,	y,			r, g, b, alpha,
				x,			y + height,	r, g, b, alpha,
				x + width,	y + height,	r, g, b, alpha,
			]);

			// insert 2 dead triangles..
			indices.addAll([ pos, pos, pos + 1, pos + 2, pos + 3, pos + 3 ]);
		}

		if (data.lineWidth > 0)
		{
			data.points = [
				x, y,
				x + width, y,
				x + width, y + height,
				x, y + height,
				x, y
			];

			buildLine(data, dst);
		}
	}


	static const SEGMENTS	= 40;
	static const SEGMENT	= (PI * 2) / SEGMENTS;

	static void buildCircle(_Path data, _WebGL dst)
	{
		int i;
		double x	= data.points[0].toDouble();
		double y	= data.points[1].toDouble();
		double rx	= data.points[2].toDouble();
		double ry	= data.type == _Path.CIRCLE ? rx : data.points[3].toDouble();

		if (data.filling)
		{
			var colour	= data.fillColor;
			var alpha	= data.fillAlpha;
			var r		= alpha * colour.r / 255.0;
			var g		= alpha * colour.g / 255.0;
			var b		= alpha * colour.b / 255.0;

			var vertices	= dst.points;
			var indices		= dst.indices;
			int pos			= vertices.length ~/ 6;

			indices.add(pos);

			for (i=0; i<SEGMENTS + 1; i++)
			{
				vertices.addAll([
					x, y, r, g, b, alpha,
					x + sin(SEGMENT * i) * rx, y + cos(SEGMENT * i) * ry, r, g, b, alpha
				]);

				indices.addAll([ pos++, pos++ ]);
			}

			indices.add(pos-1);
		}

		if (data.lineWidth > 0)
		{
			data.points = [];

			for (i=0; i<SEGMENTS + 1; i++)
			{
				data.points.addAll([
					x + sin(SEGMENT * i) * rx,
					y + cos(SEGMENT * i) * ry
				]);
			}

			buildLine(data, dst);
		}
	}
}



