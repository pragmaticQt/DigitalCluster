<Material name="aluminum_brushed" version="1.0">
    <MetaData >
        <Property formalName="Environment Map" name="uEnvironmentTexture" description="Environment texture for the material" type="Texture" filter="linear" minfilter="linearMipmapLinear" clamp="repeat" usage="environment" default="./maps/materials/spherical_checker.png" category="Material"/>
        <Property formalName="Enable Environment" name="uEnvironmentMappingEnabled" description="Enable environment mapping" type="Boolean" default="True" category="Material"/>
        <Property formalName="Baked Shadow Map" name="uBakedShadowTexture" description="Baked shadow texture for the material" type="Texture" filter="linear" minfilter="linearMipmapLinear" clamp="repeat" usage="shadow" default="./maps/materials/shadow.png" category="Material"/>
        <Property formalName="Shadow Mapping" name="uShadowMappingEnabled" description="Enable shadow mapping" type="Boolean" default="False" category="Material"/>
        <Property formalName="Brush Map" name="brush_texture" description="Brush texture for the material" type="Texture" filter="linear" minfilter="linearMipmapLinear" clamp="repeat" usage="brush" default="./maps/materials/brushed_full_contrast.png" category="Material"/>
        <Property formalName="Tiling" name="tiling" description="Texture tiling size" type="Vector" default="3 3 3" category="Material"/>
        <Property formalName="Roughness Map U" name="roughness_texture_u" description="Horizontal roughness texture" type="Texture" filter="linear" minfilter="linearMipmapLinear" clamp="repeat" usage="roughness" default="./maps/materials/brushed_full_contrast.png" category="Material"/>
        <Property formalName="Brush strength" name="brushing_strength" description="Strength of the brush stroke" type="Float" default="0.500000" category="Material"/>
        <Property formalName="Roughness Map V" name="roughness_texture_v" description="Vertical roughness texture" type="Texture" filter="linear" minfilter="linearMipmapLinear" clamp="repeat" usage="roughness" default="./maps/materials/brushed_full_contrast.png" category="Material"/>
        <Property formalName="Reflection Stretch" name="reflection_stretch" description="Reflection stretch" type="Float" default="0.500000" category="Material"/>
        <Property formalName="Metal Color" name="metal_color" description="Base color of the material" type="Color" default="0.95 0.95 0.95" category="Material"/>
        <Property formalName="Bump Map" name="bump_texture" description="Bump texture of the material" type="Texture" filter="linear" minfilter="linearMipmapLinear" clamp="repeat" usage="bump" default="./maps/materials/brushed_a.png" category="Material"/>
        <Property formalName="Bump Amount" name="bump_amount" description="Scale value for bump amount" type="Float" default="0.400000" category="Material"/>
    </MetaData>
    <Shaders type="GLSL" version="330">
    <Shader>
    <Shared>    </Shared>
<VertexShader>
        </VertexShader>
        <FragmentShader>

// add enum defines
#define mono_alpha 0
#define mono_average 1
#define mono_luminance 2
#define mono_maximum 3
#define wrap_clamp 0
#define wrap_repeat 1
#define wrap_mirrored_repeat 2
#define gamma_default 0
#define gamma_linear 1
#define gamma_srgb 2
#define scatter_reflect 0
#define scatter_transmit 1
#define scatter_reflect_transmit 2

#define QT3DS_ENABLE_UV0 1
#define QT3DS_ENABLE_WORLD_POSITION 1
#define QT3DS_ENABLE_TEXTAN 1
#define QT3DS_ENABLE_BINORMAL 1

#include "vertexFragmentBase.glsllib"

// set shader output
out vec4 fragColor;

// add structure defines
struct texture_coordinate_info
{
  vec3 position;
  vec3 tangent_u;
  vec3 tangent_v;
};


struct layer_result
{
  vec4 base;
  vec4 layer;
  mat3 tanFrame;
};


struct texture_return
{
  vec3 tint;
  float mono;
};


// temporary declarations
texture_coordinate_info tmp1;
float ftmp0;
float ftmp1;
float ftmp2;
 vec4 tmpShadowTerm;

layer_result layers[1];

#include "SSAOCustomMaterial.glsllib"
#include "sampleLight.glsllib"
#include "sampleProbe.glsllib"
#include "sampleArea.glsllib"
#include "luminance.glsllib"
#include "monoChannel.glsllib"
#include "fileBumpTexture.glsllib"
#include "transformCoordinate.glsllib"
#include "rotationTranslationScale.glsllib"
#include "textureCoordinateInfo.glsllib"
#include "weightedLayer.glsllib"
#include "fileTexture.glsllib"
#include "square.glsllib"
#include "calculateRoughness.glsllib"
#include "evalBakedShadowMap.glsllib"
#include "evalEnvironmentMap.glsllib"
#include "microfacetBSDF.glsllib"
#include "physGlossyBSDF.glsllib"
#include "simpleGlossyBSDF.glsllib"

bool evalTwoSided()
{
  return( false );
}

vec3 computeFrontMaterialEmissive()
{
  return( vec3( 0, 0, 0 ) );
}

void computeFrontLayerColor( in vec3 normal, in vec3 lightDir, in vec3 viewDir, in vec3 lightDiffuse, in vec3 lightSpecular, in float materialIOR, float aoFactor )
{
#if QT3DS_ENABLE_CG_LIGHTING
  layers[0].base += tmpShadowTerm * vec4( 0.0, 0.0, 0.0, 1.0 );
  layers[0].layer += tmpShadowTerm * microfacetBSDF( layers[0].tanFrame, lightDir, viewDir, lightSpecular, materialIOR, ftmp1, ftmp2, scatter_reflect );

#endif
}

