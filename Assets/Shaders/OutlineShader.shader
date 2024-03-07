// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/OutlineShader"
{
   Properties
   {
       _Color("Main Color", Color) = (1, 1, 1, 1)
       _MainTex("Main Texture", 2D) = "white"{}
       
       _Outline("Outline", float) = 0.1
       _OutlineColor("Outline Color", Color) = (1, 1, 1, 1)
   }

   SubShader
   {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }

       Pass
       {
           Blend SrcAlpha OneMinusSrcAlpha

           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag

           uniform half4 _Color;
           uniform sampler2D _MainTex;

           struct VertexInput
           {
               float4 vertex: POSITION;
               float4 texcoord: TEXCOORD0;
           };

           struct VertexOutput
           {
               float4 pos: SV_POSITION;
               float4 texcoord: TEXCOORD0;
           };

           VertexOutput vert(VertexInput v)
           {
               VertexOutput o;
               o.pos = UnityObjectToClipPos(v.vertex);
               o.texcoord.xy = v.texcoord;
               return o;
           }

           half4 frag(VertexOutput i): COLOR   //half4 will be treated as a color
           {
               return tex2D(_MainTex, i.texcoord) * _Color;
           }
          
           ENDCG
       }
        
       Pass
       {
           Blend SrcAlpha OneMinusSrcAlpha
           Cull front
           Zwrite off

           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag

           uniform half4 _Color;
           uniform sampler2D _MainTex;

           uniform float _Outline;
           uniform half4 _OutlineColor;
           matrix _ScaleMatrix;
           fixed3 _Scale;

           struct VertexInput
           {
               float4 vertex: POSITION;
               float4 texcoord: TEXCOORD0;
           };

           struct VertexOutput
           {
               float4 pos: SV_POSITION;
               float4 texcoord: TEXCOORD0;
           };

           VertexOutput vert(VertexInput v)
           {
               VertexOutput o;
               //o.pos = UnityObjectToClipPos(v.vertex);
               //o.pos = UnityObjectToClipPos(v.vertex * _Scale);
               //_Scale = half3(1, 2, 1);
               //_ScaleMatrix = Matrix4x4.Scale(scale);
               //o.pos = mul(UNITY_MATRIX_MVP, v.vertex + v.texcoord * _Outline);
               
               v.vertex.xyz += v.texcoord.xyz * _Scale;
               o.pos = UnityObjectToClipPos(v.vertex );
               
               return o;
           }

           half4 frag(VertexOutput i): COLOR   //half4 will be treated as a color
           {
               return tex2D(_MainTex, i.texcoord) * _Color;
           }
          
           ENDCG
       }
   }
}
