part of pixi;


class _MultiShader extends _BaseShader
{
	static const MAX_TEXTURES = 4;

	static const VERTEX = """
		attribute vec2 aVertexPosition;
		attribute vec2 aTextureCoord;
		attribute float aColor;
		attribute float aTexture;
		
		uniform vec2 projectionVector;
		uniform vec2 offsetVector;
		varying vec2 vTextureCoord;
		varying float vColor;
		varying float vTexture;
		
		const vec2 center = vec2(-1.0, 1.0);
		
		void main(void) 
		{
			gl_Position = vec4( ((aVertexPosition + offsetVector) / projectionVector) + center , 0.0, 1.0);
			vTextureCoord = aTextureCoord;
			vColor = aColor;
			vTexture = aTexture;
		}
	""";

	static const FRAGMENT = """
		precision mediump float;
		varying vec2 vTextureCoord;
		varying float vColor;
		varying float vTexture;
		uniform sampler2D uSampler0;
		uniform sampler2D uSampler1;
		uniform sampler2D uSampler2;
		uniform sampler2D uSampler3;
		
		void main(void)
		{
			if (vTexture < 1.0)			gl_FragColor = texture2D(uSampler0, vTextureCoord) * vColor;
			else if (vTexture < 2.0)	gl_FragColor = texture2D(uSampler1, vTextureCoord) * vColor;
			else if (vTexture < 3.0)	gl_FragColor = texture2D(uSampler2, vTextureCoord) * vColor;
			else 						gl_FragColor = texture2D(uSampler3, vTextureCoord) * vColor;
		}
	""";


	int textureCoord;
	int texture;
	GL.UniformLocation offset;

	// Do these actually need to be stored since they're only set once?
	List<GL.UniformLocation> samplers = new List<GL.UniformLocation>(MAX_TEXTURES);


	_MultiShader(GL.RenderingContext gl) : super(gl, VERTEX, FRAGMENT);


	void initialise(GL.RenderingContext gl)
	{
		super.initialise(gl);

		this.textureCoord	= gl.getAttribLocation(this.program, "aTextureCoord");
		this.texture		= gl.getAttribLocation(this.program, "aTexture");
		this.offset			= gl.getUniformLocation(this.program, "offsetVector");

		gl.useProgram(this.program);

		for (int i=0; i<MAX_TEXTURES; i++)
		{
			this.samplers[i] = gl.getUniformLocation(this.program, "uSampler$i");
			gl.uniform1i(this.samplers[i], i);
		}
	}


	void activate(GL.RenderingContext gl)
	{
		super.activate(gl);
		gl.enableVertexAttribArray(this.textureCoord);
		gl.enableVertexAttribArray(this.texture);
	}


	void deactivate(GL.RenderingContext gl)
	{
		super.deactivate(gl);
		gl.disableVertexAttribArray(this.textureCoord);
		gl.disableVertexAttribArray(this.texture);
	}
}
