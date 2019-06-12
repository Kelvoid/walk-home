Shader "Hidden/Custom/Derez"
{
	HLSLINCLUDE

	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

	float _NumCol;
	float _Gamma;
	int _PixelNumberX = 256;
	int _PixelNumberY = 256;


	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float ratioX = 1 / _PixelNumberX;
		float ratioY = 1 / _PixelNumberY;
		float2 uv = float2((i.texcoord.x / ratioX) * ratioX, ((i.texcoord.y / ratioY)*ratioY));
		float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);

		col.rgb = PositivePow(col.rgb, _Gamma) * _NumCol;
		col.rgb = floor(col.rgb) / _NumCol;
		col.rgb = PositivePow(col.rgb, 1.0 / _Gamma);
		return col;
	}

		ENDHLSL

		SubShader
	{
		Cull Off ZWrite Off ZTest Always

			Pass
		{
			HLSLPROGRAM

			#pragma vertex VertDefault
			#pragma fragment Frag


			ENDHLSL
		}
	}
}