Shader "Unlit/LineShader"
{
   Properties
   {
       _Color ("Main Color", Color) = (1,1,1,1)
       _MainTex("Main Texture", 2D) = "white"{}
       _Start("Start", Float) = 0.4;
       _Width("Width", Float) = 0.6;
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
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag

           uniform half4 _Color;
           uniform sampler2D _MainTex;
           float _Start;
           float _Width;

           struct VertexInput
           {
               float4 vertex: POSITION;
           };

           struct VertexOutput
           {
               float4 pos: SV_POSITION;
           };

           VertexOutput vert(VertexInput v)
           {
               VertexOutput o;
               o.pos = UnityObjectToClipPos(v.vertex);

               return o;
           }

           float drawLine(float2 uv, float start, float end)
           {
              if(uv.x > start && uv.x < end)
              {
                  return 1;
              }

              return 0;
           }
           
           half4 frag(VertexOutput i): COLOR  
           {
              float4 color = tex2D(_MainTex, i.texcoord) * _Color;
              color.a = drawLine(i.texcoord, _Start, _Width);
              return color;
           }
          
           ENDCG
       }
   }
}
