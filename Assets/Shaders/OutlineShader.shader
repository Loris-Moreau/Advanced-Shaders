Shader "Custom/OutlineShader"
{
   Properties
   {
       _Color("Main Color", Color) = (1, 1, 1, 1)
       _MainTex("Main Texture", 2D) = "white"{}
       
       _Outline("Outline Size", float) = 0.1
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
           //Blend SrcAlpha OneMinusSrcAlpha

           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag

           #include "UnityCG.cginc"
           
           uniform half4 _Color;
           uniform sampler2D _MainTex;
           float4 _MainTexture_ST;

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
               o.uv = (v.uv * _MainTexture_ST.xy) + _MainTexture_ST.zw;
               return o;
           }

           half4 frag(VertexOutput i): COLOR //SV_Target
           {
               return tex2D(_MainTex, i.texcoord) * _Color;
           }
          
           ENDCG
       }
        
       Pass
       {
           //Blend SrcAlpha OneMinusSrcAlpha
           Cull front
           //Zwrite off

           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           
           #include "UnityCG.cginc"
           
           uniform float _Outline;
           uniform half4 _OutlineColor;

           struct VertexInput
           {
               float4 vertex: POSITION;
               //float4 texcoord: TEXCOORD0;
           };

           struct VertexOutput
           {
               float4 pos: SV_POSITION;
               //float4 texcoord: TEXCOORD0;
           };

           VertexOutput vert(VertexInput v)
           {
               VertexOutput o;
               o.pos = UnityObjectToClipPos(v.vertex * _Outline);
               return o;
           }

           half4 frag(VertexOutput i): SV_Target
           {
               return _OutlineColor;
           }
          
           ENDCG
       }
   }
}
