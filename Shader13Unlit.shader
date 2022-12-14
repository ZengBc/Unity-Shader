Shader "Unlit/Shader13Unlit"
{
    Properties
    {
        _Color("Square Color",Color)=(1.0,1.0,0,1.0)
        _Size("Size",Float)=0.3
        //_Radius("Radius",Float)=0.5
        _Anchor("Anchor",Vector)=(0.0,0.0,0.5,0.5)
        _TileCount("TileCount",Int)=6
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
            //float _Radius;
            float4 _Anchor;
            float _TileCount;

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

            float rect(float2 pt, float2 anchor, float2 size, float2 center)
            {
                //Returns 1 when pt is inside a rectange defined by size and center
                //ie. (pt-center)>-halfsize and (pt-center)<halfsize
                float2 p = pt - center;
                float2 halfsize = size * 0.5;
                float horz = step(-halfsize.x - anchor.x, p.x) - step(halfsize.x - anchor.x, p.x);
                float vert = step(-halfsize.y - anchor.y, p.y) - step(halfsize.y - anchor.y, p.y);
                return horz * vert;
            }

            float2x2 getRotationMatrix(float theta)
            {
                float s = sin(theta);
                float c = cos(theta);
                return float2x2(c, -s, s, c);
            }

            float2x2 getScaleMatrix(float scale)
            {
                return float2x2(scale, 0, 0, scale);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 center = _Anchor.zw;
                float2 pos = frac(i.uv*_TileCount);

                float2x2 matr = getRotationMatrix(_Time.y);
                float2x2 mats = getScaleMatrix((sin(_Time.y) + 1) / 3 + 0.5);
                float2x2 mat = mul(matr, mats);

                float2 pt = mul(mat, pos-center)+center;
                float3 color = _Color*rect(pt,_Anchor.xy,float2(_Size,_Size),center);
                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
