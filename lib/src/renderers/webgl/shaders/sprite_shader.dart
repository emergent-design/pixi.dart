part of pixi;


class _SpriteShader extends _BaseShader
{
	static const VERTEX = """
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

	static const FRAGMENT = """
		precision mediump float;
		varying vec2 vTextureCoord;
		varying float vColor;
		uniform sampler2D uSampler;
	
		void main(void)
		{
			gl_FragColor = texture2D(uSampler, vTextureCoord);
			gl_FragColor = gl_FragColor * vColor;
		}
	""";


	int textureCoord;
	GL.UniformLocation sampler;
	GL.UniformLocation offset;


	_SpriteShader(GL.RenderingContext gl) : super(gl, VERTEX, FRAGMENT);


	void initialise(GL.RenderingContext gl)
	{
		super.initialise(gl);

		this.textureCoord	= gl.getAttribLocation(this.program, "aTextureCoord");
		this.sampler		= gl.getUniformLocation(this.program, "uSampler");
		this.offset			= gl.getUniformLocation(this.program, "offsetVector");
	}


	void activate(GL.RenderingContext gl)
	{
		super.activate(gl);
		gl.enableVertexAttribArray(this.textureCoord);
	}


	void deactivate(GL.RenderingContext gl)
	{
		super.deactivate(gl);
		gl.disableVertexAttribArray(this.textureCoord);
	}
}



