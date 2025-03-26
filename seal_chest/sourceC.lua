local seexports = {seal_items = false}
local function seelangProcessExports()
  for k in pairs(seexports) do
    local res = getResourceFromName(k)
    if res and getResourceState(res) == "running" then
      seexports[k] = exports[k]
    else
      seexports[k] = false
    end
  end
end
seelangProcessExports()
if triggerServerEvent then
  addEventHandler("onClientResourceStart", getRootElement(), seelangProcessExports, true, "high+9999999999")
end
if triggerClientEvent then
  addEventHandler("onResourceStart", getRootElement(), seelangProcessExports, true, "high+9999999999")
end
local seelangStatImgHand = false
local seelangStaticImage = {}
local seelangStaticImageToc = {}
local seelangStaticImageUsed = {}
local seelangStaticImageDel = {}
local processSeelangStaticImage = {}
seelangStaticImageToc[0] = true
seelangStaticImageToc[1] = true
seelangStaticImageToc[2] = true
seelangStaticImageToc[3] = true
seelangStaticImageToc[4] = true
seelangStaticImageToc[5] = true
seelangStaticImageToc[6] = true
seelangStaticImageToc[7] = true
seelangStaticImageToc[8] = true
seelangStaticImageToc[9] = true
seelangStaticImageToc[10] = true
local seelangStatImgPre
function seelangStatImgPre()
  local now = getTickCount()
  if seelangStaticImageUsed[0] then
    seelangStaticImageUsed[0] = false
    seelangStaticImageDel[0] = false
  elseif seelangStaticImage[0] then
    if seelangStaticImageDel[0] then
      if now >= seelangStaticImageDel[0] then
        if isElement(seelangStaticImage[0]) then
          destroyElement(seelangStaticImage[0])
        end
        seelangStaticImage[0] = nil
        seelangStaticImageDel[0] = false
        seelangStaticImageToc[0] = true
        return
      end
    else
      seelangStaticImageDel[0] = now + 5000
    end
  else
    seelangStaticImageToc[0] = true
  end
  if seelangStaticImageUsed[1] then
    seelangStaticImageUsed[1] = false
    seelangStaticImageDel[1] = false
  elseif seelangStaticImage[1] then
    if seelangStaticImageDel[1] then
      if now >= seelangStaticImageDel[1] then
        if isElement(seelangStaticImage[1]) then
          destroyElement(seelangStaticImage[1])
        end
        seelangStaticImage[1] = nil
        seelangStaticImageDel[1] = false
        seelangStaticImageToc[1] = true
        return
      end
    else
      seelangStaticImageDel[1] = now + 5000
    end
  else
    seelangStaticImageToc[1] = true
  end
  if seelangStaticImageUsed[2] then
    seelangStaticImageUsed[2] = false
    seelangStaticImageDel[2] = false
  elseif seelangStaticImage[2] then
    if seelangStaticImageDel[2] then
      if now >= seelangStaticImageDel[2] then
        if isElement(seelangStaticImage[2]) then
          destroyElement(seelangStaticImage[2])
        end
        seelangStaticImage[2] = nil
        seelangStaticImageDel[2] = false
        seelangStaticImageToc[2] = true
        return
      end
    else
      seelangStaticImageDel[2] = now + 5000
    end
  else
    seelangStaticImageToc[2] = true
  end
  if seelangStaticImageUsed[3] then
    seelangStaticImageUsed[3] = false
    seelangStaticImageDel[3] = false
  elseif seelangStaticImage[3] then
    if seelangStaticImageDel[3] then
      if now >= seelangStaticImageDel[3] then
        if isElement(seelangStaticImage[3]) then
          destroyElement(seelangStaticImage[3])
        end
        seelangStaticImage[3] = nil
        seelangStaticImageDel[3] = false
        seelangStaticImageToc[3] = true
        return
      end
    else
      seelangStaticImageDel[3] = now + 5000
    end
  else
    seelangStaticImageToc[3] = true
  end
  if seelangStaticImageUsed[4] then
    seelangStaticImageUsed[4] = false
    seelangStaticImageDel[4] = false
  elseif seelangStaticImage[4] then
    if seelangStaticImageDel[4] then
      if now >= seelangStaticImageDel[4] then
        if isElement(seelangStaticImage[4]) then
          destroyElement(seelangStaticImage[4])
        end
        seelangStaticImage[4] = nil
        seelangStaticImageDel[4] = false
        seelangStaticImageToc[4] = true
        return
      end
    else
      seelangStaticImageDel[4] = now + 5000
    end
  else
    seelangStaticImageToc[4] = true
  end
  if seelangStaticImageUsed[5] then
    seelangStaticImageUsed[5] = false
    seelangStaticImageDel[5] = false
  elseif seelangStaticImage[5] then
    if seelangStaticImageDel[5] then
      if now >= seelangStaticImageDel[5] then
        if isElement(seelangStaticImage[5]) then
          destroyElement(seelangStaticImage[5])
        end
        seelangStaticImage[5] = nil
        seelangStaticImageDel[5] = false
        seelangStaticImageToc[5] = true
        return
      end
    else
      seelangStaticImageDel[5] = now + 5000
    end
  else
    seelangStaticImageToc[5] = true
  end
  if seelangStaticImageUsed[6] then
    seelangStaticImageUsed[6] = false
    seelangStaticImageDel[6] = false
  elseif seelangStaticImage[6] then
    if seelangStaticImageDel[6] then
      if now >= seelangStaticImageDel[6] then
        if isElement(seelangStaticImage[6]) then
          destroyElement(seelangStaticImage[6])
        end
        seelangStaticImage[6] = nil
        seelangStaticImageDel[6] = false
        seelangStaticImageToc[6] = true
        return
      end
    else
      seelangStaticImageDel[6] = now + 5000
    end
  else
    seelangStaticImageToc[6] = true
  end
  if seelangStaticImageUsed[7] then
    seelangStaticImageUsed[7] = false
    seelangStaticImageDel[7] = false
  elseif seelangStaticImage[7] then
    if seelangStaticImageDel[7] then
      if now >= seelangStaticImageDel[7] then
        if isElement(seelangStaticImage[7]) then
          destroyElement(seelangStaticImage[7])
        end
        seelangStaticImage[7] = nil
        seelangStaticImageDel[7] = false
        seelangStaticImageToc[7] = true
        return
      end
    else
      seelangStaticImageDel[7] = now + 5000
    end
  else
    seelangStaticImageToc[7] = true
  end
  if seelangStaticImageUsed[8] then
    seelangStaticImageUsed[8] = false
    seelangStaticImageDel[8] = false
  elseif seelangStaticImage[8] then
    if seelangStaticImageDel[8] then
      if now >= seelangStaticImageDel[8] then
        if isElement(seelangStaticImage[8]) then
          destroyElement(seelangStaticImage[8])
        end
        seelangStaticImage[8] = nil
        seelangStaticImageDel[8] = false
        seelangStaticImageToc[8] = true
        return
      end
    else
      seelangStaticImageDel[8] = now + 5000
    end
  else
    seelangStaticImageToc[8] = true
  end
  if seelangStaticImageUsed[9] then
    seelangStaticImageUsed[9] = false
    seelangStaticImageDel[9] = false
  elseif seelangStaticImage[9] then
    if seelangStaticImageDel[9] then
      if now >= seelangStaticImageDel[9] then
        if isElement(seelangStaticImage[9]) then
          destroyElement(seelangStaticImage[9])
        end
        seelangStaticImage[9] = nil
        seelangStaticImageDel[9] = false
        seelangStaticImageToc[9] = true
        return
      end
    else
      seelangStaticImageDel[9] = now + 5000
    end
  else
    seelangStaticImageToc[9] = true
  end
  if seelangStaticImageUsed[10] then
    seelangStaticImageUsed[10] = false
    seelangStaticImageDel[10] = false
  elseif seelangStaticImage[10] then
    if seelangStaticImageDel[10] then
      if now >= seelangStaticImageDel[10] then
        if isElement(seelangStaticImage[10]) then
          destroyElement(seelangStaticImage[10])
        end
        seelangStaticImage[10] = nil
        seelangStaticImageDel[10] = false
        seelangStaticImageToc[10] = true
        return
      end
    else
      seelangStaticImageDel[10] = now + 5000
    end
  else
    seelangStaticImageToc[10] = true
  end
  if seelangStaticImageToc[0] and seelangStaticImageToc[1] and seelangStaticImageToc[2] and seelangStaticImageToc[3] and seelangStaticImageToc[4] and seelangStaticImageToc[5] and seelangStaticImageToc[6] and seelangStaticImageToc[7] and seelangStaticImageToc[8] and seelangStaticImageToc[9] and seelangStaticImageToc[10] then
    seelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
  end
