part of pixi;


// A container for sprites because they are already
// linked list entry items that belong to a container
// owned flattened graph.
class _SpriteLink extends PixiListEntry
{
	Sprite src;

	_SpriteLink(this.src)
	{
		this.src.__link = this;
	}
}


class WebGLBatch extends DisplayObject
{
	static List<WebGLBatch> _batches = [];

	GL.RenderingContext _gl;

	int _dynamicSize				= 1;
	int _blendMode					= Sprite.NORMAL;
	GL.Buffer _vertexBuffer			= null;
	GL.Buffer _indexBuffer			= null;
	GL.Buffer _uvBuffer				= null;
	GL.Buffer _colourBuffer			= null;
	BaseTexture _texture			= null;
	PixiList<_SpriteLink> _sprites	= new PixiList<_SpriteLink>();

	Float32List _vertices		= null;
	Float32List _uvs			= null;
	Float32List _colours		= null;
	Uint16List _indices			= null;
	bool _dirtyUVs				= false;
	bool _dirtyColours			= false;

	int get size => this._sprites.length;


	WebGLBatch(GL.RenderingContext gl)
	{
		this._setContext(gl);
	}


	void addBefore(_SpriteLink sprite, _SpriteLink next)
	{
		sprite.src.__batch	= this;
		this._dirty			= true;

		next.insertBefore(sprite);
	}


	void addAfter(_SpriteLink sprite, _SpriteLink previous)
	{
		sprite.src.__batch	= this;
		this._dirty			= true;

		previous.insertAfter(sprite);
	}


	void remove(_SpriteLink sprite)
	{
		sprite.src.__batch	= null;
		this._dirty			= true;

		sprite.unlink();
	}


	WebGLBatch split(_SpriteLink sprite)
	{
		var result = new WebGLBatch(this._gl);
		this._dirty = true;

		result._blendMode 	= this._blendMode;
		result._texture		= this._texture;
		result._sprites		= this._sprites.split(sprite);

		for (var s in result._sprites) s.src.batch = result;

		return result;
	}


	void merge(WebGLBatch batch)
	{
		this._dirty = true;

		this._sprites.merge(batch._sprites);

		for (var s in this._sprites) s.src.__batch = this;
	}


	void init(_SpriteLink sprite)
	{
		sprite.src.__batch	= this;
		this._dirty			= true;
		//this._size		= 1;
		this._blendMode		= sprite.src.blendMode;
		this._texture		= sprite.src.texture._base;
		this._sprites.clear();
		this._sprites.add(sprite);

		this._growBatch(this._gl);
	}


