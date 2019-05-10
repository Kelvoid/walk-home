Shader "Custom/Parallax_Window"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DepthTex ("Depth", 2D) = "grey" {}
		_WindowTex ("Window Frame", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		[HDR] _EmissionColor("Emission Color", Color) = (0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _DepthTex;
		sampler2D _WindowTex;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_WindowTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
		fixed4 _EmissionColor;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color

			fixed4 f = tex2D(_WindowTex, IN.uv_WindowTex);
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

			half4 e = f * _EmissionColor;

            o.Albedo = c.rgb * f.rgb;
			o.Emission = e;

            o.Metallic = _Metallic;
            o.Smoothness = f.r * _Glossiness ;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
