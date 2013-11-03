part of pixi;


class _Uniform
{
	static const F1 		= 0;
	static const F2 		= 1;
	static const MAT4 		= 2;
	static const SAMPLER2D	= 3;

	int type;
	dynamic value;
	GL.UniformLocation location;
}


class _PixiShader
{
	_Program _program				= null;
	String _vertex					= null;
	Map<String, _Uniform> _uniforms	= {};

	static const _fragment = """
		precision lowp float;
		varying vec2 vTextureCoord;
		varying float vColor;
		uniform sampler2D uSampler;

		void main(void) {
			gl_FragColor = texture2D(uSampler, vTextureCoord) * vColor;
		}
	""";

	void initialise(GL.RenderingContext gl)
	{
		var program = new _Program(WebGLShaders._compileProgram(gl, this._vertex != null ? this._vertex : WebGLShaders._shaderVertex, _fragment));
		program.initialise(gl, false, false, true, true, true);


		// get and store the uniforms for the shader
		//this.uSampler = gl.getUniformLocation(program, "uSampler");
		//this.projectionVector = gl.getUniformLocation(program, "projectionVector");
		//this.offsetVector = gl.getUniformLocation(program, "offsetVector");

		// get and store the attributes
		//this.aVertexPosition = gl.getAttribLocation(program, "aVertexPosition");
		//this.aTextureCoord = gl.getAttribLocation(program, "aTextureCoord");

		this._uniforms.forEach((k, v) => v.location = gl.getUniformLocation(program.program, k));
		this._program = program;
	}


	void syncUniforms(GL.RenderingContext gl)
	{
		this._uniforms.forEach((k, v) { switch (v.type) {
			case _Uniform.F1:			gl.uniform1f(v.location, v.value);					break;
			case _Uniform.F2:			gl.uniform2f(v.location, v.value.x, v.value.y);		break;
			case _Uniform.MAT4:			gl.uniformMatrix4fv(v.location, false, v.value);	break;
			case _Uniform.SAMPLER2D:	gl.activeTexture(GL.TEXTURE1);
										gl.bindTexture(GL.TEXTURE_2D, v.value._base._glTexture);
										gl.uniform1i(v.location, 1);
										break;
		}});
	}
}

