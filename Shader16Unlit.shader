Shader "Unlit/Shader16Unlit"
{
    Properties
    {
        _AxisColor("Axis Color",Color) = (0.8,0.8,0.8,1)
        _SweepColor("Sweep Color",Color) = (0.1,0.3,1,1)
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

            fixed4 _AxisColor;
            fixed4 _SweepColor;
            float circle(float2 pt, float2 center, float radius, float line_width)
            {
                float2 p = pt - center;
                float len = length(p);
                float half_line_width = line_width / 2.0;
                return step(radius - half_line_width, len) - step(radius + half_line_width, len);
            }
            float onLine(float a, float b, float line_width, float edge_thickness)
            {
                float half_line_width = line_width * 0.5;
                return smoothstep(a - half_line_width - edge_thickness, a - half_line_width, b)- smoothstep(a + half_line_width, a + half_line_width + edge_thickness, b);
            }
            fixed4 frag(v2f i) : SV_Target
            {               
                fixed3 color = onLine(i.uv.y,0.5,0.002,0.001)*_AxisColor;//xAxis
                color += onLine(i.uv.x, 0.5, 0.002, 0.001)*_AxisColor;//yAxis
                float2 center = 0.5;
                color += circle(i.uv, center, 0.3, 0.002)*_AxisColor;
                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
