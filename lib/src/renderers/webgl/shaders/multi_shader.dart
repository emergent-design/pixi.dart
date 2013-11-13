part of pixi;


class _MultiShader extends _BaseShader
{
	static const MAX_TEXTURES = 32;

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
		uniform sampler2D uSamplers[32];
		
		void main(void)
		{
			for (int i=0; i<32; i++)
			{
				if (vTexture < float(i + 1))
				{
					gl_FragColor = texture2D(uSamplers[i], vTextureCoord) * vColor;
					return;
				}
			}
		}
	""";


	int textureCoord;
	int texture;
	GL.UniformLocation samplers;
	GL.UniformLocation offset;


	_MultiShader(GL.RenderingContext gl) : super(gl, VERTEX, FRAGMENT);


	void initialise(GL.RenderingContext gl)
	{
		super.initialise(gl);

		this.textureCoord	= gl.getAttribLocation(this.program, "aTextureCoord");
		this.texture		= gl.getAttribLocation(this.program, "aTexture");
		this.samplers		= gl.getUniformLocation(this.program, "uSamplers");
		this.offset			= gl.getUniformLocation(this.program, "offsetVector");

		gl.useProgram(this.program);
		gl.uniform1iv(this.samplers, new Int32List.fromList(new List<int>.generate(MAX_TEXTURES, (i) => i)));
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
