Shader "Unlit/GradientShader"
{
   Properties
   {
       _Color ("Main Color", Color) = (1,1,1,1)
       _MainTex("Main Texture", 2D) = "white"{}
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

           uniform sampler2D _MainTex;

           VertexOutput vert(VertexInput v)
           {
               VertexOutput o;
               o.pos = UnityObjectToClipPos(v.vertex);
               o.texcoord.xy = v.texcoord;
               return o;
           }

           half4 frag(VertexOutput i): COLOR 
           {
              float4 color = tex2D(_MainTex, i.texcoord) * _Color;
              color.a = i.texcoord.x;
              return color;
           }

           ENDCG
       }
   }
}
