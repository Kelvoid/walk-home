Shader "FlowWeaver/RetroImageEffect"
{
	Properties
	{
		[HideInInspector]_MainTex("Texture", 2D) = "white"{}
		_NumCol("Number of Tones", float) = 8.0
		_Gamma("Gamma", float) = 0.6

		_PixelNumberX("Pixel Number along X", float) = 500
		_PixelNumberY("Pixel Number along Y", float) = 500
	}

		SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			uniform float _NumCol;
			uniform float _Gamma;

			float _PixelNumberX;
			float _PixelNumberY;

			float4 frag(v2f i) : SV_Target
			{
				half ratioX = 1 / _PixelNumberX;
				half ratioY = 1 / _PixelNumberY;
				half2 uv = half2((int)(i.uv.x / ratioX) * ratioX, (int)(i.uv.y / ratioY)*ratioY);

				fixed4 col = tex2D(_MainTex, uv);
				col.rgb = pow(col.rgb, _Gamma) * _NumCol;
				col.rgb = floor(col.rgb) / _NumCol;
				col.rgb = pow(col.rgb, 1.0 / _Gamma);
				return col;
			}
			ENDCG
		}
	}
}