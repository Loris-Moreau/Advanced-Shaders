Shader "Unlit/SqrtShader"
{
   Properties
   {
       _Color ("Main Color", Color) = (1,1,1,1)
       _MainTex("Main Texture", 2D) = "white"{}

       _UseSqrt("Use Square Root ? (0, 1)", Int) = 1
       _UseSin("Use Sin ? (0, 1)", Int) = 0
       _UseTan("Use Tan ? (0, 1)", Int) = 0
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
           bool _UseSqrt;
           bool _UseSin;
           bool _UseTan;

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

           half4 frag(VertexOutput i): COLOR 
           {
              float4 color = tex2D(_MainTex, i.texcoord) * _Color;

              if(_UseSqrt == 1)
              {
                color.a = sqrt(i.texcoord.x);
              }
              else if(_UseSin == 1)
              {
                color.a = sin(i.texcoord.x * 20);
              }
              else if(_UseTan == 1)
              {
                color.a = tan(i.texcoord.x * 20);
              }
              else 
              {
                float4 color = tex2D(_MainTex, i.texcoord) * _Color;
                color.a = i.texcoord.x;
              }

              return color;
           }

           ENDCG
       }
   }
}
