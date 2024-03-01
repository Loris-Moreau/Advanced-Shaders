Shader"Custom/GradientShader"
{
   Properties
   {
       _Color ("Main Color", Color) = (1,1,1,1)
       _MainTex("Texture", 2D) = "white"{}
       _SquareRoot("Use root", float) = 1
   }
   SubShader
   {
    Tags{
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
           uniform float4 _MainTex_ST;
           uniform float _SquareRoot;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 texcoord : TEXCOORD0;
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw;
                return o;
            }

            half4 frag(VertexOutput i) : COLOR //half4 will be treated as a color
            {
                half4 color = tex2D(_MainTex, i.texcoord) * _Color;
                if (_SquareRoot == 1) color.a = sqrt(i.texcoord.x);
                else color.a = i.texcoord.x;
                return color;
            }
          
            ENDCG
        }
    }
}
