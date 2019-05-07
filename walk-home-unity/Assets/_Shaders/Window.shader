// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/InteriorMapping - Cubemap"
{
	Properties
	{
		_RoomCube("Room Cube Map", Cube) = "white" {}
		_Frame("Window Frame", 2D) = "white" {}
		_depth("Room Depth", range(0,4)) = 1
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

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
			float3 normal : NORMAL;
			float4 tangent : TANGENT;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};

			samplerCUBE _RoomCube;
			sampler2D _Frame;
			float4 _RoomCube_ST;
			float4 _Frame_ST;
			float _depth;


		v2f vert(appdata v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);

			// uvs
			o.uv = TRANSFORM_TEX(v.uv, _RoomCube);
			o.uv = TRANSFORM_TEX(v.uv, _Frame);

			// get tangent space camera vector
			float4 objCam = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1.0));
			float3 viewDir = v.vertex.xyz - objCam.xyz;
			float tangentSign = v.tangent.w * unity_WorldTransformParams.w;
			float3 bitangent = cross(v.normal.xyz, v.tangent.xyz) * tangentSign;
			o.viewDir = float3(
				dot(viewDir, v.tangent.xyz),
				dot(viewDir, bitangent),
				dot(viewDir, v.normal)
				);

			// adjust for tiling
			o.viewDir *= _RoomCube_ST.xyx;
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			// room uvs
			float2 roomUV = frac(i.uv);

			// raytrace box from tangent view dir
			float3 pos = float3(roomUV * 2.0 - 1.0, 1.0 * _depth);
			float3 id = 1.0 / i.viewDir;
			float3 k = abs(id) - pos * id;
			float kMin = min(min(k.x, k.y), k.z);
			pos += kMin * i.viewDir;

			// sample room cube map
			fixed4 room = texCUBE(_RoomCube, pos.xyz) * tex2D(_Frame, i.uv);
			return fixed4(room.rgb, 1.0);
			}
			ENDCG
		}
	}
}
