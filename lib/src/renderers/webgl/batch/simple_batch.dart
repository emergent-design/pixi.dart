part of pixi;


class _SimpleBatch extends _BaseBatch
{
	_SpriteShader _shader	= null;
	BaseTexture texture		= null;

	_BaseShader get shader => this._shader;
	int get vertexSize => 5;


	_SimpleBatch(GL.RenderingContext gl, [ int size = 500 ]) : super(gl, size);


	void initialise(GL.RenderingContext gl)
	{
		super.initialise(gl);
		this._shader = new _SpriteShader(gl);
	}


	// Called during a flush
	void bind()
	{
		gl.activeTexture(GL.TEXTURE0);
		//gl.bindTexture(GL.TEXTURE_2D, this.texture._glTexture);
		gl.bindTexture(GL.TEXTURE_2D, this.glTexture(this.texture));

		gl.uniform2f(this._shader.projectionVector, this.projection.x, this.projection.y);
		gl.vertexAttribPointer(this._shader.vertexPosition, 2, GL.FLOAT, false, 20, 0);
		gl.vertexAttribPointer(this._shader.textureCoord, 2, GL.FLOAT, false, 20, 8);
		gl.vertexAttribPointer(this._shader.colour, 1, GL.FLOAT, false, 20, 16);

		// After the flush the texture is reset
		this.texture = null;
	}


	void render(Sprite sprite, List<num> uvs)
	{
		if (!this.drawing) throw "Unable to draw a sprite before begin() is called for the batch";

		var texture	= sprite._texture;
		var frame	= texture.frame;

		if (texture._base != this.texture || this.index == this.vertices.length)
		{
			this.flush();
			this.texture = texture._base;
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

		this.vertices[this.index++] = a * w1 + c * h1 + tx;
		this.vertices[this.index++] = d * h1 + b * w1 + ty;
		this.vertices[this.index++] = uvs[0];
		this.vertices[this.index++] = uvs[1];
		this.vertices[this.index++] = sprite.worldAlpha;
		this.vertices[this.index++] = a * w0 + c * h1 + tx;
		this.vertices[this.index++] = d * h1 + b * w0 + ty;
		this.vertices[this.index++] = uvs[2];
		this.vertices[this.index++] = uvs[1];
		this.vertices[this.index++] = sprite.worldAlpha;
		this.vertices[this.index++] = a * w0 + c * h0 + tx;
		this.vertices[this.index++] = d * h0 + b * w0 + ty;
		this.vertices[this.index++] = uvs[2];
		this.vertices[this.index++] = uvs[3];
		this.vertices[this.index++] = sprite.worldAlpha;
		this.vertices[this.index++] = a * w1 + c * h0 + tx;
		this.vertices[this.index++] = d * h0 + b * w1 + ty;
		this.vertices[this.index++] = uvs[0];
		this.vertices[this.index++] = uvs[3];
		this.vertices[this.index++] = sprite.worldAlpha;
	}
}
