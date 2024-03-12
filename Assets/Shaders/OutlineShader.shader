Shader "Custom/OutlineShader"
{ 
    Properties
    {
        _Color("Main Color", Color) = (1, 1, 1, 1)
        _MainTex("Main Texture", 2D) = "white"{}
        
        _Outline("Outline Size", Float) = 0.2
        _OutlineColor("Outline Color", Color) = (1, 0, 0, 1)
    }
    
    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent"
            "RenderType"="Transparent" 
            "IgnoreProjector"="True"
        }
       
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            uniform half4 _Color;
            
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            

            #include "UnityCG.cginc"

            struct VertexInput
            {
                float4 vertex:POSITION;
                float4 texcoord: TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos:SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return o;
            }

            half4 frag(VertexOutput i) : COLOR
            {
                return tex2D(_MainTex, i.texcoord) * _Color;
            }
ENDCG
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Front
            ZWrite off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            uniform float4 _MainTex_ST;
            
            uniform half4 _OutlineColor;
            uniform float _Outline;

            #include "UnityCG.cginc"

            struct VertexInput
            {
                float4 vertex:POSITION;
                float4 texcoord: TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos:SV_POSITION;
                float4 texcoord: TEXCOORD0;
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex * (_Outline + 1));
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return o;
            }

            half4 frag(VertexOutput i) : COLOR
            {
            return _OutlineColor;
            }
ENDCG
        }
    }
}
