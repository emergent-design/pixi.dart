/*part of pixi;



class _GLStripData
{
	Float32List vertices	= null;
	Float32List uvs			= null;
	Float32List colours		= null;
	Uint16List indices		= null;
	GL.Buffer vertexBuffer	= null;
	GL.Buffer indexBuffer	= null;
	GL.Buffer uvBuffer		= null;
	GL.Buffer colourBuffer	= null;


	_GLStripData(GL.RenderingContext gl)
	{
		this.createBuffers(gl);
	}


	void createBuffers(GL.RenderingContext gl)
	{
		this.vertexBuffer	= gl.createBuffer();
		this.indexBuffer	= gl.createBuffer();
		this.uvBuffer		= gl.createBuffer();
		this.colourBuffer	= gl.createBuffer();
	}


	void update(GL.RenderingContext gl)
	{
		gl.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);
		gl.bufferDataTyped(GL.ARRAY_BUFFER, this.vertices, GL.STATIC_DRAW);

		gl.bindBuffer(GL.ARRAY_BUFFER, this.uvBuffer);
		gl.bufferDataTyped(GL.ARRAY_BUFFER, this.uvs, GL.DYNAMIC_DRAW);

		gl.bindBuffer(GL.ARRAY_BUFFER, this.colourBuffer);
		gl.bufferDataTyped(GL.ARRAY_BUFFER, this.colours, GL.STATIC_DRAW);

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
		gl.bufferDataTyped(GL.ELEMENT_ARRAY_BUFFER, this.indices, GL.STATIC_DRAW);
	}
}


class _GLTilingData extends _GLStripData
{
	_GLTilingData(GL.RenderingContext gl, BaseTexture texture, double width, double height) : super(gl)
	{
		this.vertices	= new Float32List.fromList([ 0.0, 0.0, width, 0.0, width, height, 0.0, height ]);
		this.uvs		= new Float32List.fromList([ 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0 ]);
		this.colours	= new Float32List.fromList([ 1.0, 1.0, 1.0, 1.0 ]);
		this.indices	= new Uint16List.fromList([ 0, 1, 3, 2 ]);

		this.update(gl);

		//if (texture._glTexture != null)
		//{
		//	gl.bindTexture(GL.TEXTURE_2D, texture._glTexture);
		//	gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
		//	gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
		//}

		//texture._powerOf2 = true;
	}
}


class _GLTilingSprite
{
	GL.RenderingContext gl;
	_StripShader shader;
	Map<TilingSprite, _GLTilingData> data = {};


	_GLTilingSprite(GL.RenderingContext gl)
	{
		this.initialise(gl);
	}


	void initialise(GL.RenderingContext gl)
	{
		this.gl		= gl;
		this.shader = new _StripShader(gl);

		if (this.data.isNotEmpty)
		{
			for (var d in this.data.values)
			{
				d.createBuffers(gl);
				d.update(gl);
			}
		}
	}


	void renderSprite(TilingSprite sprite, Point projection, Point offset)
	{
		if (!sprite._texture.hasLoaded) return;

		var strip = this.data.putIfAbsent(sprite, () =>
			new _GLTilingData(this.gl, sprite._texture._base, sprite._width.toDouble(), sprite._height.toDouble())
		);

		var position	= sprite.tilePosition;
		var scale		= sprite.tileScale;
		double offsetX	= position.x / sprite._texture._base.width;
		double offsetY	= position.y / sprite._texture._base.height;
		double scaleX	= (sprite._width / sprite._texture._base.width) / scale.x;
		double scaleY	= (sprite._height / sprite._texture._base.height) / scale.y;

		strip.uvs[0] = -offsetX;
		strip.uvs[1] = -offsetY;
		strip.uvs[2] = scaleX - offsetX;
		strip.uvs[3] = -offsetY;
		strip.uvs[4] = scaleX - offsetX;
		strip.uvs[5] = scaleY - offsetY;
		strip.uvs[6] = -offsetX;
		strip.uvs[7] = scaleY - offsetY;

		this.gl.bindBuffer(GL.ARRAY_BUFFER, strip.uvBuffer);
		this.gl.bufferSubDataTyped(GL.ARRAY_BUFFER, 0, strip.uvs);

		this.renderStrip(sprite, strip, projection, offset);
	}


	void renderStrip(TilingSprite sprite, _GLStripData strip, Point projection, Point offset)
	{
		var matrix = sprite.worldTransform.transpose();

		this.gl.uniformMatrix3fv(this.shader.translationMatrix, false, matrix._source);
		this.gl.uniform2f(this.shader.projectionVector, projection.x, -projection.y);
		this.gl.uniform2f(this.shader.offset, -offset.x, -offset.y);
		this.gl.uniform1f(this.shader.alpha, sprite.worldAlpha);

		this.gl.bindBuffer(GL.ARRAY_BUFFER, strip.vertexBuffer);
		this.gl.vertexAttribPointer(this.shader.vertexPosition, 2, GL.FLOAT, false, 0, 0);

		this.gl.bindBuffer(GL.ARRAY_BUFFER, strip.uvBuffer);
		this.gl.vertexAttribPointer(this.shader.textureCoord, 2, GL.FLOAT, false, 0, 0);

		this.gl.activeTexture(GL.TEXTURE0);
		this.gl.bindTexture(GL.TEXTURE_2D, sprite._texture._base._glTexture);

		this.gl.bindBuffer(GL.ARRAY_BUFFER, strip.colourBuffer);
		this.gl.vertexAttribPointer(this.shader.colour, 1, GL.FLOAT, false, 0, 0);

		this.gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, strip.indexBuffer);

		this.gl.drawElements(GL.TRIANGLE_STRIP, strip.indices.length, GL.UNSIGNED_SHORT, 0);
	}
}
*/