part of pixi;


class _GraphicsShader extends _BaseShader
{
	static const VERTEX = """
		attribute vec2 aVertexPosition;
		attribute vec4 aColor;
		uniform mat3 translationMatrix;
		uniform vec2 projectionVector;
		uniform vec2 offsetVector;
		uniform float alpha;
		varying vec4 vColor;
	
		void main(void) 
		{
			vec3 v = translationMatrix * vec3(aVertexPosition , 1.0) - offsetVector.xyx;
			gl_Position = vec4( v.x / projectionVector.x -1.0, v.y / -projectionVector.y + 1.0 , 0.0, 1.0);
			vColor = aColor  * alpha;
		}
	""";

	static const FRAGMENT = """
		precision mediump float;
		varying vec4 vColor;
	
		void main(void)
		{
			gl_FragColor = vColor;
		}
	""";

	GL.UniformLocation translationMatrix;
	GL.UniformLocation alpha;
	GL.UniformLocation offset;


	_GraphicsShader(GL.RenderingContext gl) : super(gl, VERTEX, FRAGMENT);


	void initialise(GL.RenderingContext gl)
	{
		super.initialise(gl);

		this.translationMatrix	= gl.getUniformLocation(this.program, "translationMatrix");
		this.alpha				= gl.getUniformLocation(this.program, "alpha");
		this.offset				= gl.getUniformLocation(this.program, "offsetVector");
	}

}
