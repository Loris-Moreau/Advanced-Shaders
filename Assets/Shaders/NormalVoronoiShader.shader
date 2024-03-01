Shader "Custom/NormalVoronoiShader" 
{ 
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color1 ("First Color", Color) = (1,1,1,1)
		_Color2 ("Second Color", Color) = (1,1,1,1)
		_Height ("Height", Float) = 0.1
		_Speed("Speed", float) = 1
        _Frequency("Frequency", float) = 2
        _Amplitude("Amplitude", float) = 4
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
			// #pragma multi_compile_fog

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color1;
			float4 _Color2;
			float _Height;
			uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;
			
			float4 vertexAnimWaves(float4 pos, float2 uv)
            {
                pos.y = pos.y + sin((uv.y - _Time.y * _Speed) * _Frequency) * (_Amplitude / 100) * uv.y;
				pos.x = pos.x + sin((uv.x - _Time.y * _Speed) * _Frequency) * (_Amplitude / 125);
                return pos;
            }
			
			struct VertexInput
			{
				float4 vertex: POSITION;
				float4 normal: NORMAL;
				float4 texcoord: TEXCOORD0;
			};

			struct VertexOutput
			{
				float2 texcoord : TEXCOORD0;
				float4 pos : SV_POSITION;
				float4 displacement : COLOR;
			};

			VertexOutput vert (VertexInput v)
			{
				VertexOutput o;
                v.vertex = vertexAnimWaves(v.vertex,v.texcoord);
				// o.displacement = tex2Dlod(_MainTex, v.texcoord * _MainTex_ST);
				o.displacement = lerp(_Color1, _Color2, v.vertex.y * 10);
				o.pos = UnityObjectToClipPos(v.vertex + (v.normal * tex2Dlod(_MainTex, v.texcoord * _MainTex_ST) * _Height));
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}
			
			half4 frag (VertexOutput i) : COLOR
			{
				//return tex2D(_MainTex, i.texcoord) * _Color1 + (1 - tex2D(_MainTex, i.texcoord)) * _Color2;
				return tex2D(_MainTex, i.texcoord) * _Color1 + (1 - tex2D(_MainTex, i.texcoord)) * _Color2;
			}
ENDCG
		}
	}
}
