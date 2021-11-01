// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShader_HandIntersect"
{
	Properties
	{
		_ASEOutlineWidth("Outline Width", Float) = 0
		_Smoothness("Smoothness", Range(0 , 1)) = 0
		_Metallic("Metallic", Range(0 , 1)) = 0
		_DepthFadeDistance("Depth Fade Distance", Float) = 1
		_Color("Color", Color) = (0.6415094,0.239053,0.239053,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_IntersectionColor("Intersection Color", Color) = (0.4338235,0.4377282,1,0)
		[HideInInspector] _texcoord("", 2D) = "white" {}
		[HideInInspector] __dirty("", Int) = 1
	}

		SubShader
		{
			Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0"}
			ZWrite Off
			ZTest Always
			Cull Back
			CGPROGRAM
			#pragma target 3.0
			#pragma surface outlineSurf Outline nofog alpha:fade  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 

			#include "UnityCG.cginc"


			struct Input
			{
				float4 screenPos;
			};
			uniform float4 _IntersectionColor;
			uniform sampler2D _CameraDepthTexture;
			uniform float _DepthFadeDistance;
			uniform half _ASEOutlineWidth;

			void outlineVertexDataFunc(inout appdata_full v, out Input o)
			{
				UNITY_INITIALIZE_OUTPUT(Input, o);
				v.vertex.xyz += (v.normal * _ASEOutlineWidth);
			}
			inline half4 LightingOutline(SurfaceOutput s, half3 lightDir, half atten) { return half4 (0,0,0, s.Alpha); }
			void outlineSurf(Input i, inout SurfaceOutput o)
			{
				float4 ase_screenPos = float4(i.screenPos.xyz , i.screenPos.w + 0.00000000001);
				float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
				ase_screenPosNorm.z = (UNITY_NEAR_CLIP_VALUE >= 0) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth89 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
				float distanceDepth89 = abs((screenDepth89 - LinearEyeDepth(ase_screenPosNorm.z)) / ((0.1 * _DepthFadeDistance)));
				float screenDepth74 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
				float distanceDepth74 = abs((screenDepth74 - LinearEyeDepth(ase_screenPosNorm.z)) / (_DepthFadeDistance));
				o.Emission = ((_IntersectionColor).rgb + (1.0 - saturate(distanceDepth89)));
				o.Alpha = (1.0 - saturate(distanceDepth74));
			}
			ENDCG


			Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+1" }
			Cull Back
			ZWrite On
			ZTest LEqual
			CGPROGRAM
			#pragma target 3.0
			#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
			struct Input
			{
				float2 uv_texcoord;
			};

			uniform sampler2D _TextureSample0;
			uniform float4 _Color;
			uniform float _Metallic;
			uniform float _Smoothness;

			void vertexDataFunc(inout appdata_full v, out Input o)
			{
				UNITY_INITIALIZE_OUTPUT(Input, o);
				float3 PenetrateDepthFade75 = 0;
				v.vertex.xyz += PenetrateDepthFade75;
			}

			void surf(Input i , inout SurfaceOutputStandard o)
			{
				o.Albedo = (tex2D(_TextureSample0, i.uv_texcoord) * _Color).rgb;
				o.Metallic = _Metallic;
				o.Smoothness = _Smoothness;
				o.Alpha = 1;
			}

			ENDCG
		}
			Fallback "Diffuse"
				CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
222;100;1302;594;1949.888;-540.5113;1.511143;True;True
Node;AmplifyShaderEditor.CommentaryNode;65;-1498.923,635.6113;Float;False;1273.249;613.1945;;12;73;66;70;69;74;68;86;89;92;91;94;95;First Pass only renders intersection;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-1446.677,953.0531;Float;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-1470.757,1135.637;Float;False;Property;_DepthFadeDistance;Depth Fade Distance;2;0;Create;True;0;0;False;0;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1257.784,957.5866;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;89;-1105.159,953.0532;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;94;-848.265,959.0977;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;66;-1434.279,684.9986;Float;False;Property;_IntersectionColor;Intersection Color;6;0;Create;True;0;0;False;0;0.4338235,0.4377282,1,0;0.485294,0.4888436,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;74;-1239.857,1118.337;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;95;-704.7066,963.6312;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;73;-1194.263,684.3112;Float;True;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;69;-980.712,1120.794;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-804.4415,727.8929;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;70;-577.3594,1121.442;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OutlineNode;76;-211.6828,749.5011;Float;False;0;True;Transparent;2;7;Back;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-993.4202,31.69263;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-694.3745,-57.55634;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;5daedc5a8f1008648bcfb5931d482c94;5daedc5a8f1008648bcfb5931d482c94;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;24;-1570.804,1411.191;Float;False;1620.257;641.8902;Comment;11;12;21;15;14;17;16;18;13;22;20;19;X-Ray;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;7;-631,176;Float;False;Property;_Color;Color;3;0;Create;True;0;0;False;0;0.6415094,0.239053,0.239053,0;0.6415094,0.239053,0.239053,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;23.69298,743.937;Float;False;PenetrateDepthFade;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-697.6226,1753.812;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;14;-1214.857,1461.191;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-46.80989,425.9488;Float;False;75;PenetrateDepthFade;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;15;-996.2571,1842.691;Float;False;FLOAT;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-275.6032,264.7348;Float;False;Property;_Smoothness;Smoothness;0;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-1323.757,1723.491;Float;False;Property;_XRayColor;X-Ray Color;7;0;Create;True;0;0;False;0;0,1,0.9784226,0;0,1,0.9784226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-703.754,1497.169;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1518.051,1466.702;Float;False;Property;_XRayScale;X-Ray Scale;8;0;Create;True;0;0;False;0;1.240678;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-193.5469,1643.364;Float;False;XRay;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-276.9032,184.1347;Float;False;Property;_Metallic;Metallic;1;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1122.367,1938.082;Float;False;Property;_XRayIntensity;X-Ray Intensity;10;0;Create;True;0;0;False;0;5.183608;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;52;-1073.804,177.8141;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-344.6,-96.3;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;13;-452.357,1619.591;Float;False;0;True;Transparent;2;7;Back;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1519.151,1595.802;Float;False;Property;_XRayPower;X-Ray Power;5;0;Create;True;0;0;False;0;4.588235;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1520.804,1530.945;Float;False;Property;_XRayBias;X-Ray Bias;9;0;Create;True;0;0;False;0;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;482.7,80.59997;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Interactive_HandIntersect;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;1;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;91;0;92;0
WireConnection;91;1;68;0
WireConnection;89;0;91;0
WireConnection;94;0;89;0
WireConnection;74;0;68;0
WireConnection;95;0;94;0
WireConnection;73;0;66;0
WireConnection;69;0;74;0
WireConnection;86;0;73;0
WireConnection;86;1;95;0
WireConnection;70;0;69;0
WireConnection;76;0;86;0
WireConnection;76;2;70;0
WireConnection;11;1;10;0
WireConnection;75;0;76;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;16;2;17;0
WireConnection;14;1;19;0
WireConnection;14;2;20;0
WireConnection;14;3;21;0
WireConnection;15;0;12;0
WireConnection;18;0;14;0
WireConnection;18;1;12;0
WireConnection;22;0;13;0
WireConnection;4;0;11;0
WireConnection;4;1;7;0
WireConnection;13;0;18;0
WireConnection;13;2;16;0
WireConnection;0;0;4;0
WireConnection;0;3;8;0
WireConnection;0;4;9;0
WireConnection;0;11;23;0
ASEEND*/
//CHKSM=AF82E78D30237678FA19A18935E971A97E2F8E7C