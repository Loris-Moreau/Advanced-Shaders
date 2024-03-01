Shader "Custom/VoronoiShader" 
{ 
Properties 
{ 
_MainTex ("Texture", 2D) = "white" {}
_Color1 ("First Color", Color) = (1,1,1,1)
_Color2 ("Second Color", Color) = (1,1,1,1)
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

		struct VertexInput
		{
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
		};

		struct VertexOutput
		{
			float2 texcoord : TEXCOORD0;
			float4 pos : SV_POSITION;
		};

		
		VertexOutput vert (VertexInput v)
		{
			VertexOutput o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
			return o;
		}
		
		half4 frag (VertexOutput i) : COLOR
		{
			return tex2D(_MainTex, i.texcoord) * _Color1 + (1 - tex2D(_MainTex, i.texcoord)) * _Color2;
		}
		ENDCG
	}
  }
}
