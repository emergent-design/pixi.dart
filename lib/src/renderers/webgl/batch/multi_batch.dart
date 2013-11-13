part of pixi;


class _MultiBatch extends _BaseBatch
{
	_MultiShader _shader		= null;
	List<BaseTexture> textures	= [];

	_BaseShader get shader => this._shader;
	int get vertexSize => 6;


	_MultiBatch(GL.RenderingContext gl, [ int size = 500 ]) : super(gl, size);


	void initialise(GL.RenderingContext gl)
	{
		super.initialise(gl);
		this._shader = new _MultiShader(gl);
	}


	// Called during a flush
	void bind()
	{
		for (int i=this.textures.length - 1; i >= 0; i--)
		{
			gl.activeTexture(GL.TEXTURE0 + i);
			gl.bindTexture(GL.TEXTURE_2D, this.textures[i]._glTexture);
		}

		gl.uniform2f(this._shader.projectionVector, this.projection.x, this.projection.y);
		gl.vertexAttribPointer(this._shader.vertexPosition, 2, GL.FLOAT, false, 24, 0);
		gl.vertexAttribPointer(this._shader.textureCoord, 2, GL.FLOAT, false, 24, 8);
		gl.vertexAttribPointer(this._shader.colour, 1, GL.FLOAT, false, 24, 16);
		gl.vertexAttribPointer(this._shader.texture, 1, GL.FLOAT, false, 24, 20);

		// After the flush the textures are reset
		this.textures = [];
	}


	void renderSprite(Sprite sprite)
	{
		if (!this.drawing) throw "Unable to draw a sprite before begin() is called for the batch";

		var texture	= sprite._texture;
		var frame	= texture.frame;

		if (frame == null || texture == null || texture._base == null || texture._base._glTexture == null) return;

		var textureIndex = this.textures.indexOf(texture._base);

		if (textureIndex < 0 || this.index == this.vertices.length)
		{
			if (this.textures.length == _MultiShader.MAX_TEXTURES || this.index == this.vertices.length)
			{
				this.flush();
			}

			this.textures.add(texture._base);
			textureIndex = this.textures.indexOf(texture._base);
		}

		// Can the following be cached somehow and only updated
		// if the sprite has changed?
		var world	= sprite.worldTransform;
		num ax 		= sprite.anchor.x;
		num ay 		= sprite.anchor.y;
		num w0 		= frame.width * (1.0 - ax);
		num w1 		= frame.width * -ax;
		num h0 		= frame.height * (1.0 - ay);
		num h1 		= frame.height * -ay;
		num a		= world[0];
		num b		= world[3];
		num c		= world[1];
		num d		= world[4];
		num tx		= world[2];
		num ty		= world[5];
		num width	= texture._base.width;
		num height	= texture._base.height;

		this.vertices[this.index++] = a * w1 + c * h1 + tx;
		this.vertices[this.index++] = d * h1 + b * w1 + ty;
		this.vertices[this.index++] = frame.left / width;
		this.vertices[this.index++] = frame.top / height;
		this.vertices[this.index++] = sprite.worldAlpha;
		this.vertices[this.index++] = textureIndex.toDouble();
		this.vertices[this.index++] = a * w0 + c * h1 + tx;
		this.vertices[this.index++] = d * h1 + b * w0 + ty;
		this.vertices[this.index++] = (frame.left + frame.width) / width;
		this.vertices[this.index++] = frame.top / height;
		this.vertices[this.index++] = sprite.worldAlpha;
		this.vertices[this.index++] = textureIndex.toDouble();
		this.vertices[this.index++] = a * w0 + c * h0 + tx;
		this.vertices[this.index++] = d * h0 + b * w0 + ty;
		this.vertices[this.index++] = (frame.left + frame.width) / width;
		this.vertices[this.index++] = (frame.top + frame.height) / height;
		this.vertices[this.index++] = sprite.worldAlpha;
		this.vertices[this.index++] = textureIndex.toDouble();
		this.vertices[this.index++] = a * w1 + c * h0 + tx;
		this.vertices[this.index++] = d * h0 + b * w1 + ty;
		this.vertices[this.index++] = frame.left / width;
		this.vertices[this.index++] = (frame.top + frame.height) / height;
		this.vertices[this.index++] = sprite.worldAlpha;
		this.vertices[this.index++] = textureIndex.toDouble();
	}
}
