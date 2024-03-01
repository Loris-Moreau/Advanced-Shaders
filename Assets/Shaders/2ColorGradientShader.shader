Shader "Custom/2ColorGradientShader" 
{ 
Properties 
{ 
_MainTex ("Texture", 2D) = "white" {}
_Color1 ("First Color", Color) = (1,1,1,1)
_Color2 ("Second Color", Color) = (1,1,1,1)
_Height ("Height", Float) = 10.0
}

SubShader 
{ 
Tags 
{
"Queue"="Transparent" 
"IgnoreProjectors"="True" 
"RenderType"="Transparent" 
} 

	Pass
	{
Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		// make fog work
		#pragma multi_compile_fog
		
		#include "UnityCG.cginc"

		sampler2D _MainTex;
		float4 _MainTex_ST;
		float4 _Color1;
		float4 _Color2;
		float _Height;

		struct VertexInput
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct VertexOutput
		{
			float2 uv : TEXCOORD0;
			float4 vertex : SV_POSITION;
			float3 texcoord : TEXCOORD2;
		};

		
		VertexOutput vert (VertexInput v)
		{
			VertexOutput o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			o.texcoord = mul(unity_ObjectToWorld, v.vertex).xyz;
			return o;
		}
		
		half4 frag (VertexOutput i) : COLOR
		{
			// sample the texture
			fixed4 noise = tex2D(_MainTex, i.uv);
			
			fixed4 gradient = lerp(_Color1, _Color2, i.texcoord.y / _Height);
			
			noise = noise * gradient;
			return noise;
		}
		ENDCG
	}
  }
}
