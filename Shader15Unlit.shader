Shader "Unlit/Shader15Unlit"
{
    Properties
    {
        _Color("Color",Color) = (1.0,1.0,1.0,1.0)
        _LineWidth("Line Width",Float) = 0.01
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

            fixed4 _Color;
            float _LineWidth;

            float onLine(float a, float b, float line_width, float edge_thickness)
            {
                float half_line_width = line_width * 0.5;
                return smoothstep(a - half_line_width - edge_thickness, a - half_line_width, b)- smoothstep(a + half_line_width, a + half_line_width + edge_thickness, b);
            }
            fixed4 frag(v2f i) : SV_Target
            {
                float2 pos = i.position.xy * 2;
                float2 uv = i.uv;
               
                fixed3 color = _Color*onLine(pos.y,sin(pos.x*UNITY_PI),0.05,0.002);
                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
