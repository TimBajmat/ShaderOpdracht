Shader "Custom/RimShader" {

	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("Normal Map", 2D) = "bump" {}

		_ColorTint ("Color tint", Color) = (1, 1, 1, 1)

		[Header(Rim Settings)]
		_RimColor ("Rim Color", Color) = (1, 1, 1, 1)
		_RimPower ("Rim Power", Range(1.0, 6.0)) = 3.0
	}

	SubShader {
		Tags { "RenderType" = "Opaque"}

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _BumpMap;

		float4 _ColorTint;
		float4 _RimColor;
		float _RimPower;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 worldNormal;
			float3 viewDir;
			float4 color : Color;
		};

		void surf(Input IN, inout SurfaceOutput o){
			IN.color = _ColorTint;
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb * IN.color;
			o.Normal = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));

			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
