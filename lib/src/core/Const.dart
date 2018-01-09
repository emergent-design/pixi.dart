part of pixi.core;


class RENDERER_TYPE
{
	static const int UNKNOWN	= 0;
	static const int WEBGL		= 1;
	static const int CANVAS		= 2;
}

class BLEND_MODES
{
	static const int NORMAL			= 0;
	static const int ADD			= 1;
	static const int MULTIPLY		= 2;
	static const int SCREEN			= 3;
	static const int OVERLAY		= 4;
	static const int DARKEN			= 5;
	static const int LIGHTEN		= 6;
	static const int COLOR_DODGE	= 7;
	static const int COLOR_BURN		= 8;
	static const int HARD_LIGHT		= 9;
	static const int SOFT_LIGHT		= 10;
	static const int DIFFERENCE		= 11;
	static const int EXCLUSION		= 12;
	static const int HUE			= 13;
	static const int SATURATION		= 14;
	static const int COLOR			= 15;
	static const int LUMINOSITY		= 16;
}

class DRAW_MODES
{
	static const int POINTS         = 0;
	static const int LINES          = 1;
	static const int LINE_LOOP      = 2;
	static const int LINE_STRIP     = 3;
	static const int TRIANGLES      = 4;
	static const int TRIANGLE_STRIP = 5;
	static const int TRIANGLE_FAN   = 6;
}

class MESH_DRAW_MODES
{
	static const int TRIANGLE_MESH	= 0;
	static const int TRIANGLES		= 1;
}

class SCALE_MODES
{
	static const int DEFAULT	= 0;
	static const int LINEAR		= 0;
	static const int NEAREST	= 1;
}

class WRAP_MODES
{
	static const int CLAMP      	   	= 0;
	static const int REPEAT     	   	= 1;
	static const int MIRRORED_REPEAT	= 2;
}

class SHAPES
{
	static const int POLY = 0;
	static const int RECT = 1;
	static const int CIRC = 2;
	static const int ELIP = 3;
	static const int RREC = 4;
}

class PRECISION
{
	static const String LOW		= 'lowp';
	static const String MEDIUM	= 'mediump';
	static const String HIGH	= 'highp';
}

class TRANSFORM_MODE
{
	static const int STATIC		= 0;
	static const int DYNAMIC	= 1;
}

class TEXT_GRADIENT
{
	static const int LINEAR_VERTICAL	= 0;
	static const int LINEAR_HORIZONTAL	= 1;
}

class UPDATE_PRIORITY
{
    static const int INTERACTION 	= 50;
    static const int HIGH 			= 25;
    static const int NORMAL 		= 0;
    static const int LOW 			= -25;
    static const int UTILITY 		= -50;
}
