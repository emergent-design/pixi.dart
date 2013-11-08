part of pixi;


class _SimpleBatch extends _BaseBatch
{
	BaseTexture texture = null;

	int get vertexSize => 5;

	//Shader shader;


	_SimpleBatch(GL.RenderingContext gl, [ int size = 500 ]) : super(gl, size);


	// Called during a flush
	void bind()
	{
		gl.activeTexture(GL.TEXTURE0);
		gl.bindTexture(GL.TEXTURE_2D, this.texture._glTexture);

		var shader = WebGLShaders.currentShader;

		//this.shader.activate();
		gl.useProgram(shader.program);

		gl.uniform2f(shader.projectionVector, this.projection.x, this.projection.y);
		gl.vertexAttribPointer(shader.vertexPosition, 2, GL.FLOAT, false, 20, 0);
		gl.vertexAttribPointer(shader.textureCoord, 2, GL.FLOAT, false, 20, 8);
		gl.vertexAttribPointer(shader.colour, 1, GL.FLOAT, false, 20, 16);

		// After the flush the texture is reset
		this.texture = null;
	}


	void renderSprite(Sprite sprite)
	{
		if (!this.drawing) throw "Unable to draw a sprite before begin() is called for the batch";

		var texture	= sprite._texture;
		var frame	= texture.frame;

		if (frame == null || texture == null || texture._base == null || texture._base._glTexture == null) return;

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
		num width	= texture._base.width;
		num height	= texture._base.height;

		this.vertices[this.index++] = a * w1 + c * h1 + tx;
		this.vertices[this.index++] = d * h1 + b * w1 + ty;
		this.vertices[this.index++] = frame.left / width;
		this.vertices[this.index++] = frame.top / height;
		this.vertices[this.index++] = sprite.worldAlpha;
		this.vertices[this.index++] = a * w0 + c * h1 + tx;
		this.vertices[this.index++] = d * h1 + b * w0 + ty;
		this.vertices[this.index++] = (frame.left + frame.width) / width;
		this.vertices[this.index++] = frame.top / height;
		this.vertices[this.index++] = sprite.worldAlpha;
		this.vertices[this.index++] = a * w0 + c * h0 + tx;
		this.vertices[this.index++] = d * h0 + b * w0 + ty;
		this.vertices[this.index++] = (frame.left + frame.width) / width;
		this.vertices[this.index++] = (frame.top + frame.height) / height;
		this.vertices[this.index++] = sprite.worldAlpha;
		this.vertices[this.index++] = a * w1 + c * h0 + tx;
		this.vertices[this.index++] = d * h0 + b * w1 + ty;
		this.vertices[this.index++] = frame.left / width;
		this.vertices[this.index++] = (frame.top + frame.height) / height;
		this.vertices[this.index++] = sprite.worldAlpha;
	}
}

