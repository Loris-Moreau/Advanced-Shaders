Shader "Unlit/LineShader"
{
   Properties
   {
       _Color ("Main Color", Color) = (1,1,1,1)
       _MainTex("Main Texture", 2D) = "white"{}

       _Start("Start", Float) = 0.5
       _Width("Width", Float) = 0.5 

       _Start2("Second Start", Float) = 0.75
       _Width2("Second Width", Float) = 0.75

       //_Amount ("Amount of Lines", Int) = 1
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

           float _Start;
           float _Width;

           float _Start2;
           float _Width2;

           //int _Amount;


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

           float drawLine(float2 uv, float start, float end, float start2, float end2)
           {
              if(uv.x > start && uv.x < end)
              {
                  return 1;
              }
              if(uv.x > start2 && uv.x < end2)
              {
                  return 1;
              }

              return 0;
           }
           
           half4 frag(VertexOutput i): COLOR  
           {
              float4 color = tex2D(_MainTex, i.texcoord) * _Color;
              color.a = drawLine(i.texcoord, _Start, _Width, _Start2, _Width2);
              return color;
           }
          
           ENDCG
       }
   }
}
