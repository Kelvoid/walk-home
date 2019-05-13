Shader "Hidden/Custom/LUT"
{
	HLSLINCLUDE

#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

	float4 _Color1;
	float4 _Color2;
	float4 _Color3;
	float4 _Color4;


	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

		color = dot(color.rgb, float3(0.3, 0.59, 0.11));
		
		if (color.r <= 0.25)
		{
			color = _Color1;
		}
		else if (color.r > 0.75)
		{
			color = _Color2;
		}
		else if (color.r > 0.25 && color.r <= 0.5)
		{
			color = _Color3;
		}
		else
		{
			color = _Color4;
		}

		return color;
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