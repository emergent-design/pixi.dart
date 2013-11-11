part of pixi;

// The base batcher for rendering sprite quads (indexed triangles).
// Based on the implementation at https://github.com/mattdesl/pixi.js
// by Matt DesLauriers

abstract class _BaseBatch
{
	static const MAX_SIZE = 8000;

	GL.RenderingContext gl;
	GL.Buffer vertexBuffer;
	GL.Buffer indexBuffer;

	Float32List vertices;
	Uint16List indices;
	int size;

	bool drawing			= false;
	int index				= 0;
	int totalRenderCalls	= 0;
	Point projection;
	// Blend mode, flush if changed??


	// Abstract properties and functions
	int get vertexSize;

	void bind();
	void renderSprite(Sprite sprite);


	_BaseBatch(GL.RenderingContext gl, this.size)
	{
		if (this.size > MAX_SIZE) throw "The largest batch size permitted is ${MAX_SIZE}";

		var numv 		= this.size * 4 * this.vertexSize;
		var numi 		= this.size * 6;
		this.vertices	= new Float32List(numv);
		this.indices	= new Uint16List(numi);

		for (int i=0, j=0; i<numi; i+=6, j+=4)
		{
			this.indices[i + 0] = j + 0;
			this.indices[i + 1] = j + 1;
			this.indices[i + 2] = j + 2;
			this.indices[i + 3] = j + 0;
			this.indices[i + 4] = j + 2;
			this.indices[i + 5] = j + 3;
		}

		this.initialise(gl);
	}


	void destroy()
	{
		if (this.vertexBuffer != null)	this.gl.deleteBuffer(this.vertexBuffer);
		if (this.indexBuffer != null)	this.gl.deleteBuffer(this.indexBuffer);
		this.vertices	= null;
		this.indices	= null;
		this.size		= 0;
	}


	void initialise(GL.RenderingContext gl)
	{
		this.gl				= gl;
		this.vertexBuffer 	= gl.createBuffer();
		this.indexBuffer	= gl.createBuffer();

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
    	gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, this.indices, GL.STATIC_DRAW);
	}


	// Begins the sprite batch. Subclasses should then bind shaders,
	// upload projection matrix, and bind textures.
	void begin(Point projection)
	{
		if (this.drawing) throw "Cannot call begin during drawing";

		this.drawing			= true;
		this.projection			= projection;
		this.totalRenderCalls	= 0;

		gl.depthMask(false);
		gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
	}


	void end()
	{
		if (!this.drawing)	throw "Cannot end a batch that was not begun";
		if (this.index > 0)	this.flush();

		this.drawing = false;
		this.gl.depthMask(true);
	}


	void flush()
	{
		if (this.index == 0) return;
		this.totalRenderCalls++;

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
		gl.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);
		gl.bufferData(GL.ARRAY_BUFFER, this.vertices, GL.DYNAMIC_DRAW);

		this.bind();

		int count = this.index ~/ (this.vertexSize * 4);

		gl.drawElements(GL.TRIANGLES, count * 6, GL.UNSIGNED_SHORT, 0);

		this.index = 0;
	}
}
