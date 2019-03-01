#ifdef WITH_LIGHTING
	#ifdef WITH_GLOBAL_AMBIENT
		float4 globalAmbientColor : register(c255);
	#endif
#endif

sampler2D tex0 : register(s0);
sampler2D tex1 : register(s1);
sampler2D tex2 : register(s2);
sampler2D tex3 : register(s3);
sampler2D tex4 : register(s4);
sampler2D tex5 : register(s5);
sampler2D tex6 : register(s6);
sampler2D tex7 : register(s7);

#ifdef FLAT_SHADING
	#define LIGHTING_INTERPOLATION nointerpolation
#else
	#define LIGHTING_INTERPOLATION linear
#endif

struct inProcessedVert
{
#if defined(WITH_LIGHTING) || defined(WITH_COLORVERTEX)
	LIGHTING_INTERPOLATION float4 diffuse : COLOR0;
#endif
#ifdef WITH_LIGHTING
	LIGHTING_INTERPOLATION float4 specular : COLOR1;
#endif
	float2 texCoord0 : TEXCOORD0;
};

float4 main(const in inProcessedVert input) : COLOR0
{
	const float4 tex0Color = tex2D(tex0, input.texCoord0);
	const float4 vertexColor = 
#ifdef WITH_COLORVERTEX
		input.diffuse;
#else
		float4(1.0f, 1.0f, 1.0f, 1.0f);
#endif

	// Ambient lighting calculation: https://msdn.microsoft.com/en-us/library/windows/desktop/bb172256(v=vs.85).aspx
	float4 ambientColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
#ifdef WITH_LIGHTING
	#ifdef WITH_GLOBAL_AMBIENT
		ambientColor = float4(0.0f, 0.0f, 0.0f, 0.0f); // globalAmbientColor;
	#endif
#endif

	// Lighting equation and combination:
	return tex0Color * vertexColor + ambientColor;
}
