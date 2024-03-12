Shader "Custom/NormalVoronoiShader"
{ 
    Properties
    {
        _Color("Color",Color) = (1,1,1,1)
        _SecondaryColor("Secondary Color",Color) = (1,1,1,1)
        
        _FirstVarColor("Foam Color",Color) = (0.8, 0.75, 0.25 , 0.5)
        _SecondVarColor("Foam Secondary Color",Color) = (0.25, 0.75, 0.5, 0.25)
        
        _NoiseTexF("Noise Texture", 2D) = "black" {}
        
        _HeightFactor("Height", float) =0.1
        _Speed("Speed", float) = 0
        _Frequency("Frequency", float) = 0
        _Amplitude("Amplitude", float) = 0
        
        _SecondPass("Do Second Pass ? (0, 1)", int) = 1
    }
    
    SubShader
    {
        Tags { }
       
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            uniform half4 _Color;
            uniform half4 _SecondaryColor;
            
            uniform sampler2D _NoiseTexF;
            uniform float4 _NoiseTexF_ST;
            uniform sampler2D _NoiseTexS;
            uniform float4 _NoiseTexS_ST;
            
            uniform float _HeightFactor;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;
            
            #include "UnityCG.cginc"
            
            float4 vertexAnimFlag(float4 pos, float2 uv)
            {
                pos.y = pos.y + sin((uv.y - _Time.y * _Speed) * _Frequency) * _Amplitude / 100 ;// * uv.y;
                
                return pos;
            }
            
            struct VertexInput
            {
                float4 vertex:POSITION;
                float4 normal:NORMAL;
                float4 texcoord: TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos:SV_POSITION;
                float4 texcoord: TEXCOORD0;
                float4 displacement:COLOR; 
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                v.vertex = vertexAnimFlag(v.vertex,v.texcoord);
                float4 offset = v.normal * tex2Dlod(_NoiseTexF, v.texcoord*_NoiseTexF_ST) * (_HeightFactor / 100);
                offset *= (sin((v.texcoord.y - _Time.y * _Speed) * _Frequency) * _Amplitude);
                o.pos = UnityObjectToClipPos(v.vertex + offset);
                o.texcoord.xy = (v.texcoord.xy * _NoiseTexF_ST.xy + _NoiseTexF_ST.zw);
                
                float factor = (sin((v.texcoord.y - _Time.y * _Speed) * _Frequency) * _Amplitude);
                float color = (offset.y / (2 * factor)) + (factor / 2);
                float percentage = (v.vertex.y + color);
               
                o.displacement = sqrt(_Color * percentage + _SecondaryColor * (1 - percentage));
                
                return o;
            }
            
            half4 frag(VertexOutput i) : COLOR
            {
                return i.displacement;
            }
            ENDCG
        }


//----------------------------------------Second Pass----------------------------------------
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            uniform half4 _FirstVarColor;
            uniform half4 _SecondVarColor;
            
            uniform sampler2D _NoiseTexF;
            uniform float4 _NoiseTexF_ST;
            uniform sampler2D _NoiseTexS;
            uniform float4 _NoiseTexS_ST;
            
            uniform float _HeightFactor;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;

            uniform int _SecondPass;
            #include "UnityCG.cginc"

            
            bool1 DoSecondPass()
            {
                if(_SecondPass == 0)
                {
                    return false;
                }
                return true;
            }
            
            float4 vertexAnimFlag(float4 pos, float2 uv)
            {
                if(DoSecondPass())
                {
                    pos.y = pos.y + sin((uv.y - _Time.y * _Speed) * _Frequency) * _Amplitude / 100 ;// * uv.y;
                }
                return pos;
            }
            
            struct VertexInput
            {
                float4 vertex: POSITION;
                float4 normal: NORMAL;
                float4 texcoord: TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos: SV_POSITION;
                float4 texcoord: TEXCOORD0;
                float4 displacement: COLOR; 
            };

            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                
                if(DoSecondPass())
                {
                    v.vertex = vertexAnimFlag(v.vertex,v.texcoord);
                    float4 offset = v.normal * tex2Dlod(_NoiseTexF, v.texcoord*_NoiseTexF_ST) * ((_HeightFactor + 1.5f) / 100);
                    offset *= (sin((v.texcoord.y - _Time.y * _Speed) * _Frequency) * _Amplitude);
                    o.pos = UnityObjectToClipPos(v.vertex + offset);
                    o.texcoord.xy = (v.texcoord.xy * _NoiseTexF_ST.xy + _NoiseTexF_ST.zw);
                    
                    float factor = (sin((v.texcoord.y - _Time.y * _Speed) * _Frequency) * _Amplitude);
                    float color = (offset.y / (2 * factor)) + (factor / 2);
                    float percentage = (v.vertex.y + color);
                    
                    o.displacement = sqrt(_FirstVarColor * percentage + _SecondVarColor * (1 - percentage)); 
                }
                
                return o;
            }
            
            half4 frag(VertexOutput i) : COLOR
            {
                if(DoSecondPass())
                {
                    half4 color = i.displacement;
                    color.a -= _HeightFactor / 100;
                                    
                    return color;
                }
                else
                {
                    return DoSecondPass();
                }
            }
            ENDCG
        }
    }
}