end
processSeelangStaticImage[0] = function()
  if not isElement(seelangStaticImage[0]) then
    seelangStaticImageToc[0] = false
    seelangStaticImage[0] = dxCreateTexture("files/shad.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[1] = function()
  if not isElement(seelangStaticImage[1]) then
    seelangStaticImageToc[1] = false
    seelangStaticImage[1] = dxCreateTexture("files/shine.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[2] = function()
  if not isElement(seelangStaticImage[2]) then
    seelangStaticImageToc[2] = false
    seelangStaticImage[2] = dxCreateTexture("files/shine2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[3] = function()
  if not isElement(seelangStaticImage[3]) then
    seelangStaticImageToc[3] = false
    seelangStaticImage[3] = dxCreateTexture("files/bogyesz.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[4] = function()
  if not isElement(seelangStaticImage[4]) then
    seelangStaticImageToc[4] = false
    seelangStaticImage[4] = dxCreateTexture("files/logof.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[5] = function()
  if not isElement(seelangStaticImage[5]) then
    seelangStaticImageToc[5] = false
    seelangStaticImage[5] = dxCreateTexture("files/logo.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[6] = function()
  if not isElement(seelangStaticImage[6]) then
    seelangStaticImageToc[6] = false
    seelangStaticImage[6] = dxCreateTexture("files/csilla.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[7] = function()
  if not isElement(seelangStaticImage[7]) then
    seelangStaticImageToc[7] = false
    seelangStaticImage[7] = dxCreateTexture("files/itemHover.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[8] = function()
  if not isElement(seelangStaticImage[8]) then
    seelangStaticImageToc[8] = false
    seelangStaticImage[8] = dxCreateTexture("files/win.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[9] = function()
  if not isElement(seelangStaticImage[9]) then
    seelangStaticImageToc[9] = false
    seelangStaticImage[9] = dxCreateTexture("files/item.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[10] = function()
  if not isElement(seelangStaticImage[10]) then
    seelangStaticImageToc[10] = false
    seelangStaticImage[10] = dxCreateTexture("files/iname.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
local seelangCondHandlState2 = false
local function seelangCondHandl2(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState2 then
    seelangCondHandlState2 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderChest, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderChest)
    end
  end
end
local seelangCondHandlState1 = false
local function seelangCondHandl1(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState1 then
    seelangCondHandlState1 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderBogyesz, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderBogyesz)
    end
  end
end
local seelangCondHandlState0 = false
local function seelangCondHandl0(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState0 then
    seelangCondHandlState0 = cond
    if cond then
      addEventHandler("onClientRender", getRootElement(), renderChest, true, prio)
    else
      removeEventHandler("onClientRender", getRootElement(), renderChest)
    end
  end
end
local screenX, screenY = guiGetScreenSize()
local objectPreviewSource = " float3 sElementOffset = float3(0,0,0); float3 sWorldOffset = float3(0,0,0); float3 sCameraPosition = float3(0,0,0); float3 sCameraForward = float3(0,0,0); float3 sCameraUp = float3(0,0,0); float sFov = 1; float sAspect = 1; float2 sMoveObject2D = float2(0,0); float2 sScaleObject2D = float2(1,1); float2 sRealScale2D = float2(1,1); float sAlphaMult = 1; float sProjZMult = 2; float4 sColorFilter1 = float4(0,0,0,0); float4 sColorFilter2 = float4(0,0,0,0); texture gTexture0 < string textureState=\"0,Texture\"; >; float4x4 gWorld : WORLD; float4x4 gProjection : PROJECTION; texture secondRT < string renderTarget = \"yes\"; >; int gLighting < string renderState=\"LIGHTING\"; >; float4 gGlobalAmbient < string renderState=\"AMBIENT\"; >; int gAmbientMaterialSource < string renderState=\"AMBIENTMATERIALSOURCE\"; >; int gDiffuseMaterialSource < string renderState=\"DIFFUSEMATERIALSOURCE\"; >; int gEmissiveMaterialSource < string renderState=\"EMISSIVEMATERIALSOURCE\"; >; float4 gMaterialAmbient < string materialState=\"Ambient\"; >; float4 gMaterialDiffuse < string materialState=\"Diffuse\"; >; float4 gMaterialSpecular < string materialState=\"Specular\"; >; float4 gMaterialEmissive < string materialState=\"Emissive\"; >; int CUSTOMFLAGS <string createNormals = \"yes\"; string skipUnusedParameters = \"yes\"; >; float4 gTextureFactor < string renderState=\"TEXTUREFACTOR\"; >; sampler Sampler0 = sampler_state { Texture = (gTexture0); }; struct VSInput { float3 Position : POSITION0; float4 Diffuse : COLOR0; float2 TexCoord0 : TEXCOORD0; }; struct PSInput { float4 Position : POSITION0; float4 Diffuse : COLOR0; float2 TexCoord0 : TEXCOORD0; float4 vPosition : TEXCOORD1; float2 Depth : TEXCOORD2; }; float4x4 createViewMatrix( float3 pos, float3 fwVec, float3 upVec ) { float3 zaxis = normalize( fwVec); float3 xaxis = normalize( cross( -upVec, zaxis )); float3 yaxis = cross( xaxis, zaxis ); float4x4 viewMatrix = { float4( xaxis.x, yaxis.x, zaxis.x, 0 ), float4( xaxis.y, yaxis.y, zaxis.y, 0 ), float4( xaxis.z, yaxis.z, zaxis.z, 0 ), float4(-dot( xaxis, pos ), -dot( yaxis, pos ), -dot( zaxis, pos ), 1 ) }; return viewMatrix; } float4x4 createProjectionMatrix(float near_plane, float far_plane, float fov_horiz, float fov_aspect, float2 ss_mov, float2 ss_scale) { float h, w, Q; w = 1/tan(fov_horiz * 0.5); h = w/fov_aspect; Q = far_plane/(far_plane - near_plane); float4x4 projectionMatrix = { float4(w * ss_scale.x, 0, 0, 0), float4(0, h * ss_scale.y, 0, 0), float4(ss_mov.x, ss_mov.y, Q, 1), float4(0, 0, -Q*near_plane, 0) }; return projectionMatrix; } float4 MTACalcGTABuildingDiffuse( float4 InDiffuse ) { float4 OutDiffuse; if ( !gLighting ) { OutDiffuse = InDiffuse; } else { float4 ambient = gAmbientMaterialSource == 0 ? gMaterialAmbient : InDiffuse; float4 diffuse = gDiffuseMaterialSource == 0 ? gMaterialDiffuse : InDiffuse; float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse; OutDiffuse = gGlobalAmbient * saturate( ambient + emissive ); OutDiffuse.a *= diffuse.a; } return OutDiffuse; } PSInput VertexShaderFunction(VSInput VS) { PSInput PS = (PSInput)0; float4 wPos = mul(float4(VS.Position, 1), gWorld); wPos.xyz += sWorldOffset; float4x4 sView = createViewMatrix(sCameraPosition, sCameraForward, sCameraUp); float4 vPos = mul(wPos, sView); vPos.xzy += sElementOffset; float sFarClip = gProjection[3][2] / (1 - gProjection[2][2]); float sNearClip = gProjection[3][2] / - gProjection[2][2]; float4x4 sProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sAspect, sMoveObject2D, sScaleObject2D); float4x4 tProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sAspect, float2(0,0), sScaleObject2D / sRealScale2D); PS.Position = mul(vPos, sProjection); PS.vPosition = mul(vPos, tProjection); PS.Depth = float2(PS.Position.z, PS.Position.w); PS.TexCoord0 = VS.TexCoord0; float Diffa = MTACalcGTABuildingDiffuse(VS.Diffuse).a; PS.Diffuse = float4(0.35, 0.35, 0.3, Diffa); return PS; } struct Pixel { float4 Color : COLOR0; float4 Extra : COLOR1; float Depth : DEPTH0; }; float rM = 3; float gM = 3; float bM = 3; Pixel PixelShaderFunction(PSInput PS) { Pixel output; float4 texel = tex2D(Sampler0, PS.TexCoord0); output.Color = float4(0, 0, 0, min(min(texel.a * PS.Diffuse.a, 0.006105), sAlphaMult)); float4 finalColor = texel * PS.Diffuse; float2 scrCoord =(PS.vPosition.xy / PS.vPosition.w) * float2(0.5, -0.5) + 0.5; output.Depth = ((PS.Depth.x * 0.00625 * sProjZMult) / PS.Depth.y); if ((scrCoord.x > 1) || (scrCoord.x < 0) || (scrCoord.y > 1) || (scrCoord.y < 0)) { output.Depth = 1; output.Color = 0; } output.Extra = saturate(finalColor); output.Extra.rgb += output.Extra.rgb * sColorFilter1.rgb * sColorFilter1.a; output.Extra.rgb += output.Extra.rgb * sColorFilter2.rgb * sColorFilter2.a; output.Extra.r *= rM; output.Extra.g *= gM; output.Extra.b *= bM; output.Extra.a *= sAlphaMult; return output; } technique fx_pre_object_MRT { pass P0 { FogEnable = false; AlphaBlendEnable = true; AlphaRef = 1; SeparateAlphaBlendEnable = true; SrcBlendAlpha = SrcAlpha; DestBlendAlpha = One; VertexShader = compile vs_2_0 VertexShaderFunction(); PixelShader = compile ps_2_0 PixelShaderFunction(); } } technique fallback { pass P0 { } } "
function createElementMatrix(rx, ry, rz)
  local rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
  return {
    {
      math.cos(rz) * math.cos(ry) - math.sin(rz) * math.sin(rx) * math.sin(ry),
      math.cos(ry) * math.sin(rz) + math.cos(rz) * math.sin(rx) * math.sin(ry),
      -math.cos(rx) * math.sin(ry),
      0
    },
    {
      -math.cos(rx) * math.sin(rz),
      math.cos(rz) * math.cos(rx),
      math.sin(rx),
      0
    },
    {
      math.cos(rz) * math.sin(ry) + math.cos(ry) * math.sin(rz) * math.sin(rx),
      math.sin(rz) * math.sin(ry) - math.cos(rz) * math.cos(ry) * math.sin(rx),
      math.cos(rx) * math.cos(ry),
      0
    },
    {
      0,
      0,
      0,
      1
    }
  }
end
function getEulerAnglesFromMatrix(mat)
  local nz1, nz2, nz3
  nz3 = math.sqrt(mat[2][1] * mat[2][1] + mat[2][2] * mat[2][2])
  nz1 = -mat[2][1] * mat[2][3] / nz3
  nz2 = -mat[2][2] * mat[2][3] / nz3
  local vx = nz1 * mat[1][1] + nz2 * mat[1][2] + nz3 * mat[1][3]
  local vz = nz1 * mat[3][1] + nz2 * mat[3][2] + nz3 * mat[3][3]
  return math.deg(math.asin(mat[2][3])), -math.deg(math.atan2(vx, vz)), -math.deg(math.atan2(mat[2][1], mat[2][2]))
end
function getPositionFromMatrixOffset(mat, x, y, z)
  return x * mat[1][1] + y * mat[2][1] + z * mat[3][1] + mat[4][1], x * mat[1][2] + y * mat[2][2] + z * mat[3][2] + mat[4][2], x * mat[1][3] + y * mat[2][3] + z * mat[3][3] + mat[4][3]
end
function getPositionFromMatrixOffsetEx(mat, x, y, z)
  return x * mat[1][1] + y * mat[2][1] + z * mat[3][1], x * mat[1][2] + y * mat[2][2] + z * mat[3][2], x * mat[1][3] + y * mat[2][3] + z * mat[3][3]
end
function matrixMultiply(mat1, mat2)
  local matOut = {}
  for i = 1, #mat1 do
    matOut[i] = {}
    for j = 1, #mat2[1] do
      local num = mat1[i][1] * mat2[1][j]
      for n = 2, #mat1[1] do
        num = num + mat1[i][n] * mat2[n][j]
      end
      matOut[i][j] = num
    end
  end
  return matOut
end
local chestItem = false
local objects = {}
local objectOffset = {
  {
    -0.21,
    0,
    0.0503
  },
  {
    0.2189,
    0,
    0.0168
  }
}
local csillaOffsets = {
  {106, 26},
  {133, 41},
  {252, 27},
  {259, 66},
  {394, 28},
  {449, 27}
}
local itemFont = false
local chestRt = false
local objectShader = false
local insideShader = false
function convertItemName(name)
  return utf8.lower(utf8.gsub(utf8.gsub(name, "ű", "ü"), "ő", "ö"))
end
local chestStart = getTickCount() + 1000
local chestFade = 0
local finalRot = 0
local finalLight = 0
local finalLight2 = 0
local itemShow = {}
local itemPics = {}
local itemIds = {}
function shuffleTable(t)
  local rand = math.random
  local iterations = #t
  local j
  for i = iterations, 2, -1 do
    j = rand(i)
    t[i], t[j] = t[j], t[i]
  end
  return t
end
local itemVelocity = 0
local itemRot = 0
local itemFrame = 0
local itemSound = false
local itemName = false
local itemNameNext = false
local itemGold = false
local itemGoldNext = false
local bogyeszList = {}
local nextBogyesz = 0
local itemShowoff = 0
local endWait = 8000
local minigameEnd = 1
local fadeOut = 1
local winItemPlace = 40 + math.random() * 40
local winItemId = false
local winItemPos = false
local winItemPics = false
local winItemName = false
local csillaIndex = 1
local csillaP = 0
local nextCsilla = 0
local csillaSpd = 0
local musicSound = false
local music2Sound = false
function preRenderBogyesz(delta)
  for i = #bogyeszList, 1, -1 do
    bogyeszList[i][1] = bogyeszList[i][1] + bogyeszList[i][3] * delta / 1000
    bogyeszList[i][2] = bogyeszList[i][2] + bogyeszList[i][4] * delta / 1000
    bogyeszList[i][5] = bogyeszList[i][5] + delta / 1000 * bogyeszList[i][6]
    if bogyeszList[i][7] > 0 then
      bogyeszList[i][7] = bogyeszList[i][7] - delta / 1000
      if bogyeszList[i][7] < 0 then
        table.remove(bogyeszList, i)
      end
    end
  end
end
function preRenderChest(delta)
  dxSetRenderTarget(chestRt, true)
  dxSetRenderTarget()
  local p = (getTickCount() - chestStart) / 1000
  local fall = 1
  local descend = 1
  chestFade = 0
  local rotOff = {}
  local posOff = {}
  for i = 2, 3 do
    rotOff[i] = {
      0,
      0,
      0
    }
    posOff[i] = {
      0,
      0,
      0
    }
  end
  finalRot = 0
  finalLight = 0
  if 0 < p then
    while true do
      if p <= 2 then
        if p < 0.5 then
          chestFade = 255 * getEasingValue(p / 0.5, "OutQuad")
        else
          chestFade = 255
        end
        descend = 1 - getEasingValue(p / 2, "OutBounce")
        if 1 < p and p < 1.75 then
          fall = 1 - getEasingValue((p - 1) / 0.75, "InQuad")
        elseif 1.75 <= p then
          fall = 0
        end
        rotOff[3][1] = -75 * descend
        break
      end
      fall = 0
      descend = 0
      chestFade = 255
      p = p - 2
      if 0 < p and p <= 2 then
        rotOff[3][1] = getEasingValue(math.min(p, 1), "InBack", 0.3, 1, 3) * 90
        posOff[3][2] = getEasingValue(math.max(0, math.min((p - 0.75) / 1.25, 1)), "OutBack", 0.3, 1, 1.25) * 0.25
        posOff[3][3] = -getEasingValue(math.max(0, math.min((p - 0.75) / 1.25, 1)), "InQuad", 0.3, 1, 1.25) * 2
        break
      end
      posOff[3][3] = 2
      p = p - 2
      if 0 < p and p <= 3 then
        finalRot = getEasingValue(p / 3, "InOutQuad")
        rotOff[2][2] = getEasingValue(p / 3, "InOutQuad") * -60
        break
      end
      finalRot = 1
      rotOff[2][2] = -60
      p = p - 3
      if 0 < p and p <= 2 then
        finalLight = getEasingValue(p / 2, "InOutQuad")
        break
      end
      finalLight = 1
      p = p - 1
      break
    end
  end
  csillaP = csillaP + delta / 1000 * csillaSpd
  if csillaP >= nextCsilla then
    csillaIndex = math.random(1, #csillaOffsets)
    csillaP = 0
    nextCsilla = 1 + math.random() * 2
    csillaSpd = 0.8 + 0.5 * math.random()
  end
  finalLight2 = finalLight * (0.8 + 0.2 * math.sin(getTickCount() % 5000 / 5000 * 2 * math.pi))
  dxSetShaderValue(insideShader, "rM", 3 + 6 * finalLight2 * minigameEnd)
  dxSetShaderValue(insideShader, "gM", 3 + 5.176470588235294 * finalLight2 * minigameEnd)
  dxSetShaderValue(insideShader, "bM", 3 + 2.9411764705882355 * finalLight2 * minigameEnd)
  if 0.5 <= finalLight then
    nextBogyesz = nextBogyesz - delta
    if nextBogyesz <= 0 and 0 < minigameEnd then
      nextBogyesz = math.random() * 200 + 100
      for i = 1, math.random(1, 3) do
        local deg = -math.random() * math.pi / 2 - math.pi / 4
        local cos = math.cos(deg)
        local sin = math.sin(deg)
        local spd = 0.5 + 1 * math.random()
        table.insert(bogyeszList, {
          screenX / 2,
          screenY / 2 - 60 - 76 * itemShowoff,
          cos * 50 * spd,
          sin * 50 * spd,
          0,
          spd / 2,
          2 + math.random() * 5,
          0.5 < math.random(),
          math.random(0, 7) * 16
        })
      end
    end
    local done = true
    for i = 1, #itemShow do
      if itemShow[i] < 1 then
        done = false
        local new = itemShow[i] + delta / 1000 * 2.5
        if itemShow[i] <= 0 and 0 < new then
          local v = getEasingValue(1 - math.abs((i - 5) / 5), "OutQuad")
          if 0 < v then
            local sound = playSound("files/Whoo" .. math.random(1, 4) .. ".wav")
            setSoundVolume(sound, v)
            setSoundPan(sound, (i - 5) / 10)
          end
        end
        itemShow[i] = new
        if 1 < itemShow[i] then
          itemShow[i] = 1
        end
      end
    end
    if done then
      if itemVelocity < 1 then
        itemVelocity = itemVelocity + delta / 1000 * 0.25
        if 1 < itemVelocity then
          itemVelocity = 1
        end
      end
      if itemFrame < 1 then
        itemFrame = itemFrame + delta / 1000 * 2
        if 1 < itemFrame then
          itemFrame = 1
        end
        if not isElement(musicSound) then
          musicSound = playSound("files/nota" .. (chestItem == 442 and "f" or "") .. ".wav", true)
        end
        if not isElement(music2Sound) then
          music2Sound = playSound("files/nota" .. (chestItem == 442 and "f" or "") .. "2.wav", true)
        end
      end
      local isp = math.min(1, 2 * itemShowoff)
      if isElement(musicSound) then
        setSoundVolume(musicSound, 0.65 * itemFrame * minigameEnd * (1 - isp))
      end
      if isElement(music2Sound) then
        setSoundVolume(music2Sound, 0.75 * isp * minigameEnd)
      end
    end
    local spd = itemVelocity * 7.5
    spd = math.min(spd, math.max(0.2, (winItemPos or 0) * 0.5, (winItemPlace + 5) * 0.5))
    spd = spd * delta / 1000
    if winItemPos and 0 < winItemPos then
      winItemPos = winItemPos - spd
      if winItemPos <= 0 then
        spd = math.max(spd + winItemPos, 1 - itemRot)
        winItemPos = 0
      end
    end
    itemRot = itemRot + spd
    winItemPlace = winItemPlace - spd
    while 1 < itemRot and (winItemPos or 1) > 0 do
      itemRot = itemRot - 1
      local item = chooseFakeItem(chestItem)
      if itemRot <= 1 and winItemPlace <= 0 and not winItemPos then
        winItemPos = 1 - itemRot + 4
        item = winItemId
      end
      table.remove(itemPics, 1)
      table.remove(itemIds, 1)
      table.insert(itemPics, ":seal_items/files/items/" .. item - 1 .. ".png")
      table.insert(itemIds, item)
      itemSound = false
      itemName = itemNameNext
      itemNameNext = convertItemName(seexports.seal_items:getItemName(itemIds[6]))
      itemGold = itemGoldNext
      itemGoldNext = goldItems[itemIds[6]]
    end
    if 0.5 <= itemRot and not itemSound then
      itemSound = true
      playSound("files/spin" .. (chestItem == 436 and "f" or "") .. ".wav")
    end
    if winItemPos and winItemPos <= 0 then
      itemRot = 1
      if itemShowoff < 1 then
        local new = itemShowoff + delta / 1000 * 0.65
        if itemShowoff <= 0 and 0 < new then
          playSound("files/waawin" .. (chestItem == 436 and "f" or "") .. ".wav")
        end
        itemShowoff = new
        if 1 < itemShowoff then
          itemShowoff = 1
        end
      else
        endWait = endWait - delta
        if endWait <= 0 then
          local new = minigameEnd - delta / 1000 * 1.5
          if 1 <= minigameEnd and new < 1 then
            playSound("files/end.wav")
          end
          minigameEnd = new
          rotOff[2][2] = getEasingValue(minigameEnd, "InOutQuad") * -60
          if minigameEnd < 0 then
            minigameEnd = 0
            fadeOut = fadeOut - delta / 1000
            if fadeOut < 0 then
              fadeOut = 0
            end
          end
        end
      end
    end
  end
  local mainRX, mainRY, mainRZ = 20 * fall, 20 * fall + 30 * finalRot * minigameEnd, 270
  local offX, offY, offZ = 0, 1.5 - 0.1 * fall, 0.15 * finalRot * minigameEnd
  local x, y = screenX / 2 - 256, screenY / 2 - 256 - screenY * 0.75 * descend
  local sx, sy = 512, 512
  local psx, psy = sx / screenX / 2, sy / screenY / 2
  local ppx, ppy = x / screenX + psx - 0.5, -(y / screenY + psy - 0.5)
  ppx, ppy = 2 * ppx, 2 * ppy
  dxSetShaderValue(objectShader, "sMoveObject2D", ppx, ppy)
  dxSetShaderValue(objectShader, "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
  dxSetShaderValue(objectShader, "sRealScale2D", 2 * psx, 2 * psy)
  dxSetShaderValue(insideShader, "sMoveObject2D", ppx, ppy)
  dxSetShaderValue(insideShader, "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
  dxSetShaderValue(insideShader, "sRealScale2D", 2 * psx, 2 * psy)
  local cameraMatrix = getElementMatrix(getCamera())
  local transformMatrix = createElementMatrix(mainRX, mainRY, mainRZ)
  local multipliedMatrix = matrixMultiply(transformMatrix, cameraMatrix)
  local rotX, rotY, rotZ = getEulerAnglesFromMatrix(multipliedMatrix)
  local dim = getElementDimension(localPlayer)
  local int = getElementInterior(localPlayer)
  local posX, posY, posZ = getPositionFromMatrixOffset(cameraMatrix, offX, offY, offZ)
  setElementPosition(objects[1], posX, posY, posZ, false)
  setElementRotation(objects[1], rotX, rotY, rotZ, "ZXY")
  for i = 1, #objects do
    setElementDimension(objects[i], dim)
    setElementInterior(objects[i], int)
    if 1 < i then
      local x, y, z = getPositionFromMatrixOffsetEx(multipliedMatrix, objectOffset[i - 1][1] + posOff[i][1], objectOffset[i - 1][2] + posOff[i][2], objectOffset[i - 1][3] + posOff[i][3])
      setElementPosition(objects[i], posX + x, posY + y, posZ + z, false)
      setElementRotation(objects[i], rotX + rotOff[i][1], rotY + rotOff[i][2], rotZ + rotOff[i][3], "ZXY")
    end
  end
  dxSetShaderValue(objectShader, "sCameraPosition", cameraMatrix[4])
  dxSetShaderValue(objectShader, "sCameraForward", cameraMatrix[2])
  dxSetShaderValue(objectShader, "sCameraUp", cameraMatrix[3])
  dxSetShaderValue(insideShader, "sCameraPosition", cameraMatrix[4])
  dxSetShaderValue(insideShader, "sCameraForward", cameraMatrix[2])
  dxSetShaderValue(insideShader, "sCameraUp", cameraMatrix[3])
  if fadeOut <= 0 then
    deleteChestMinigame()
  end
end
function renderChest()
  local fOut = 0 < fadeOut
  if fOut then
    local sl = 1 - itemShowoff
    seelangStaticImageUsed[0] = true
    if seelangStaticImageToc[0] then
      processSeelangStaticImage[0]()
    end
    dxDrawImage(screenX / 2 - 256, screenY / 2, 512, 128, seelangStaticImage[0], 0, 0, 0, tocolor(255, 255, 255, 255 * sl * finalLight))
    dxDrawImage(0, 0, screenX, screenY, chestRt, 0, 0, 0, tocolor(255, 255, 255, chestFade * fadeOut))
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImage(screenX / 2 - 256, screenY / 2 - 256, 512, 256, seelangStaticImage[1], 0, 0, 0, tocolor(255, 255, 255, 255 * sl * finalLight2))
    local sx = 512 * (0.5 + 0.5 * finalLight2) * finalLight
    local sy = 256 * finalLight
    seelangStaticImageUsed[2] = true
    if seelangStaticImageToc[2] then
      processSeelangStaticImage[2]()
    end
    dxDrawImage(screenX / 2 - sx / 2, screenY / 2 - sy - 48 * (1 - finalLight), sx, sy, seelangStaticImage[2], 0, 0, 0, tocolor(255, 255, 255, 255 * sl * math.pow(finalLight, 2)))
  end
  for i = 1, #bogyeszList do
    if bogyeszList[i][8] then
      local p = bogyeszList[i][5]
      local x, y = bogyeszList[i][1] + math.cos(p * math.pi) * 16, bogyeszList[i][2] + math.sin(p * math.pi) * 16
      local a = math.min(1, math.min(p, bogyeszList[i][7]))
      seelangStaticImageUsed[3] = true
      if seelangStaticImageToc[3] then
        processSeelangStaticImage[3]()
      end
      dxDrawImageSection(x - 8, y - 8, 16, 16, bogyeszList[i][9], 0, 16, 16, seelangStaticImage[3], 0, 0, 0, tocolor(255, 198, 0, 255 * a))
    end
  end
  if fOut then
    local lx, ly = screenX / 2 - 234.5, screenY / 2 - 256 - 100 + 50 * (1 - minigameEnd)
    local la = 255 * fadeOut * finalLight
    if chestItem == 442 then
      seelangStaticImageUsed[4] = true
      if seelangStaticImageToc[4] then
        processSeelangStaticImage[4]()
      end
      dxDrawImage(lx, ly, 469, 200, seelangStaticImage[4], 0, 0, 0, tocolor(255, 255, 255, la))
    else
      seelangStaticImageUsed[5] = true
      if seelangStaticImageToc[5] then
        processSeelangStaticImage[5]()
      end
      dxDrawImage(lx, ly, 469, 200, seelangStaticImage[5], 0, 0, 0, tocolor(255, 255, 255, la))
    end
    if 0 < csillaP and csillaP < 1 and chestItem ~= 653 then
      local a = csillaP * 2
      if 1 < a then
        a = getEasingValue(2 - a, "OutQuad")
      else
        a = getEasingValue(a, "InQuad")
      end
      local x, y = csillaOffsets[csillaIndex][1], csillaOffsets[csillaIndex][2]
      seelangStaticImageUsed[6] = true
      if seelangStaticImageToc[6] then
        processSeelangStaticImage[6]()
      end
      dxDrawImage(lx + x - 64, ly + y - 64, 128, 128, seelangStaticImage[6], 90 * csillaP, 0, 0, tocolor(255, 255, 255, la * a))
    end
    if 1 <= finalRot then
      local p = itemRot
      local k = 0
      for i = -4, 5 do
        k = k + 1
        if itemShowoff <= 0 or i ~= 1 then
          local show = itemShow[k] * (1 - itemShowoff)
          if 0 < show then
            if show < 1 then
              show = getEasingValue(show, "InOutQuad")
            end
            local j = i - p
            local rx = -50 * j * show
            local ry = (64 + 40 * math.cos(j / 5 * math.pi / 2)) * show
            local p = 1 - math.abs(j / 5)
            local x, y = screenX / 2 - rx, screenY / 2 - 32 - ry
            dxDrawImage(x - 18, y - 18, 36, 36, itemPics[k], 0, 0, 0, tocolor(255, 255, 255, 255 * show * p))
            if goldItems[itemIds[k]] then
              seelangStaticImageUsed[7] = true
              if seelangStaticImageToc[7] then
                processSeelangStaticImage[7]()
              end
              dxDrawImage(x - 33, y - 33, 66, 66, seelangStaticImage[7], 0, 0, 0, tocolor(chestItem == 436 and 40 or 240, chestItem == 436 and 240 or 40, chestItem == 436 and 186 or 155, 255 * show * p))
            end
          end
        end
      end
    end
    if 0 < itemShowoff then
      local p = getEasingValue(itemShowoff, "InQuad")
      local x, y = screenX / 2, screenY / 2 - 32 - 104 * minigameEnd
      local r = goldItems[winItemId] and (chestItem == 436 and 40 or 240) or 240
      local g = goldItems[winItemId] and (chestItem == 436 and 240 or 40) or 200
      local b = goldItems[winItemId] and (chestItem == 436 and 186 or 155) or 80
      seelangStaticImageUsed[8] = true
      if seelangStaticImageToc[8] then
        processSeelangStaticImage[8]()
      end
      dxDrawImage(x - 200, y - 200, 400, 400, seelangStaticImage[8], getTickCount() / 30, 0, 0, tocolor(r, g, b, 255 * p * minigameEnd))
      local s = 1 + 0.2 * p
      dxDrawImage(x - 36 * s / 2, y - 36 * s / 2, 36 * s, 36 * s, winItemPics, 0, 0, 0, tocolor(255, 255, 255, 255 * minigameEnd))
      if goldItems[winItemId] then
        seelangStaticImageUsed[7] = true
        if seelangStaticImageToc[7] then
          processSeelangStaticImage[7]()
        end
        dxDrawImage(x - 66 * s / 2, y - 66 * s / 2, 66 * s, 66 * s, seelangStaticImage[7], 0, 0, 0, tocolor(chestItem == 436 and 40 or 240, chestItem == 436 and 240 or 40, chestItem == 436 and 186 or 155, 255 * minigameEnd))
      end
    end
    seelangStaticImageUsed[9] = true
    if seelangStaticImageToc[9] then
      processSeelangStaticImage[9]()
    end
    dxDrawImage(screenX / 2 - 32, screenY / 2 - 32 - 104 - 32, 64, 64, seelangStaticImage[9], 0, 0, 0, tocolor(255, 255, 255, 255 * itemFrame * math.max(0, 1 - itemShowoff * 3)))
    local y = screenY / 2 + 128 - 34
    local p = itemRot * 2
    if 0 < itemShowoff then
      y = y - 170 * getEasingValue(itemShowoff, "InOutQuad") + 104 * (1 - minigameEnd)
      local r = goldItems[winItemId] and (chestItem == 436 and 40 or 240) or 240
      local g = goldItems[winItemId] and (chestItem == 436 and 240 or 40) or 200
      local b = goldItems[winItemId] and (chestItem == 436 and 186 or 155) or 80
      seelangStaticImageUsed[10] = true
      if seelangStaticImageToc[10] then
        processSeelangStaticImage[10]()
      end
      dxDrawImage(screenX / 2 - 250, y, 500, 34, seelangStaticImage[10], 0, 0, 0, tocolor(255, 255, 255, 255 * itemFrame * minigameEnd))
      dxDrawText(winItemName, 0, y, screenX, y + 34, tocolor(r, g, b, 255 * minigameEnd), 0.5, itemFont, "center", "center")
    elseif 1 < p then
      p = 1 - getEasingValue(2 - p, "InQuad")
      local r = itemGoldNext and (chestItem == 436 and 40 or 240) or 240
      local g = itemGoldNext and (chestItem == 436 and 240 or 40) or 200
      local b = itemGoldNext and (chestItem == 436 and 186 or 155) or 80
      seelangStaticImageUsed[10] = true
      if seelangStaticImageToc[10] then
        processSeelangStaticImage[10]()
      end
      dxDrawImage(screenX / 2 - 250, y, 500, 34, seelangStaticImage[10], 0, 0, 0, tocolor(255, 255, 255, 255 * itemFrame * minigameEnd))
      dxDrawText(itemNameNext, 0, y, screenX, y + 34, tocolor(r, g, b, 255 * itemFrame * p), 0.5, itemFont, "center", "center")
    else
      local r = itemGold and (chestItem == 436 and 40 or 240) or 240
      local g = itemGold and (chestItem == 436 and 240 or 40) or 200
      local b = itemGold and (chestItem == 436 and 186 or 155) or 80
      p = 1 - getEasingValue(p, "InQuad")
      seelangStaticImageUsed[10] = true
      if seelangStaticImageToc[10] then
        processSeelangStaticImage[10]()
      end
      dxDrawImage(screenX / 2 - 250, y, 500, 34, seelangStaticImage[10], 0, 0, 0, tocolor(255, 255, 255, 255 * itemFrame * minigameEnd))
      dxDrawText(itemName, 0, y, screenX, y + 34, tocolor(r, g, b, 255 * itemFrame * p), 0.5, itemFont, "center", "center")
    end
  end
  for i = 1, #bogyeszList do
    if not bogyeszList[i][8] then
      local p = bogyeszList[i][5]
      local x, y = bogyeszList[i][1] + math.cos(p * math.pi) * 16, bogyeszList[i][2] + math.sin(p * math.pi) * 16
      local a = math.min(1, math.min(p, bogyeszList[i][7]))
      seelangStaticImageUsed[3] = true
      if seelangStaticImageToc[3] then
        processSeelangStaticImage[3]()
      end
      dxDrawImageSection(x - 8, y - 8, 16, 16, bogyeszList[i][9], 0, 16, 16, seelangStaticImage[3], 0, 0, 0, tocolor(255, 198, 0, 255 * a))
    end
  end
  if not fOut and #bogyeszList <= 0 then
    seelangCondHandl0(false)
    seelangCondHandl1(false)
  end
end
function deleteChestMinigame()
  chestItem = false
  for i = 1, #objects do
    setElementPosition(objects[i], 0, 0, 0)
    if isElement(objects[i]) then
      destroyElement(objects[i])
    end
    objects[i] = nil
  end
  if isElement(itemFont) then
    destroyElement(itemFont)
  end
  itemFont = nil
  if isElement(chestRt) then
    destroyElement(chestRt)
  end
  chestRt = nil
  if isElement(objectShader) then
    destroyElement(objectShader)
  end
  objectShader = nil
  if isElement(insideShader) then
    destroyElement(insideShader)
  end
  insideShader = nil
  if isElement(musicSound) then
    destroyElement(musicSound)
  end
  musicSound = nil
  if isElement(music2Sound) then
    destroyElement(music2Sound)
  end
  music2Sound = nil
  itemShow = {}
  itemPics = {}
  itemIds = {}
  seelangCondHandl2(false)
end
addEvent("createChestMinigame", true)
addEventHandler("createChestMinigame", getRootElement(), function(item, itemPlace, winItem)
  deleteChestMinigame()
  chestItem = item
  table.insert(objects, createObject(8397, 0, 0, 0))
  table.insert(objects, createObject(8394, 0, 0, 0))
  table.insert(objects, createObject(8396, 0, 0, 0))
  itemFont = dxCreateFont("files/fiddlerscove.ttf", 26, false, "antialiased")
  chestRt = dxCreateRenderTarget(screenX, screenY, true)
  objectShader = dxCreateShader(objectPreviewSource, 0, 0, false, "all")
  insideShader = dxCreateShader(objectPreviewSource, 0, 0, false, "all")
  dxSetShaderValue(objectShader, "sFov", 70)
  dxSetShaderValue(objectShader, "sAspect", screenY / screenX)
  dxSetShaderValue(objectShader, "secondRT", chestRt)
  dxSetShaderValue(insideShader, "sFov", 70)
  dxSetShaderValue(insideShader, "sAspect", screenY / screenX)
  dxSetShaderValue(insideShader, "secondRT", chestRt)
  for i = 1, #objects do
    engineApplyShaderToWorldTexture(objectShader, "*", objects[i])
    engineRemoveShaderFromWorldTexture(objectShader, "*inside", objects[i])
    engineApplyShaderToWorldTexture(insideShader, "*inside", objects[i])
    setElementCollisionsEnabled(objects[i], false)
  end
  chestStart = getTickCount()
  chestFade = 0
  finalRot = 0
  finalLight = 0
  finalLight2 = 0
  for i = 1, 10 do
    itemShow[i] = -(i - 1) * 0.5
    local item = chooseFakeItem(chestItem)
    itemPics[i] = ":seal_items/files/items/" .. item - 1 .. ".png"
    itemIds[i] = item
  end
  shuffleTable(itemShow)
  itemVelocity = 0
  itemRot = 0
  itemFrame = 0
  itemSound = false
  itemName = convertItemName(seexports.seal_items:getItemName(itemIds[5]))
  itemNameNext = convertItemName(seexports.seal_items:getItemName(itemIds[6]))
  itemGold = goldItems[itemIds[5]]
  itemGoldNext = goldItems[itemIds[6]]
  nextBogyesz = 0
  itemShowoff = 0
  endWait = 8000
  minigameEnd = 1
  fadeOut = 1
  winItemPlace = itemPlace
  winItemId = winItem
  winItemPos = false
  winItemPics = ":seal_items/files/items/" .. winItemId - 1 .. ".png"
  winItemName = convertItemName(seexports.seal_items:getItemName(winItemId))
  seelangCondHandl2(true)
  seelangCondHandl1(true)
  seelangCondHandl0(true)
  playSound("files/boxfall.wav")
end)
function openChest(itemId, dbID)

  triggerServerEvent("tryToStartTreasureOpening", localPlayer, itemId, dbID)
end
--[[
local function solveDecode(input, key, iv)
    return decodeString("aes128", input, {
        key = key,
        iv = iv,
    })
end
tmp = {}
keysTable = {
    ["files/v4_fishing_chest.dff"] = {
        iv = "vl0TemT5LJiOpiYxXQwoDw==",
        key = "o22eRGKf2K8fZj6h"
      },
      ["files/v4_fishing_chest.dff"] = {
        iv = "aSKrEGdmsSDJcuPI1bC6Dw==",
        key = "tVftd5KI1KUgvnjp"
      },
      ["files/v4_fishing_chest_catch.dff"] = {
        iv = "xfOl/+Q7a0Nv4jBQbcxQfQ==",
        key = "mGPoj6Ui1G5J4Zhi"
      },
      ["files/v4_fishing_chest_catch.dff"] = {
        iv = "q7PFFm52CRQz9mk0C7jNhw==",
        key = "EW5gdByt1GPnO3sA"
      },
      ["files/v4_fishing_chest_top.dff"] = {
        iv = "oTo4CbQk6pR53/c2PDSeBQ==",
        key = "bkc6mT34CcTKkKCy"
      },
      ["files/v4_fishing_chest_top.dff"] = {
        iv = "jYFQjLjW0OWMJ4U3/7Wzow==",
        key = "xXfjVkXdDcRoijjI"
      },
}
for k, v in pairs(keysTable) do
    local protected1 = fileOpen(k .. ".protected1", true)
    table.insert(tmp, solveDecode(fileRead(protected1, fileGetSize(protected1)), v.key, base64Decode(v.iv)))
    fileClose(protected1)
    
    local protected2 = fileOpen(k .. ".protected2", true)
    
    if protected2 then
        table.insert(tmp, solveDecode(fileRead(protected2, fileGetSize(protected2)), v.key, base64Decode(v.iv)))
        fileClose(protected2)
    end
    local fi = fileCreate(k .. "a")
    local content = table.concat(tmp, "")
    fileWrite(fi, content)
    fileClose(fi)
end--]]