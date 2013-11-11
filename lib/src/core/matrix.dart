part of pixi;


abstract class Matrix
{
	Float32List _source;


	Matrix()
	{
		this.identity();
	}

	Matrix.from(Iterable<num> source)
	{
		//this._source = new List<num>.from(source.map((i) => i.toDouble()), growable: false);
		//this._source = new List<num>.from(source, growable: false);
		this._source = new Float32List.fromList(source);
	}

	num operator [](int index) => this._source[index];

	void operator []=(int index, num value)
	{
		this._source[index] = value.toDouble();
	}


	void identity();
	Matrix transpose();
	Matrix clone();
}


class Mat3 extends Matrix
{
	Mat3() : super();

	Mat3.from(Iterable<num> source) : super.from(source)
	{
		if (source.length != 9) throw "A Mat3 must be constructed with 9 elements";
	}


	void identity()
	{
		this._source = new Float32List.fromList([
			1.0, 0.0, 0.0,
			0.0, 1.0, 0.0,
			0.0, 0.0, 1.0
		]);
	}


	Mat3 operator *(Mat3 m)
	{

		var a00 = this[0], a01 = this[1], a02 = this[2],
			a10 = this[3], a11 = this[4], a12 = this[5],
			a20 = this[6], a21 = this[7], a22 = this[8],

			b00 = m[0], b01 = m[1], b02 = m[2],
			b10 = m[3], b11 = m[4], b12 = m[5],
			b20 = m[6], b21 = m[7], b22 = m[8];

		// This might be the wrong way round since
		// results don't match a this * m operation
		// but an m * this one.
		return new Mat3.from([
			b00 * a00 + b01 * a10 + b02 * a20,
			b00 * a01 + b01 * a11 + b02 * a21,
			b00 * a02 + b01 * a12 + b02 * a22,

			b10 * a00 + b11 * a10 + b12 * a20,
			b10 * a01 + b11 * a11 + b12 * a21,
			b10 * a02 + b11 * a12 + b12 * a22,

			b20 * a00 + b21 * a10 + b22 * a20,
			b20 * a01 + b21 * a11 + b22 * a21,
			b20 * a02 + b21 * a12 + b22 * a22
		]);
	}


	Matrix transpose() => new Mat3.from([
		this[0], this[3], this[6],
		this[1], this[4], this[7],
		this[2], this[5], this[8]
	]);


	Matrix clone() => new Mat3.from(this._source);


	Mat4 toMat4() => new Mat4.from([
		this[0],	this[1],	this[2],	0,
		this[3],	this[4],	this[5],	0,
		this[6],	this[7],	this[8],	0,
		0,			0,			0,			1,
	]);

}


class Mat4 extends Matrix
{
	Mat4() : super();

	Mat4.from(Iterable<num> source) : super.from(source)
	{
		if (source.length != 16) throw "A Mat4 must be constructed with 16 elements";
	}


	void identity()
	{
		this._source = new Float32List.fromList([
			1.0, 0.0, 0.0, 0.0,
			0.0, 1.0, 0.0, 0.0,
			0.0, 0.0, 1.0, 0.0,
			0.0, 0.0, 0.0, 1.0
		]);
	}


	Mat4 operator *(Mat4 m)
	{
		var result	= new Mat4();
		var a00		= this[ 0], a01 = this[ 1], a02 = this[ 2], a03 = this[3];
		var a10		= this[ 4], a11 = this[ 5], a12 = this[ 6], a13 = this[7];
		var a20		= this[ 8], a21 = this[ 9], a22 = this[10], a23 = this[11];
		var a30		= this[12], a31 = this[13], a32 = this[14], a33 = this[15];

		var b0 = m[0], b1 = m[1], b2 = m[2], b3 = m[3];
		result[0] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
		result[1] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
		result[2] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
		result[3] = b0*a03 + b1*a13 + b2*a23 + b3*a33;

		b0 = m[8];	b1 = m[9];	b2 = m[10];	b3 = m[11];
		result[8] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
		result[9] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
		result[10] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
		result[11] = b0*a03 + b1*a13 + b2*a23 + b3*a33;

		b0 = m[12];	b1 = m[13];	b2 = m[14];	b3 = m[15];
		result[12] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
		result[13] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
		result[14] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
		result[15] = b0*a03 + b1*a13 + b2*a23 + b3*a33;

		return result;
	}


	Matrix transpose() => new Mat4.from([
		this[0],	this[4],	this[8],	this[12],
		this[1],	this[5],	this[9],	this[13],
		this[2],	this[6],	this[10],	this[14],
		this[3],	this[7],	this[11],	this[15]
	]);


	Matrix clone() => new Mat4.from(this._source);
}
