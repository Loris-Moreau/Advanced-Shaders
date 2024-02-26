Shader "Unlit/GradientShader"
{
   Properties
   {
       _Color ("Main Color", Color) = (1,1,1,1)
       _MainTex("Main Texture", 2D) = "white"{}
       _SecondTex("Second Texture", 2D) = "white"{}
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
           uniform sampler2D _SecondTex;

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

           half4 frag(VertexOutput i): COLOR    //half4 will be treated as a color
           {
              float4 color = tex2D(_MainTex, i.texcoord) * _Color;
              float4 color2 = tex2D(_SecondTex, i.texcoord) * _Color;
              color.a = i.texcoord.x;
              color2.a = i.texcoord.x;
              return color;
           }

           ENDCG
       }
   }
}
