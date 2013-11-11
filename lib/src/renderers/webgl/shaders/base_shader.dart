part of pixi;


abstract class _BaseShader
{
	GL.Program program;
	GL.UniformLocation projectionVector;
	int vertexPosition;
	int colour;

	String vertex;
	String fragment;


	_BaseShader(GL.RenderingContext gl, this.vertex, String this.fragment)
	{
		this.initialise(gl);
	}


	void activate(GL.RenderingContext gl)
	{
		gl.useProgram(this.program);
		gl.enableVertexAttribArray(this.vertexPosition);
		gl.enableVertexAttribArray(this.colour);
	}


	void deactivate(GL.RenderingContext gl)
	{
		gl.disableVertexAttribArray(this.vertexPosition);
		gl.disableVertexAttribArray(this.colour);
	}


	void initialise(GL.RenderingContext gl)
	{
		this.compileProgram(gl);

		this.vertexPosition 	= gl.getAttribLocation(this.program, "aVertexPosition");
		this.colour				= gl.getAttribLocation(this.program, "aColor");
		this.projectionVector	= gl.getUniformLocation(this.program, "projectionVector");
	}


	void compileProgram(GL.RenderingContext gl)
	{
		var fragmentShader	= this.compileFragmentShader(gl, this.fragment);
		var vertexShader	= this.compileVertexShader(gl, this.vertex);

		this.program = gl.createProgram();

		gl.attachShader(this.program, vertexShader);
		gl.attachShader(this.program, fragmentShader);
		gl.linkProgram(this.program);

		if (!gl.getProgramParameter(this.program, GL.LINK_STATUS))
		{
			print("Could not initialise shader");
		}
	}


	GL.Shader compileFragmentShader(GL.RenderingContext gl, String src)	=> compileShader(gl, src, GL.FRAGMENT_SHADER);
	GL.Shader compileVertexShader(GL.RenderingContext gl, String src)	=> compileShader(gl, src, GL.VERTEX_SHADER);

	GL.Shader compileShader(GL.RenderingContext gl, String src, int type)
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
}
