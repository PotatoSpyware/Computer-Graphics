 Shader "Custom/WireFrame"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        // _LineWidth ("Width", Range(0, 5)) = 1;
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "Universal Pipeline"}
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes 
            {
                float4 positionOS : POSITION;
                float3 normal : NORMAL;
            };

            struct Varyings
			{
				float4 positionHCS : SV_POSITION;
			};

            Varyings vert (Attributes IN)
            {
                Varyings OUT;
                float3 tangent = IN.normal;

                float4 clipPos = UnityObjectToClipPos(IN.positionOS.xyz);
                float4 tangentClipPos = UnityObjectToClipPos(IN.positionOS.xyz + tangent);

                float4 screenPos = clipPos / clipPos.w * _ScreenParams;
                float4 tangentScreenPos = tangentClipPos / clipPos.w * _ScreenParams;

                float4 screenTangent = tangentScreenPos - screenPos;
                float4 screenNormal = normalize(float4(-screenTangent.y, screenTangent.x, 0, 1));

                float4 screenPosOut = screenPos + screenNormal * 20;
                float4 clipPosOut = screenPosOut / _ScreenParams * clipPos.w;

                OUT.vertex = clipPosOut;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
			{
                return _Color;
            }

            ENDHLSL
        }
    }
}
