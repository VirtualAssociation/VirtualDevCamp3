// Shader created with Shader Forge v1.28 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.28;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True;n:type:ShaderForge.SFN_Final,id:4795,x:32666,y:32680,varname:node_4795,prsc:2|emission-2393-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:31786,y:32717,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2393,x:32459,y:32781,varname:node_2393,prsc:2|A-6551-OUT,B-2053-RGB,C-9248-OUT;n:type:ShaderForge.SFN_VertexColor,id:2053,x:32256,y:32940,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Vector1,id:9248,x:32256,y:33084,varname:node_9248,prsc:2,v1:0.25;n:type:ShaderForge.SFN_TexCoord,id:2174,x:31243,y:32516,varname:node_2174,prsc:2,uv:0;n:type:ShaderForge.SFN_Multiply,id:6551,x:32058,y:32626,varname:node_6551,prsc:2|A-4562-OUT,B-6074-RGB,C-6915-RGB;n:type:ShaderForge.SFN_RemapRange,id:6856,x:31432,y:32516,varname:node_6856,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-2174-UVOUT;n:type:ShaderForge.SFN_Length,id:6607,x:31623,y:32516,varname:node_6607,prsc:2|IN-6856-OUT;n:type:ShaderForge.SFN_OneMinus,id:4562,x:31786,y:32516,varname:node_4562,prsc:2|IN-6607-OUT;n:type:ShaderForge.SFN_Color,id:6915,x:31786,y:32939,ptovrint:False,ptlb:TintColor,ptin:_TintColor,varname:node_6915,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;proporder:6074-6915;pass:END;sub:END;*/

Shader "Shader Forge/FogParticle" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _TintColor ("TintColor", Color) = (1,1,1,1)
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float4 _TintColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 emissive = (((1.0 - length((i.uv0*2.0+-1.0)))*_MainTex_var.rgb*_TintColor.rgb)*i.vertexColor.rgb*0.25);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0.5,0.5,0.5,1));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