	void _growBatch(GL.RenderingContext gl)
	{
		this._dynamicSize	= this.size == 1 ? 1 : (this.size * 1.5).toInt();
		this._vertices		= new Float32List(this._dynamicSize * 8);
		this._uvs			= new Float32List(this._dynamicSize * 8);
		this._colours		= new Float32List(this._dynamicSize * 4);
		this._indices		= new Uint16List(this._dynamicSize * 6);
		this._dirtyUVs		= true;
		this._dirtyColours	= true;

		gl.bindBuffer(GL.ARRAY_BUFFER, this._vertexBuffer);
		gl.bufferData(GL.ARRAY_BUFFER, this._vertices, GL.DYNAMIC_DRAW);

		gl.bindBuffer(GL.ARRAY_BUFFER, this._uvBuffer);
		gl.bufferData(GL.ARRAY_BUFFER, this._uvs, GL.DYNAMIC_DRAW);

		gl.bindBuffer(GL.ARRAY_BUFFER, this._colourBuffer);
		gl.bufferData(GL.ARRAY_BUFFER, this._colours, GL.DYNAMIC_DRAW);

		int i, j, k;
		int length = this._dynamicSize;

		for (i=j=k=0; i<length; i++, j+=6, k+=4)
		{
			this._indices[j + 0] = k + 0;
			this._indices[j + 1] = k + 1;
			this._indices[j + 2] = k + 2;
			this._indices[j + 3] = k + 0;
			this._indices[j + 4] = k + 2;
			this._indices[j + 5] = k + 3;
		}

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this._indexBuffer);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, this._indices, GL.STATIC_DRAW);
	}


	void _refresh(GL.RenderingContext gl)
	{
		if (this._dynamicSize < this.size) this._growBatch(gl);

		int index	= 0;
		int colour	= 0;
		int width, height;
		Rectangle frame;

		for (var sprite in this._sprites)
		{
			frame	= sprite.src.texture.frame;
			width	= sprite.src.texture._base.width;
			height	= sprite.src.texture._base.height;

			if (frame != null)
			{
				_uvs[index + 0] = _uvs[index + 6] = frame.left / width;
				_uvs[index + 1] = _uvs[index + 3] = frame.top / height;
				_uvs[index + 2] = _uvs[index + 4] = (frame.left + frame.width) / width;
				_uvs[index + 5] = _uvs[index + 7] = (frame.top + frame.height) / height;
			}

			_colours[colour] = _colours[colour + 1] = _colours[colour + 2] = _colours[colour + 3] = sprite.src.worldAlpha;
			sprite.src._updateFrame	= false;

			index	+= 8;
			colour	+= 4;
		}

		this._dirtyUVs		= true;
		this._dirtyColours	= true;
	}


	void _update(GL.RenderingContext gl)
	{
		Mat3 world;
		Rectangle frame;
		num width, height, ax, ay, w0, w1, h0, h1;
		num a, b, c, d, tx, ty;

		var vertices	= this._vertices;
		var uvs			= this._uvs;
		var colours		= this._colours;
		int index		= 0;
		int colour		= 0;

		for (var sprite in this._sprites)
		{
			if (sprite.src._vcount == DisplayObject._visibleCount)
			{
				frame	= sprite.src.texture.frame;
				width 	= frame == null ? 0.0 : frame.width;
				height	= frame == null ? 0.0 : frame.height;

				ax = sprite.src.anchor.x;
				ay = sprite.src.anchor.y;
				w0 = width * (1.0 - ax);
				w1 = width * -ax;
				h0 = height * (1.0 - ay);
				h1 = height * -ay;

				//print ("$width $height + $ax $ay : $w0 $w1 $h0 $h1");

				world	= sprite.src.worldTransform;
				a		= world[0];
				b		= world[3];
				c		= world[1];
				d		= world[4];
				tx		= world[2];
				ty		= world[5];

				vertices[index + 0] = a * w1 + c * h1 + tx;
				vertices[index + 1] = d * h1 + b * w1 + ty;
				vertices[index + 2] = a * w0 + c * h1 + tx;
				vertices[index + 3] = d * h1 + b * w0 + ty;
				vertices[index + 4] = a * w0 + c * h0 + tx;
				vertices[index + 5] = d * h0 + b * w0 + ty;
				vertices[index + 6] = a * w1 + c * h0 + tx;
				vertices[index + 7] = d * h0 + b * w1 + ty;

				if (sprite.src._updateFrame || sprite.src.texture._updateFrame)
				{
					width	= sprite.src.texture._base.width;
					height	= sprite.src.texture._base.height;

					if (frame != null)
					{
						_uvs[index + 0] = _uvs[index + 6] = frame.left / width;
						_uvs[index + 1] = _uvs[index + 3] = frame.top / height;
						_uvs[index + 2] = _uvs[index + 4] = (frame.left + frame.width) / width;
						_uvs[index + 5] = _uvs[index + 7] = (frame.top + frame.height) / height;
					}

					sprite.src._updateFrame				= false;
					sprite.src._texture._updateFrame	= false;
					this._dirtyUVs						= true;
				}

				if (sprite.src._cacheAlpha != sprite.src.worldAlpha)
				{
					sprite.src._cacheAlpha	= sprite.src.worldAlpha;
					colours[colour]			= colours[colour + 1] = colours[colour + 2] = colours[colour + 3] = sprite.src.worldAlpha;
					this._dirtyColours		= true;
				}

			}
			else
			{
				vertices[index + 0] = vertices[index + 1] = vertices[index + 2] = vertices[index + 3] = vertices[index + 4] = vertices[index + 5] = vertices[index + 6] = vertices[index + 7] = 0;
			}

			index += 8;
			colour += 4;
		}
	}


	void render(GL.RenderingContext gl, [int start = 0, int end = 0])
	{
		if (end == 0) end = this.size;

		if (this._dirty)
		{
			this._refresh(gl);
			this._dirty = false;
		}

		if (this.size == 0) return;

		this._update(gl);

		var shader = WebGLShaders.currentShader;

		// Update the vertices
		gl.bindBuffer(GL.ARRAY_BUFFER, this._vertexBuffer);
		gl.bufferSubData(GL.ARRAY_BUFFER, 0, this._vertices);
		gl.vertexAttribPointer(shader.vertexPosition, 2, GL.FLOAT, false, 0, 0);

		// Update the UVs
		gl.bindBuffer(GL.ARRAY_BUFFER, this._uvBuffer);

		if (this._dirtyUVs)
		{
			this._dirtyUVs = false;
			gl.bufferSubData(GL.ARRAY_BUFFER, 0, this._uvs);
		}

		gl.vertexAttribPointer(shader.textureCoord, 2, GL.FLOAT, false, 0, 0);
	    gl.activeTexture(GL.TEXTURE0);
	    gl.bindTexture(GL.TEXTURE_2D, this._texture._glTexture);

		// Update colour
		gl.bindBuffer(GL.ARRAY_BUFFER, this._colourBuffer);

		if (this._dirtyColours)
		{
			this._dirtyColours = false;
			gl.bufferSubData(GL.ARRAY_BUFFER, 0, this._colours);
		}
		gl.vertexAttribPointer(shader.colour, 1, GL.FLOAT, false, 0, 0);

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this._indexBuffer);

		int length = end - start;

		gl.drawElements(GL.TRIANGLES, length * 6, GL.UNSIGNED_SHORT, start * 2 * 6);
	}


	WebGLBatch clean()
	{
		this._vertices		= [];
		this._uvs			= [];
		this._colours		= [];
		this._indices		= [];
		this._dynamicSize	= 1;
		this._texture		= null;

		//this.last = null;??
		this._sprites.clear();

		return this;
	}


	void _setContext(GL.RenderingContext gl)
	{
		this._gl			= gl;
		this._vertexBuffer	= gl.createBuffer();
		this._indexBuffer	= gl.createBuffer();
		this._uvBuffer		= gl.createBuffer();
		this._colourBuffer	= gl.createBuffer();
	}


	static WebGLBatch _getBatch(GL.RenderingContext gl)
	{
		return _batches.isEmpty ? new WebGLBatch(gl) : _batches.removeLast();
	}

	static void _returnBatch(WebGLBatch batch)
	{
		_batches.add(batch.clean());
	}

	static void _restoreBatches(GL.RenderingContext gl)
	{
		for (var b in _batches) b._setContext(gl);
	}
}

