/*part of pixi;


class _StripShader extends _BaseShader
{
	static const VERTEX = """
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
			vec3 v = translationMatrix * vec3(aVertexPosition, 1.0) - offsetVector.xyx;
			gl_Position = vec4( v.x / projectionVector.x -1.0, v.y / -projectionVector.y + 1.0 , 0.0, 1.0);
			vTextureCoord = aTextureCoord;
			vColor = aColor;
		}
	""";

	static const FRAGMENT = """
		precision mediump float;
		varying vec2 vTextureCoord;
		varying float vColor;
		uniform float alpha;
		uniform sampler2D uSampler;

		void main(void)
		{
			gl_FragColor = texture2D(uSampler, vTextureCoord);
			gl_FragColor = gl_FragColor * alpha * vColor;
		}
	""";


	int textureCoord;
	GL.UniformLocation translationMatrix;
	GL.UniformLocation alpha;
	GL.UniformLocation sampler;
	GL.UniformLocation offset;


	_StripShader(GL.RenderingContext gl) : super(gl, VERTEX, FRAGMENT);


	void initialise(GL.RenderingContext gl)
	{
		super.initialise(gl);

		this.translationMatrix	= gl.getUniformLocation(this.program, "translationMatrix");
		this.alpha				= gl.getUniformLocation(this.program, "alpha");
		this.textureCoord		= gl.getAttribLocation(this.program, "aTextureCoord");
		this.sampler			= gl.getUniformLocation(this.program, "uSampler");
		this.offset				= gl.getUniformLocation(this.program, "offsetVector");
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
*/