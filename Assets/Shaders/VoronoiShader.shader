Shader "Unlit/VoronoiShader"
{

Properties
{
   _Color("Color", Color) = (1, 0, 0, 1)
   _Color2("Second Color", Color) = (0.5, 0.5, 0.5, 1)
   _Noise("Noise Texture", 2D) = "white"{}
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

           #include "UnityCG.cginc"

           fixed4 _Color;
           fixed4 _Color2;
           uniform sampler2D _Noise;

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

           fixed4 frag (VertexOutput i) : SV_Target
           {
                fixed4 _ColorW = (1, 1, 1, 1);
                float4 noise = tex2D(_Noise, i.texcoord) * _ColorW;

                return noise;
           }

           ENDCG
       }
   }
}
