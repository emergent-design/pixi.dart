/*part of pixi;


class _Program
{
	GL.Program program;
	int vertexPosition;
	int colour;
	int textureCoord;
	GL.UniformLocation projectionVector;
	GL.UniformLocation translationMatrix;
	GL.UniformLocation alpha;
	GL.UniformLocation sampler;
	GL.UniformLocation offset;


	_Program(this.program);

	void initialise(GL.RenderingContext gl, bool translation, bool alpha, bool texture, bool sampler, bool offset)
	{
		gl.useProgram(this.program);

		this.vertexPosition 	= gl.getAttribLocation(this.program, "aVertexPosition");
		this.colour				= gl.getAttribLocation(this.program, "aColor");
		this.projectionVector	= gl.getUniformLocation(program, "projectionVector");

		if (translation)	this.translationMatrix	= gl.getUniformLocation(program, "translationMatrix");
		if (alpha)			this.alpha				= gl.getUniformLocation(program, "alpha");
		if (texture)		this.textureCoord		= gl.getAttribLocation(program, "aTextureCoord");
		if (sampler)		this.sampler			= gl.getUniformLocation(program, "uSampler");
		if (offset)			this.offset				= gl.getUniformLocation(program, "offsetVector");
	}
}


class WebGLShaders
{
	static const _shaderVertex = """
		attribute vec2 aVertexPosition;
		attribute vec2 aTextureCoord;
		attribute float aColor;

		uniform vec2 projectionVector;
		uniform vec2 offsetVector;
		varying vec2 vTextureCoord;
		varying float vColor;

		const vec2 center = vec2(-1.0, 1.0);

		void main(void)
		{
			gl_Position = vec4( ((aVertexPosition + offsetVector) / projectionVector) + center , 0.0, 1.0);
			vTextureCoord = aTextureCoord;
			vColor = aColor;
		}
	""";

	static const _shaderFragment = """
		precision mediump float;
		varying vec2 vTextureCoord;
		varying float vColor;
		uniform sampler2D uSampler;

		void main(void)
		{
			gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y));
			gl_FragColor = gl_FragColor * vColor;
		}
	""";

	static const _primitiveVertex = """
		attribute vec2 aVertexPosition;
		attribute vec4 aColor;
		uniform mat3 translationMatrix;
		uniform vec2 projectionVector;
		uniform vec2 offsetVector;
		uniform float alpha;
		varying vec4 vColor;

		void main(void)
		{
			vec3 v = translationMatrix * vec3(aVertexPosition , 1.0);
			v -= offsetVector.xyx;
			gl_Position = vec4( v.x / projectionVector.x -1.0, v.y / -projectionVector.y + 1.0 , 0.0, 1.0);
			vColor = aColor  * alpha;
		}
	""";

	static const _primitiveFragment = """
		precision mediump float;
		varying vec4 vColor;

		void main(void)
		{
			gl_FragColor = vColor;
		}
	""";

	static const _stripVertex = """
		attribute vec2 aVertexPosition;
		attribute vec2 aTextureCoord;
		attribute float aColor;
		uniform mat3 translationMatrix;
		uniform vec2 projectionVector;
		varying vec2 vTextureCoord;
		uniform vec2 offsetVector;
		varying float vColor;

		void main(void)
		{
			vec3 v = translationMatrix * vec3(aVertexPosition, 1.0);
			v -= offsetVector.xyx;
			gl_Position = vec4( v.x / projectionVector.x -1.0, v.y / -projectionVector.y + 1.0 , 0.0, 1.0);
			vTextureCoord = aTextureCoord;
			vColor = aColor;
		}
	""";

	static const _stripFragment = """
		precision mediump float;
		varying vec2 vTextureCoord;
		varying float vColor;
		uniform float alpha;
		uniform sampler2D uSampler;

		void main(void)
		{
			gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y));
			gl_FragColor = gl_FragColor * alpha * vColor;
		}
	""";

	static _Program shaderProgram			= null;
	static _Program primitiveProgram		= null;
	static _Program stripProgram			= null;
	static _Program currentShader			= null;
	static _PixiShader defaultShader		= null;
	static List<_PixiShader> shaderStack	= [];

	//PIXI.frameBufferStack = [];
	//PIXI.frameBufferPool = [];

	static void initDefaultShader(GL.RenderingContext gl)
	{
		//shaderProgram = new _Program(_compileProgram(gl, _shaderVertex, _shaderFragment));
		//shaderProgram.initialise(gl, false, false, true, true, true);

		defaultShader = new _PixiShader();
		defaultShader.initialise(gl);

		pushShader(gl, defaultShader);
	}


	static void initPrimitiveShader(GL.RenderingContext gl)
	{
		primitiveProgram = new _Program(_compileProgram(gl, _primitiveVertex, _primitiveFragment));
		primitiveProgram.initialise(gl, true, true, false, false, true);
	}


	static void initDefaultStripShader(GL.RenderingContext gl)
	{
		stripProgram = new _Program(_compileProgram(gl, _stripVertex, _stripFragment));
		stripProgram.initialise(gl, true, true, true, true, true);
	}


	/*static void activateDefaultShader(RenderingContext gl)
	{
		gl.useProgram(shaderProgram.program);
		gl.enableVertexAttribArray(shaderProgram.vertexPosition);
		gl.enableVertexAttribArray(shaderProgram.textureCoord);
		gl.enableVertexAttribArray(shaderProgram.colour);
	}*/


	static void activatePrimitiveShader(GL.RenderingContext gl)
	{
		gl.useProgram(primitiveProgram.program);
		gl.disableVertexAttribArray(currentShader.textureCoord);
		gl.disableVertexAttribArray(currentShader.colour);
		gl.enableVertexAttribArray(primitiveProgram.colour);
	}

	static void deactivatePrimitiveShader(GL.RenderingContext gl)
	{
		gl.useProgram(currentShader.program);
		gl.disableVertexAttribArray(primitiveProgram.colour);
		gl.enableVertexAttribArray(currentShader.textureCoord);
		gl.enableVertexAttribArray(currentShader.colour);
	}


	static void pushShader(GL.RenderingContext gl, _PixiShader shader)
	{
		// Why??
		//gl.colorMask(true, true, true, true);
		//gl.viewport(0, 0, this.width, this.height);
		//gl.clearColor(0,0,0, 0);
		//gl.clear(gl.COLOR_BUFFER_BIT);

		shaderStack.add(shader);

		var program = shader._program;

		// flip! the texture..
		// set the texture!

		// map uniforms..
		gl.useProgram(program.program);

		gl.enableVertexAttribArray(program.vertexPosition);
		gl.enableVertexAttribArray(program.colour);
		gl.enableVertexAttribArray(program.textureCoord);

		shader.syncUniforms(gl);
		currentShader = program;
	}


	static void popShader(GL.RenderingContext gl)
	{
		var last	= shaderStack.removeLast();
		var program	= shaderStack.last._program;

		gl.useProgram(program.program);
		currentShader = program;
	}


	static GL.Program _compileProgram(GL.RenderingContext gl, String vertex, String fragment)
	{
		var fragmentShader	= _compileFragmentShader(gl, fragment);
		var vertexShader	= _compileVertexShader(gl, vertex);

		var program = gl.createProgram();

		gl.attachShader(program, vertexShader);
		gl.attachShader(program, fragmentShader);
		gl.linkProgram(program);

		if (!gl.getProgramParameter(program, GL.LINK_STATUS))
		{
			print("Could not initialise shaders");
		}

		return program;
	}


	static GL.Shader _compileFragmentShader(GL.RenderingContext gl, String src)	=> _compileShader(gl, src, GL.FRAGMENT_SHADER);
	static GL.Shader _compileVertexShader(GL.RenderingContext gl, String src)	=> _compileShader(gl, src, GL.VERTEX_SHADER);

	static GL.Shader _compileShader(GL.RenderingContext gl, String src, int type)
	{
		var shader = gl.createShader(type);

		gl.shaderSource(shader, src);
		gl.compileShader(shader);

		if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS))
		{
			print(gl.getShaderInfoLog(shader));
			return null;
		}

		return shader;
	}
}*/