void computeFrontAreaColor( in int lightIdx, in vec4 lightDiffuse, in vec4 lightSpecular )
{
#if QT3DS_ENABLE_CG_LIGHTING
  layers[0].base += tmpShadowTerm * vec4( 0.0, 0.0, 0.0, 1.0 );
  layers[0].layer += tmpShadowTerm * lightSpecular * sampleAreaGlossy( layers[0].tanFrame, varWorldPos, lightIdx, viewDir, ftmp1, ftmp2 );

#endif
}

void computeFrontLayerEnvironment( in vec3 normal, in vec3 viewDir, float aoFactor )
{
#if !QT3DS_ENABLE_LIGHT_PROBE
  layers[0].base += tmpShadowTerm * vec4( 0.0, 0.0, 0.0, 1.0 );
  layers[0].layer += tmpShadowTerm * microfacetSampledBSDF( layers[0].tanFrame, viewDir, ftmp1, ftmp2, scatter_reflect );

#else
  layers[0].base += tmpShadowTerm * vec4( 0.0, 0.0, 0.0, 1.0 );
  layers[0].layer += tmpShadowTerm * sampleGlossyAniso( layers[0].tanFrame, viewDir, ftmp1, ftmp2 );

#endif
}

vec3 computeBackMaterialEmissive()
{
  return( vec3(0, 0, 0) );
}

void computeBackLayerColor( in vec3 normal, in vec3 lightDir, in vec3 viewDir, in vec3 lightDiffuse, in vec3 lightSpecular, in float materialIOR, float aoFactor )
{
#if QT3DS_ENABLE_CG_LIGHTING
  layers[0].base += vec4( 0.0, 0.0, 0.0, 1.0 );
  layers[0].layer += vec4( 0.0, 0.0, 0.0, 1.0 );
#endif
}

void computeBackAreaColor( in int lightIdx, in vec4 lightDiffuse, in vec4 lightSpecular )
{
#if QT3DS_ENABLE_CG_LIGHTING
  layers[0].base += vec4( 0.0, 0.0, 0.0, 1.0 );
  layers[0].layer += vec4( 0.0, 0.0, 0.0, 1.0 );
#endif
}

void computeBackLayerEnvironment( in vec3 normal, in vec3 viewDir, float aoFactor )
{
#if !QT3DS_ENABLE_LIGHT_PROBE
  layers[0].base += vec4( 0.0, 0.0, 0.0, 1.0 );
  layers[0].layer += vec4( 0.0, 0.0, 0.0, 1.0 );
#else
  layers[0].base += vec4( 0.0, 0.0, 0.0, 1.0 );
  layers[0].layer += vec4( 0.0, 0.0, 0.0, 1.0 );
#endif
}

float computeIOR()
{
  return( false ? 1.0 : luminance( vec3( 1, 1, 1 ) ) );
}

float evalCutout()
{
  return( 1.000000 );
}

vec3 computeNormal()
{
  return( fileBumpTexture(bump_texture, bump_amount, mono_average, tmp1, vec2( 0.000000, 1.000000 ), vec2( 0.000000, 1.000000 ), wrap_repeat, wrap_repeat, normal ) );
}

void computeTemporaries()
{
     tmp1 = transformCoordinate( rotationTranslationScale( vec3( 0.000000, 0.000000, 0.000000 ), vec3( 0.000000, 0.000000, 0.000000 ), tiling ), textureCoordinateInfo( texCoord0, tangent, binormal ) );
     ftmp0 = fileTexture(brush_texture, vec3( 0.5, 0.5, 0.5 ), vec3( 0.5, 0.5, 0.5 ), mono_luminance, tmp1, vec2( 0.000000, 1.000000 ), vec2( 0.000000, 1.000000 ), wrap_repeat, wrap_repeat, gamma_default ).mono;
     ftmp1 = fileTexture(roughness_texture_u, vec3( 0.12, 0.12, 0.12 ), vec3( ( 0.800000*brushing_strength ) ), mono_luminance, tmp1, vec2( 0.000000, 1.000000 ), vec2( 0.000000, 1.000000 ), wrap_repeat, wrap_repeat, gamma_default ).mono;
     ftmp2 = fileTexture(roughness_texture_v, vec3( ( 0.150000+( 0.400000*reflection_stretch ) ) ), vec3( ( 0.100000+( reflection_stretch*0.300000 ) ) ), mono_luminance, tmp1, vec2( 0.000000, 1.000000 ), vec2( 0.000000, 1.000000 ), wrap_repeat, wrap_repeat, gamma_default ).mono;
     tmpShadowTerm = evalBakedShadowMap( texCoord0 );
}

vec4 computeLayerWeights( in float alpha )
{
  vec4 color;
  color = weightedLayer( ftmp0, vec4( metal_color, 1.0).rgb, layers[0].layer, layers[0].base, alpha );
  return color;
}


void initializeLayerVariables(void)
{
  // clear layers
  layers[0].base = vec4(0.0, 0.0, 0.0, 1.0);
  layers[0].layer = vec4(0.0, 0.0, 0.0, 1.0);
  layers[0].tanFrame = orthoNormalize( mat3( tangent, cross(normal, tangent), normal ) );
}

        </FragmentShader>
    </Shader>
    </Shaders>
<Passes >
        <ShaderKey value="4"/>
        <LayerKey count="1"/>
    <Pass >
    </Pass>
</Passes>
</Material>
