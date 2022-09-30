Shader "Unlit/Shader10Unlit"
{
    Properties
    {
        _Color("Color",Color)=(1,1,0,1)
        _Size("Size",Float)=0.3
        _Radius("Radius",Float)=0.5
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Color;
            float _Size;
            float _Radius;

            struct v2f
            {
                float4 vertex:SV_POSITION;
                float4 position:TEXCOORD1;
                float2 uv:TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = v.vertex;
                o.uv = v.texcoord;
                return o;
            }

            float rect(float2 pt, float2 size, float2 center)
            {
                //Returns 1 when pt is inside a rectange defined by size and center
                //ie. (pt-center)>-halfsize and (pt-center)<halfsize
                float2 p = pt - center;
                float2 halfsize = size * 0.5;
                //float horz = step(-halfsize.x, p.x) - step(halfsize.x, p.x);
                float2 test = step(-halfsize, p) - step(halfsize, p);
                return test.x*test.y;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 center = float2(cos(_Time.y),sin(_Time.y))*_Radius;
                float2 pos = i.position.xy*2.0;
                float2 size = _Size;
                fixed3 color = _Color*rect(pos,size,center);
                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
