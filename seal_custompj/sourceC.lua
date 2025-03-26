local seexports = {seal_gui = false}
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
local seelangDynImgHand = false
local seelangDynImgLatCr = false
local seelangDynImage = {}
local seelangDynImageForm = {}
local seelangDynImageMip = {}
local seelangDynImageUsed = {}
local seelangDynImageDel = {}
local seelangDynImgPre
function seelangDynImgPre()
  local now = getTickCount()
  seelangDynImgLatCr = true
  local rem = true
  for k in pairs(seelangDynImage) do
    rem = false
    if seelangDynImageDel[k] then
      if now >= seelangDynImageDel[k] then
        if isElement(seelangDynImage[k]) then
          destroyElement(seelangDynImage[k])
        end
        seelangDynImage[k] = nil
        seelangDynImageForm[k] = nil
        seelangDynImageMip[k] = nil
        seelangDynImageDel[k] = nil
        break
      end
    elseif not seelangDynImageUsed[k] then
      seelangDynImageDel[k] = now + 5000
    end
  end
  for k in pairs(seelangDynImageUsed) do
    if not seelangDynImage[k] and seelangDynImgLatCr then
      seelangDynImgLatCr = false
      seelangDynImage[k] = dxCreateTexture(k, seelangDynImageForm[k], seelangDynImageMip[k])
    end
    seelangDynImageUsed[k] = nil
    seelangDynImageDel[k] = nil
    rem = false
  end
  if rem then
    removeEventHandler("onClientPreRender", getRootElement(), seelangDynImgPre)
    seelangDynImgHand = false
  end
end
local seelangBlankTex = dxCreateTexture(1, 1)
local function latentDynamicImage(img, form, mip)
  if not seelangDynImgHand then
    seelangDynImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangDynImgPre, true, "high+999999999")
  end
  seelangDynImageForm[img] = form
  seelangDynImageMip[img] = mip
  seelangDynImageUsed[img] = true
  return seelangDynImage[img] or seelangBlankTex
end
local function dynamicImage(img, form, mip)
  if not seelangDynImgHand then
    seelangDynImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangDynImgPre, true, "high+999999999")
  end
  if not seelangDynImage[img] then
    seelangDynImage[img] = dxCreateTexture(img, form, mip)
  end
  seelangDynImageForm[img] = form
  seelangDynImageUsed[img] = true
  return seelangDynImage[img]
end
local gratisPJ = false
function teaDecodeBinary(data, key)
  return base64Decode(teaDecode(data, key))
end
function teaEncodeBinary(data, key)
  return teaEncode(base64Encode(data), key)
end
local screenX, screenY = guiGetScreenSize()
local shader = false
local mainShaderSource = [[
#include "files/mta-helper.fx"
 texture secondRTX < string renderTarget = "yes"; >; texture secondRTY < string renderTarget = "yes"; >; texture Tex0; sampler Sampler0 = sampler_state { Texture = (Tex0); }; sampler Sampler1 = sampler_state { Texture = (gTexture1); }; struct VSInput { float3 Position : POSITION0; float3 Normal : NORMAL0; float4 Diffuse : COLOR0; float2 TexCoord : TEXCOORD0; float3 TexCoord1 : TEXCOORD1; }; struct PSInput { float4 Position : POSITION0; float4 Diffuse : COLOR0; float2 TexCoord : TEXCOORD0; float3 Specular : COLOR1; float3 TexCoord1 : TEXCOORD1; }; float4 gLight1Specular < string lightState="1,Specular"; >; int gStage1ColorOp < string stageState="1,COLOROP"; >; float4 gTextureFactor < string renderState="TEXTUREFACTOR"; >; float4 CalcVehDiff( float3 WorldNormal, float4 InDiffuse ) { float4 ambient = gAmbientMaterialSource == 0 ? gMaterialAmbient : InDiffuse; float4 diffuse = gDiffuseMaterialSource == 0 ? gMaterialDiffuse : InDiffuse; float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse; float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient ); float DirectionFactor = 0; DirectionFactor += max(0,dot(WorldNormal, -float3(0.5773502691896258, 0.5773502691896258, -0.5773502691896258) )); DirectionFactor += max(0,dot(WorldNormal, -float3(0.5773502691896258, -0.5773502691896258, -0.5773502691896258) )); DirectionFactor += max(0,dot(WorldNormal, -float3(-0.5773502691896258, -0.5773502691896258, -0.5773502691896258) )); DirectionFactor += max(0,dot(WorldNormal, -float3(-0.5773502691896258, 0.5773502691896258, -0.5773502691896258) )); DirectionFactor /= 4; float4 TotalDiffuse = ( diffuse * gLightDiffuse * DirectionFactor * 1.25 ); float4 OutDiffuse = saturate(TotalDiffuse + TotalAmbient + emissive); OutDiffuse.a *= diffuse.a; return OutDiffuse; } PSInput VertexShaderFunction(VSInput VS) { PSInput PS = (PSInput)0; PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection); PS.TexCoord = VS.TexCoord; float3 WorldNormal = MTACalcWorldNormal( VS.Normal ); PS.Diffuse = CalcVehDiff( WorldNormal, VS.Diffuse ); if (gStage1ColorOp == 25) { float3 ViewNormal = mul(VS.Normal, (float3x3)gWorldView); ViewNormal = normalize(ViewNormal); PS.TexCoord1 = ViewNormal.xyz; } else if (gStage1ColorOp == 14) { PS.TexCoord1 = float3(VS.TexCoord1.xy, 1); } else { PS.TexCoord1 = 0; } PS.Specular.rgb = gMaterialSpecular.rgb * MTACalculateSpecular(gCameraDirection, gLightDirection, VS.Normal, min(127, gMaterialSpecPower)) * gLight1Specular.rgb; return PS; } struct Pixel { float4 Color : COLOR0; float4 ExtraX : COLOR1; float4 ExtraY : COLOR2; }; Pixel PixelShaderFunction(PSInput PS) { Pixel output; output.Color = tex2D(Sampler0, PS.TexCoord) * PS.Diffuse; if (gStage1ColorOp == 14) { float4 envTexel = tex2D(Sampler1, PS.TexCoord1.xy); output.Color.rgb = output.Color.rgb * (1 - gTextureFactor.a) + envTexel.rgb * gTextureFactor.a; } if (gStage1ColorOp == 25) { float4 sphTexel = tex2D(Sampler1, PS.TexCoord1.xy/PS.TexCoord1.z); output.Color.rgb += sphTexel.rgb * gTextureFactor.r; } if (gMaterialSpecPower != 0) output.Color.rgb += PS.Specular.rgb; output.ExtraX = float4( min(1, PS.TexCoord[0]*3), min(1, max(0, PS.TexCoord[0]*3-1)), max(0, PS.TexCoord[0]*3-2), 1 ); output.ExtraY = float4( min(1, PS.TexCoord[1]*3), min(1, max(0, PS.TexCoord[1]*3-1)), max(0, PS.TexCoord[1]*3-2), 1 ); return output; } technique tec { pass P0 { VertexShader = compile vs_2_0 VertexShaderFunction(); PixelShader = compile ps_2_0 PixelShaderFunction(); } } ]]
local veh = false
function getEditingVeh()
  return veh
end
local buyingPaintjob = false
local minX, minY, minZ, maxX, maxY, maxZ = false, nil, nil, nil, nil, nil
local rtToDraw = false
local ts = 1024
local renderTargetX = false
local renderTargetY = false
local renderTarget2 = false
local decals = {}
local decalCategorys = {}
local decalCategoryList = {
  "1shapes",
  "gradients",
  "grunge",
  "splashpaint",
  "textures",
  "mintazatok",
  "pinstripe",
  "tribal",
  "animals",
  "skull",
  "flames",
  "racing",
  "flags",
  "stickers",
  "stickers2",
  "aftermarket",
  "aftermarket2",
  "manufacturer",
  "manufacturer2"
}
local colorCategories = {
  aftermarket2 = true,
  manufacturer2 = true,
  stickers2 = true,
  textures = true,
  flags = true
}
local decalsToLoad = 0
local decalLoadQueue = false
function getDecalTexture(id, sx, sy)
  if decals[id] then
    if not sy then
      sx, sy = seexports.seal_gui:getGuiSize(sx)
    else
      sx, sy = math.abs(sx), math.abs(sy)
    end
    local s = math.max(sx, sy)
    if s <= 32 then
      return decals[id][1][1]
    elseif s <= 64 then
      return decals[id][1][2]
    elseif s <= 128 then
      return decals[id][1][3]
    else
      return decals[id][1][4]
    end
  end
end
function loadDecalFinal(cat, name, colorable)
  if not decalCategorys[cat] then
    decalCategorys[cat] = {}
  end
  table.insert(decalCategorys[cat], cat .. "/" .. name)
  decals[cat .. "/" .. name] = {
    {
      "files/decals/32/" .. cat .. "/" .. name .. ".dds",
      "files/decals/64/" .. cat .. "/" .. name .. ".dds",
      "files/decals/128/" .. cat .. "/" .. name .. ".dds",
      "files/decals/256/" .. cat .. "/" .. name .. ".dds"
    },
    256,
    256,
    colorable,
    cat
  }
end
function loadDecal(cat, name)
  if not decalLoadQueue then
    decalLoadQueue = {}
    decalsToLoad = 0
  end
  colorable = not colorCategories[cat]
  if not decals[cat .. "/" .. name] then
    table.insert(decalLoadQueue, {
      cat,
      name,
      colorable
    })
    decalsToLoad = decalsToLoad + 1
  end
end
local categoryNames = {
  ["1shapes"] = "Formák",
  gradients = "Átmenetek",
  grunge = "Piszok",
  splashpaint = "Festék",
  textures = "Textúrák",
  mintazatok = "Mintázatok",
  pinstripe = "Pinstripe minták",
  tribal = "Tribal minták",
  animals = "Állatok",
  skull = "Koponya",
  flames = "Lángok",
  racing = "Motorsport",
  flags = "Zászlók",
  stickers = "Matricák",
  stickers2 = "Matricák",
  aftermarket = "Logók",
  aftermarket2 = "Logók",
  manufacturer = "Autómárkák",
  manufacturer2 = "Autómárkák"
}
function loadTheDecals()
  decalLoadQueue = {}
  decalsToLoad = 0
  loadDecal("1shapes", "0")
  loadDecal("1shapes", "1")
  loadDecal("1shapes", "2")
  loadDecal("1shapes", "2a")
  loadDecal("1shapes", "3")
  loadDecal("1shapes", "4")
  loadDecal("1shapes", "4a")
  loadDecal("1shapes", "5")
  loadDecal("1shapes", "6")
  loadDecal("1shapes", "7")
  loadDecal("1shapes", "8")
  loadDecal("1shapes", "8a")
  loadDecal("1shapes", "8b")
  loadDecal("1shapes", "9")
  loadDecal("1shapes", "9a")
  loadDecal("1shapes", "9b")
  loadDecal("1shapes", "10")
  loadDecal("1shapes", "11")
  loadDecal("1shapes", "11a")
  loadDecal("1shapes", "11a1")
  loadDecal("1shapes", "11b")
  loadDecal("1shapes", "12")
  loadDecal("1shapes", "12a")
  loadDecal("1shapes", "12b")
  loadDecal("1shapes", "12c")
  loadDecal("1shapes", "12c1")
  loadDecal("1shapes", "12c2")
  loadDecal("1shapes", "12d")
  loadDecal("1shapes", "12e")
  loadDecal("1shapes", "13")
  loadDecal("1shapes", "13a")
  loadDecal("1shapes", "14")
  loadDecal("1shapes", "14a")
  loadDecal("1shapes", "14a1")
  loadDecal("1shapes", "15")
  loadDecal("1shapes", "15a")
  loadDecal("1shapes", "15b")
  loadDecal("1shapes", "16")
  loadDecal("1shapes", "16a")
  loadDecal("1shapes", "16b")
  loadDecal("1shapes", "16c")
  loadDecal("1shapes", "17")
  loadDecal("1shapes", "17a")
  loadDecal("1shapes", "18")
  loadDecal("1shapes", "18a")
  loadDecal("1shapes", "19")
  loadDecal("1shapes", "20")
  loadDecal("1shapes", "21")
  loadDecal("1shapes", "21a")
  loadDecal("1shapes", "22")
  loadDecal("1shapes", "22a")
  loadDecal("1shapes", "22b")
  loadDecal("1shapes", "23")
  loadDecal("1shapes", "24")
  loadDecal("1shapes", "25")
  loadDecal("1shapes", "26")
  loadDecal("1shapes", "26a")
  loadDecal("1shapes", "26b")
  loadDecal("1shapes", "26c")
  loadDecal("1shapes", "26d")
  loadDecal("1shapes", "26e")
  loadDecal("1shapes", "26f")
  loadDecal("1shapes", "27")
  loadDecal("1shapes", "28")
  loadDecal("1shapes", "29")
  loadDecal("1shapes", "x4")
  loadDecal("1shapes", "x4a")
  loadDecal("1shapes", "x5")
  loadDecal("1shapes", "x6")
  loadDecal("1shapes", "x7")
  loadDecal("1shapes", "x8")
  loadDecal("1shapes", "y")
  loadDecal("1shapes", "y0")
  loadDecal("1shapes", "y0a")
  loadDecal("1shapes", "y1")
  loadDecal("1shapes", "y2")
  loadDecal("1shapes", "y2a")
  loadDecal("1shapes", "Y3")
  loadDecal("1shapes", "y4")
  loadDecal("1shapes", "y5")
  loadDecal("1shapes", "y6")
  loadDecal("1shapes", "y7")
  loadDecal("1shapes", "y8")
  loadDecal("1shapes", "y9")
  loadDecal("1shapes", "y10")
  loadDecal("aftermarket", "5zigen")
  loadDecal("aftermarket", "aem")
  loadDecal("aftermarket", "akra")
  loadDecal("aftermarket", "alpine")
  loadDecal("aftermarket", "alpinestars")
  loadDecal("aftermarket", "apex")
  loadDecal("aftermarket", "apracing")
  loadDecal("aftermarket", "bbs")
  loadDecal("aftermarket", "bf")
  loadDecal("aftermarket", "blitz")
  loadDecal("aftermarket", "borla")
  loadDecal("aftermarket", "bosch")
  loadDecal("aftermarket", "brembo")
  loadDecal("aftermarket", "brembo1")
  loadDecal("aftermarket", "bride")
  loadDecal("aftermarket", "bridgestone")
  loadDecal("aftermarket", "castr")
  loadDecal("aftermarket", "continental")
  loadDecal("aftermarket", "cwest")
  loadDecal("aftermarket", "dunlop")
  loadDecal("aftermarket", "edelb")
  loadDecal("aftermarket", "eibach")
  loadDecal("aftermarket", "endless")
  loadDecal("aftermarket", "enkei")
  loadDecal("aftermarket", "falken")
  loadDecal("aftermarket", "fifteen")
  loadDecal("aftermarket", "firestone")
  loadDecal("aftermarket", "garrett")
  loadDecal("aftermarket", "goody")
  loadDecal("aftermarket", "greddy")
  loadDecal("aftermarket", "hankook")
  loadDecal("aftermarket", "hella")
  loadDecal("aftermarket", "hks")
  loadDecal("aftermarket", "holley")
  loadDecal("aftermarket", "hoosier")
  loadDecal("aftermarket", "import")
  loadDecal("aftermarket", "kenwood")
  loadDecal("aftermarket", "kn")
  loadDecal("aftermarket", "koni")
  loadDecal("aftermarket", "konig")
  loadDecal("aftermarket", "kw")
  loadDecal("aftermarket", "magna")
  loadDecal("aftermarket", "michelin")
  loadDecal("aftermarket", "momo")
  loadDecal("aftermarket", "motec")
  loadDecal("aftermarket", "motul")
  loadDecal("aftermarket", "ngk")
  loadDecal("aftermarket", "nitto")
  loadDecal("aftermarket", "nos")
  loadDecal("aftermarket", "nx")
  loadDecal("aftermarket", "oz")
  loadDecal("aftermarket", "pirelli")
  loadDecal("aftermarket", "rays")
  loadDecal("aftermarket", "recaro")
  loadDecal("aftermarket", "recaro2")
  loadDecal("aftermarket", "remus")
  loadDecal("aftermarket", "ronal")
  loadDecal("aftermarket", "sparco")
  loadDecal("aftermarket", "sparco2")
  loadDecal("aftermarket", "speedh")
  loadDecal("aftermarket", "sultan")
  loadDecal("aftermarket", "takata")
  loadDecal("aftermarket", "tein")
  loadDecal("aftermarket", "tenzo")
  loadDecal("aftermarket", "toyo")
  loadDecal("aftermarket", "veilside")
  loadDecal("aftermarket", "wilwood")
  loadDecal("aftermarket", "work")
  loadDecal("aftermarket", "x")
  loadDecal("aftermarket", "x2")
  loadDecal("aftermarket", "yokohama")
  loadDecal("aftermarket2", "5zigen")
  loadDecal("aftermarket2", "76")
  loadDecal("aftermarket2", "advan")
  loadDecal("aftermarket2", "advan2")
  loadDecal("aftermarket2", "akra")
  loadDecal("aftermarket2", "alpines")
  loadDecal("aftermarket2", "alpines1")
  loadDecal("aftermarket2", "am")
  loadDecal("aftermarket2", "apexi")
  loadDecal("aftermarket2", "apracing")
  loadDecal("aftermarket2", "bbs")
  loadDecal("aftermarket2", "bf")
  loadDecal("aftermarket2", "borla")
  loadDecal("aftermarket2", "bosch")
  loadDecal("aftermarket2", "brembo")
  loadDecal("aftermarket2", "bridgestone")
  loadDecal("aftermarket2", "bridgestone2")
  loadDecal("aftermarket2", "castr")
  loadDecal("aftermarket2", "champion")
  loadDecal("aftermarket2", "chevron")
  loadDecal("aftermarket2", "conti")
  loadDecal("aftermarket2", "dunlop")
  loadDecal("aftermarket2", "edelb2")
  loadDecal("aftermarket2", "eibach")
  loadDecal("aftermarket2", "falken")
  loadDecal("aftermarket2", "flowmasters")
  loadDecal("aftermarket2", "goody")
  loadDecal("aftermarket2", "goodyear")
  loadDecal("aftermarket2", "greddy")
  loadDecal("aftermarket2", "greddy1")
  loadDecal("aftermarket2", "gulf")
  loadDecal("aftermarket2", "hankook")
  loadDecal("aftermarket2", "hella")
  loadDecal("aftermarket2", "hks")
  loadDecal("aftermarket2", "hks2")
  loadDecal("aftermarket2", "hks3")
  loadDecal("aftermarket2", "hks4")
  loadDecal("aftermarket2", "holley")
  loadDecal("aftermarket2", "hoo")
  loadDecal("aftermarket2", "hotw")
  loadDecal("aftermarket2", "japanracing")
  loadDecal("aftermarket2", "kenwood")
  loadDecal("aftermarket2", "kn")
  loadDecal("aftermarket2", "koni")
  loadDecal("aftermarket2", "kw")
  loadDecal("aftermarket2", "martini")
  loadDecal("aftermarket2", "martini1")
  loadDecal("aftermarket2", "martini2")
  loadDecal("aftermarket2", "michelin")
  loadDecal("aftermarket2", "momo")
  loadDecal("aftermarket2", "monster")
  loadDecal("aftermarket2", "motul")
  loadDecal("aftermarket2", "ngk")
  loadDecal("aftermarket2", "nitto")
  loadDecal("aftermarket2", "nx")
  loadDecal("aftermarket2", "oz")
  loadDecal("aftermarket2", "penzoil")
  loadDecal("aftermarket2", "redb")
  loadDecal("aftermarket2", "roush")
  loadDecal("aftermarket2", "shell")
  loadDecal("aftermarket2", "subw")
  loadDecal("aftermarket2", "texaco")
  loadDecal("aftermarket2", "valvoline")
  loadDecal("aftermarket2", "volk")
  loadDecal("aftermarket2", "wilwood")
  loadDecal("aftermarket2", "yokohama")
  loadDecal("aftermarket2", "yokohama2")
  loadDecal("animals", "animal00")
  loadDecal("animals", "animal01")
  loadDecal("animals", "animal02")
  loadDecal("animals", "animal03")
  loadDecal("animals", "animal04")
  loadDecal("animals", "animal05")
  loadDecal("animals", "animal06")
  loadDecal("animals", "animal07")
  loadDecal("animals", "animal08")
  loadDecal("animals", "animal09")
  loadDecal("animals", "animal10")
  loadDecal("animals", "animal11")
  loadDecal("animals", "animal12")
  loadDecal("animals", "animal13")
  loadDecal("animals", "animal14")
  loadDecal("animals", "animal15")
  loadDecal("animals", "animal16")
  loadDecal("animals", "animal17")
  loadDecal("animals", "animal18")
  loadDecal("animals", "animal19")
  loadDecal("animals", "animal20")
  loadDecal("animals", "animal21")
  loadDecal("flags", "australia")
  loadDecal("flags", "austria")
  loadDecal("flags", "canada")
  loadDecal("flags", "croatia")
  loadDecal("flags", "france")
  loadDecal("flags", "germany")
  loadDecal("flags", "hungary")
  loadDecal("flags", "italy")
  loadDecal("flags", "japan")
  loadDecal("flags", "mexico")
  loadDecal("flags", "netherlands")
  loadDecal("flags", "romania")
  loadDecal("flags", "russia")
  loadDecal("flags", "serbia")
  loadDecal("flags", "slovakia")
  loadDecal("flags", "slovenia")
  loadDecal("flags", "spain")
  loadDecal("flags", "uk")
  loadDecal("flags", "ukraine")
  loadDecal("flags", "usa")
  loadDecal("flames", "flame01")
  loadDecal("flames", "flame02")
  loadDecal("flames", "flame03")
  loadDecal("flames", "flame04")
  loadDecal("flames", "flame05")
  loadDecal("flames", "flame06")
  loadDecal("flames", "flame07")
  loadDecal("flames", "flame08")
  loadDecal("flames", "flame09")
  loadDecal("flames", "flame10")
  loadDecal("flames", "flame11")
  loadDecal("flames", "flame12")
  loadDecal("flames", "flame13")
  loadDecal("flames", "flame14")
  loadDecal("flames", "flame15")
  loadDecal("flames", "flame16")
  loadDecal("flames", "flame17")
  loadDecal("flames", "flame18")
  loadDecal("flames", "flame19")
  loadDecal("flames", "flame20")
  loadDecal("flames", "flame21")
  loadDecal("flames", "flame22")
  loadDecal("flames", "flame23")
  loadDecal("flames", "flame24")
  loadDecal("flames", "flame25")
  loadDecal("flames", "flame26")
  loadDecal("flames", "flame27")
  loadDecal("flames", "flame28")
  loadDecal("flames", "flame29")
  loadDecal("flames", "flame30")
  loadDecal("flames", "flame31")
  loadDecal("flames", "flame32")
  loadDecal("flames", "flame33")
  loadDecal("flames", "flame34")
  loadDecal("flames", "flame35")
  loadDecal("flames", "flame36")
  loadDecal("flames", "flame37")
  loadDecal("flames", "flame38")
  loadDecal("flames", "flame39")
  loadDecal("flames", "flame40")
  loadDecal("flames", "flame41")
  loadDecal("flames", "flame42")
  loadDecal("flames", "flame43")
  loadDecal("flames", "flame44")
  loadDecal("flames", "flame45")
  loadDecal("flames", "flame46")
  loadDecal("flames", "flame47")
  loadDecal("flames", "flame48")
  loadDecal("flames", "flame49")
  loadDecal("flames", "flame50")
  loadDecal("flames", "flame51")
  loadDecal("gradients", "1")
  loadDecal("gradients", "1a")
  loadDecal("gradients", "1b")
  loadDecal("gradients", "1c")
  loadDecal("gradients", "2")
  loadDecal("gradients", "2a")
  loadDecal("gradients", "2a1")
  loadDecal("gradients", "2b")
  loadDecal("gradients", "2c")
  loadDecal("gradients", "3")
  loadDecal("gradients", "4")
  loadDecal("gradients", "5")
  loadDecal("gradients", "6")
  loadDecal("gradients", "7")
  loadDecal("gradients", "8")
  loadDecal("gradients", "8a")
  loadDecal("gradients", "9")
  loadDecal("gradients", "9a")
  loadDecal("gradients", "9a1")
  loadDecal("gradients", "9b")
  loadDecal("gradients", "9c")
  loadDecal("gradients", "9c1")
  loadDecal("gradients", "9d")
  loadDecal("gradients", "9e")
  loadDecal("gradients", "10")
  loadDecal("gradients", "11")
  loadDecal("gradients", "11a")
  loadDecal("gradients", "11b")
  loadDecal("gradients", "11b1")
  loadDecal("gradients", "11b2")
  loadDecal("gradients", "11c")
  loadDecal("gradients", "12")
  loadDecal("gradients", "12a")
  loadDecal("gradients", "13")
  loadDecal("gradients", "14")
  loadDecal("gradients", "14a")
  loadDecal("gradients", "15")
  loadDecal("gradients", "15a")
  loadDecal("gradients", "15b")
  loadDecal("gradients", "15c")
  loadDecal("gradients", "16")
  loadDecal("gradients", "16a")
  loadDecal("gradients", "16a1")
  loadDecal("gradients", "16b")
  loadDecal("gradients", "16c")
  loadDecal("gradients", "16d")
  loadDecal("gradients", "17")
  loadDecal("gradients", "y2")
  loadDecal("gradients", "y2a1")
  loadDecal("gradients", "y2a2")
  loadDecal("grunge", "0")
  loadDecal("grunge", "0a")
  loadDecal("grunge", "0a1")
  loadDecal("grunge", "1")
  loadDecal("grunge", "2")
  loadDecal("grunge", "3")
  loadDecal("grunge", "3a")
  loadDecal("grunge", "3b")
  loadDecal("grunge", "3c")
  loadDecal("grunge", "4")
  loadDecal("grunge", "4a")
  loadDecal("grunge", "5")
  loadDecal("grunge", "6")
  loadDecal("grunge", "7")
  loadDecal("grunge", "8")
  loadDecal("grunge", "9")
  loadDecal("grunge", "10")
  loadDecal("grunge", "11")
  loadDecal("grunge", "12")
  loadDecal("grunge", "13")
  loadDecal("grunge", "14")
  loadDecal("grunge", "15")
  loadDecal("grunge", "15a")
  loadDecal("grunge", "16")
  loadDecal("grunge", "17")
  loadDecal("grunge", "17a")
  loadDecal("grunge", "17a1")
  loadDecal("grunge", "17a2")
  loadDecal("grunge", "18")
  loadDecal("grunge", "18a")
  loadDecal("grunge", "18a1")
  loadDecal("grunge", "18b")
  loadDecal("grunge", "19")
  loadDecal("grunge", "20")
  loadDecal("grunge", "21")
  loadDecal("grunge", "21a")
  loadDecal("grunge", "22")
  loadDecal("grunge", "22a")
  loadDecal("grunge", "23")
  loadDecal("grunge", "24")
  loadDecal("grunge", "25")
  loadDecal("grunge", "26")
  loadDecal("grunge", "27")
  loadDecal("grunge", "28")
  loadDecal("grunge", "29")
  loadDecal("grunge", "30")
  loadDecal("grunge", "31")
  loadDecal("grunge", "32")
  loadDecal("grunge", "33")
  loadDecal("grunge", "34")
  loadDecal("grunge", "35")
  loadDecal("grunge", "36")
  loadDecal("grunge", "37")
  loadDecal("grunge", "38")
  loadDecal("manufacturer", "a_quattro")
  loadDecal("manufacturer", "a_rs4")
  loadDecal("manufacturer", "a_rs6")
  loadDecal("manufacturer", "a_sport")
  loadDecal("manufacturer", "alpina")
  loadDecal("manufacturer", "audi")
  loadDecal("manufacturer", "audi1")
  loadDecal("manufacturer", "audi2")
  loadDecal("manufacturer", "audi3")
  loadDecal("manufacturer", "chevy")
  loadDecal("manufacturer", "chevy2")
  loadDecal("manufacturer", "chevy3")
  loadDecal("manufacturer", "chevy4")
  loadDecal("manufacturer", "chevy5")
  loadDecal("manufacturer", "dodge")
  loadDecal("manufacturer", "dodge1")
  loadDecal("manufacturer", "ferrari")
  loadDecal("manufacturer", "firebird")
  loadDecal("manufacturer", "ford")
  loadDecal("manufacturer", "fordmustanggt")
  loadDecal("manufacturer", "fordold")
  loadDecal("manufacturer", "fordraptor")
  loadDecal("manufacturer", "gti")
  loadDecal("manufacturer", "hemi")
  loadDecal("manufacturer", "honda")
  loadDecal("manufacturer", "honda1")
  loadDecal("manufacturer", "honda1mugen")
  loadDecal("manufacturer", "jeep")
  loadDecal("manufacturer", "jeep1")
  loadDecal("manufacturer", "lada")
  loadDecal("manufacturer", "lambo")
  loadDecal("manufacturer", "mercedes")
  loadDecal("manufacturer", "mercedesamg")
  loadDecal("manufacturer", "mitsu_ralliart")
  loadDecal("manufacturer", "mitsu")
  loadDecal("manufacturer", "mitsu1")
  loadDecal("manufacturer", "mopar")
  loadDecal("manufacturer", "nismo")
  loadDecal("manufacturer", "nismo2")
  loadDecal("manufacturer", "nissan")
  loadDecal("manufacturer", "nissan1")
  loadDecal("manufacturer", "nissanmines")
  loadDecal("manufacturer", "pontiac")
  loadDecal("manufacturer", "porsche")
  loadDecal("manufacturer", "porsche1")
  loadDecal("manufacturer", "raptor")
  loadDecal("manufacturer", "raptor1")
  loadDecal("manufacturer", "rt")
  loadDecal("manufacturer", "shelby")
  loadDecal("manufacturer", "shelby1")
  loadDecal("manufacturer", "silverado")
  loadDecal("manufacturer", "skoda")
  loadDecal("manufacturer", "skoda2")
  loadDecal("manufacturer", "skoda2vrs")
  loadDecal("manufacturer", "srt")
  loadDecal("manufacturer", "subaru")
  loadDecal("manufacturer", "subarusti")
  loadDecal("manufacturer", "toyo")
  loadDecal("manufacturer", "trd")
  loadDecal("manufacturer", "vw")
  loadDecal("manufacturer", "vw2")
  loadDecal("manufacturer", "vw2a")
  loadDecal("manufacturer", "vw3")
  loadDecal("manufacturer", "vw4")
  loadDecal("manufacturer2", "alfa")
  loadDecal("manufacturer2", "amc")
  loadDecal("manufacturer2", "amg")
  loadDecal("manufacturer2", "ariel")
  loadDecal("manufacturer2", "audi")
  loadDecal("manufacturer2", "audi2")
  loadDecal("manufacturer2", "audi3")
  loadDecal("manufacturer2", "bmw")
  loadDecal("manufacturer2", "bmw1")
  loadDecal("manufacturer2", "bmw2")
  loadDecal("manufacturer2", "bmw3")
  loadDecal("manufacturer2", "bmw4")
  loadDecal("manufacturer2", "bmw5")
  loadDecal("manufacturer2", "bmw6")
  loadDecal("manufacturer2", "bmw7")
  loadDecal("manufacturer2", "bmw8")
  loadDecal("manufacturer2", "bmw9")
  loadDecal("manufacturer2", "bmwm")
  loadDecal("manufacturer2", "bmwm2")
  loadDecal("manufacturer2", "bmwm3")
  loadDecal("manufacturer2", "bmwm4")
  loadDecal("manufacturer2", "bugatti")
  loadDecal("manufacturer2", "cadi")
  loadDecal("manufacturer2", "chevy")
  loadDecal("manufacturer2", "chevy0")
  loadDecal("manufacturer2", "chevy1")
  loadDecal("manufacturer2", "chevy1a")
  loadDecal("manufacturer2", "chevy2")
  loadDecal("manufacturer2", "dodge")
  loadDecal("manufacturer2", "dodge1")
  loadDecal("manufacturer2", "ducati")
  loadDecal("manufacturer2", "ferrari")
  loadDecal("manufacturer2", "ferrari1")
  loadDecal("manufacturer2", "firebird")
  loadDecal("manufacturer2", "ford")
  loadDecal("manufacturer2", "ford1")
  loadDecal("manufacturer2", "ford2")
  loadDecal("manufacturer2", "gmc")
  loadDecal("manufacturer2", "honda")
  loadDecal("manufacturer2", "hum")
  loadDecal("manufacturer2", "jeep")
  loadDecal("manufacturer2", "lada")
  loadDecal("manufacturer2", "lambo")
  loadDecal("manufacturer2", "landrover")
  loadDecal("manufacturer2", "lincoln")
  loadDecal("manufacturer2", "mazda")
  loadDecal("manufacturer2", "mb")
  loadDecal("manufacturer2", "mclaren")
  loadDecal("manufacturer2", "mitsu_ralliart")
  loadDecal("manufacturer2", "mitsu_ralliart2")
  loadDecal("manufacturer2", "mitsu")
  loadDecal("manufacturer2", "mopar")
  loadDecal("manufacturer2", "mugen")
  loadDecal("manufacturer2", "nismo")
  loadDecal("manufacturer2", "nissan")
  loadDecal("manufacturer2", "nissanmines")
  loadDecal("manufacturer2", "nissanvspec")
  loadDecal("manufacturer2", "nissanvspec2")
  loadDecal("manufacturer2", "peu")
  loadDecal("manufacturer2", "plymouth")
  loadDecal("manufacturer2", "pontiac")
  loadDecal("manufacturer2", "porsche")
  loadDecal("manufacturer2", "porsche2")
  loadDecal("manufacturer2", "raptor")
  loadDecal("manufacturer2", "raptora")
  loadDecal("manufacturer2", "raptorx")
  loadDecal("manufacturer2", "seat")
  loadDecal("manufacturer2", "silverado")
  loadDecal("manufacturer2", "skodavrs")
  loadDecal("manufacturer2", "skodavrs2")
  loadDecal("manufacturer2", "suba")
  loadDecal("manufacturer2", "suzuki")
  loadDecal("manufacturer2", "toyota")
  loadDecal("manufacturer2", "toyotadenso")
  loadDecal("manufacturer2", "toyotatrd")
  loadDecal("manufacturer2", "toyotatrd1")
  loadDecal("manufacturer2", "transam")
  loadDecal("manufacturer2", "vw")
  loadDecal("manufacturer2", "vw2")
  loadDecal("manufacturer2", "vw3")
  loadDecal("mintazatok", "0")
  loadDecal("mintazatok", "0a")
  loadDecal("mintazatok", "1")
  loadDecal("mintazatok", "1a")
  loadDecal("mintazatok", "2")
  loadDecal("mintazatok", "3")
  loadDecal("mintazatok", "4")
  loadDecal("mintazatok", "x")
  loadDecal("mintazatok", "x1")
  loadDecal("mintazatok", "x1a")
  loadDecal("mintazatok", "x2")
  loadDecal("mintazatok", "x2a")
  loadDecal("mintazatok", "x2a1")
  loadDecal("mintazatok", "x2a2")
  loadDecal("mintazatok", "x2aa")
  loadDecal("mintazatok", "x2b")
  loadDecal("mintazatok", "x2c")
  loadDecal("mintazatok", "x2d")
  loadDecal("mintazatok", "x2e")
  loadDecal("mintazatok", "x3a")
  loadDecal("mintazatok", "y0")
  loadDecal("mintazatok", "y1")
  loadDecal("mintazatok", "y2")
  loadDecal("mintazatok", "y3")
  loadDecal("mintazatok", "y4")
  loadDecal("mintazatok", "y5")
  loadDecal("mintazatok", "y6")
  loadDecal("mintazatok", "y7")
  loadDecal("pinstripe", "1")
  loadDecal("pinstripe", "2")
  loadDecal("pinstripe", "3")
  loadDecal("pinstripe", "4")
  loadDecal("pinstripe", "5")
  loadDecal("pinstripe", "6")
  loadDecal("pinstripe", "7")
  loadDecal("pinstripe", "8")
  loadDecal("pinstripe", "9")
  loadDecal("pinstripe", "10")
  loadDecal("pinstripe", "11")
  loadDecal("pinstripe", "12")
  loadDecal("pinstripe", "13")
  loadDecal("pinstripe", "14")
  loadDecal("pinstripe", "15")
  loadDecal("pinstripe", "16")
  loadDecal("pinstripe", "17")
  loadDecal("pinstripe", "18")
  loadDecal("pinstripe", "19")
  loadDecal("pinstripe", "20")
  loadDecal("pinstripe", "21")
  loadDecal("pinstripe", "22")
  loadDecal("pinstripe", "23")
  loadDecal("pinstripe", "24")
  loadDecal("pinstripe", "25")
  loadDecal("pinstripe", "26")
  loadDecal("pinstripe", "27")
  loadDecal("pinstripe", "28")
  loadDecal("pinstripe", "29")
  loadDecal("pinstripe", "30")
  loadDecal("pinstripe", "31")
  loadDecal("pinstripe", "32")
  loadDecal("pinstripe", "33")
  loadDecal("pinstripe", "34")
  loadDecal("pinstripe", "35")
  loadDecal("pinstripe", "36")
  loadDecal("pinstripe", "37")
  loadDecal("pinstripe", "38")
  loadDecal("pinstripe", "39")
  loadDecal("pinstripe", "40")
  loadDecal("pinstripe", "41")
  loadDecal("pinstripe", "42")
  loadDecal("pinstripe", "43")
  loadDecal("pinstripe", "44")
  loadDecal("racing", "1")
  loadDecal("racing", "2")
  loadDecal("racing", "3")
  loadDecal("racing", "3a")
  loadDecal("racing", "4")
  loadDecal("racing", "4a")
  loadDecal("racing", "4b")
  loadDecal("racing", "4c")
  loadDecal("racing", "4d")
  loadDecal("racing", "4e")
  loadDecal("racing", "4g")
  loadDecal("racing", "4g1")
  loadDecal("racing", "5")
  loadDecal("racing", "5a")
  loadDecal("racing", "5b")
  loadDecal("racing", "5ba")
  loadDecal("racing", "5c")
  loadDecal("racing", "6a")
  loadDecal("racing", "6b")
  loadDecal("racing", "7")
  loadDecal("racing", "8")
  loadDecal("racing", "9")
  loadDecal("racing", "10")
  loadDecal("racing", "11")
  loadDecal("racing", "12")
  loadDecal("racing", "13")
  loadDecal("racing", "14")
  loadDecal("racing", "15")
  loadDecal("racing", "hood")
  loadDecal("racing", "hood2")
  loadDecal("racing", "side")
  loadDecal("racing", "side1")
  loadDecal("racing", "side3")
  loadDecal("racing", "t1")
  loadDecal("racing", "t2")
  loadDecal("racing", "t3")
  loadDecal("racing", "t4")
  loadDecal("racing", "t4a")
  loadDecal("racing", "t5")
  loadDecal("racing", "t6")
  loadDecal("racing", "t7")
  loadDecal("skull", "sk")
  loadDecal("skull", "sk1")
  loadDecal("skull", "skull01")
  loadDecal("skull", "skull02")
  loadDecal("skull", "skull03")
  loadDecal("skull", "skull04")
  loadDecal("skull", "skull05")
  loadDecal("skull", "skull06")
  loadDecal("skull", "skull07")
  loadDecal("skull", "skull08")
  loadDecal("skull", "skull09")
  loadDecal("skull", "skull10")
  loadDecal("skull", "skull11")
  loadDecal("skull", "skull12")
  loadDecal("skull", "skull13")
  loadDecal("skull", "skull14")
  loadDecal("skull", "skull15")
  loadDecal("skull", "skull16")
  loadDecal("skull", "skull17")
  loadDecal("skull", "skull18")
  loadDecal("skull", "skull19")
  loadDecal("skull", "skull20")
  loadDecal("skull", "skull21")
  loadDecal("skull", "skull22")
  loadDecal("skull", "skull23")
  loadDecal("skull", "skull24")
  loadDecal("splashpaint", "0")
  loadDecal("splashpaint", "0a")
  loadDecal("splashpaint", "0b")
  loadDecal("splashpaint", "0c")
  loadDecal("splashpaint", "1")
  loadDecal("splashpaint", "2")
  loadDecal("splashpaint", "3")
  loadDecal("splashpaint", "4")
  loadDecal("splashpaint", "5")
  loadDecal("splashpaint", "6")
  loadDecal("splashpaint", "7")
  loadDecal("splashpaint", "8")
  loadDecal("splashpaint", "8a")
  loadDecal("splashpaint", "8a1")
  loadDecal("splashpaint", "8b")
  loadDecal("splashpaint", "8c")
  loadDecal("splashpaint", "8c1")
  loadDecal("splashpaint", "9")
  loadDecal("splashpaint", "10")
  loadDecal("splashpaint", "11")
  loadDecal("splashpaint", "12")
  loadDecal("splashpaint", "13")
  loadDecal("splashpaint", "14")
  loadDecal("splashpaint", "15")
  loadDecal("splashpaint", "16")
  loadDecal("splashpaint", "16a")
  loadDecal("splashpaint", "16b")
  loadDecal("splashpaint", "16c")
  loadDecal("splashpaint", "16d")
  loadDecal("splashpaint", "16e")
  loadDecal("splashpaint", "16e1")
  loadDecal("splashpaint", "16e1a")
  loadDecal("splashpaint", "16e2")
  loadDecal("splashpaint", "17")
  loadDecal("splashpaint", "18")
  loadDecal("splashpaint", "19")
  loadDecal("splashpaint", "20")
  loadDecal("splashpaint", "21")
  loadDecal("splashpaint", "22")
  loadDecal("splashpaint", "23")
  loadDecal("splashpaint", "x")
  loadDecal("splashpaint", "x0")
  loadDecal("splashpaint", "x0a")
  loadDecal("splashpaint", "x1")
  loadDecal("stickers", "4x4")
  loadDecal("stickers", "4x42")
  loadDecal("stickers", "battlem")
  loadDecal("stickers", "beem")
  loadDecal("stickers", "blow")
  loadDecal("stickers", "bmw")
  loadDecal("stickers", "bomb")
  loadDecal("stickers", "bomb2")
  loadDecal("stickers", "bomb3")
  loadDecal("stickers", "boo")
  loadDecal("stickers", "built")
  loadDecal("stickers", "bullet")
  loadDecal("stickers", "call")
  loadDecal("stickers", "callservice")
  loadDecal("stickers", "crown")
  loadDecal("stickers", "daily")
  loadDecal("stickers", "dapper")
  loadDecal("stickers", "dc")
  loadDecal("stickers", "dekra")
  loadDecal("stickers", "dekra2")
  loadDecal("stickers", "diamond")
  loadDecal("stickers", "diesel")
  loadDecal("stickers", "diesel2")
  loadDecal("stickers", "domo")
  loadDecal("stickers", "domo1")
  loadDecal("stickers", "dope")
  loadDecal("stickers", "dope2")
  loadDecal("stickers", "dope3")
  loadDecal("stickers", "drift")
  loadDecal("stickers", "drift2")
  loadDecal("stickers", "drift3")
  loadDecal("stickers", "drift4")
  loadDecal("stickers", "drift5")
  loadDecal("stickers", "drift6")
  loadDecal("stickers", "drift7")
  loadDecal("stickers", "drift8")
  loadDecal("stickers", "driftking")
  loadDecal("stickers", "driftking2")
  loadDecal("stickers", "dtm")
  loadDecal("stickers", "dub")
  loadDecal("stickers", "dub2")
  loadDecal("stickers", "eat")
  loadDecal("stickers", "eat2")
  loadDecal("stickers", "eye")
  loadDecal("stickers", "eyes")
  loadDecal("stickers", "f1")
  loadDecal("stickers", "face")
  loadDecal("stickers", "fatl")
  loadDecal("stickers", "formuladrift")
  loadDecal("stickers", "fox")
  loadDecal("stickers", "gasmonkey")
  loadDecal("stickers", "gasmonkey1")
  loadDecal("stickers", "ghost")
  loadDecal("stickers", "grip")
  loadDecal("stickers", "groot")
  loadDecal("stickers", "gym")
  loadDecal("stickers", "haters")
  loadDecal("stickers", "hoon")
  loadDecal("stickers", "hoon2")
  loadDecal("stickers", "hoon3")
  loadDecal("stickers", "hot")
  loadDecal("stickers", "illest")
  loadDecal("stickers", "illest2")
  loadDecal("stickers", "illest3")
  loadDecal("stickers", "init")
  loadDecal("stickers", "initiald")
  loadDecal("stickers", "insta")
  loadDecal("stickers", "jag1")
  loadDecal("stickers", "jag2")
  loadDecal("stickers", "japan")
  loadDecal("stickers", "jdm")
  loadDecal("stickers", "jdm2")
  loadDecal("stickers", "jeep")
  loadDecal("stickers", "jeep2")
  loadDecal("stickers", "kazanish")
  loadDecal("stickers", "low")
  loadDecal("stickers", "low2")
  loadDecal("stickers", "low3")
  loadDecal("stickers", "lowlife")
  loadDecal("stickers", "madein")
  loadDecal("stickers", "mario")
  loadDecal("stickers", "mario2")
  loadDecal("stickers", "mario3")
  loadDecal("stickers", "med")
  loadDecal("stickers", "med2")
  loadDecal("stickers", "med3")
  loadDecal("stickers", "mil")
  loadDecal("stickers", "mil2")
  loadDecal("stickers", "monstel")
  loadDecal("stickers", "monster")
  loadDecal("stickers", "mountain")
  loadDecal("stickers", "nfs")
  loadDecal("stickers", "nofatc")
  loadDecal("stickers", "noisebomb")
  loadDecal("stickers", "noisebomb2")
  loadDecal("stickers", "nos")
  loadDecal("stickers", "nur")
  loadDecal("stickers", "pandem")
  loadDecal("stickers", "patesz")
  loadDecal("stickers", "pig")
  loadDecal("stickers", "racing")
  loadDecal("stickers", "rocket")
  loadDecal("stickers", "rocket2")
  loadDecal("stickers", "safetyc")
  loadDecal("stickers", "safetyc2")
  loadDecal("stickers", "sedan")
  loadDecal("stickers", "stance")
  loadDecal("stickers", "stance2")
  loadDecal("stickers", "stance3")
  loadDecal("stickers", "star")
  loadDecal("stickers", "star2")
  loadDecal("stickers", "star3")
  loadDecal("stickers", "static")
  loadDecal("stickers", "sticker5hp")
  loadDecal("stickers", "sticker10hp")
  loadDecal("stickers", "suba")
  loadDecal("stickers", "tuning")
  loadDecal("stickers", "tuning1")
  loadDecal("stickers", "turbo")
  loadDecal("stickers", "turbo1")
  loadDecal("stickers", "turbo2")
  loadDecal("stickers", "turbo3")
  loadDecal("stickers", "turbo4")
  loadDecal("stickers", "twitch")
  loadDecal("stickers", "x")
  loadDecal("stickers", "x0")
  loadDecal("stickers", "x1")
  loadDecal("stickers", "xbaby")
  loadDecal("stickers", "xbaby2")
  loadDecal("stickers", "yt")
  loadDecal("stickers2", "0")
  loadDecal("stickers2", "bear")
  loadDecal("stickers2", "bear2")
  loadDecal("stickers2", "bomb")
  loadDecal("stickers2", "built")
  loadDecal("stickers2", "carhub1")
  loadDecal("stickers2", "carhub2")
  loadDecal("stickers2", "crown")
  loadDecal("stickers2", "dc")
  loadDecal("stickers2", "dofi")
  loadDecal("stickers2", "domo")
  loadDecal("stickers2", "drift")
  loadDecal("stickers2", "driftmonkey")
  loadDecal("stickers2", "face")
  loadDecal("stickers2", "fdrift")
  loadDecal("stickers2", "fuelcap")
  loadDecal("stickers2", "fuelcap2")
  loadDecal("stickers2", "grip")
  loadDecal("stickers2", "hand")
  loadDecal("stickers2", "heat")
  loadDecal("stickers2", "hk")
  loadDecal("stickers2", "hks")
  loadDecal("stickers2", "hoo")
  loadDecal("stickers2", "hoo2")
  loadDecal("stickers2", "hoodpin")
  loadDecal("stickers2", "insta")
  loadDecal("stickers2", "jdm")
  loadDecal("stickers2", "jeep")
  loadDecal("stickers2", "liq")
  loadDecal("stickers2", "lowrider")
  loadDecal("stickers2", "mouth")
  loadDecal("stickers2", "mouth2")
  loadDecal("stickers2", "nagymagyar")
  loadDecal("stickers2", "nber1")
  loadDecal("stickers2", "nber2")
  loadDecal("stickers2", "nber3")
  loadDecal("stickers2", "nber4")
  loadDecal("stickers2", "nber5")
  loadDecal("stickers2", "nber6")
  loadDecal("stickers2", "nber7")
  loadDecal("stickers2", "nber8")
  loadDecal("stickers2", "nber9")
  loadDecal("stickers2", "nber10")
  loadDecal("stickers2", "nber11")
  loadDecal("stickers2", "nber12")
  loadDecal("stickers2", "nber13")
  loadDecal("stickers2", "nur")
  loadDecal("stickers2", "p")
  loadDecal("stickers2", "pelikan")
  loadDecal("stickers2", "shine")
  loadDecal("stickers2", "shine2")
  loadDecal("stickers2", "skull2")
  loadDecal("stickers2", "smokeandcharm1")
  loadDecal("stickers2", "smokeandcharm2")
  loadDecal("stickers2", "st")
  loadDecal("stickers2", "stick")
  loadDecal("stickers2", "stones")
  loadDecal("stickers2", "sultan")
  loadDecal("stickers2", "t")
  loadDecal("stickers2", "thug")
  loadDecal("stickers2", "turbo")
  loadDecal("stickers2", "yt")
  loadDecal("textures", "0")
  loadDecal("textures", "1")
  loadDecal("textures", "alu")
  loadDecal("textures", "brushed")
  loadDecal("textures", "c1")
  loadDecal("textures", "camo0")
  loadDecal("textures", "camo00")
  loadDecal("textures", "camo000")
  loadDecal("textures", "camo00a")
  loadDecal("textures", "camo0a")
  loadDecal("textures", "camo0a1")
  loadDecal("textures", "camo1")
  loadDecal("textures", "camo2")
  loadDecal("textures", "camo2a")
  loadDecal("textures", "camo2a1")
  loadDecal("textures", "camo2a2")
  loadDecal("textures", "camo2a3")
  loadDecal("textures", "camo2a4")
  loadDecal("textures", "camo2a5")
  loadDecal("textures", "camo3")
  loadDecal("textures", "camo4")
  loadDecal("textures", "fiberglass")
  loadDecal("textures", "hks")
  loadDecal("textures", "metal")
  loadDecal("textures", "metal2")
  loadDecal("textures", "metal3")
  loadDecal("textures", "metal3a")
  loadDecal("textures", "metal4")
  loadDecal("textures", "metal4a")
  loadDecal("textures", "metal5")
  loadDecal("textures", "metal6")
  loadDecal("textures", "metal7")
  loadDecal("textures", "neon1")
  loadDecal("textures", "neon2")
  loadDecal("textures", "neon3")
  loadDecal("textures", "neon4")
  loadDecal("textures", "neon5")
  loadDecal("textures", "neon6")
  loadDecal("textures", "neon7")
  loadDecal("textures", "neon8")
  loadDecal("textures", "neonp1")
  loadDecal("textures", "neonp2")
  loadDecal("textures", "neonp3")
  loadDecal("textures", "neonp4")
  loadDecal("textures", "plastic")
  loadDecal("textures", "ps")
  loadDecal("textures", "rust")
  loadDecal("textures", "rust2")
  loadDecal("textures", "splat0")
  loadDecal("textures", "splat1")
  loadDecal("textures", "splat1a")
  loadDecal("textures", "splat2")
  loadDecal("textures", "splat3")
  loadDecal("textures", "splat4")
  loadDecal("textures", "splat5")
  loadDecal("textures", "splat11")
  loadDecal("textures", "stars")
  loadDecal("textures", "stickerbomb")
  loadDecal("textures", "stickerbomb1")
  loadDecal("textures", "w1")
  loadDecal("textures", "w2")
  loadDecal("textures", "w3")
  loadDecal("tribal", "0")
  loadDecal("tribal", "1")
  loadDecal("tribal", "2")
  loadDecal("tribal", "3")
  loadDecal("tribal", "4")
  loadDecal("tribal", "5")
  loadDecal("tribal", "6")
  loadDecal("tribal", "7")
  loadDecal("tribal", "8")
  loadDecal("tribal", "9")
  loadDecal("tribal", "10")
  loadDecal("tribal", "11")
  loadDecal("tribal", "12")
  loadDecal("tribal", "13")
  loadDecal("tribal", "14")
  loadDecal("tribal", "15")
  loadDecal("tribal", "16")
  loadDecal("tribal", "17")
  loadDecal("tribal", "18")
  loadDecal("tribal", "19")
  loadDecal("tribal", "20")
  loadDecal("tribal", "21")
  loadDecal("tribal", "22")
  loadDecal("tribal", "23")
  loadDecal("tribal", "24")
  loadDecal("tribal", "25")
  loadDecal("tribal", "26")
end
local layers = {}
local selectedLayer = false
local layerClick = false
local selectorCategory = false
local paintjobDeleterPrompt = false
local paintjobToLoad = false
local paintjobLoaderElements = {}
local paintjobLoaderData = {}
local paintjobLoaderPager = {}
local currentPaintjobLoaderPage = 1
local decalSelectorElements = {}
local decalSelectorCategoryElements = {}
local decalSelectorCategoryScroll = 0
local decalCategoryButtons = {}
local currentDecalSelectorPage = 1
local decalToPlace = false
local sx, sy = 0, 0
local camX = 0.5
local camY = 0
local desiredCamZoom = 1.75
local camZoom = 1.75
local camCursor = false
local w = math.floor(screenX * 0.15)
local editor = false
local footer = false
local header = false
local layerElements = {}
local layerButtons = {}
local decalSelectorPager = false
local decalSelectorPagers = false
local layerCountLabel = false
local bcgH1 = false
local bcgH2 = false
local sliderH = false
local bcgS1 = false
local bcgS2 = false
local sliderS = false
local bcgL1 = false
local bcgL2 = false
local bcgL3 = false
local sliderL = false
local bcgO1 = false
local bcgO2 = false
local sliderO = false
local labelO = false
local sliderBackgroundSize = false
local newDecalImage = false
local layerNameInput = false
local newDecalColorInput = false
local newDecalColors = false
local newDecalColorCount = false
local newDecalColorList = {}
function resetTheColorList()
  newDecalColorList = {
    {
      255,
      255,
      255,
      true
    },
    {
      50,
      50,
      50,
      true
    },
    {
      0,
      0,
      0,
      true
    },
    {
      29,
      167,
      230,
      true
    },
    {
      45,
      41,
      143,
      true
    },
    {
      217,
      23,
      29,
      true
    },
    {
      226,
      0,
      37,
      true
    },
    {
      252,
      228,
      0,
      true
    },
    {
      33,
      116,
      78,
      true
    },
    {
      214,
      39,
      39,
      true
    },
    {
      61,
      87,
      143,
      true
    },
    {
      255,
      151,
      0,
      true
    },
    {
      0,
      152,
      155,
      true
    },
    {
      7,
      17,
      66,
      true
    },
    {
      0,
      154,
      78,
      true
    },
    {
      0,
      173,
      239,
      true
    },
    {
      218,
      30,
      42,
      true
    },
    {
      37,
      49,
      92,
      true
    },
    {
      251,
      206,
      7,
      true
    }
  }
end
local toolbarIcons = {}
local toolbarToggles = {}
local layerScroll = 0
local placingDecalColor = {
  255,
  255,
  255
}
local inEditorMode = false
local placingDecal = false
local placingHeight = 128
local placingRot = 0
local uvX, uvY = false, nil
local uvR = 0
local hoveringLayerSide = {}
local hoveringLayerSideCount = 0
local hoveringLayer = false
local movingLayer = false
local movingMode = "move"
local green = false
local grey2 = false
local grey4 = false
local mirrorTries = 0
local mirrorSetStage = 1
local mirrorPositions = {}
local mirrorsReady = false
local mirrorsPostReady = false
local customTextFonts = {
  {
    "aAnotherTag.ttf",
    30
  },
  {
    "americorps.ttf",
    20
  },
  {
    "americorps3d.ttf",
    20
  },
  {
    "americorpsgrad.ttf",
    20
  },
  {
    "americorpslaser.ttf",
    20
  },
  {
    "barbatrick.ttf",
    23
  },
  {
    "BebasNeueBold.otf",
    25
  },
  {
    "BebasNeueRegular.otf",
    25
  },
  {
    "BlankRiver.ttf",
    30
  },
  {"Ikarus.otf", 23},
  {
    "Butler_Regular.otf",
    25
  },
  {
    "CampusA.ttf",
    23
  },
  {
    "DDayStencil.ttf",
    25
  },
  {
    "raustila-Regular.ttf",
    30
  },
  {
    "StrangerbackintheNight.ttf",
    30
  },
  {
    "Ubuntu-B.ttf",
    23
  },
  {
    "Ubuntu-R.ttf",
    23
  },
  {
    "Xenogears.ttf",
    23
  }
}
local maskSource = [[
	  
	texture MaskTexture; 
	sampler implicitMaskTexture = sampler_state 
	{ 
		Texture = <MaskTexture>; 
	}; 
	  
	  
	float4 MaskTextureMain( float2 uv : TEXCOORD0 ) : COLOR0 
	{ 
		 
		float4 sampledTexture = float4(1, 1, 1, 0); 

		float4 maskSampled = tex2D( implicitMaskTexture, uv ); 
		
		sampledTexture.a = (maskSampled.r + maskSampled.g + maskSampled.b) / 3.0f; 

		return sampledTexture; 
	} 
	  
	technique Technique1 
	{ 
		pass Pass1 
		{ 
			PixelShader = compile ps_2_0 MaskTextureMain(); 
		} 
	} 

]]
function loadCustomTextDecal(input, fontInput, size)
  local name = "customtext/" .. fontInput .. "/" .. size .. "/" .. input
  if decals[name] then
    return name
  end
  local done = false
  local text = false
  local tw = 0
  local font = dxCreateFont("files/fonts/" .. fontInput, size * 2, false, "antialiased")
  if isElement(font) then
    local tw = math.floor(dxGetTextWidth(input, 0.5, font) / 2) * 2 + 16
    local rt = dxCreateRenderTarget(tw, 64, true)
    local rt2 = dxCreateRenderTarget(tw, 64, true)
    local shader = dxCreateShader(maskSource)
    if isElement(rt) and isElement(rt2) and isElement(shader) then
      dxSetShaderValue(shader, "MaskTexture", rt2)
      dxSetRenderTarget(rt2, true)
      dxSetBlendMode("modulate_add")
      dxDrawRectangle(0, 0, tw, 64, tocolor(0, 0, 0))
      dxDrawText(input, tw, 0, 0, 64, tocolor(255, 255, 255, 255), 0.5, font, "center", "center")
      dxSetRenderTarget(rt, true)
      dxSetBlendMode("overwrite")
      dxDrawImage(0, 0, tw, 64, shader)
      dxSetBlendMode("blend")
      dxSetRenderTarget()
      local pixels = dxGetTexturePixels(rt)
      if pixels then
        text = dxCreateTexture(pixels)
        pixels = nil
        collectgarbage("collect")
        decals[name] = {
          text,
          tw,
          64,
          true,
          "Egyedi szöveg",
          fontInput,
          size,
          input
        }
        done = name
      end
    end
    if isElement(shader) then
      destroyElement(shader)
    end
    shader = nil
    if isElement(rt) then
      destroyElement(rt)
    end
    rt = nil
    if isElement(rt2) then
      destroyElement(rt2)
    end
    rt2 = nil
    destroyElement(font)
    font = nil
  end
  return done
end
local carBackgroundTexutre = "textures/0"
local carBackgroundColor = {
  255,
  255,
  255
}
local carBackgroundSize = 256
local layerHighlight = false
function drawPlacing()
  local v = decals[placingDecal]
  local w = math.floor(placingHeight * (v[2] / v[3]))
  if v[6] then
    dxDrawImage(math.floor(uvX * ts - w / 2), math.floor(uvY * ts - placingHeight / 2), w, placingHeight, v[1], placingRot + (uvR or 0), 0, 0, tocolor(placingDecalColor[1], placingDecalColor[2], placingDecalColor[3], placingDecalColor[4]))
  else
    dxDrawImage(math.floor(uvX * ts - w / 2), math.floor(uvY * ts - placingHeight / 2), w, placingHeight, dynamicImage(getDecalTexture(placingDecal, w, placingHeight), "argb", false), placingRot + (uvR or 0), 0, 0, tocolor(placingDecalColor[1], placingDecalColor[2], placingDecalColor[3], placingDecalColor[4]))
  end
end
function drawLayers(final)
  if not decalLoadQueue or final then
    local pulse = getTickCount() % 1500 / 750
    if 1 < pulse then
      pulse = 2 - pulse
    end
    pulse = getEasingValue(pulse, "InOutQuad")
    dxSetRenderTarget(renderTarget2, true)
    dxSetBlendMode("modulate_add")
    local col = tocolor(carBackgroundColor[1], carBackgroundColor[2], carBackgroundColor[3])
    local cs = math.floor(carBackgroundSize + 0.5)
    for x = 0, math.ceil(ts / cs) - 1 do
      for y = 0, math.ceil(ts / cs) - 1 do
        dxDrawImage(x * cs, y * cs, cs, cs, dynamicImage(getDecalTexture(carBackgroundTexutre, cs, cs), "argb", false), 0, 0, 0, col)
      end
    end
    for i = 1, #layers do
      local a = layers[i][7][4]
      if not final and layerHighlight and i ~= selectedLayer then
        a = a * 0.25
      end
      if not final and not layerClick and hoveringLayerSide[i] then
        a = a * (0.5 + 0.5 * pulse)
      end
      local x, y, sx, sy = layers[i][2], layers[i][3], layers[i][4], layers[i][5]
      if layers[i][9] then
        x = x + sx
        sx = -sx
      end
      if layers[i][10] then
        y = y + sy
        sy = -sy
      end
      if decals[layers[i][1]][6] then
        dxDrawImage(x, y, sx, sy, decals[layers[i][1]][1], layers[i][6], 0, 0, tocolor(layers[i][7][1], layers[i][7][2], layers[i][7][3], a))
      else
        dxDrawImage(x, y, sx, sy, dynamicImage(getDecalTexture(layers[i][1], sx, sy), "argb", false), layers[i][6], 0, 0, tocolor(layers[i][7][1], layers[i][7][2], layers[i][7][3], a))
      end
      if mirrorsReady and layers[i][11] then
        local x, y, sx, sy = layers[i][2], layers[i][3], layers[i][4], layers[i][5]
        local mx, my, mdx, mdy = mirrorPositions[1], mirrorPositions[2], mirrorPositions[3], mirrorPositions[4]
        local mx2, my2, mdx2, mdy2 = mirrorPositions[5], mirrorPositions[6], mirrorPositions[7], mirrorPositions[8]
        if getDistanceBetweenPoints2D(x, y, mx2, my2) < getDistanceBetweenPoints2D(x, y, mx, my) then
          mx, my, mdx, mdy = mirrorPositions[5], mirrorPositions[6], mirrorPositions[7], mirrorPositions[8]
          mx2, my2, mdx2, mdy2 = mirrorPositions[1], mirrorPositions[2], mirrorPositions[3], mirrorPositions[4]
        end
        x = x + sx / 2
        y = y + sy / 2
        x = mx2 + (x - mx) * (mdx2 * mdx)
        y = my2 + (y - my) * (mdy2 * mdy)
        local dx = (layers[i][9] and -1 or 1) * mdx2 * mdx * (layers[i][12] and -1 or 1)
        local dy = (layers[i][10] and -1 or 1) * mdy2 * mdy
        local r = layers[i][6]
        if mdx2 * mdx * mdy2 * mdy < 0 then
          r = 360 - r
        end
        x = x + sx / 2 * -dx
        y = y + sy / 2 * -dy
        sx = sx * dx
        sy = sy * dy
        if decals[layers[i][1]][6] then
          dxDrawImage(x, y, sx, sy, decals[layers[i][1]][1], r, 0, 0, tocolor(layers[i][7][1], layers[i][7][2], layers[i][7][3], a))
        else
          dxDrawImage(x, y, sx, sy, dynamicImage(getDecalTexture(layers[i][1], sx, sy), "argb", false), r, 0, 0, tocolor(layers[i][7][1], layers[i][7][2], layers[i][7][3], a))
        end
      end
      if i == selectedLayer and placingDecal and uvX then
        drawPlacing()
      end
    end
    if placingDecal and uvX and (not selectedLayer or not layers[selectedLayer]) then
      drawPlacing()
    end
    if not final and not placingDecal and selectedLayer then
      local layer = layers[selectedLayer]
      local hom = hoveringLayer or movingLayer
      local hSide = false
      if movingMode == "resize" and hom then
        hSide = hoveringLayer and hoveringLayer[7] or movingLayer[7]
      end
      local white = tocolor(255, 255, 255)
      local col = hom and green or white
      local x, y = layer[2], layer[3]
      local sx, sy = layer[4], layer[5]
      local rot = layer[6]
      local r = math.rad(rot)
      local s = math.sin(r)
      local c = math.cos(r)
      local cs = math.min(math.floor(math.min(sx, sy) / 5 / 2) * 2, 16)
      local lw = cs / 4
      local lx, ly, lx2, ly2, cx, cy, cx2, cy2
      if movingMode == "resize" then
        col = hom and hSide == "s1" and green or white
        lx = x + sx / 2 + (-sx / 2 + cs * 1.5) * c - -sy / 2 * s
        ly = y + sy / 2 + (-sx / 2 + cs * 1.5) * s + -sy / 2 * c
        lx2 = x + sx / 2 + (sx / 2 - cs * 1.5) * c - -sy / 2 * s
        ly2 = y + sy / 2 + (sx / 2 - cs * 1.5) * s + -sy / 2 * c
        dxDrawLineEx(lx, ly, lx2, ly2, lw)
        dxDrawLine(lx, ly, lx2, ly2, col, lw)
        col = hom and hSide == "s2" and green or white
        lx = x + sx / 2 + (-sx / 2 + cs * 1.5) * c - sy / 2 * s
        ly = y + sy / 2 + (-sx / 2 + cs * 1.5) * s + sy / 2 * c
        lx2 = x + sx / 2 + (sx / 2 - cs * 1.5) * c - sy / 2 * s
        ly2 = y + sy / 2 + (sx / 2 - cs * 1.5) * s + sy / 2 * c
        dxDrawLineEx(lx, ly, lx2, ly2, lw)
        dxDrawLine(lx, ly, lx2, ly2, col, lw)
        col = hom and hSide == "s3" and green or white
        lx = x + sx / 2 + -sx / 2 * c - (-sy / 2 + cs * 1.5) * s
        ly = y + sy / 2 + -sx / 2 * s + (-sy / 2 + cs * 1.5) * c
        lx2 = x + sx / 2 + -sx / 2 * c - (sy / 2 - cs * 1.5) * s
        ly2 = y + sy / 2 + -sx / 2 * s + (sy / 2 - cs * 1.5) * c
        dxDrawLineEx(lx, ly, lx2, ly2, lw)
        dxDrawLine(lx, ly, lx2, ly2, col, lw)
        col = hom and hSide == "s4" and green or white
        lx = x + sx / 2 + sx / 2 * c - (-sy / 2 + cs * 1.5) * s
        ly = y + sy / 2 + sx / 2 * s + (-sy / 2 + cs * 1.5) * c
        lx2 = x + sx / 2 + sx / 2 * c - (sy / 2 - cs * 1.5) * s
        ly2 = y + sy / 2 + sx / 2 * s + (sy / 2 - cs * 1.5) * c
        dxDrawLineEx(lx, ly, lx2, ly2, lw)
        dxDrawLine(lx, ly, lx2, ly2, col, lw)
      end
      if movingMode == "resize" then
        col = hom and hSide == "c1" and green or white
      end
      cx = x + sx / 2 + (-sx / 2 - lw / 2) * c - -sy / 2 * s
      cy = y + sy / 2 + (-sx / 2 - lw / 2) * s + -sy / 2 * c
      cx2 = x + sx / 2 + -sx / 2 * c - -sy / 2 * s
      cy2 = y + sy / 2 + -sx / 2 * s + -sy / 2 * c
      lx = x + sx / 2 + (-sx / 2 + cs) * c - -sy / 2 * s
      ly = y + sy / 2 + (-sx / 2 + cs) * s + -sy / 2 * c
      lx2 = x + sx / 2 + -sx / 2 * c - (-sy / 2 + cs) * s
      ly2 = y + sy / 2 + -sx / 2 * s + (-sy / 2 + cs) * c
      dxDrawLineEx(cx, cy, lx, ly, lw)
      dxDrawLineEx(cx2, cy2, lx2, ly2, lw)
      dxDrawLine(cx, cy, lx, ly, col, lw)
      dxDrawLine(cx2, cy2, lx2, ly2, col, lw)
      if movingMode == "resize" then
        col = hom and hSide == "c3" and green or white
      end
      cx = x + sx / 2 + (sx / 2 + lw / 2) * c - -sy / 2 * s
      cy = y + sy / 2 + (sx / 2 + lw / 2) * s + -sy / 2 * c
      cx2 = x + sx / 2 + sx / 2 * c - -sy / 2 * s
      cy2 = y + sy / 2 + sx / 2 * s + -sy / 2 * c
      lx = x + sx / 2 + (sx / 2 - cs) * c - -sy / 2 * s
      ly = y + sy / 2 + (sx / 2 - cs) * s + -sy / 2 * c
      lx2 = x + sx / 2 + sx / 2 * c - (-sy / 2 + cs) * s
      ly2 = y + sy / 2 + sx / 2 * s + (-sy / 2 + cs) * c
      dxDrawLineEx(cx, cy, lx, ly, lw)
      dxDrawLineEx(cx2, cy2, lx2, ly2, lw)
      dxDrawLine(cx, cy, lx, ly, col, lw)
      dxDrawLine(cx2, cy2, lx2, ly2, col, lw)
      if movingMode == "resize" then
        col = hom and hSide == "c4" and green or white
      end
      cx = x + sx / 2 + (sx / 2 + lw / 2) * c - sy / 2 * s
      cy = y + sy / 2 + (sx / 2 + lw / 2) * s + sy / 2 * c
      cx2 = x + sx / 2 + sx / 2 * c - sy / 2 * s
      cy2 = y + sy / 2 + sx / 2 * s + sy / 2 * c
      lx = x + sx / 2 + (sx / 2 - cs) * c - sy / 2 * s
      ly = y + sy / 2 + (sx / 2 - cs) * s + sy / 2 * c
      lx2 = x + sx / 2 + sx / 2 * c - (sy / 2 - cs) * s
      ly2 = y + sy / 2 + sx / 2 * s + (sy / 2 - cs) * c
      dxDrawLineEx(cx, cy, lx, ly, lw)
      dxDrawLineEx(cx2, cy2, lx2, ly2, lw)
      dxDrawLine(cx, cy, lx, ly, col, lw)
      dxDrawLine(cx2, cy2, lx2, ly2, col, lw)
      if movingMode == "resize" then
        col = hom and hSide == "c2" and green or white
      end
      cx = x + sx / 2 + (-sx / 2 - lw / 2) * c - sy / 2 * s
      cy = y + sy / 2 + (-sx / 2 - lw / 2) * s + sy / 2 * c
      cx2 = x + sx / 2 + -sx / 2 * c - sy / 2 * s
      cy2 = y + sy / 2 + -sx / 2 * s + sy / 2 * c
      lx = x + sx / 2 + (-sx / 2 + cs) * c - sy / 2 * s
      ly = y + sy / 2 + (-sx / 2 + cs) * s + sy / 2 * c
      lx2 = x + sx / 2 + -sx / 2 * c - (sy / 2 - cs) * s
      ly2 = y + sy / 2 + -sx / 2 * s + (sy / 2 - cs) * c
      dxDrawLineEx(cx, cy, lx, ly, lw)
      dxDrawLineEx(cx2, cy2, lx2, ly2, lw)
      dxDrawLine(cx, cy, lx, ly, col, lw)
      dxDrawLine(cx2, cy2, lx2, ly2, col, lw)
      if movingMode == "rotate" then
        dxDrawLineEx(x + sx / 2 - cs / 2, y + sy / 2, x + sx / 2 + cs / 2, y + sy / 2, lw)
        dxDrawLineEx(x + sx / 2, y + sy / 2 - cs / 2, x + sx / 2, y + sy / 2 + cs / 2, lw)
        dxDrawLine(x + sx / 2 - cs / 2, y + sy / 2, x + sx / 2 + cs / 2, y + sy / 2, col, lw)
        dxDrawLine(x + sx / 2, y + sy / 2 - cs / 2, x + sx / 2, y + sy / 2 + cs / 2, col, lw)
      end
    end
    dxSetBlendMode("blend")
    dxSetRenderTarget()
  end
end
addEvent("copyCurrentDecalLayer", true)
addEventHandler("copyCurrentDecalLayer", getRootElement(), function()
  if selectedLayer and layers[selectedLayer] then
    local tmp = {}
    for i, v in pairs(layers[selectedLayer]) do
      tmp[i] = v
    end
    table.insert(layers, selectedLayer, tmp)
    processToolbarToggles()
    processLayerElements()
    rtToDraw = true
  end
end)
addEvent("deleteCurrentDecalLayer", true)
addEventHandler("deleteCurrentDecalLayer", getRootElement(), function()
  if selectedLayer and layers[selectedLayer] then
    if decals[layers[selectedLayer][1]][6] then
      local found = false
      for i = 1, #layers do
        if i ~= selectedLayer and layers[i][1] == layers[selectedLayer][1] then
          found = true
          break
        end
      end
      if not found then
        if isElement(decals[layers[selectedLayer][1]][1]) then
          destroyElement(decals[layers[selectedLayer][1]][1])
        end
        decals[layers[selectedLayer][1]] = nil
      end
    end
    table.remove(layers, selectedLayer)
    if not layers[selectedLayer] then
      selectedLayer = #layers
      if not layers[selectedLayer] then
        selectedLayer = false
      end
    end
    if layerScroll > math.max(0, #layers - #layerElements) then
      layerScroll = math.max(0, #layers - #layerElements)
    end
    processToolbarToggles()
    processLayerElements()
    rtToDraw = true
  end
end)
local newLayerCounter = 1
function pjEditorClick(btn, state)
  if state == "down" and btn == "left" then
    if placingDecal and uvX then
      local v = decals[placingDecal]
      local w = math.floor(placingHeight * (v[2] / v[3]))
      local tmp = {
        placingDecal,
        math.floor(uvX * ts - w / 2),
        math.floor(uvY * ts - placingHeight / 2),
        w,
        placingHeight,
        placingRot + (uvR or 0),
        {
          placingDecalColor[1],
          placingDecalColor[2],
          placingDecalColor[3],
          placingDecalColor[4] or 255
        },
        placingDecalName
      }
      if selectedLayer and layers[selectedLayer + 1] then
        table.insert(layers, selectedLayer + 1, tmp)
        selectedLayer = selectedLayer + 1
      else
        table.insert(layers, tmp)
        selectedLayer = #layers
        layerScroll = 0
      end
      processToolbarToggles()
      newLayerCounter = newLayerCounter + 1
      placingDecal = false
      decalToPlace = false
      processLayerElements()
      rtToDraw = true
    elseif hoveringLayer then
      movingLayer = hoveringLayer
    end
  elseif state == "up" then
    if layerClick then
      layerClick = false
      rtToDraw = true
      processLayerElements()
    elseif movingLayer and btn == "left" then
      movingLayer = false
      rtToDraw = true
    end
  end
end
function pjEditorKey(key, por)
  if not buyingPaintjob then
    if key == "mouse_wheel_up" and inEditorMode then
      local cx, cy = getCursorPosition()
      if cx then
        cx = cx * screenX
        cy = cy * screenY
      end
      if cx and 24 <= cx and cx <= 24 + w and 72 <= cy and cy <= seexports.seal_gui:getGuiRealPosition(footer, "y") then
        if 0 < layerScroll then
          layerScroll = layerScroll - 1
          processLayerElements()
        end
      elseif placingDecal and not getKeyState("mouse2") then
        if getKeyState("lshift") then
          placingRot = (placingRot + 2.5) % 360
        elseif placingHeight < 256 then
          placingHeight = placingHeight + 8
          rtToDraw = true
        end
      elseif getKeyState("lshift") and selectedLayer and layers[selectedLayer] then
        if movingMode == "rotate" then
          layers[selectedLayer][6] = math.floor(layers[selectedLayer][6] + 1) % 360
          rtToDraw = true
        else
          local rot = layers[selectedLayer][6]
          local osx, osy = layers[selectedLayer][4], layers[selectedLayer][5]
          local sx, sy = 8, 8
          if sx > sy then
            sy = sy * (osy / osx)
          else
            sx = sx * (osx / osy)
          end
          local rx, ry = 0, 0
          local r = math.rad(rot)
          local s = math.sin(r)
          local c = math.cos(r)
          local ix = osx / 2
          local iy = osy / 2
          layers[selectedLayer][2] = math.floor(layers[selectedLayer][2] + ix - (osx + sx) / 2 + 0.5)
          layers[selectedLayer][3] = math.floor(layers[selectedLayer][3] + iy - (osy + sy) / 2 + 0.5)
          layers[selectedLayer][4] = layers[selectedLayer][4] + sx
          layers[selectedLayer][5] = layers[selectedLayer][5] + sy
          rtToDraw = true
        end
      elseif 1 < desiredCamZoom then
        desiredCamZoom = desiredCamZoom - 0.1
      end
    elseif key == "mouse_wheel_down" and inEditorMode then
      local cx, cy = getCursorPosition()
      if cx then
        cx = cx * screenX
        cy = cy * screenY
      end
      if cx and 24 <= cx and cx <= 24 + w and 72 <= cy and cy <= seexports.seal_gui:getGuiRealPosition(footer, "y") then
        if layerScroll < #layers - #layerElements then
          layerScroll = layerScroll + 1
          processLayerElements()
        end
      elseif placingDecal and not getKeyState("mouse2") then
        if getKeyState("lshift") then
          placingRot = (placingRot - 2.5) % 360
        elseif 32 < placingHeight then
          placingHeight = placingHeight - 8
          rtToDraw = true
        end
      elseif getKeyState("lshift") and selectedLayer and layers[selectedLayer] then
        if movingMode == "rotate" then
          layers[selectedLayer][6] = math.floor(layers[selectedLayer][6] - 1) % 360
          rtToDraw = true
        else
          local rot = layers[selectedLayer][6]
          local osx, osy = layers[selectedLayer][4], layers[selectedLayer][5]
          local sx, sy = -8, -8
          if sx > sy then
            sy = sy * (osy / osx)
          else
            sx = sx * (osx / osy)
          end
          if 24 <= osx + sx and 24 <= osy + sy then
            local rx, ry = 0, 0
            local r = math.rad(rot)
            local s = math.sin(r)
            local c = math.cos(r)
            local ix = osx / 2
            local iy = osy / 2
            layers[selectedLayer][2] = math.floor(layers[selectedLayer][2] + ix - (osx + sx) / 2 + 0.5)
            layers[selectedLayer][3] = math.floor(layers[selectedLayer][3] + iy - (osy + sy) / 2 + 0.5)
            layers[selectedLayer][4] = layers[selectedLayer][4] + sx
            layers[selectedLayer][5] = layers[selectedLayer][5] + sy
            rtToDraw = true
          end
        end
      elseif desiredCamZoom < 2.75 then
        desiredCamZoom = desiredCamZoom + 0.1
      end
    elseif por and not seexports.seal_gui:getActiveInput() then
      if inEditorMode then
        if key == "delete" then
          triggerEvent("deleteCurrentDecalLayer", localPlayer)
        elseif key == "m" then
          movingMode = "move"
          movingLayer = false
          rtToDraw = true
          processToolbarIcons()
        elseif key == "r" then
          movingMode = "rotate"
          movingLayer = false
          rtToDraw = true
          processToolbarIcons()
        elseif key == "o" then
          if getKeyState("lctrl") then
            triggerEvent("decalEditorOpenPaintjob", localPlayer)
          end
        elseif key == "s" then
          if getKeyState("lctrl") then
            triggerEvent("decalEditorSavePaintjob", localPlayer)
          else
            movingMode = "resize"
            movingLayer = false
            rtToDraw = true
            processToolbarIcons()
          end
        elseif key == "t" then
          triggerEvent("openNewTextLayerPanel", localPlayer)
        elseif key == "c" then
          triggerEvent("copyCurrentDecalLayer", localPlayer)
        elseif key == "e" then
          triggerEvent("decalEditorEditLayer", localPlayer)
        elseif key == "n" then
          triggerEvent("openNewDecalPanel", localPlayer)
        end
      elseif key == "backspace" then
        triggerEvent("returnToTheMainPaintjobPage", localPlayer)
      end
    end
  end
end
function initColorsAndFonts()
  green = seexports.seal_gui:getColorCodeToColor("primary")
  grey2 = seexports.seal_gui:getColorCodeToColor("grey2")
  grey4 = seexports.seal_gui:getColorCodeToColor("grey4")
end
local newTextInput = false
local newTextPreviewFont = false
local newTextPreviewFontId = 1
local newTextPreviewFontElements = {}
local layersScrollBcg = false
local layersScrollbar = false
local oldCarBcgTexture = false
local paintjobPreviewTexture = false
local saveNextFrame = false
local prepareSaveNextFrame = false
local saveFakeScreenSource = false
local guiElementDecals = {}
local guiElementDecalsTex = {}
addEvent("deletedPJDecalElement", false)
addEventHandler("deletedPJDecalElement", getRootElement(), function(el)
  guiElementDecals[el] = nil
  guiElementDecalsTex[el] = nil
end)
function deleteEditorGui()
  for i = 1, #paintjobLoaderData do
    if isElement(paintjobLoaderData[i][2]) then
      destroyElement(paintjobLoaderData[i][2])
    end
  end
  guiElementDecals = {}
  guiElementDecalsTex = {}
  paintjobLoaderData = {}
  paintjobLoaderPager = {}
  paintjobLoaderElements = {}
  if isElement(paintjobPreviewTexture) then
    destroyElement(paintjobPreviewTexture)
  end
  paintjobPreviewTexture = false
  saveNextFrame = false
  prepareSaveNextFrame = false
  if isElement(newTextPreviewFont) then
    destroyElement(newTextPreviewFont)
  end
  newTextPreviewFont = false
  if oldCarBcgTexture then
    carBackgroundTexutre = oldCarBcgTexture
  end
  oldCarBcgTexture = false
  newTextInput = false
  newTextPreviewFontElements = {}
  if editor then
    seexports.seal_gui:deleteGuiElement(editor)
  end
  layersScrollBcg = false
  layersScrollbar = false
  inEditorMode = false
  layerClick = false
  hoveringLayerSide = {}
  hoveringLayerSideCount = 0
  layerElements = {}
  decalSelectorElements = {}
  decalSelectorCategoryElements = {}
  decalSelectorPager = false
  layerCountLabel = false
  editor = false
  footer = false
  header = false
  layerNameInput = false
  newDecalColorInput = false
  bcgH1 = false
  bcgH2 = false
  sliderH = false
  bcgS1 = false
  bcgS2 = false
  sliderS = false
  bcgL1 = false
  bcgL2 = false
  bcgL3 = false
  sliderL = false
  bcgO1 = false
  bcgO2 = false
  sliderO = false
  labelO = false
  sliderBackgroundSize = false
  newDecalImage = false
  layerNameInput = false
  newDecalColorInput = false
  newDecalColors = false
  newDecalColorCount = false
  toolbarIcons = {}
  toolbarToggles = {}
  collectgarbage("collect")
end
function processLayerElements()
  hoveringLayerSide = {}
  hoveringLayerSideCount = 0
  local h = 64
  local y = 72
  for i = 1, #layerElements do
    local j = #layers - i + 1 - layerScroll
    if layers[j] then
      if not layerClick or layerClick[1] ~= j then
        seexports.seal_gui:setGuiPosition(layerElements[i][1], 24, y)
      end
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][1], false)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][2], false)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][3], false)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][4], false)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][5], false)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][6], false)
      layerButtons[layerElements[i][1]] = j
      if selectedLayer == j then
        seexports.seal_gui:setGuiBackground(layerElements[i][1], "solid", "grey3")
        seexports.seal_gui:setGuiHover(layerElements[i][1], "none", false, false, true)
      else
        seexports.seal_gui:setGuiBackground(layerElements[i][1], "solid", "grey2")
        seexports.seal_gui:setGuiHover(layerElements[i][1], "gradient", {"grey2", "grey3"}, false, true)
      end
      if decals[layers[j][1]][6] then
        seexports.seal_gui:setImageDDS(layerElements[i][3], ":seal_custompj/files/fonts/" .. decals[layers[j][1]][6] .. ".dds")
        seexports.seal_gui:setDeleteEvent(layerElements[i][3], false)
        guiElementDecals[layerElements[i][3]] = nil
        guiElementDecalsTex[layerElements[i][3]] = nil
      else
        seexports.seal_gui:setImageFile(layerElements[i][3], false)
        seexports.seal_gui:setDeleteEvent(layerElements[i][3], "deletedPJDecalElement")
        guiElementDecals[layerElements[i][3]] = getDecalTexture(layers[j][1], layerElements[i][3])
        guiElementDecalsTex[layerElements[i][3]] = nil
      end
      seexports.seal_gui:setImageColor(layerElements[i][3], layers[j][7])
      local cat = decals[layers[j][1]][5]
      seexports.seal_gui:setLabelText(layerElements[i][4], categoryNames[cat] or cat)
      seexports.seal_gui:setLabelText(layerElements[i][5], layers[j][8])
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][7], not layers[j][11])
      if layers[j][11] then
        seexports.seal_gui:setImageDDS(layerElements[i][7], ":seal_custompj/files/sidemirr" .. (layers[j][12] and "2" or "") .. ".dds")
      end
      y = y + h
    else
      layerButtons[layerElements[i][1]] = false
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][1], true)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][2], true)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][3], true)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][4], true)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][5], true)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][6], true)
      seexports.seal_gui:setGuiRenderDisabled(layerElements[i][7], true)
    end
  end
  seexports.seal_gui:setGuiSize(header, false, y - 24 + 48)
  seexports.seal_gui:setLabelText(layerCountLabel, #layers .. " réteg")
  seexports.seal_gui:setGuiPosition(footer, false, y)
  seexports.seal_gui:guiToFront(footer)
  local sh = y - 72
  seexports.seal_gui:setGuiSize(layersScrollBcg, false, sh)
  sh = sh / math.max(1, #layers - #layerElements + 1)
  seexports.seal_gui:setGuiSize(layersScrollbar, false, sh)
  seexports.seal_gui:setGuiPosition(layersScrollbar, false, 72 + sh * layerScroll)
  seexports.seal_gui:guiToFront(layersScrollBcg)
  seexports.seal_gui:guiToFront(layersScrollbar)
end
addEvent("hoveringSideLayerDecalEditor", true)
addEventHandler("hoveringSideLayerDecalEditor", getRootElement(), function(el, state)
  if layerButtons[el] and (hoveringLayerSide[layerButtons[el]] or false) ~= state then
    hoveringLayerSide[layerButtons[el]] = state
    hoveringLayerSideCount = hoveringLayerSideCount + (state and 1 or -1)
    rtToDraw = true
  end
end)
addEvent("selectSideLayerDecalEditor", true)
addEventHandler("selectSideLayerDecalEditor", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if layerButtons[el] then
    if selectedLayer ~= layerButtons[el] then
      selectedLayer = layerButtons[el]
      processToolbarToggles()
      processLayerElements()
      rtToDraw = true
    end
    local x, y = seexports.seal_gui:getGuiRealPosition(el)
    layerClick = {
      selectedLayer,
      absoluteY,
      y
    }
    seexports.seal_gui:guiToFront(el)
  end
end)
function processToolbarIcons()
  for k, v in pairs(toolbarIcons) do
    seexports.seal_gui:setImageColor(v, k == movingMode and "primary" or "#ffffff")
    seexports.seal_gui:setGuiHoverable(v, k ~= movingMode)
  end
end
function processToolbarToggles()
  if selectedLayer and layers[selectedLayer] then
    seexports.seal_gui:setImageColor(toolbarToggles.hilit, layerHighlight and "primary" or "#ffffff")
    seexports.seal_gui:setGuiHoverable(toolbarToggles.hilit, true)
    seexports.seal_gui:setImageColor(toolbarToggles.edit, "#ffffff")
    seexports.seal_gui:setGuiHoverable(toolbarToggles.edit, true)
    seexports.seal_gui:setImageColor(toolbarToggles.mirror1, layers[selectedLayer][9] and "primary" or "#ffffff")
    seexports.seal_gui:setImageColor(toolbarToggles.mirror2, layers[selectedLayer][10] and "primary" or "#ffffff")
    seexports.seal_gui:setImageColor(toolbarToggles.sidemirror, layers[selectedLayer][11] and "primary" or "#ffffff")
    seexports.seal_gui:setGuiHoverable(toolbarToggles.mirror1, true)
    seexports.seal_gui:setGuiHoverable(toolbarToggles.mirror2, true)
    if mirrorsReady then
      seexports.seal_gui:setGuiHoverable(toolbarToggles.sidemirror, true)
      if layers[selectedLayer][11] then
        seexports.seal_gui:setImageColor(toolbarToggles.sidemirrorX, layers[selectedLayer][12] and "primary" or "#ffffff")
        seexports.seal_gui:setGuiHoverable(toolbarToggles.sidemirrorX, true)
      else
        seexports.seal_gui:setImageColor(toolbarToggles.sidemirrorX, "midgrey")
        seexports.seal_gui:setGuiHoverable(toolbarToggles.sidemirrorX, false)
      end
    else
      seexports.seal_gui:setImageColor(toolbarToggles.sidemirror, "midgrey")
      seexports.seal_gui:setImageColor(toolbarToggles.sidemirrorX, "midgrey")
      seexports.seal_gui:setGuiHoverable(toolbarToggles.sidemirror, false)
      seexports.seal_gui:setGuiHoverable(toolbarToggles.sidemirrorX, false)
    end
  else
    seexports.seal_gui:setImageColor(toolbarToggles.hilit, "midgrey")
    seexports.seal_gui:setImageColor(toolbarToggles.mirror1, "midgrey")
    seexports.seal_gui:setImageColor(toolbarToggles.mirror2, "midgrey")
    seexports.seal_gui:setImageColor(toolbarToggles.sidemirror, "midgrey")
    seexports.seal_gui:setImageColor(toolbarToggles.sidemirrorX, "midgrey")
    seexports.seal_gui:setImageColor(toolbarToggles.edit, "midgrey")
    seexports.seal_gui:setGuiHoverable(toolbarToggles.hilit, false)
    seexports.seal_gui:setGuiHoverable(toolbarToggles.mirror1, false)
    seexports.seal_gui:setGuiHoverable(toolbarToggles.mirror2, false)
    seexports.seal_gui:setGuiHoverable(toolbarToggles.sidemirror, false)
    seexports.seal_gui:setGuiHoverable(toolbarToggles.sidemirrorX, false)
    seexports.seal_gui:setGuiHoverable(toolbarToggles.edit, false)
  end
end
addEvent("toggleDecalEditorSideMirror", true)
addEventHandler("toggleDecalEditorSideMirror", getRootElement(), function()
  if selectedLayer and layers[selectedLayer] then
    layers[selectedLayer][11] = not layers[selectedLayer][11]
    processToolbarToggles()
    processLayerElements()
    rtToDraw = true
  end
end)
addEvent("toggleDecalEditorSideMirrorX", true)
addEventHandler("toggleDecalEditorSideMirrorX", getRootElement(), function()
  if selectedLayer and layers[selectedLayer] then
    layers[selectedLayer][12] = not layers[selectedLayer][12]
    processToolbarToggles()
    processLayerElements()
    rtToDraw = true
  end
end)
addEvent("setDecalEditorMovingModeMove", true)
addEventHandler("setDecalEditorMovingModeMove", getRootElement(), function()
  movingMode = "move"
  movingLayer = false
  rtToDraw = true
  processToolbarIcons()
end)
addEvent("setDecalEditorMovingModeRotate", true)
addEventHandler("setDecalEditorMovingModeRotate", getRootElement(), function()
  movingMode = "rotate"
  movingLayer = false
  rtToDraw = true
  processToolbarIcons()
end)
addEvent("setDecalEditorMovingModeResize", true)
addEventHandler("setDecalEditorMovingModeResize", getRootElement(), function()
  movingMode = "resize"
  movingLayer = false
  rtToDraw = true
  processToolbarIcons()
end)
addEvent("toggleDecalLayerHighlight", true)
addEventHandler("toggleDecalLayerHighlight", getRootElement(), function()
  layerHighlight = not layerHighlight
  rtToDraw = true
  processToolbarToggles()
end)
addEvent("decalEditorMirrorHorizontal", true)
addEventHandler("decalEditorMirrorHorizontal", getRootElement(), function()
  if selectedLayer and layers[selectedLayer] then
    layers[selectedLayer][9] = not layers[selectedLayer][9]
    processToolbarToggles()
    rtToDraw = true
  end
end)
addEvent("decalEditorMirrorVertical", true)
addEventHandler("decalEditorMirrorVertical", getRootElement(), function()
  if selectedLayer and layers[selectedLayer] then
    layers[selectedLayer][10] = not layers[selectedLayer][10]
    processToolbarToggles()
    rtToDraw = true
  end
end)
addEvent("decalEditorEditLayer", true)
addEventHandler("decalEditorEditLayer", getRootElement(), function()
  if selectedLayer and layers[selectedLayer] then
    decalToPlace = false
    createNewDecalPanel()
  end
end)
function pushToDecalColor(fR, fG, fB)
  local found = false
  for i = 1, #newDecalColorList do
    if fR == newDecalColorList[i][1] and fG == newDecalColorList[i][2] and fB == newDecalColorList[i][3] then
      local tmp = newDecalColorList[i]
      table.remove(newDecalColorList, i)
      table.insert(newDecalColorList, 1, tmp)
      found = true
      break
    end
  end
  if not found then
    table.insert(newDecalColorList, 1, {
      fR,
      fG,
      fB
    })
  end
  if 38 < #newDecalColorList then
    for i = #newDecalColorList, 1, -1 do
      if not newDecalColorList[i][4] then
        table.remove(newDecalColorList, i)
        if #newDecalColorList <= 38 then
          break
        end
      end
    end
  end
end
addEvent("editDecalPageDone", true)
addEventHandler("editDecalPageDone", getRootElement(), function()
  if selectedLayer and layers[selectedLayer] then
    layers[selectedLayer][8] = seexports.seal_gui:getInputValue(layerNameInput)
    local h = seexports.seal_gui:getSliderValue(sliderH)
    local s = seexports.seal_gui:getSliderValue(sliderS)
    local l = seexports.seal_gui:getSliderValue(sliderL)
    local o = seexports.seal_gui:getSliderValue(sliderO)
    local fR, fG, fB = convertHSLToRGB(h, s, l)
    layers[selectedLayer][7] = {
      fR,
      fG,
      fB,
      o * 255
    }
    pushToDecalColor(fR, fG, fB)
  end
  rtToDraw = true
  createEditorGui()
end)
function createExitPrompt(bought)
  deleteEditorGui()
  local w = 350
  local h = 130
  editor = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - w / 2, screenY / 2 - h / 2, w, h)
  seexports.seal_gui:setGuiBackground(editor, "solid", "grey2")
  local label = seexports.seal_gui:createGuiElement("label", 5, 0, w - 10, h - 30 - 5, editor)
  seexports.seal_gui:setLabelAlignment(label, "center", "center")
  seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
  if bought then
    seexports.seal_gui:setLabelText(label, "Sikeres vásárlás!\n\nSzeretnél kilépni a szerkesztőből?")
  else
    seexports.seal_gui:setLabelText(label, "Biztosan szeretnél kilépni?\n\nA mentetlen változtatások elvesznek.")
  end
  btn = seexports.seal_gui:createGuiElement("button", 5, h - 30 - 5, (w - 15) / 2, 30, editor)
  seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
  seexports.seal_gui:setGuiHover(btn, "gradient", {
    "primary",
    "secondary"
  }, false, true)
  seexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
  seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
  seexports.seal_gui:setButtonText(btn, "Igen")
  seexports.seal_gui:setClickEvent(btn, "finalPaintjobEditorExit")
  seexports.seal_gui:setClickSound(btn, "selectdone")
  btn = seexports.seal_gui:createGuiElement("button", 5 + (w - 15) / 2 + 5, h - 30 - 5, (w - 15) / 2, 30, editor)
  seexports.seal_gui:setGuiBackground(btn, "solid", "red")
  seexports.seal_gui:setGuiHover(btn, "gradient", {
    "red",
    "red-second"
  }, false, true)
  seexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
  seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
  seexports.seal_gui:setButtonText(btn, "Nem")
  seexports.seal_gui:setClickEvent(btn, "returnToTheMainPaintjobPage")
  seexports.seal_gui:setClickSound(btn, "selectdone")
end
addEvent("startPaintjobEditorExit", true)
addEventHandler("startPaintjobEditorExit", getRootElement(), function()
  createExitPrompt()
end)
function createEditorGui()
  deleteEditorGui()
  inEditorMode = true
  editor = seexports.seal_gui:createGuiElement("null", 0, 0, screenX, screenY)
  local n = 13
  local toolbar = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - (6 + 24 * n + 12 * n + 12) / 2, screenY - 24 - 24 - 12 - 12, 6 + 24 * n + 12 * n + 12, 48, editor)
  seexports.seal_gui:setGuiBackground(toolbar, "solid", "grey1")
  toolbarIcons = {}
  toolbarToggles = {}
  local image = seexports.seal_gui:createGuiElement("image", 12, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/carbg.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setClickEvent(image, "openDecalBackgroundEditor")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Fényezés")
  local image = seexports.seal_gui:createGuiElement("image", 48, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/hilit.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setClickEvent(image, "toggleDecalLayerHighlight")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Réteg kiemelése")
  toolbarToggles.hilit = image
  local image = seexports.seal_gui:createGuiElement("image", 84, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/move.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setClickEvent(image, "setDecalEditorMovingModeMove")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Mozgatás (M)")
  toolbarIcons.move = image
  local image = seexports.seal_gui:createGuiElement("image", 120, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/resize.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setClickEvent(image, "setDecalEditorMovingModeResize")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Méretezés (S)")
  toolbarIcons.resize = image
  local image = seexports.seal_gui:createGuiElement("image", 156, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/rotate.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setClickEvent(image, "setDecalEditorMovingModeRotate")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Forgatás (R)")
  toolbarIcons.rotate = image
  local image = seexports.seal_gui:createGuiElement("image", 192, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/mirr_horiz.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setClickEvent(image, "decalEditorMirrorHorizontal")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Tükrözés")
  toolbarToggles.mirror1 = image
  local image = seexports.seal_gui:createGuiElement("image", 228, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/mirr_vert.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setClickEvent(image, "decalEditorMirrorVertical")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Tükrözés")
  toolbarToggles.mirror2 = image
  local image = seexports.seal_gui:createGuiElement("image", 264, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/sidemirr.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setClickEvent(image, "toggleDecalEditorSideMirror")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Tükrözés az autón")
  toolbarToggles.sidemirror = image
  local image = seexports.seal_gui:createGuiElement("image", 300, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/sidemirr2.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setClickEvent(image, "toggleDecalEditorSideMirrorX")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Tükrözés az autó másik oldalán")
  toolbarToggles.sidemirrorX = image
  local image = seexports.seal_gui:createGuiElement("image", 336, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/edit.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setClickEvent(image, "decalEditorEditLayer")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Szerkesztés (E)")
  toolbarToggles.edit = image
  local border = seexports.seal_gui:createGuiElement("hr", 368, 8, 2, 32, toolbar)
  seexports.seal_gui:setGuiHrColor(border, "grey3", "grey2")
  local image = seexports.seal_gui:createGuiElement("image", 378, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/open.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setClickEvent(image, "decalEditorOpenPaintjob")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Megnyitás (CTRL+O)")
  local image = seexports.seal_gui:createGuiElement("image", 414, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/save.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setClickEvent(image, "decalEditorSavePaintjob")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Mentés (CTRL+S)")
  local image = seexports.seal_gui:createGuiElement("image", 450, 12, 24, 24, toolbar)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/exit.dds")
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setClickEvent(image, "startPaintjobEditorExit")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Kilépés")
  processToolbarIcons()
  processToolbarToggles()
  header = seexports.seal_gui:createGuiElement("rectangle", 24, 24, w, 96, editor)
  seexports.seal_gui:setGuiBackground(header, "solid", "grey1")
  local label = seexports.seal_gui:createGuiElement("label", 24, 24, w, 48, editor)
  seexports.seal_gui:setLabelFont(label, "17/BebasNeueBold.otf")
  seexports.seal_gui:setLabelText(label, "Rétegek")
  seexports.seal_gui:setLabelAlignment(label, "center", "center")
  local h = 64
  local mn = math.floor((screenY * 0.6 - 48) / h)
  local y = 72
  local fh1 = seexports.seal_gui:getFontHeight("9/Ubuntu-L.ttf")
  local fh2 = seexports.seal_gui:getFontHeight("11/Ubuntu-R.ttf")
  layerElements = {}
  layerButtons = {}
  for i = 1, mn do
    layerElements[i] = {}
    local layer = seexports.seal_gui:createGuiElement("rectangle", 24, y, w, h, editor)
    seexports.seal_gui:setGuiHoverable(layer, true)
    layerElements[i][1] = layer
    seexports.seal_gui:setHoverEvent(layer, "hoveringSideLayerDecalEditor")
    seexports.seal_gui:setClickEvent(layer, "selectSideLayerDecalEditor")
    seexports.seal_gui:setClickSound(layer, "selectdone")
    local lbg = seexports.seal_gui:createGuiElement("rectangle", 8, 8, h - 16, h - 16, layer)
    seexports.seal_gui:setGuiBackground(lbg, "solid", "grey4")
    layerElements[i][2] = lbg
    local image = seexports.seal_gui:createGuiElement("image", 12, 12, h - 24, h - 24, layer)
    layerElements[i][3] = image
    local label = seexports.seal_gui:createGuiElement("label", h, h / 2 - (fh1 + fh2) / 2, w, h, layer)
    seexports.seal_gui:setLabelFont(label, "9/Ubuntu-L.ttf")
    seexports.seal_gui:setLabelColor(label, "lightgrey")
    seexports.seal_gui:setLabelAlignment(label, "left", "top")
    layerElements[i][4] = label
    local label = seexports.seal_gui:createGuiElement("label", h, h / 2 - (fh1 + fh2) / 2 + fh1, w, h, layer)
    seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    seexports.seal_gui:setLabelAlignment(label, "left", "top")
    layerElements[i][5] = label
    local border = seexports.seal_gui:createGuiElement("hr", 0, -1, w, 2, layer)
    layerElements[i][6] = border
    local image = seexports.seal_gui:createGuiElement("image", w - 32 - 12, 16, h - 32, h - 32, layer)
    seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/sidemirr.dds")
    layerElements[i][7] = image
    y = y + h
  end
  layersScrollBcg = seexports.seal_gui:createGuiElement("rectangle", 24 + w - 2, 72, 2, 0, editor)
  seexports.seal_gui:setGuiBackground(layersScrollBcg, "solid", "grey3")
  layersScrollbar = seexports.seal_gui:createGuiElement("rectangle", 24 + w - 2, 72, 2, 0, editor)
  seexports.seal_gui:setGuiBackground(layersScrollbar, "solid", "midgrey")
  footer = seexports.seal_gui:createGuiElement("null", 24, 72, w, 48, editor)
  local border = seexports.seal_gui:createGuiElement("hr", 0, -1, w, 2, footer)
  local label = seexports.seal_gui:createGuiElement("label", 12, 0, w, 48, footer)
  seexports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
  seexports.seal_gui:setLabelAlignment(label, "left", "center")
  layerCountLabel = label
  local image = seexports.seal_gui:createGuiElement("image", w - 32, 12, 24, 24, footer)
  seexports.seal_gui:setImageFile(image, seexports.seal_gui:getFaIconFilename("plus", 24))
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setClickEvent(image, "openNewDecalPanel")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Új réteg (N)")
  local image = seexports.seal_gui:createGuiElement("image", w - 64, 12, 24, 24, footer)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/newtext.dds")
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setClickEvent(image, "openNewTextLayerPanel")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Új szöveges réteg (T)")
  local image = seexports.seal_gui:createGuiElement("image", w - 96, 12, 24, 24, footer)
  seexports.seal_gui:setImageFile(image, seexports.seal_gui:getFaIconFilename("copy", 24))
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setGuiHover(image, "solid", "primary")
  seexports.seal_gui:setClickEvent(image, "copyCurrentDecalLayer")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Réteg másolása (C)")
  local image = seexports.seal_gui:createGuiElement("image", w - 128, 12, 24, 24, footer)
  seexports.seal_gui:setImageFile(image, seexports.seal_gui:getFaIconFilename("trash-alt", 24))
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setGuiHover(image, "solid", "red")
  seexports.seal_gui:setClickEvent(image, "deleteCurrentDecalLayer")
  seexports.seal_gui:setClickSound(image, "selectdone")
  seexports.seal_gui:guiSetTooltip(image, "Réteg törlése (DEL)")
  processLayerElements()
end
addEvent("selectCreateDecalCategory", false)
addEventHandler("selectCreateDecalCategory", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if decalCategoryButtons[el] then
    selectorCategory = decalCategoryButtons[el]
    currentDecalSelectorPage = 1
    processDecalSelectorCategories()
    processDecalSelectorDecals()
  end
end)
addEvent("selectCreateDecal", false)
addEventHandler("selectCreateDecal", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if decalSelectorElements[el] then
    local decal = decalCategorys[selectorCategory][decalSelectorElements[el][1] + (currentDecalSelectorPage - 1) * sx * sy]
    if not decals[decal][4] then
      placingDecalColor = {
        255,
        255,
        255
      }
    end
    decalToPlace = decal
    createNewDecalPanel()
  end
end)
addEvent("openNewDecalPanel", false)
addEventHandler("openNewDecalPanel", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  placingDecal = false
  decalToPlace = false
  createDecalSelector()
end)
addEvent("openNewTextLayerPanel", false)
addEventHandler("openNewTextLayerPanel", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  placingDecal = false
  decalToPlace = false
  createNewTextPanel()
end)
addEvent("returnToTheMainPaintjobPage", false)
addEventHandler("returnToTheMainPaintjobPage", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  createEditorGui()
end)
addEvent("newTextLayerDone", false)
addEventHandler("newTextLayerDone", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  local text = seexports.seal_gui:getInputValue(newTextInput)
  if text then
    if isElement(newTextPreviewFont) then
      destroyElement(newTextPreviewFont)
    end
    newTextPreviewFont = false
    decalToPlace = loadCustomTextDecal(text, customTextFonts[newTextPreviewFontId][1], customTextFonts[newTextPreviewFontId][2])
    if decalToPlace then
      createNewDecalPanel()
      placingHeight = math.min(placingHeight, 64)
      seexports.seal_gui:setInputValue(layerNameInput, text)
    end
  end
end)
addEvent("paintjobLoaderPagerClick", false)
addEventHandler("paintjobLoaderPagerClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if paintjobLoaderPager[el] then
    if tonumber(paintjobLoaderPager[el]) and currentPaintjobLoaderPage ~= tonumber(paintjobLoaderPager[el]) then
      currentPaintjobLoaderPage = tonumber(paintjobLoaderPager[el])
    elseif paintjobLoaderPager[el] == "plus" then
      currentPaintjobLoaderPage = currentPaintjobLoaderPage + 1
    elseif paintjobLoaderPager[el] == "minus" then
      currentPaintjobLoaderPage = currentPaintjobLoaderPage - 1
    end
    processPaintjobLoaders()
  end
end)
addEvent("decalSelectorPagerClick", false)
addEventHandler("decalSelectorPagerClick", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if decalSelectorPagers[el] then
    if tonumber(decalSelectorPagers[el]) and currentDecalSelectorPage ~= tonumber(decalSelectorPagers[el]) then
      currentDecalSelectorPage = tonumber(decalSelectorPagers[el])
    elseif decalSelectorPagers[el] == "plus" then
      currentDecalSelectorPage = currentDecalSelectorPage + 1
    elseif decalSelectorPagers[el] == "minus" then
      currentDecalSelectorPage = currentDecalSelectorPage - 1
    end
    processDecalSelectorPager()
    processDecalSelectorDecals()
  end
end)
function processDecalSelectorPager()
  for el, v in pairs(decalSelectorPagers) do
    if v == "plus" then
      local pages = math.ceil(#decalCategorys[selectorCategory] / (sx * sy))
      seexports.seal_gui:setGuiRenderDisabled(el, pages <= currentDecalSelectorPage)
    elseif v == "minus" then
      seexports.seal_gui:setGuiRenderDisabled(el, currentDecalSelectorPage <= 1)
    else
      local curr = v == currentDecalSelectorPage
      seexports.seal_gui:setImageFile(el, seexports.seal_gui:getFaIconFilename("circle", 16, curr and "solid" or "regular"))
      seexports.seal_gui:setImageColor(el, curr and "primary" or "#ffffff")
      seexports.seal_gui:setGuiHoverable(el, not curr)
    end
  end
end
addEvent("scrollRightDecalSelectorCategory", false)
addEventHandler("scrollRightDecalSelectorCategory", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  local ds = 128
  local spacing = 2
  local titlebarHeight = 40
  local x = 16
  local mx = sx * ds + spacing * 2 - 16
  local val = false
  for i = 1, #decalCategoryList do
    local name = categoryNames[decalCategoryList[i]] or decalCategoryList[i]
    local current = selectorCategory == decalCategoryList[i]
    local tw = seexports.seal_gui:getTextWidthFont(name, "12/BebasNeueBold.otf")
    local w = tw + 32 + 16 + titlebarHeight / 2 - 16
    x = x + w
    if x - mx > decalSelectorCategoryScroll and not val then
      val = x - mx
      break
    end
  end
  if val then
    decalSelectorCategoryScroll = val
    processDecalSelectorCategories()
  end
end)
addEvent("scrollLeftDecalSelectorCategory", false)
addEventHandler("scrollLeftDecalSelectorCategory", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  local ds = 128
  local spacing = 2
  local titlebarHeight = 40
  local x = 16
  local mx = sx * ds + spacing * 2 - 16
  local val = 0
  for i = 1, #decalCategoryList do
    local name = categoryNames[decalCategoryList[i]] or decalCategoryList[i]
    local current = selectorCategory == decalCategoryList[i]
    local tw = seexports.seal_gui:getTextWidthFont(name, "12/BebasNeueBold.otf")
    local w = tw + 32 + 16 + titlebarHeight / 2 - 16
    x = x + w
    if x - mx < decalSelectorCategoryScroll then
      val = x - mx
    end
  end
  val = math.max(0, val)
  if val and decalSelectorCategoryScroll ~= val then
    decalSelectorCategoryScroll = val
    processDecalSelectorCategories()
  end
end)
function processDecalSelectorCategories()
  local ds = 128
  local spacing = 2
  local titlebarHeight = 40
  local x = 16 - decalSelectorCategoryScroll
  local mx = sx * ds + spacing * 2 - 16
  if decalSelectorPager then
    seexports.seal_gui:deleteGuiElement(decalSelectorPager)
  end
  local pages = math.ceil(#decalCategorys[selectorCategory] / (sx * sy))
  local w = 16 * pages
  decalSelectorPager = seexports.seal_gui:createGuiElement("null", (sx * ds + spacing * 2) / 2 - w / 2, sy * ds + titlebarHeight + spacing * 2 + 64 - spacing, w, 24, editor)
  decalSelectorPagers = {}
  local button = seexports.seal_gui:createGuiElement("image", -24, 0, 24, 24, decalSelectorPager)
  seexports.seal_gui:setImageFile(button, seexports.seal_gui:getFaIconFilename("caret-left", 24))
  seexports.seal_gui:setGuiHover(button, "solid", "#ffffff")
  seexports.seal_gui:setImageColor(button, "lightgrey")
  seexports.seal_gui:setGuiHoverable(button, true)
  seexports.seal_gui:setClickEvent(button, "decalSelectorPagerClick")
  seexports.seal_gui:setClickSound(button, "selectdone")
  decalSelectorPagers[button] = "minus"
  local button = seexports.seal_gui:createGuiElement("image", w, 0, 24, 24, decalSelectorPager)
  seexports.seal_gui:setImageFile(button, seexports.seal_gui:getFaIconFilename("caret-right", 24))
  seexports.seal_gui:setGuiHover(button, "solid", "#ffffff")
  seexports.seal_gui:setImageColor(button, "lightgrey")
  seexports.seal_gui:setGuiHoverable(button, true)
  seexports.seal_gui:setClickEvent(button, "decalSelectorPagerClick")
  seexports.seal_gui:setClickSound(button, "selectdone")
  decalSelectorPagers[button] = "plus"
  for i = 1, pages do
    local button = seexports.seal_gui:createGuiElement("image", (i - 1) * 16, 4, 16, 16, decalSelectorPager)
    seexports.seal_gui:setGuiHover(button, "solid", "primary")
    seexports.seal_gui:setClickEvent(button, "decalSelectorPagerClick")
    seexports.seal_gui:setClickSound(button, "selectdone")
    decalSelectorPagers[button] = i
  end
  processDecalSelectorPager()
  for i = 1, #decalCategoryList do
    local name = categoryNames[decalCategoryList[i]] or decalCategoryList[i]
    local current = selectorCategory == decalCategoryList[i]
    local tw = seexports.seal_gui:getTextWidthFont(name, "12/BebasNeueBold.otf")
    local w = tw + 32 + 16 + titlebarHeight / 2 - 16
    if decalSelectorCategoryElements[i] then
      if x > mx or x + w < 16 then
        seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][2], true)
        seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][3], true)
        seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][4], true)
        seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][5], true)
        if decalSelectorCategoryElements[i][6] then
          seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][6], true)
        end
      else
        seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][2], false)
        seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][3], false)
        seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][4], false)
        if x < 16 then
          seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][5], true)
        else
          seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][5], false)
        end
        local holder = decalSelectorCategoryElements[i][1]
        seexports.seal_gui:setGuiPosition(holder, x, false)
        local rect = decalSelectorCategoryElements[i][2]
        seexports.seal_gui:setGuiBackground(rect, "solid", current and "grey3" or "grey2")
        local rx = math.max(0, 16 - x)
        seexports.seal_gui:setGuiPosition(rect, rx, false)
        seexports.seal_gui:setGuiSize(rect, math.min(math.max(w - rx, 0), math.max(mx - x, 0)), false)
        if not current then
          seexports.seal_gui:setGuiHoverable(rect, true)
        else
          seexports.seal_gui:setGuiHoverable(rect, false)
        end
        local label = decalSelectorCategoryElements[i][3]
        local lx = 40 + titlebarHeight / 2 - 16 - 4
        if x + lx < 16 then
          seexports.seal_gui:setGuiSize(label, x + lx + tw - 16, false)
          seexports.seal_gui:setGuiPosition(label, 16 - x, false)
          seexports.seal_gui:setLabelAlignment(label, "right", "center")
        else
          seexports.seal_gui:setGuiSize(label, math.min(w - lx, mx - (lx + x)), false)
          seexports.seal_gui:setGuiPosition(label, lx, false)
          seexports.seal_gui:setLabelAlignment(label, "left", "center")
        end
        local image = decalSelectorCategoryElements[i][4]
        seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/decals/" .. decalCategoryList[i] .. ".dds")
        local ix = x + titlebarHeight / 2 - 12
        if ix < 16 then
          local w = math.max(0, ix + 24 - 16)
          seexports.seal_gui:setImageUV(image, 32 - w * 1.3333333333333333, 0, w * 1.3333333333333333, 32)
          seexports.seal_gui:setGuiSize(image, w, false)
          seexports.seal_gui:setGuiPosition(image, 16 - x, false)
        elseif mx < ix + 24 then
          local w = math.max(0, mx - ix)
          seexports.seal_gui:setImageUV(image, 0, 0, w * 1.3333333333333333, 32)
          seexports.seal_gui:setGuiSize(image, w, false)
          seexports.seal_gui:setGuiPosition(image, ix - x, false)
        else
          seexports.seal_gui:setImageUV(image, 0, 0, 32, 32)
          seexports.seal_gui:setGuiSize(image, 24, false)
          seexports.seal_gui:setGuiPosition(image, ix - x, false)
        end
        if decalSelectorCategoryElements[i][6] then
          local ix = x + titlebarHeight / 2 + 12 - 8
          if mx < ix or 16 > ix + 12 then
            seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][6], true)
          else
            seexports.seal_gui:setGuiRenderDisabled(decalSelectorCategoryElements[i][6], false)
          end
        end
        seexports.seal_gui:setLabelColor(label, current and "primary" or "#ffffff")
        seexports.seal_gui:setImageColor(image, current and "primary" or "#ffffff")
      end
    end
    x = x + w
  end
end
function processDecalSelectorDecals()
  for hover, v in pairs(decalSelectorElements) do
    if decalCategorys[selectorCategory][v[1] + (currentDecalSelectorPage - 1) * sx * sy] then
      seexports.seal_gui:setImageFile(v[2], false)
      seexports.seal_gui:setDeleteEvent(v[2], "deletedPJDecalElement")
      guiElementDecals[v[2]] = getDecalTexture(decalCategorys[selectorCategory][v[1] + (currentDecalSelectorPage - 1) * sx * sy], v[2])
      guiElementDecalsTex[v[2]] = nil
      seexports.seal_gui:setImageColor(v[2], {
        255,
        255,
        255
      })
      seexports.seal_gui:setGuiHoverable(v[3], true)
      seexports.seal_gui:setImageDDS(hover, ":seal_custompj/files/hover.dds")
      seexports.seal_gui:setImageColor(hover, "primary")
      seexports.seal_gui:setGuiHoverable(hover, true)
      seexports.seal_gui:setImageFadeHover(hover, true)
    else
      seexports.seal_gui:setGuiHoverable(v[3], false)
      seexports.seal_gui:setImageFile(v[2], false)
      seexports.seal_gui:setDeleteEvent(v[2], false)
      guiElementDecals[v[2]] = nil
      guiElementDecalsTex[v[2]] = nil
      seexports.seal_gui:setImageDDS(hover, ":seal_custompj/files/empty.dds")
      seexports.seal_gui:setImageColor(hover, {
        255,
        255,
        255
      })
      seexports.seal_gui:setGuiHoverable(hover, false)
      seexports.seal_gui:setImageFadeHover(hover, false)
    end
  end
end
function createDecalSelector()
  deleteEditorGui()
  local ds = 128
  local spacing = 2
  local titlebarHeight = 40
  sx = math.floor(screenX / ds) - 4
  sy = math.floor(screenY / ds) - 3
  editor = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - (sx * ds + spacing * 2) / 2, screenY / 2 - (sy * ds + 32 + spacing * 2 + 64 + 24) / 2, sx * ds + spacing * 2, sy * ds + titlebarHeight + spacing * 2 + 64 + 24)
  seexports.seal_gui:setGuiBackground(editor, "solid", "grey1")
  local image = seexports.seal_gui:createGuiElement("image", 8, 8, 48, 48, editor)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/sparkle.dds")
  local label = seexports.seal_gui:createGuiElement("label", 64, 0, 0, 64, editor)
  seexports.seal_gui:setLabelFont(label, "20/BebasNeueBold.otf")
  seexports.seal_gui:setLabelText(label, "Matrica kiválasztása")
  seexports.seal_gui:setLabelAlignment(label, "left", "center")
  local image = seexports.seal_gui:createGuiElement("image", sx * ds + spacing * 2 - 32 - 8, 8, 32, 32, editor)
  seexports.seal_gui:setImageFile(image, seexports.seal_gui:getFaIconFilename("times", 32))
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setGuiHover(image, "solid", "red")
  seexports.seal_gui:setClickEvent(image, "returnToTheMainPaintjobPage")
  seexports.seal_gui:setClickSound(image, "selectdone")
  local titlebar = seexports.seal_gui:createGuiElement("rectangle", 0, 64, sx * ds + spacing * 2, titlebarHeight, editor)
  seexports.seal_gui:setGuiBackground(titlebar, "solid", "grey2")
  local x = 16
  decalSelectorElements = {}
  decalSelectorCategoryElements = {}
  for i = 1, #decalCategoryList do
    local name = categoryNames[decalCategoryList[i]] or decalCategoryList[i]
    local holder = seexports.seal_gui:createGuiElement("null", x, 0, 32, titlebarHeight, titlebar)
    local rect = seexports.seal_gui:createGuiElement("rectangle", 0, 0, 32, titlebarHeight, holder)
    seexports.seal_gui:setGuiBackground(rect, "solid", "grey2")
    seexports.seal_gui:setGuiHover(rect, "solid", "grey3", false, true)
    seexports.seal_gui:setClickEvent(rect, "selectCreateDecalCategory")
    seexports.seal_gui:setClickSound(rect, "selectdone")
    decalCategoryButtons[rect] = decalCategoryList[i]
    local border = seexports.seal_gui:createGuiElement("hr", -1, 0, 2, titlebarHeight, holder)
    local label = seexports.seal_gui:createGuiElement("label", 40 + titlebarHeight / 2 - 16, 0, 32, titlebarHeight, holder)
    seexports.seal_gui:setLabelFont(label, "12/BebasNeueBold.otf")
    seexports.seal_gui:setLabelText(label, " ")
    seexports.seal_gui:setLabelClip(label, true)
    seexports.seal_gui:setLabelAlignment(label, "left", "center")
    seexports.seal_gui:setLabelText(label, name)
    local image = seexports.seal_gui:createGuiElement("image", titlebarHeight / 2 - 12, titlebarHeight / 2 - 12, 24, 24, holder)
    decalSelectorCategoryElements[i] = {
      holder,
      rect,
      label,
      image,
      border
    }
    if colorCategories[decalCategoryList[i]] then
      local image = seexports.seal_gui:createGuiElement("image", titlebarHeight / 2 + 12 - 8, titlebarHeight / 2 + 12 - 8, 12, 12, holder)
      seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/decals/color.dds")
      decalSelectorCategoryElements[i][6] = image
    end
    x = x + 32
  end
  local btn = seexports.seal_gui:createGuiElement("button", 0, 0, 16, titlebarHeight, titlebar)
  seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
  seexports.seal_gui:setGuiHover(btn, "gradient", {
    "primary",
    "secondary"
  }, false, true)
  seexports.seal_gui:setButtonFont(btn, "12/BebasNeueRegular.otf")
  seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("caret-left", 16))
  seexports.seal_gui:setClickEvent(btn, "scrollLeftDecalSelectorCategory")
  seexports.seal_gui:setClickSound(btn, "selectdone")
  local border = seexports.seal_gui:createGuiElement("hr", 15, 0, 2, titlebarHeight, titlebar)
  local btn = seexports.seal_gui:createGuiElement("button", sx * ds + spacing * 2 - 16, 0, 16, titlebarHeight, titlebar)
  seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
  seexports.seal_gui:setGuiHover(btn, "gradient", {
    "primary",
    "secondary"
  }, false, true)
  seexports.seal_gui:setButtonFont(btn, "12/BebasNeueRegular.otf")
  seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("caret-right", 16))
  seexports.seal_gui:setClickEvent(btn, "scrollRightDecalSelectorCategory")
  seexports.seal_gui:setClickSound(btn, "selectdone")
  local border = seexports.seal_gui:createGuiElement("hr", sx * ds + spacing * 2 - 16 - 1, 0, 2, titlebarHeight, titlebar)
  processDecalSelectorCategories()
  local c = 1
  for x = 0, sx - 1 do
    for y = 0, sy - 1 do
      local lbg = seexports.seal_gui:createGuiElement("rectangle", spacing + x * ds + spacing, 64 + spacing + titlebarHeight + y * ds + spacing, ds - spacing * 2, ds - spacing * 2, editor)
      seexports.seal_gui:setGuiBackground(lbg, "solid", "midgrey")
      seexports.seal_gui:setGuiHover(lbg, "gradient", {
        "midgrey",
        "lightgrey"
      }, false, true)
      seexports.seal_gui:setGuiHoverable(lbg, true)
      local image = seexports.seal_gui:createGuiElement("image", 12, 12, ds - spacing * 2 - 24, ds - spacing * 2 - 24, lbg)
      local hover = seexports.seal_gui:createGuiElement("image", 0, 0, ds - spacing * 2, ds - spacing * 2, lbg)
      seexports.seal_gui:setImageDDS(hover, ":seal_custompj/files/hover.dds")
      seexports.seal_gui:setImageColor(hover, "primary")
      seexports.seal_gui:setImageFadeHover(hover, true)
      decalSelectorElements[hover] = {
        c,
        image,
        lbg
      }
      seexports.seal_gui:setClickEvent(hover, "selectCreateDecal")
      seexports.seal_gui:setClickSound(hover, "selectdone")
      c = c + 1
    end
  end
  processDecalSelectorDecals()
end
local placingMirrorX = false
local placingMirrorY = false
function calculateCoord(pixles, x, y)
  local r, g, b, a = dxGetPixelColor(pixles, x, y)
  if r and 0 < a then
    return (r + g + b) / 765
  end
end
function getPositionFromMatrixOffset(m, offX, offY, offZ)
  local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
  local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
  local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
  return x, y, z
end
function drawLineEx(x, y, x2, y2)
  x = x * 50
  y = y * 50
  x2 = x2 * 50
  y2 = y2 * 50
  dxDrawLine(x + screenX / 2, y + screenY / 2, x2 + screenX / 2, y2 + screenY / 2, tocolor(255, 255, 255), 3)
end
local pih = math.pi / 2
function cameraMovement(p, p2, minX, minY, maxX, maxY, maxZ, d)
  local x, y, z = 0, 0, 0
  local x2, y2, z2 = 0, 0, 0
  local sideA = maxX - minX
  local sideB = maxY - minY
  local sum = sideA * 2 + sideB * 2
  local pA = sideA / sum
  local pB = sideB / sum
  local r = -pih * 1.5
  if p <= pA and 0 <= p then
    local p2 = p / pA
    x2 = minX + (maxX - minX) * p2
    y2 = minY
    r = r + pih * p2
  elseif pB >= p - pA and 0 <= p - pA then
    local p2 = (p - pA) / pB
    x2 = maxX
    y2 = minY + (maxY - minY) * p2
    r = r + pih * (1 + p2)
  elseif pA >= p - pA - pB and 0 <= p - pA - pB then
    local p2 = (p - pA - pB) / pA
    x2 = maxX + (minX - maxX) * p2
    y2 = maxY
    r = r + pih * (2 + p2)
  else
    local p2 = (p - pA - pB - pA) / pB
    x2 = minX
    y2 = maxY + (minY - maxY) * p2
    r = r + pih * (3 + p2)
  end
  local circle = 2 * d * pih * 2 / 4
  minZ = minZ * 0.25
  local d2 = d * 1.25
  r = pih * 4 * p
  r2 = 0 + pih - pih * 0.75 * p2
  x2 = 0
  y2 = 0
  x = math.cos(r) * d2 * (sideA / 2 + sideB / 4)
  y = math.sin(r) * d2 * (sideB / 2 + sideA / 4)
  z = d2 * math.cos(r2)
  x = x * math.sin(r2)
  y = y * math.sin(r2)
  local m = getElementMatrix(veh)
  local cx, cy, cz = getPositionFromMatrixOffset(m, x, y, z)
  local tx, ty, tz = getPositionFromMatrixOffset(m, x2, y2, z2)
  setCameraMatrix(cx, cy, cz, tx, ty, tz)
  return 10, 10
end
function restorePjEditor()
  if not mirrorsReady then
    deleteEditorGui()
    if isElement(saveFakeScreenSource) then
      destroyElement(saveFakeScreenSource)
    end
    saveFakeScreenSource = dxCreateScreenSource(screenX, screenY)
    dxUpdateScreenSource(saveFakeScreenSource, true)
    dxDrawImage(0, 0, screenX, screenY, saveFakeScreenSource)
    mirrorTries = 0
  end
  rtToDraw = true
end
function preRenderPjEditor(delta)
  dxSetRenderTarget(renderTargetX, true)
  dxSetRenderTarget(renderTargetY, true)
  dxSetRenderTarget()
  if camZoom < desiredCamZoom then
    camZoom = camZoom + 1.1 * delta / 1000
    if camZoom > desiredCamZoom then
      camZoom = desiredCamZoom
    end
  elseif camZoom > desiredCamZoom then
    camZoom = camZoom - 1.1 * delta / 1000
    if camZoom < desiredCamZoom then
      camZoom = desiredCamZoom
    end
  end
  if 6 < mirrorSetStage then
    local zoom = camZoom
    local x = camX
    local y = camY
    if prepareSaveNextFrame then
      dxUpdateScreenSource(saveFakeScreenSource, true)
    end
    if prepareSaveNextFrame or saveNextFrame then
      zoom = 2.35
      x = 0.4
      y = 0.25
    end
    if getVehicleType(veh) ~= "Automobile" then
      zoom = zoom + 0.5
    end
    local sumD, sumD2 = cameraMovement(x, y, minX, minY, maxX, maxY, maxZ, zoom)
    local cx, cy = getCursorPosition()
    if getKeyState("mouse2") and cx and inEditorMode then
      if not camCursor then
        camCursor = {cx, cy}
      else
        local val = cx - camCursor[1]
        camX = camX + 10 * delta / 1000 * math.pow(math.min(0.15, math.abs(val)), 1.5) * (val < 0 and -1 or 1)
        local val = cy - camCursor[2]
        camY = camY + 10 * delta / 1000 * math.pow(math.min(0.15, math.abs(val)), 1.5) * (val < 0 and 1 or -1)
        camX = camX % 1
        camY = math.min(1, math.max(0, camY))
        if camX < 0 then
          camX = 1 + camX
        end
      end
    else
      if camCursor then
      end
      camCursor = false
    end
  end
  if not decalLoadQueue then
    if mirrorSetStage <= 6 then
      rtToDraw = true
      local mirrorSide = 3 < mirrorSetStage and -1 or 1
      local m = getElementMatrix(veh)
      local x1, y1, z1 = getVehicleComponentPosition(veh, "door_lf_dummy")
      local x2, y2, z2 = getVehicleComponentPosition(veh, "door_rf_dummy")
      if not (not (4 < mirrorTries) and x1) or not y2 then
        local cx, cy, cz = getPositionFromMatrixOffset(m, ((maxX - minX) / 2 + 2) * mirrorSide, 0, 0.25 - (mirrorTries - 4) * 0.05)
        local tx, ty, tz = getPositionFromMatrixOffset(m, (maxX - minX) / 2 * mirrorSide, 0, 0.25 - (mirrorTries - 4) * 0.05)
        setCameraMatrix(cx, cy, cz, tx, ty, tz)
      else
        local y, z = (y2 + y1) / 2, (z2 + z1) / 2
        local cx, cy, cz = getPositionFromMatrixOffset(m, ((maxX - minX) / 2 + 2) * mirrorSide, y - 0.25, z + 0.1 - mirrorTries * 0.05)
        local tx, ty, tz = getPositionFromMatrixOffset(m, (maxX - minX) / 2 * mirrorSide, y - 0.25, z + 0.1 - mirrorTries * 0.05)
        setCameraMatrix(cx, cy, cz, tx, ty, tz)
      end
      mirrorSetStage = mirrorSetStage + 1
    elseif not mirrorsReady and mirrorTries < 8 then
      mirrorSetStage = 1
      mirrorTries = mirrorTries + 1
      if 8 <= mirrorTries then
        mirrorSetStage = 7
        createEditorGui()
        cameraMovement(camX, camY, minX, minY, maxX, maxY, maxZ, camZoom)
      end
    end
  end
end
function swap(array, index1, index2)
  array[index1], array[index2] = array[index2], array[index1]
end
function hue2rgb(m1, m2, h)
  if h < 0 then
    h = h + 1
  elseif 1 < h then
    h = h - 1
  end
  if 1 > h * 6 then
    return m1 + (m2 - m1) * h * 6
  elseif 1 > h * 2 then
    return m2
  elseif 2 > h * 3 then
    return m1 + (m2 - m1) * (0.6666666666666666 - h) * 6
  else
    return m1
  end
end
function convertHSLToRGB(h, s, l)
  local m2
  if l < 0.5 then
    m2 = l * (s + 1)
  else
    m2 = l + s - l * s
  end
  local m1 = l * 2 - m2
  local r = hue2rgb(m1, m2, h + 0.3333333333333333) * 255
  local g = hue2rgb(m1, m2, h) * 255
  local b = hue2rgb(m1, m2, h - 0.3333333333333333) * 255
  return math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5)
end
function convertRGBToHSL(r, g, b)
  r = r / 255
  g = g / 255
  b = b / 255
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local h, s
  local l = (max + min) / 2
  if max == min then
    h = 0
    s = 0
  else
    local d = max - min
    s = 0.5 < l and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    end
    if max == g then
      h = (b - r) / d + 2
    end
    if max == b then
      h = (r - g) / d + 4
    end
    h = h / 6
  end
  return h, s, l
end
function refreshNewDecalColorPickerBcg(refreshInput)
  local h = seexports.seal_gui:getSliderValue(sliderH)
  local s = seexports.seal_gui:getSliderValue(sliderS)
  local l = seexports.seal_gui:getSliderValue(sliderL)
  local o = sliderO and seexports.seal_gui:getSliderValue(sliderO) or 1
  local fR, fG, fB = convertHSLToRGB(h, s, l)
  seexports.seal_gui:setGuiBackground(bcgH1, "solid", {
    convertHSLToRGB(0, 0, l)
  })
  seexports.seal_gui:setImageColor(bcgH2, {
    255,
    255,
    255,
    s * 255
  })
  local r, g, b = convertHSLToRGB(0, 0, l)
  local a = math.abs(l - 0.5) / 0.5 * 255
  seexports.seal_gui:setGuiBackground(bcgH3, "solid", {
    r,
    g,
    b,
    a
  })
  seexports.seal_gui:setGuiBackground(bcgS1, "solid", {
    convertHSLToRGB(h, 0, l)
  })
  seexports.seal_gui:setImageColor(bcgS2, {
    convertHSLToRGB(h, 1, l)
  })
  seexports.seal_gui:setImageColor(bcgL3, {
    convertHSLToRGB(h, s, 0.5)
  })
  local col = {
    fR,
    fG,
    fB
  }
  if sliderO then
    seexports.seal_gui:setImageColor(bcgO2, col)
  end
  seexports.seal_gui:setSliderColor(sliderH, {
    0,
    0,
    0,
    0
  }, col)
  seexports.seal_gui:setSliderColor(sliderS, {
    0,
    0,
    0,
    0
  }, col)
  seexports.seal_gui:setSliderColor(sliderL, {
    0,
    0,
    0,
    0
  }, col)
  if refreshInput then
    seexports.seal_gui:setInputValue(newDecalColorInput, utf8.sub(seexports.seal_gui:getColorCodeHex(col), 2, 7))
  end
  col[4] = o * 255
  seexports.seal_gui:setImageColor(newDecalImage, col)
  if sliderO then
    seexports.seal_gui:setSliderColor(sliderO, {
      0,
      0,
      0,
      0
    }, col)
  end
  if labelO then
    seexports.seal_gui:setLabelText(labelO, math.floor(o * 100 * 10 + 0.5) / 10 .. "%")
  end
end
addEvent("newDecalColorPickerChanged", true)
addEventHandler("newDecalColorPickerChanged", getRootElement(), function()
  refreshNewDecalColorPickerBcg(true)
end)
addEvent("refreshNewDecalColorInput", true)
addEventHandler("refreshNewDecalColorInput", getRootElement(), function(val)
  seexports.seal_gui:setInputValue(newDecalColorInput, utf8.upper(val))
  local r = tonumber("0x" .. val:sub(1, 2))
  local g = tonumber("0x" .. val:sub(3, 4))
  local b = tonumber("0x" .. val:sub(5, 6))
  if r and g and b then
    local h, s, l = convertRGBToHSL(r, g, b)
    seexports.seal_gui:setSliderValue(sliderH, h)
    seexports.seal_gui:setSliderValue(sliderS, s)
    seexports.seal_gui:setSliderValue(sliderL, l)
    refreshNewDecalColorPickerBcg()
  end
end)
addEvent("selectNewDecalPreDefinedColor", true)
addEventHandler("selectNewDecalPreDefinedColor", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if newDecalColors[el] then
    local h, s, l = convertRGBToHSL(newDecalColors[el][1], newDecalColors[el][2], newDecalColors[el][3])
    seexports.seal_gui:setSliderValue(sliderH, h)
    seexports.seal_gui:setSliderValue(sliderS, s)
    seexports.seal_gui:setSliderValue(sliderL, l)
    refreshNewDecalColorPickerBcg(true)
  end
end)
addEvent("newDecalPageDone", true)
addEventHandler("newDecalPageDone", getRootElement(), function()
  if decalToPlace then
    placingDecalName = seexports.seal_gui:getInputValue(layerNameInput)
    placingDecal = decalToPlace
    decalToPlace = false
    local h = seexports.seal_gui:getSliderValue(sliderH)
    local s = seexports.seal_gui:getSliderValue(sliderS)
    local l = seexports.seal_gui:getSliderValue(sliderL)
    local o = seexports.seal_gui:getSliderValue(sliderO)
    local fR, fG, fB = convertHSLToRGB(h, s, l)
    placingDecalColor = {
      fR,
      fG,
      fB,
      o * 255
    }
    pushToDecalColor(fR, fG, fB)
  end
  createEditorGui()
end)
function createNewDecalPanel()
  if decalToPlace or selectedLayer then
    deleteEditorGui()
    local w = 550
    local h = 245
    editor = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - w / 2, screenY / 2 - h / 2, w, h)
    seexports.seal_gui:setGuiBackground(editor, "solid", "grey2")
    local lbg = seexports.seal_gui:createGuiElement("rectangle", 8, 8, h - 16, h - 16, editor)
    seexports.seal_gui:setGuiBackground(lbg, "solid", "grey4")
    newDecalImage = seexports.seal_gui:createGuiElement("image", 12, 12, h - 24, h - 24, editor)
    local decalName = false
    if decalToPlace then
      decalName = decalToPlace
    elseif selectedLayer then
      decalName = layers[selectedLayer][1]
    end
    if decals[decalName][6] then
      seexports.seal_gui:setImageDDS(newDecalImage, ":seal_custompj/files/fonts/" .. decals[decalName][6] .. ".dds")
    else
      seexports.seal_gui:setImageFile(newDecalImage, false)
      seexports.seal_gui:setDeleteEvent(newDecalImage, "deletedPJDecalElement")
      guiElementDecals[newDecalImage] = getDecalTexture(decalName, newDecalImage)
      guiElementDecalsTex[newDecalImage] = nil
    end
    local x = h
    local y = 8
    local sw = w - h - 8
    layerNameInput = seexports.seal_gui:createGuiElement("input", x, y, sw - 32 - 8, 32, editor)
    seexports.seal_gui:setInputPlaceholder(layerNameInput, "Új réteg neve")
    if decalToPlace then
      seexports.seal_gui:setInputValue(layerNameInput, "Réteg " .. newLayerCounter)
    elseif selectedLayer then
      seexports.seal_gui:setInputValue(layerNameInput, layers[selectedLayer][8])
    end
    seexports.seal_gui:setInputFont(layerNameInput, "10/Ubuntu-R.ttf")
    seexports.seal_gui:setInputIcon(layerNameInput, "pencil-alt")
    seexports.seal_gui:setInputMaxLength(layerNameInput, 24)
    local btn = seexports.seal_gui:createGuiElement("button", x + sw - 32, y, 32, 32, editor)
    seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
    seexports.seal_gui:setGuiHover(btn, "gradient", {
      "primary",
      "secondary"
    }, false, true)
    seexports.seal_gui:setButtonFont(btn, "12/BebasNeueRegular.otf")
    seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("check", 32))
    if decalToPlace then
      seexports.seal_gui:setClickEvent(btn, "newDecalPageDone")
      seexports.seal_gui:setClickSound(btn, "selectdone")
    elseif selectedLayer then
      seexports.seal_gui:setClickEvent(btn, "editDecalPageDone")
      seexports.seal_gui:setClickSound(btn, "selectdone")
    end
    y = y + 32 + 8
    local sbg = seexports.seal_gui:createGuiElement("rectangle", x, y, sw, 152, editor)
    seexports.seal_gui:setGuiBackground(sbg, "solid", "grey4")
    y = y + 8
    bcgH1 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
    bcgH2 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
    seexports.seal_gui:setImageDDS(bcgH2, ":seal_custompj/files/col3.dds")
    bcgH3 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
    sliderH = seexports.seal_gui:createGuiElement("slider", x + 8, y, sw - 16, 20, editor)
    seexports.seal_gui:setSliderSize(sliderH, 20)
    seexports.seal_gui:setSliderBorder(sliderH, {
      0,
      0,
      0
    }, 1)
    seexports.seal_gui:setSliderChangeEvent(sliderH, "newDecalColorPickerChanged")
    y = y + 20 + 8
    bcgS1 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
    bcgS2 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
    seexports.seal_gui:setImageDDS(bcgS2, ":seal_custompj/files/col1.dds")
    sliderS = seexports.seal_gui:createGuiElement("slider", x + 8, y, sw - 16, 20, editor)
    seexports.seal_gui:setSliderSize(sliderS, 20)
    seexports.seal_gui:setSliderBorder(sliderS, {
      0,
      0,
      0
    }, 1)
    seexports.seal_gui:setSliderChangeEvent(sliderS, "newDecalColorPickerChanged")
    y = y + 20 + 8
    bcgL1 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, (sw - 16 - 20) / 2, 12, editor)
    seexports.seal_gui:setGuiBackground(bcgL1, "solid", {
      0,
      0,
      0
    })
    bcgL2 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10 + (sw - 16 - 20) / 2, y + 10 - 6, (sw - 16 - 20) / 2, 12, editor)
    seexports.seal_gui:setGuiBackground(bcgL2, "solid", {
      255,
      255,
      255
    })
    bcgL3 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
    seexports.seal_gui:setImageDDS(bcgL3, ":seal_custompj/files/col2.dds")
    sliderL = seexports.seal_gui:createGuiElement("slider", x + 8, y, sw - 16, 20, editor)
    seexports.seal_gui:setSliderSize(sliderL, 20)
    seexports.seal_gui:setSliderBorder(sliderL, {
      0,
      0,
      0
    }, 1)
    seexports.seal_gui:setSliderChangeEvent(sliderL, "newDecalColorPickerChanged")
    y = y + 20 + 8
    bcgO1 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, sw - 16 - 48 - 20, 12, editor)
    seexports.seal_gui:setImageDDS(bcgO1, ":seal_custompj/files/col4.dds")
    bcgO2 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, sw - 16 - 48 - 20, 12, editor)
    seexports.seal_gui:setImageDDS(bcgO2, ":seal_custompj/files/col1.dds")
    sliderO = seexports.seal_gui:createGuiElement("slider", x + 8, y, sw - 16 - 48, 20, editor)
    seexports.seal_gui:setSliderValue(sliderO, 1)
    seexports.seal_gui:setSliderSize(sliderO, 20)
    seexports.seal_gui:setSliderBorder(sliderO, {
      0,
      0,
      0
    }, 1, true)
    seexports.seal_gui:setSliderChangeEvent(sliderO, "newDecalColorPickerChanged")
    labelO = seexports.seal_gui:createGuiElement("label", x + sw - 8 - 48, y, 48, 20, editor)
    seexports.seal_gui:setLabelFont(labelO, "10/Ubuntu-R.ttf")
    seexports.seal_gui:setLabelText(labelO, "100%")
    seexports.seal_gui:setLabelAlignment(labelO, "center", "center")
    y = y + 20 + 8
    newDecalColorInput = seexports.seal_gui:createGuiElement("input", x + sw / 2 - 50, y, 100, 24, editor)
    seexports.seal_gui:setInputPlaceholder(newDecalColorInput, "HEX színkód")
    seexports.seal_gui:setInputValue(newDecalColorInput, "FF0000")
    seexports.seal_gui:setInputFont(newDecalColorInput, "10/Ubuntu-R.ttf")
    seexports.seal_gui:setInputIcon(newDecalColorInput, "hashtag")
    seexports.seal_gui:setInputMaxLength(newDecalColorInput, 6)
    seexports.seal_gui:setInputChangeEvent(newDecalColorInput, "refreshNewDecalColorInput")
    y = y + 24 + 8
    y = y + 8
    local nx, ny = 19, 2
    x = x - 1
    y = y - 1
    local w = (sw + 2) / nx
    local h = (h - y - 8 + 2) / ny
    newDecalColorCount = nx * ny
    newDecalColors = {}
    local c = 1
    for j = 0, ny - 1 do
      for i = 0, nx - 1 do
        local rect = seexports.seal_gui:createGuiElement("rectangle", x + i * w + 1, y + j * h + 1, w - 2, h - 2, editor)
        if newDecalColorList[c] then
          newDecalColors[rect] = {
            newDecalColorList[c][1],
            newDecalColorList[c][2],
            newDecalColorList[c][3]
          }
          seexports.seal_gui:setGuiBackground(rect, "solid", newDecalColors[rect])
          seexports.seal_gui:setGuiHover(rect, "none", false, false, true)
          seexports.seal_gui:setGuiHoverable(rect, true)
          seexports.seal_gui:setClickEvent(rect, "selectNewDecalPreDefinedColor")
          seexports.seal_gui:setClickSound(rect, "selectdone")
        else
          seexports.seal_gui:setGuiBackground(rect, "solid", "grey4")
        end
        c = c + 1
      end
    end
    local h, s, l = 0, 0, 1
    if decalToPlace then
      local r = placingDecalColor[1]
      local g = placingDecalColor[2]
      local b = placingDecalColor[3]
      h, s, l = convertRGBToHSL(r, g, b)
    elseif selectedLayer then
      local r = layers[selectedLayer][7][1]
      local g = layers[selectedLayer][7][2]
      local b = layers[selectedLayer][7][3]
      h, s, l = convertRGBToHSL(r, g, b)
    end
    seexports.seal_gui:setSliderValue(sliderH, h)
    seexports.seal_gui:setSliderValue(sliderS, s)
    seexports.seal_gui:setSliderValue(sliderL, l)
    if selectedLayer then
      seexports.seal_gui:setSliderValue(sliderO, layers[selectedLayer][7][4] / 255)
    end
    refreshNewDecalColorPickerBcg(true)
  end
end
addEvent("previousTextureForDecalBackground", true)
addEventHandler("previousTextureForDecalBackground", getRootElement(), function()
  for i = 1, #decalCategorys.textures do
    if carBackgroundTexutre == decalCategorys.textures[i] then
      local j = i - 1
      if j < 1 then
        j = #decalCategorys.textures
      end
      carBackgroundTexutre = decalCategorys.textures[j]
      break
    end
  end
  seexports.seal_gui:setImageFile(newDecalImage, false)
  seexports.seal_gui:setDeleteEvent(newDecalImage, "deletedPJDecalElement")
  guiElementDecals[newDecalImage] = getDecalTexture(carBackgroundTexutre, newDecalImage)
  guiElementDecalsTex[newDecalImage] = nil
end)
addEvent("nextTextureForDecalBackground", true)
addEventHandler("nextTextureForDecalBackground", getRootElement(), function()
  for i = 1, #decalCategorys.textures do
    if carBackgroundTexutre == decalCategorys.textures[i] then
      local j = i + 1
      if j > #decalCategorys.textures then
        j = 1
      end
      carBackgroundTexutre = decalCategorys.textures[j]
      break
    end
  end
  seexports.seal_gui:setImageFile(newDecalImage, false)
  seexports.seal_gui:setDeleteEvent(newDecalImage, "deletedPJDecalElement")
  guiElementDecals[newDecalImage] = getDecalTexture(carBackgroundTexutre, newDecalImage)
  guiElementDecalsTex[newDecalImage] = nil
end)
addEvent("editCarDecalBackgroundDone", true)
addEventHandler("editCarDecalBackgroundDone", getRootElement(), function()
  oldCarBcgTexture = false
  local h = seexports.seal_gui:getSliderValue(sliderH)
  local s = seexports.seal_gui:getSliderValue(sliderS)
  local l = seexports.seal_gui:getSliderValue(sliderL)
  local fR, fG, fB = convertHSLToRGB(h, s, l)
  carBackgroundColor = {
    fR,
    fG,
    fB
  }
  pushToDecalColor(fR, fG, fB)
  carBackgroundSize = 128 + 128 * seexports.seal_gui:getSliderValue(sliderBackgroundSize)
  createEditorGui()
  rtToDraw = true
end)
addEvent("openDecalBackgroundEditor", true)
addEventHandler("openDecalBackgroundEditor", getRootElement(), function()
  createBackgroundEditor()
end)
function createBackgroundEditor()
  deleteEditorGui()
  oldCarBcgTexture = carBackgroundTexutre
  local w = 550
  local h = 245
  editor = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - w / 2, screenY / 2 - h / 2, w, h)
  seexports.seal_gui:setGuiBackground(editor, "solid", "grey2")
  local lbg = seexports.seal_gui:createGuiElement("rectangle", 8, 8, h - 16, h - 16, editor)
  seexports.seal_gui:setGuiBackground(lbg, "solid", "grey4")
  newDecalImage = seexports.seal_gui:createGuiElement("image", 12, 12, h - 24, h - 24, editor)
  seexports.seal_gui:setImageFile(newDecalImage, false)
  seexports.seal_gui:setDeleteEvent(newDecalImage, "deletedPJDecalElement")
  guiElementDecals[newDecalImage] = getDecalTexture(carBackgroundTexutre, newDecalImage)
  guiElementDecalsTex[newDecalImage] = nil
  local bottombar = seexports.seal_gui:createGuiElement("rectangle", 8, 8 + h - 16 - 32, h - 16, 32, editor)
  seexports.seal_gui:setGuiBackground(bottombar, "solid", {
    0,
    0,
    0,
    125
  })
  local label = seexports.seal_gui:createGuiElement("label", 0, 0, h - 16, 32, bottombar)
  seexports.seal_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
  seexports.seal_gui:setLabelText(label, "Mintázat")
  seexports.seal_gui:setLabelAlignment(label, "center", "center")
  local button = seexports.seal_gui:createGuiElement("image", 0, 0, 32, 32, bottombar)
  seexports.seal_gui:setImageFile(button, seexports.seal_gui:getFaIconFilename("caret-left", 32))
  seexports.seal_gui:setGuiHover(button, "solid", "primary")
  seexports.seal_gui:setImageColor(button, "#ffffff")
  seexports.seal_gui:setGuiHoverable(button, true)
  seexports.seal_gui:setClickEvent(button, "previousTextureForDecalBackground")
  seexports.seal_gui:setClickSound(button, "selectdone")
  local button = seexports.seal_gui:createGuiElement("image", h - 16 - 32, 0, 32, 32, bottombar)
  seexports.seal_gui:setImageFile(button, seexports.seal_gui:getFaIconFilename("caret-right", 32))
  seexports.seal_gui:setGuiHover(button, "solid", "primary")
  seexports.seal_gui:setImageColor(button, "#ffffff")
  seexports.seal_gui:setGuiHoverable(button, true)
  seexports.seal_gui:setClickEvent(button, "nextTextureForDecalBackground")
  seexports.seal_gui:setClickSound(button, "selectdone")
  local x = h
  local y = 8
  local sw = w - h - 8
  local label = seexports.seal_gui:createGuiElement("label", x, y, sw - 32 - 8, 32, editor)
  seexports.seal_gui:setLabelFont(label, "17/BebasNeueBold.otf")
  seexports.seal_gui:setLabelText(label, "Fényezés")
  seexports.seal_gui:setLabelAlignment(label, "left", "center")
  local btn = seexports.seal_gui:createGuiElement("button", x + sw - 32, y, 32, 32, editor)
  seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
  seexports.seal_gui:setGuiHover(btn, "gradient", {
    "primary",
    "secondary"
  }, false, true)
  seexports.seal_gui:setButtonFont(btn, "12/BebasNeueRegular.otf")
  seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("check", 32))
  seexports.seal_gui:setClickEvent(btn, "editCarDecalBackgroundDone")
  seexports.seal_gui:setClickSound(btn, "selectdone")
  y = y + 32 + 8
  local sbg = seexports.seal_gui:createGuiElement("rectangle", x, y, sw, 152, editor)
  seexports.seal_gui:setGuiBackground(sbg, "solid", "grey4")
  y = y + 8
  bcgH1 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
  bcgH2 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
  seexports.seal_gui:setImageDDS(bcgH2, ":seal_custompj/files/col3.dds")
  bcgH3 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
  sliderH = seexports.seal_gui:createGuiElement("slider", x + 8, y, sw - 16, 20, editor)
  seexports.seal_gui:setSliderSize(sliderH, 20)
  seexports.seal_gui:setSliderBorder(sliderH, {
    0,
    0,
    0
  }, 1)
  seexports.seal_gui:setSliderChangeEvent(sliderH, "newDecalColorPickerChanged")
  y = y + 20 + 8
  bcgS1 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
  bcgS2 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
  seexports.seal_gui:setImageDDS(bcgS2, ":seal_custompj/files/col1.dds")
  sliderS = seexports.seal_gui:createGuiElement("slider", x + 8, y, sw - 16, 20, editor)
  seexports.seal_gui:setSliderSize(sliderS, 20)
  seexports.seal_gui:setSliderBorder(sliderS, {
    0,
    0,
    0
  }, 1)
  seexports.seal_gui:setSliderChangeEvent(sliderS, "newDecalColorPickerChanged")
  y = y + 20 + 8
  bcgL1 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, (sw - 16 - 20) / 2, 12, editor)
  seexports.seal_gui:setGuiBackground(bcgL1, "solid", {
    0,
    0,
    0
  })
  bcgL2 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10 + (sw - 16 - 20) / 2, y + 10 - 6, (sw - 16 - 20) / 2, 12, editor)
  seexports.seal_gui:setGuiBackground(bcgL2, "solid", {
    255,
    255,
    255
  })
  bcgL3 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, sw - 16 - 20, 12, editor)
  seexports.seal_gui:setImageDDS(bcgL3, ":seal_custompj/files/col2.dds")
  sliderL = seexports.seal_gui:createGuiElement("slider", x + 8, y, sw - 16, 20, editor)
  seexports.seal_gui:setSliderSize(sliderL, 20)
  seexports.seal_gui:setSliderBorder(sliderL, {
    0,
    0,
    0
  }, 1)
  seexports.seal_gui:setSliderChangeEvent(sliderL, "newDecalColorPickerChanged")
  y = y + 20 + 8
  newDecalColorInput = seexports.seal_gui:createGuiElement("input", x + sw / 2 - 50, y, 100, 24, editor)
  seexports.seal_gui:setInputPlaceholder(newDecalColorInput, "HEX színkód")
  seexports.seal_gui:setInputValue(newDecalColorInput, "FF0000")
  seexports.seal_gui:setInputFont(newDecalColorInput, "10/Ubuntu-R.ttf")
  seexports.seal_gui:setInputIcon(newDecalColorInput, "hashtag")
  seexports.seal_gui:setInputMaxLength(newDecalColorInput, 6)
  seexports.seal_gui:setInputChangeEvent(newDecalColorInput, "refreshNewDecalColorInput")
  y = y + 20 + 16
  local rect = seexports.seal_gui:createGuiElement("rectangle", x + 8, y + 3, 6, 6, editor)
  seexports.seal_gui:setGuiBackground(rect, "solid", "#ffffff")
  local rect = seexports.seal_gui:createGuiElement("rectangle", x + sw - 16 - 2, y, 12, 12, editor)
  seexports.seal_gui:setGuiBackground(rect, "solid", "#ffffff")
  sliderBackgroundSize = seexports.seal_gui:createGuiElement("slider", x + 8 + 16, y, sw - 16 - 32, 12, editor)
  seexports.seal_gui:setSliderValue(sliderBackgroundSize, 0.5)
  seexports.seal_gui:setSliderSize(sliderBackgroundSize, 12)
  y = y + 24
  y = y + 8
  local nx, ny = 19, 2
  x = x - 1
  y = y - 1
  local w = (sw + 2) / nx
  local h = (h - y - 8 + 2) / ny
  newDecalColorCount = nx * ny
  newDecalColors = {}
  local c = 1
  for j = 0, ny - 1 do
    for i = 0, nx - 1 do
      local rect = seexports.seal_gui:createGuiElement("rectangle", x + i * w + 1, y + j * h + 1, w - 2, h - 2, editor)
      if newDecalColorList[c] then
        newDecalColors[rect] = {
          newDecalColorList[c][1],
          newDecalColorList[c][2],
          newDecalColorList[c][3]
        }
        seexports.seal_gui:setGuiBackground(rect, "solid", newDecalColors[rect])
        seexports.seal_gui:setGuiHover(rect, "none", false, false, true)
        seexports.seal_gui:setGuiHoverable(rect, true)
        seexports.seal_gui:setClickEvent(rect, "selectNewDecalPreDefinedColor")
        seexports.seal_gui:setClickSound(rect, "selectdone")
      else
        seexports.seal_gui:setGuiBackground(rect, "solid", "grey4")
      end
      c = c + 1
    end
  end
  local h, s, l = 0, 0, 1
  local r = carBackgroundColor[1]
  local g = carBackgroundColor[2]
  local b = carBackgroundColor[3]
  h, s, l = convertRGBToHSL(r, g, b)
  seexports.seal_gui:setSliderValue(sliderH, h)
  seexports.seal_gui:setSliderValue(sliderS, s)
  seexports.seal_gui:setSliderValue(sliderL, l)
  seexports.seal_gui:setSliderValue(sliderBackgroundSize, (carBackgroundSize - 128) / 128)
  refreshNewDecalColorPickerBcg(true)
end
function savePaintjob(bought)
  local filename = getRealTime().timestamp .. "_" .. getTickCount()
  local model = getElementModel(veh)
  local file = fileCreate("saves/" .. model .. "/" .. filename .. ".seal")
  local data = ""
  if file then
    for i = 1, #layers do
      if layers[i] then
        data = data .. layers[i][1] .. "\n"
        data = data .. layers[i][2] .. "\n"
        data = data .. layers[i][3] .. "\n"
        data = data .. layers[i][4] .. "\n"
        data = data .. layers[i][5] .. "\n"
        data = data .. layers[i][6] .. "\n"
        data = data .. layers[i][7][1] .. "\n"
        data = data .. layers[i][7][2] .. "\n"
        data = data .. layers[i][7][3] .. "\n"
        data = data .. layers[i][7][4] .. "\n"
        data = data .. layers[i][8] .. "\n"
        data = data .. (layers[i][9] and 1 or 0) .. "\n"
        data = data .. (layers[i][10] and 1 or 0) .. "\n"
        data = data .. (layers[i][11] and 1 or 0) .. "\n"
        data = data .. (layers[i][12] and 1 or 0) .. "\n"
      end
    end
    data = teaEncodeBinary(data, model .. "pjlayer" .. filename)
    fileWrite(file, data)
    fileClose(file)
  end
  local file = fileCreate("saves/" .. model .. "/" .. filename .. "_d.seal")
  if file then
    data = ""
    data = data .. carBackgroundTexutre .. "\n"
    data = data .. carBackgroundColor[1] .. "\n"
    data = data .. carBackgroundColor[2] .. "\n"
    data = data .. carBackgroundColor[3] .. "\n"
    data = data .. carBackgroundSize .. "\n"
    for i = 1, #newDecalColorList do
      if newDecalColorList[i] then
        data = data .. newDecalColorList[i][1] .. "\n"
        data = data .. newDecalColorList[i][2] .. "\n"
        data = data .. newDecalColorList[i][3] .. "\n"
        data = data .. (newDecalColorList[i][4] and 1 or 0) .. "\n"
      end
    end
    data = teaEncodeBinary(data, model .. "pjdet" .. filename)
    fileWrite(file, data)
    fileClose(file)
  end
  data = dxGetTexturePixels(paintjobPreviewTexture)
  data = dxConvertPixels(data, "png")
  if data then
    local file = fileCreate("saves/" .. model .. "/" .. filename .. "_p.png")
    if file then
      fileWrite(file, data)
      fileClose(file)
    end
  end
  local listFilename = "saves/" .. model .. ".seal"
  local listFile = false
  if fileExists(listFilename) then
    listFile = fileOpen(listFilename)
    if listFile then
      fileSetPos(listFile, fileGetSize(listFile))
    end
  else
    listFile = fileCreate(listFilename)
  end
  if listFile then
    fileWrite(listFile, (bought and "b" or "") .. filename .. "\n")
    fileClose(listFile)
  end
  data = nil
  collectgarbage("collect")
  createEditorGui()
end
addEvent("saveTheCurrentPaintjob", true)
addEventHandler("saveTheCurrentPaintjob", getRootElement(), function()
  savePaintjob()
end)
function createBuyingPrompt()
  seexports.seal_gui:deleteGuiElement(editor)
  local w = 350
  local h = 130
  editor = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - w / 2, screenY / 2 - h / 2, w, h)
  seexports.seal_gui:setGuiBackground(editor, "solid", "grey2")
  local label = seexports.seal_gui:createGuiElement("label", 5, 0, w - 10, h - 30 - 5, editor)
  seexports.seal_gui:setLabelAlignment(label, "center", "center")
  seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
  if gratisPJ then
    seexports.seal_gui:setLabelText(label, "Szeretnéd megvásárolni a paintjobot?\n\nA paintjob ára: [color=green]ingyenes")
  else
    seexports.seal_gui:setLabelText(label, "Szeretnéd megvásárolni a paintjobot?\n\nA paintjob ára: [color=blue]" .. seexports.seal_gui:thousandsStepper(8000) .. " PP")
  end
  btn = seexports.seal_gui:createGuiElement("button", 5, h - 30 - 5, (w - 15) / 2, 30, editor)
  seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
  seexports.seal_gui:setGuiHover(btn, "gradient", {
    "primary",
    "secondary"
  }, false, true)
  seexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
  seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
  seexports.seal_gui:setButtonText(btn, "Igen")
  seexports.seal_gui:setClickEvent(btn, "decalEditorFinalBuyPaintjob")
  seexports.seal_gui:setClickSound(btn, "selectdone")
  btn = seexports.seal_gui:createGuiElement("button", 5 + (w - 15) / 2 + 5, h - 30 - 5, (w - 15) / 2, 30, editor)
  seexports.seal_gui:setGuiBackground(btn, "solid", "red")
  seexports.seal_gui:setGuiHover(btn, "gradient", {
    "red",
    "red-second"
  }, false, true)
  seexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
  seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
  seexports.seal_gui:setButtonText(btn, "Nem")
  seexports.seal_gui:setClickEvent(btn, "returnToTheSaverPage")
  seexports.seal_gui:setClickSound(btn, "selectdone")
end
addEvent("startPaintjobBuying", true)
addEventHandler("startPaintjobBuying", getRootElement(), function()
  createBuyingPrompt()
end)
addEvent("returnToTheSaverPage", true)
addEventHandler("returnToTheSaverPage", getRootElement(), function()
  seexports.seal_gui:deleteGuiElement(editor)
  createPaintjobSaver()
end)
addEvent("boughtPaintjobResponse", true)
addEventHandler("boughtPaintjobResponse", getRootElement(), function(success, resetGratis)
  if resetGratis then
    gratisPJ = false
  end
  buyingPaintjob = false
  if success then
    savePaintjob(true)
    createExitPrompt(true)
  else
    createEditorGui()
  end
  rtToDraw = true
end)
addEvent("decalEditorFinalBuyPaintjob", true)
addEventHandler("decalEditorFinalBuyPaintjob", getRootElement(), function()
  seexports.seal_gui:deleteGuiElement(editor)
  local w = 350
  local h = 90
  editor = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - w / 2, screenY / 2 - h / 2, w, h)
  seexports.seal_gui:setGuiBackground(editor, "solid", "grey2")
  local label = seexports.seal_gui:createGuiElement("label", 5, 0, w - 10, h, editor)
  seexports.seal_gui:setLabelAlignment(label, "center", "center")
  seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
  seexports.seal_gui:setLabelText(label, "Vásárlás folyamatban...")
  buyingPaintjob = true
  drawLayers(true)
  local pixels = dxGetTexturePixels(renderTarget2, "dds", "dxt1", false)
  if pixels then
    triggerLatentServerEvent("doneCustomPaintjob", 1000000, veh, pixels, gratisPJ)
  end
end)
function createPaintjobSaver()
  local h = 195
  editor = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - h / 2, screenY / 2 - (h + 96) / 2, h, h + 96)
  seexports.seal_gui:setGuiBackground(editor, "solid", "grey2")
  if isElement(paintjobPreviewTexture) then
    local image = seexports.seal_gui:createGuiElement("image", 8, 8, h - 16, h - 16, editor)
    seexports.seal_gui:setImageFile(image, paintjobPreviewTexture)
    local btn = seexports.seal_gui:createGuiElement("button", 8, h, h - 16, 24, editor)
    seexports.seal_gui:setGuiBackground(btn, "solid", "blue")
    seexports.seal_gui:setGuiHover(btn, "gradient", {
      "blue",
      "blue-second"
    }, false, true)
    seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
    seexports.seal_gui:setButtonText(btn, "Vásárlás")
    seexports.seal_gui:setClickEvent(btn, "startPaintjobBuying")
    seexports.seal_gui:setClickSound(btn, "selectdone")
    local btn = seexports.seal_gui:createGuiElement("button", 8, h + 32, h - 16, 24, editor)
    seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
    seexports.seal_gui:setGuiHover(btn, "gradient", {
      "primary",
      "secondary"
    }, false, true)
    seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
    seexports.seal_gui:setButtonText(btn, "Mentés")
    seexports.seal_gui:setClickEvent(btn, "saveTheCurrentPaintjob")
    seexports.seal_gui:setClickSound(btn, "selectdone")
  end
  local btn = seexports.seal_gui:createGuiElement("button", 8, h + 64, h - 16, 24, editor)
  seexports.seal_gui:setGuiBackground(btn, "solid", "red")
  seexports.seal_gui:setGuiHover(btn, "gradient", {
    "red",
    "red-second"
  }, false, true)
  seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
  seexports.seal_gui:setClickEvent(btn, "returnToTheMainPaintjobPage")
  seexports.seal_gui:setClickSound(btn, "selectdone")
  seexports.seal_gui:setButtonText(btn, "Mégsem")
  rtToDraw = true
end
function createPaintjobLoadPrompt()
  if paintjobToLoad then
    deleteEditorGui()
    local h = 256
    editor = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - h / 2, screenY / 2 - (h + 96) / 2, h, h + 96)
    seexports.seal_gui:setGuiBackground(editor, "solid", "grey2")
    local folder = ":seal_custompj/saves/" .. getElementModel(veh)
    local image = seexports.seal_gui:createGuiElement("image", 8, 8, h - 16, h - 16, editor)
    if fileExists(folder .. "/" .. paintjobToLoad .. "_p.png") then
      seexports.seal_gui:setImageFile(image, folder .. "/" .. paintjobToLoad .. "_p.png")
    end
    if not paintjobDeleterPrompt then
      local btn = seexports.seal_gui:createGuiElement("button", 8, h, h - 16, 24, editor)
      seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
      seexports.seal_gui:setGuiHover(btn, "gradient", {
        "primary",
        "secondary"
      }, false, true)
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setButtonText(btn, "Megnyitás")
      seexports.seal_gui:setClickEvent(btn, "loadTheCurrentPaintjob")
      seexports.seal_gui:setClickSound(btn, "selectdone")
      local btn = seexports.seal_gui:createGuiElement("button", 8, h + 32, h - 16, 24, editor)
      seexports.seal_gui:setGuiBackground(btn, "solid", "red")
      seexports.seal_gui:setGuiHover(btn, "gradient", {
        "red",
        "red-second"
      }, false, true)
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setButtonText(btn, "Törlés")
      seexports.seal_gui:setClickEvent(btn, "togglePaintjobDeleterPrompt")
      seexports.seal_gui:setClickSound(btn, "selectdone")
    end
    if paintjobDeleterPrompt then
      local label = seexports.seal_gui:createGuiElement("label", 0, h, h, 24, editor)
      seexports.seal_gui:setLabelText(label, "Biztosan törlöd?")
      seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
      seexports.seal_gui:setLabelAlignment(label, "center", "center")
      local btn = seexports.seal_gui:createGuiElement("button", 8, h + 32, h - 16, 24, editor)
      seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
      seexports.seal_gui:setGuiHover(btn, "gradient", {
        "primary",
        "secondary"
      }, false, true)
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setButtonText(btn, "Igen")
      seexports.seal_gui:setClickEvent(btn, "finalDeleteThePaintjob")
      seexports.seal_gui:setClickSound(btn, "selectdone")
      local btn = seexports.seal_gui:createGuiElement("button", 8, h + 64, h - 16, 24, editor)
      seexports.seal_gui:setGuiBackground(btn, "solid", "red")
      seexports.seal_gui:setGuiHover(btn, "gradient", {
        "red",
        "red-second"
      }, false, true)
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setClickEvent(btn, "togglePaintjobDeleterPrompt")
      seexports.seal_gui:setClickSound(btn, "selectdone")
      seexports.seal_gui:setButtonText(btn, "Nem")
    else
      local btn = seexports.seal_gui:createGuiElement("button", 8, h + 64, h - 16, 24, editor)
      seexports.seal_gui:setGuiBackground(btn, "solid", "red")
      seexports.seal_gui:setGuiHover(btn, "gradient", {
        "red",
        "red-second"
      }, false, true)
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setClickEvent(btn, "decalEditorOpenPaintjob")
      seexports.seal_gui:setClickSound(btn, "selectdone")
      seexports.seal_gui:setButtonText(btn, "Mégsem")
    end
  end
end
function processPaintjobLoaders()
  for hover, v in pairs(paintjobLoaderElements) do
    if paintjobLoaderData[v[1] + (currentPaintjobLoaderPage - 1) * sx * sy] then
      seexports.seal_gui:setGuiRenderDisabled(v[4], not paintjobLoaderData[v[1] + (currentPaintjobLoaderPage - 1) * sx * sy][3])
      if paintjobLoaderData[v[1] + (currentPaintjobLoaderPage - 1) * sx * sy][2] then
        seexports.seal_gui:setImageFile(v[2], ":seal_custompj/" .. paintjobLoaderData[v[1] + (currentPaintjobLoaderPage - 1) * sx * sy][2])
      else
        seexports.seal_gui:setImageFile(v[2], false)
      end
      seexports.seal_gui:setImageColor(v[2], {
        255,
        255,
        255
      })
      seexports.seal_gui:setGuiHoverable(v[3], true)
      seexports.seal_gui:setImageDDS(hover, ":seal_custompj/files/hover.dds")
      seexports.seal_gui:setImageColor(hover, "primary")
      seexports.seal_gui:setGuiHoverable(hover, true)
      seexports.seal_gui:setImageFadeHover(hover, true)
    else
      seexports.seal_gui:setGuiRenderDisabled(v[4], true)
      seexports.seal_gui:setGuiHoverable(v[3], false)
      seexports.seal_gui:setImageFile(v[2], false)
      seexports.seal_gui:setImageDDS(hover, ":seal_custompj/files/empty.dds")
      seexports.seal_gui:setImageColor(hover, {
        255,
        255,
        255
      })
      seexports.seal_gui:setGuiHoverable(hover, false)
      seexports.seal_gui:setImageFadeHover(hover, false)
    end
  end
  for el, v in pairs(paintjobLoaderPager) do
    if v == "plus" then
      local pages = math.ceil(#paintjobLoaderData / (sx * sy))
      seexports.seal_gui:setGuiRenderDisabled(el, pages <= currentPaintjobLoaderPage)
    elseif v == "minus" then
      seexports.seal_gui:setGuiRenderDisabled(el, currentPaintjobLoaderPage <= 1)
    else
      local curr = v == currentPaintjobLoaderPage
      seexports.seal_gui:setImageFile(el, seexports.seal_gui:getFaIconFilename("circle", 16, curr and "solid" or "regular"))
      seexports.seal_gui:setImageColor(el, curr and "primary" or "#ffffff")
      seexports.seal_gui:setGuiHoverable(el, not curr)
    end
  end
end
function createPaintjobOpener()
  deleteEditorGui()
  paintjobToLoad = false
  paintjobDeleterPrompt = false
  local ds = 175
  local spacing = 2
  sx = math.floor(screenX / ds) - 3
  sy = math.floor(screenY / ds) - 2
  editor = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - (sx * ds + spacing * 2) / 2, screenY / 2 - (sy * ds + 32 + spacing * 2 + 64 + 24) / 2, sx * ds + spacing * 2, sy * ds + spacing * 2 + 64 + 24)
  seexports.seal_gui:setGuiBackground(editor, "solid", "grey1")
  local image = seexports.seal_gui:createGuiElement("image", 8, 8, 48, 48, editor)
  seexports.seal_gui:setImageDDS(image, ":seal_custompj/files/open.dds")
  local label = seexports.seal_gui:createGuiElement("label", 64, 0, 0, 64, editor)
  seexports.seal_gui:setLabelFont(label, "20/BebasNeueBold.otf")
  seexports.seal_gui:setLabelText(label, "Paintjob betöltése")
  seexports.seal_gui:setLabelAlignment(label, "left", "center")
  local image = seexports.seal_gui:createGuiElement("image", sx * ds + spacing * 2 - 32 - 8, 8, 32, 32, editor)
  seexports.seal_gui:setImageFile(image, seexports.seal_gui:getFaIconFilename("times", 32))
  seexports.seal_gui:setGuiHoverable(image, true)
  seexports.seal_gui:setGuiHover(image, "solid", "red")
  seexports.seal_gui:setClickEvent(image, "returnToTheMainPaintjobPage")
  seexports.seal_gui:setClickSound(image, "selectdone")
  local x = 16
  local c = 1
  paintjobLoaderData = {}
  local folder = "saves/" .. getElementModel(veh)
  local listFilename = folder .. ".seal"
  if fileExists(listFilename) then
    local file = fileOpen(listFilename)
    if file then
      local buffer = ""
      local data = fileRead(file, fileGetSize(file))
      data = split(data, "\n")
      fileClose(file)
      for i = #data, 1, -1 do
        local bought = utf8.sub(data[i], 1, 1) == "b"
        if bought then
          data[i] = utf8.sub(data[i], 2, utf8.len(data[i]))
        end
        if data[i] and fileExists(folder .. "/" .. data[i] .. ".seal") then
          local text = false
          if fileExists(folder .. "/" .. data[i] .. "_p.png") then
            text = folder .. "/" .. data[i] .. "_p.png"
          end
          table.insert(paintjobLoaderData, {
            data[i],
            text,
            bought
          })
        end
      end
      buffer = nil
      data = nil
      collectgarbage("collect")
    end
  end
  paintjobLoaderElements = {}
  for y = 0, sy - 1 do
    for x = 0, sx - 1 do
      local lbg = seexports.seal_gui:createGuiElement("rectangle", spacing + x * ds + spacing, 64 + spacing + y * ds + spacing, ds - spacing * 2, ds - spacing * 2, editor)
      seexports.seal_gui:setGuiBackground(lbg, "solid", "midgrey")
      seexports.seal_gui:setGuiHover(lbg, "none", false, false, true)
      seexports.seal_gui:setGuiHoverable(lbg, true)
      local image = seexports.seal_gui:createGuiElement("image", 0, 0, ds - spacing * 2, ds - spacing * 2, lbg)
      seexports.seal_gui:setImageUV(image, 0, 0, 195, 195)
      seexports.seal_gui:setGuiHoverable(image, true)
      local hover = seexports.seal_gui:createGuiElement("image", 0, 0, ds - spacing * 2, ds - spacing * 2, lbg)
      seexports.seal_gui:setImageDDS(hover, ":seal_custompj/files/hover.dds")
      seexports.seal_gui:setImageColor(hover, "primary")
      seexports.seal_gui:setImageFadeHover(hover, true)
      local icon = seexports.seal_gui:createGuiElement("image", ds - spacing * 2 - 32 - spacing, ds - spacing * 2 - 32 - spacing, 32, 32, lbg)
      seexports.seal_gui:setImageFile(icon, seexports.seal_gui:getFaIconFilename("shopping-cart", 32))
      seexports.seal_gui:setImageColor(icon, "primary")
      paintjobLoaderElements[hover] = {
        c,
        image,
        lbg,
        icon
      }
      seexports.seal_gui:setClickEvent(hover, "selectPaintjobToLoad")
      seexports.seal_gui:setClickSound(hover, "selectdone")
      c = c + 1
    end
  end
  local pages = math.ceil(#paintjobLoaderData / (sx * sy))
  local w = 16 * pages
  local pager = seexports.seal_gui:createGuiElement("null", (sx * ds + spacing * 2) / 2 - w / 2, sy * ds + spacing * 2 + 64 - spacing, w, 24, editor)
  paintjobLoaderPager = {}
  local button = seexports.seal_gui:createGuiElement("image", -24, 0, 24, 24, pager)
  seexports.seal_gui:setImageFile(button, seexports.seal_gui:getFaIconFilename("caret-left", 24))
  seexports.seal_gui:setGuiHover(button, "solid", "#ffffff")
  seexports.seal_gui:setImageColor(button, "lightgrey")
  seexports.seal_gui:setGuiHoverable(button, true)
  seexports.seal_gui:setClickEvent(button, "paintjobLoaderPagerClick")
  seexports.seal_gui:setClickSound(button, "selectdone")
  paintjobLoaderPager[button] = "minus"
  local button = seexports.seal_gui:createGuiElement("image", w, 0, 24, 24, pager)
  seexports.seal_gui:setImageFile(button, seexports.seal_gui:getFaIconFilename("caret-right", 24))
  seexports.seal_gui:setGuiHover(button, "solid", "#ffffff")
  seexports.seal_gui:setImageColor(button, "lightgrey")
  seexports.seal_gui:setGuiHoverable(button, true)
  seexports.seal_gui:setClickEvent(button, "paintjobLoaderPagerClick")
  seexports.seal_gui:setClickSound(button, "selectdone")
  paintjobLoaderPager[button] = "plus"
  for i = 1, pages do
    local button = seexports.seal_gui:createGuiElement("image", (i - 1) * 16, 4, 16, 16, pager)
    seexports.seal_gui:setGuiHover(button, "solid", "primary")
    seexports.seal_gui:setClickEvent(button, "paintjobLoaderPagerClick")
    seexports.seal_gui:setClickSound(button, "selectdone")
    paintjobLoaderPager[button] = i
  end
  processPaintjobLoaders()
end
addEvent("decalEditorOpenPaintjob", true)
addEventHandler("decalEditorOpenPaintjob", getRootElement(), function()
  createPaintjobOpener()
end)
addEvent("finalDeleteThePaintjob", true)
addEventHandler("finalDeleteThePaintjob", getRootElement(), function()
  if paintjobToLoad then
    local folder = "saves/" .. getElementModel(veh)
    local listFilename = folder .. ".seal"
    if fileExists(folder .. "/" .. paintjobToLoad .. ".seal") then
      fileDelete(folder .. "/" .. paintjobToLoad .. ".seal")
    end
    if fileExists(folder .. "/" .. paintjobToLoad .. "_p.png") then
      fileDelete(folder .. "/" .. paintjobToLoad .. "_p.png")
    end
    if fileExists(folder .. "/" .. paintjobToLoad .. "_d.seal") then
      fileDelete(folder .. "/" .. paintjobToLoad .. "_d.seal")
    end
    if fileExists(listFilename) then
      local file = fileOpen(listFilename)
      if file then
        local buffer = ""
        local data = fileRead(file, fileGetSize(file))
        data = split(data, "\n")
        fileClose(file)
        fileDelete(listFilename)
        local file = fileCreate(listFilename)
        if file then
          for i = 1, #data do
            if data[i] ~= paintjobToLoad then
              fileWrite(file, data[i] .. "\n")
            end
          end
          fileClose(file)
        end
        data = nil
        collectgarbage("collect")
      end
    end
  end
  createPaintjobOpener()
end)
addEvent("loadTheCurrentPaintjob", true)
addEventHandler("loadTheCurrentPaintjob", getRootElement(), function()
  if paintjobToLoad then
    local model = getElementModel(veh)
    local folder = "saves/" .. model
    layers = {}
    for k in pairs(decals) do
      if decals[k] and decals[k][6] then
        if isElement(decals[k][1]) then
          destroyElement(decals[k][1])
        end
        decals[k] = nil
      end
    end
    carBackgroundTexutre = "textures/0"
    carBackgroundColor = {
      255,
      255,
      255
    }
    carBackgroundSize = 256
    resetTheColorList()
    if fileExists(folder .. "/" .. paintjobToLoad .. "_d.seal") then
      local file = fileOpen(folder .. "/" .. paintjobToLoad .. "_d.seal")
      if file then
        local data = fileRead(file, fileGetSize(file))
        data = teaDecodeBinary(data, model .. "pjdet" .. paintjobToLoad)
        data = split(data, "\n")
        fileClose(file)
        if decals[data[1]] then
          carBackgroundTexutre = data[1]
        end
        if tonumber(data[2]) and tonumber(data[3]) and tonumber(data[4]) then
          carBackgroundColor[1] = tonumber(data[2])
          carBackgroundColor[2] = tonumber(data[3])
          carBackgroundColor[3] = tonumber(data[4])
        end
        if tonumber(data[5]) then
          carBackgroundSize = tonumber(data[5])
        end
        newDecalColorList = {}
        local valid = true
        local buffer = false
        for i = 6, #data do
          local j = (i - 6) % 4 + 1
          if j == 1 then
            buffer = {}
            buffer[1] = tonumber(data[i])
            if buffer[1] then
              valid = true
            end
          elseif j == 4 then
            buffer[4] = tonumber(data[i]) == 1
            if valid then
              table.insert(newDecalColorList, buffer)
            end
          else
            buffer[j] = tonumber(data[i])
            if not buffer[j] then
              valid = false
            end
          end
        end
        data = nil
        buffer = nil
        collectgarbage("collect")
      end
    end
    if fileExists(folder .. "/" .. paintjobToLoad .. ".seal") then
      local file = fileOpen(folder .. "/" .. paintjobToLoad .. ".seal")
      if file then
        local data = fileRead(file, fileGetSize(file))
        data = teaDecodeBinary(data, model .. "pjlayer" .. paintjobToLoad)
        local buffer = false
        data = split(data, "\n")
        fileClose(file)
        local valid = true
        for i = 1, #data do
          local j = i % 15
          if j == 1 then
            buffer = {}
            if utf8.sub(data[i], 1, 10) == "customtext" then
              local dat = split(data[i], "/")
              table.remove(dat, 1)
              local font = dat[1]
              table.remove(dat, 1)
              local size = tonumber(dat[1]) or 20
              table.remove(dat, 1)
              local text = table.concat(dat, "/")
              buffer[1] = loadCustomTextDecal(text, font, size)
            else
              buffer[1] = data[i]
            end
            if buffer[1] then
              valid = true
            end
          elseif 2 <= j and j <= 6 then
            buffer[j] = tonumber(data[i])
            if not buffer[j] then
              valid = false
            end
          elseif 7 <= j and j <= 10 then
            if not buffer[7] then
              buffer[7] = {}
            end
            local int = tonumber(data[i])
            if not int then
              valid = false
            end
            buffer[7][j - 6] = int
          elseif j == 11 then
            buffer[8] = utf8.sub(data[i], 1, 24)
          elseif 12 <= j and j <= 14 then
            buffer[j - 3] = tonumber(data[i]) == 1
          elseif j == 0 then
            buffer[12] = tonumber(data[i]) == 1
            if valid and buffer[1] and decals[buffer[1]] then
              table.insert(layers, buffer)
            end
          end
        end
        data = nil
        buffer = nil
        collectgarbage("collect")
      end
    end
    selectedLayer = #layers
    if not layers[selectedLayer] then
      selectedLayer = false
    end
    layerScroll = 0
    rtToDraw = true
  end
  createEditorGui()
end)
addEvent("togglePaintjobDeleterPrompt", true)
addEventHandler("togglePaintjobDeleterPrompt", getRootElement(), function()
  if paintjobToLoad then
    paintjobDeleterPrompt = not paintjobDeleterPrompt
    createPaintjobLoadPrompt()
  end
end)
addEvent("selectPaintjobToLoad", true)
addEventHandler("selectPaintjobToLoad", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if paintjobLoaderElements[el] then
    paintjobToLoad = paintjobLoaderData[paintjobLoaderElements[el][1] + (currentPaintjobLoaderPage - 1) * sx * sy][1]
    createPaintjobLoadPrompt()
  end
end)
addEvent("decalEditorSavePaintjob", true)
addEventHandler("decalEditorSavePaintjob", getRootElement(), function()
  deleteEditorGui()
  prepareSaveNextFrame = true
  if isElement(saveFakeScreenSource) then
    destroyElement(saveFakeScreenSource)
  end
  saveFakeScreenSource = dxCreateScreenSource(screenX, screenY)
end)
addEvent("changeNewTextPanelFont", true)
addEventHandler("changeNewTextPanelFont", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if newTextPreviewFontElements[el] then
    newTextPreviewFontId = newTextPreviewFontElements[el]
    for im, i in pairs(newTextPreviewFontElements) do
      if i == newTextPreviewFontId then
        seexports.seal_gui:setImageColor(im, "primary")
        seexports.seal_gui:setGuiHoverable(im, false)
      else
        seexports.seal_gui:setImageColor(im, "#ffffff")
        seexports.seal_gui:setGuiHoverable(im, true)
      end
    end
    if isElement(newTextPreviewFont) then
      destroyElement(newTextPreviewFont)
    end
    newTextPreviewFont = dxCreateFont("files/fonts/" .. customTextFonts[newTextPreviewFontId][1], customTextFonts[newTextPreviewFontId][2] * 2, false, "antialiased")
  end
end)
function createNewTextPanel()
  deleteEditorGui()
  local w = 495
  local h = 48 + w / 9 * 2
  editor = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - w / 2, screenY / 2 - h / 2 - 48, w, h)
  seexports.seal_gui:setGuiBackground(editor, "solid", "grey2")
  local x = 0
  local y = 8
  local sw = w - 16
  newTextInput = seexports.seal_gui:createGuiElement("input", 8, y, sw - 32 - 8, 32, editor)
  seexports.seal_gui:setInputPlaceholder(newTextInput, "Szöveg")
  seexports.seal_gui:setInputFont(newTextInput, "10/Ubuntu-R.ttf")
  seexports.seal_gui:setInputIcon(newTextInput, "pencil-alt")
  seexports.seal_gui:setInputMaxLength(newTextInput, 24)
  local btn = seexports.seal_gui:createGuiElement("button", 8 + sw - 32, y, 32, 32, editor)
  seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
  seexports.seal_gui:setGuiHover(btn, "gradient", {
    "primary",
    "secondary"
  }, false, true)
  seexports.seal_gui:setButtonFont(btn, "12/BebasNeueRegular.otf")
  seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("check", 32))
  seexports.seal_gui:setClickEvent(btn, "newTextLayerDone")
  seexports.seal_gui:setClickSound(btn, "selectdone")
  y = y + 32 + 8
  newTextPreviewFontElements = {}
  for i = 1, #customTextFonts do
    local im = seexports.seal_gui:createGuiElement("image", x, y, w / 9, w / 9, editor)
    seexports.seal_gui:setImageDDS(im, ":seal_custompj/files/fonts/" .. customTextFonts[i][1] .. ".dds")
    seexports.seal_gui:setGuiHover(im, "solid", "primary")
    seexports.seal_gui:setClickEvent(im, "changeNewTextPanelFont")
    seexports.seal_gui:setClickSound(im, "selectdone")
    if i == newTextPreviewFontId then
      seexports.seal_gui:setImageColor(im, "primary")
    else
      seexports.seal_gui:setGuiHoverable(im, true)
    end
    newTextPreviewFontElements[im] = i
    x = x + w / 9
    if i == 9 then
      x = 0
      y = y + w / 9
    end
  end
  newTextPreviewFont = dxCreateFont("files/fonts/" .. customTextFonts[newTextPreviewFontId][1], customTextFonts[newTextPreviewFontId][2] * 2, false, "antialiased")
end
function dxDrawLineEx(x, y, x2, y2, w)
  dxDrawLine(x + 1, y + 1, x2 + 1, y2 + 1, tocolor(0, 0, 0), w)
  dxDrawLine(x - 1, y + 1, x2 - 1, y2 + 1, tocolor(0, 0, 0), w)
  dxDrawLine(x + 1, y - 1, x2 + 1, y2 - 1, tocolor(0, 0, 0), w)
  dxDrawLine(x - 1, y - 1, x2 - 1, y2 - 1, tocolor(0, 0, 0), w)
end
function dxDrawImageEx(x, y, sx, sy, t, r, rx, ry, c)
  r = r or 0
  rx = rx or 0
  ry = ry or 0
  dxDrawImage(x + 1, y + 1, sx, sy, t, r, rx, ry, tocolor(0, 0, 0))
  dxDrawImage(x + 1, y - 1, sx, sy, t, r, rx, ry, tocolor(0, 0, 0))
  dxDrawImage(x - 1, y + 1, sx, sy, t, r, rx, ry, tocolor(0, 0, 0))
  dxDrawImage(x - 1, y - 1, sx, sy, t, r, rx, ry, tocolor(0, 0, 0))
  dxDrawImage(x, y, sx, sy, t, r, rx, ry, c)
end
function maxabs(a, b)
  if math.abs(a) > math.abs(b) then
    return a
  else
    return b
  end
end
function renderPjEditor()
  local loadingTex = false
  for el, decal in pairs(guiElementDecals) do
    local tex = latentDynamicImage(decal, "argb", false)
    if tex == seelangBlankTex then
      tex = false
    end
    if guiElementDecalsTex[el] ~= tex then
      guiElementDecalsTex[el] = tex
      if tex then
        seexports.seal_gui:setImageSpinner(el, false)
        seexports.seal_gui:setImageFile(el, tex)
      else
        loadingTex = loadingTex or dynamicImage("files/decals/loading.dds")
        seexports.seal_gui:setImageSpinner(el, true)
        seexports.seal_gui:setImageFile(el, loadingTex)
      end
    end
  end
  if newTextPreviewFont then
    local w = 495
    local h = 48 + w / 9 * 2
    local x = screenX / 2 - w / 2
    local y = screenY / 2 - h / 2 - 48
    dxDrawRectangle(x, y + h, w, 96, grey2)
    dxDrawRectangle(x + 8, y + h + 8, w - 16, 80, grey4)
    dxDrawText(seexports.seal_gui:getInputValue(newTextInput) or "", x, y + h, x + w, y + h + 96, tocolor(255, 255, 255, 255), 0.5, newTextPreviewFont, "center", "center")
  end
  if mirrorSetStage == 3 or mirrorSetStage == 6 then
    local mx, my = false, false
    local mdx, mdy = false, false
    for i = 0, screenY * 0.025 do
      local pixelX = dxGetTexturePixels(renderTargetX, screenX / 2, screenY / 2 + i, ts, ts)
      if pixelX then
        mx = calculateCoord(pixelX, 0, 0)
        local pixelY = dxGetTexturePixels(renderTargetY, screenX / 2, screenY / 2 + i, ts, ts)
        if pixelY then
          my = calculateCoord(pixelY, 0, 0)
        end
      end
      pixelX, pixelY = nil, nil
      collectgarbage("collect")
      if mx and my then
        for j = 1, screenY * 0.025 do
          local dx, dy = false, false
          local pixelX = dxGetTexturePixels(renderTargetX, screenX / 2 + j * (mirrorSetStage == 6 and -1 or 1), screenY / 2 + i + j, ts, ts)
          if pixelX then
            dx = calculateCoord(pixelX, 0, 0)
            local pixelY = dxGetTexturePixels(renderTargetY, screenX / 2 + j * (mirrorSetStage == 6 and -1 or 1), screenY / 2 + i + j, ts, ts)
            if pixelY then
              dy = calculateCoord(pixelY, 0, 0)
            end
          end
          pixelX, pixelY = nil, nil
          collectgarbage("collect")
          if dx and dy and dx ~= mx and dy ~= my then
            mdx = dx
            mdy = dy
          end
        end
      end
      if mx and my and mdx and mdy then
        break
      end
    end
    if mx and my and mdx and mdy then
      if mirrorSetStage == 3 then
        mirrorPositions[1] = math.floor(mx * ts + 0.5)
        mirrorPositions[2] = math.floor(my * ts + 0.5)
        mirrorPositions[3] = (mdx - mx) / math.abs(mdx - mx)
        mirrorPositions[4] = (mdy - my) / math.abs(mdy - my)
      else
        mirrorPositions[5] = math.floor(mx * ts + 0.5)
        mirrorPositions[6] = math.floor(my * ts + 0.5)
        mirrorPositions[7] = (mdx - mx) / math.abs(mdx - mx)
        mirrorPositions[8] = (mdy - my) / math.abs(mdy - my)
      end
      rtToDraw = true
      mirrorsReady = tonumber(mirrorPositions[1]) and tonumber(mirrorPositions[5])
      if mirrorsReady then
        createEditorGui()
      end
    end
  end
  uvX, uvY = false, false
  local cx, cy = getCursorPosition()
  if cx and cy and inEditorMode then
    cx, cy = cx * screenX, cy * screenY
    if layerClick then
      local y = cy - layerClick[2]
      rtToDraw = true
      if 1 < math.abs(y) then
        layerClick[2] = cy
        layerClick[3] = layerClick[3] + y
        local i = math.floor((layerClick[3] + 32 - 72) / 64) + 1
        i = math.max(i, 1)
        i = math.min(i, math.min(#layerElements, #layers))
        local j = #layers - i + 1 - layerScroll
        if layers[j] and j ~= layerClick[1] then
          swap(layers, j, layerClick[1])
          layerClick[1] = j
          selectedLayer = j
          processToolbarToggles()
          seexports.seal_gui:guiToFront(layerElements[#layers - layerClick[1] + 1 - layerScroll][1])
          processLayerElements()
        end
        seexports.seal_gui:setGuiPosition(layerElements[#layers - layerClick[1] + 1 - layerScroll][1], false, layerClick[3], true)
      end
    elseif not getKeyState("mouse2") or placingDecal or movingLayer then
      local ts = not (not placingDecal or uvR) and 3 or 1
      local pixelX = dxGetTexturePixels(renderTargetX, cx, cy, ts, ts)
      if pixelX then
        uvX = calculateCoord(pixelX, 0, 0)
      end
      if uvX then
        local pixelY = dxGetTexturePixels(renderTargetY, cx, cy, ts, ts)
        if pixelY then
          uvY = calculateCoord(pixelY, 0, 0)
        end
        if uvY then
          if placingDecal and not uvR then
            local bx = uvX - (calculateCoord(pixelX, 0, 2) or 0)
            local by = uvY - (calculateCoord(pixelY, 0, 2) or 0)
            local rx = uvX - (calculateCoord(pixelX, 2, 0) or 0)
            local ry = uvY - (calculateCoord(pixelY, 2, 0) or 0)
            local r = false
            if 0 < math.abs(bx) + math.abs(by) and math.abs(bx) < 2 / ts and math.abs(by) < 2 / ts then
              r = math.floor(math.atan2(by, bx) / pih) * pih + pih
            end
            if 0 < math.abs(rx) + math.abs(ry) and math.abs(rx) < 2 / ts and math.abs(ry) < 2 / ts then
              local r2 = math.floor(math.atan2(ry, rx) / pih) * pih + pih * 2
              r = r and math.max(r, r2) or r2
            end
            if r then
              uvR = math.deg(r)
            end
          end
        else
          uvX = false
        end
      end
    end
  elseif layerClick then
    layerClick = false
    rtToDraw = true
    processLayerElements()
  end
  if uvR and not uvX then
    uvR = false
  end
  local tmp = hoveringLayer and true or false
  hoveringLayer = false
  if placingDecal then
    rtToDraw = true
  elseif selectedLayer and uvX then
    local uvX, uvY = uvX * ts, uvY * ts
    if movingLayer then
      if movingMode == "resize" then
        local layer = layers[selectedLayer]
        local rot = layer[6]
        local r = math.rad(-rot)
        local s = math.sin(r)
        local c = math.cos(r)
        local ix = (uvX - movingLayer[1]) * c - (uvY - movingLayer[2]) * s
        local iy = (uvX - movingLayer[1]) * s + (uvY - movingLayer[2]) * c
        local osx, osy = movingLayer[5], movingLayer[6]
        local rx, ry = 0, 0
        if getKeyState("lalt") then
          ix = ix * 2
          iy = iy * 2
        end
        if movingLayer[7] == "c4" then
          if getKeyState("lshift") then
            local a1 = iy + osx - iy
            local b1 = ix - (ix - osy)
            local c1 = a1 * ix + b1 * iy
            local det = osy * b1 - a1 * -osx
            ix = (b1 - -osx * c1) / det
            iy = (osy * c1 - a1) / det
          end
          layers[selectedLayer][4] = math.max(24, math.floor(movingLayer[5] + ix))
          layers[selectedLayer][5] = math.max(24, math.floor(movingLayer[6] + iy))
        elseif movingLayer[7] == "c3" then
          if getKeyState("lshift") then
            local a1 = iy + osx - iy
            local b1 = ix - (ix + osy)
            local c1 = a1 * ix + b1 * iy
            local det = -osy * b1 - a1 * -osx
            ix = (b1 - -osx * c1) / det
            iy = (-osy * c1 - a1) / det
          end
          layers[selectedLayer][4] = math.max(24, math.floor(movingLayer[5] + ix))
          layers[selectedLayer][5] = math.max(24, math.floor(movingLayer[6] - iy))
          ry = layers[selectedLayer][5] - osy
        elseif movingLayer[7] == "c2" then
          if getKeyState("lshift") then
            local a1 = iy - osx - iy
            local b1 = ix - (ix - osy)
            local c1 = a1 * ix + b1 * iy
            local det = osy * b1 - a1 * osx
            ix = (b1 - osx * c1) / det
            iy = (osy * c1 - a1) / det
          end
          layers[selectedLayer][4] = math.max(24, math.floor(movingLayer[5] - ix))
          layers[selectedLayer][5] = math.max(24, math.floor(movingLayer[6] + iy))
          rx = layers[selectedLayer][4] - osx
        elseif movingLayer[7] == "c1" then
          if getKeyState("lshift") then
            local a1 = iy - osx - iy
            local b1 = ix - (ix + osy)
            local c1 = a1 * ix + b1 * iy
            local det = -osy * b1 - a1 * osx
            ix = (b1 - osx * c1) / det
            iy = (-osy * c1 - a1) / det
          end
          layers[selectedLayer][4] = math.max(24, math.floor(movingLayer[5] - ix))
          layers[selectedLayer][5] = math.max(24, math.floor(movingLayer[6] - iy))
          rx = layers[selectedLayer][4] - osx
          ry = layers[selectedLayer][5] - osy
        elseif movingLayer[7] == "s4" then
          layers[selectedLayer][4] = math.max(24, math.floor(movingLayer[5] + ix))
        elseif movingLayer[7] == "s3" then
          layers[selectedLayer][4] = math.max(24, math.floor(movingLayer[5] - ix))
          rx = layers[selectedLayer][4] - osx
        elseif movingLayer[7] == "s2" then
          layers[selectedLayer][5] = math.max(24, math.floor(movingLayer[6] + iy))
        elseif movingLayer[7] == "s1" then
          layers[selectedLayer][5] = math.max(24, math.floor(movingLayer[6] - iy))
          ry = layers[selectedLayer][5] - osy
        end
        local sx, sy = layers[selectedLayer][4] - osx, layers[selectedLayer][5] - osy
        local r = math.rad(rot)
        local s = math.sin(r)
        local c = math.cos(r)
        local ix = osx / 2
        local iy = osy / 2
        if not getKeyState("lalt") then
          ix = ix + (sx / 2 - rx) * c - (sy / 2 - ry) * s
          iy = iy + (sx / 2 - rx) * s + (sy / 2 - ry) * c
        end
        layers[selectedLayer][2] = movingLayer[3] + ix - (osx + sx) / 2
        layers[selectedLayer][3] = movingLayer[4] + iy - (osy + sy) / 2
      elseif movingMode == "rotate" then
        local layer = layers[selectedLayer]
        local rot = math.deg(movingLayer[1] - math.atan2(uvX - (layer[2] + layer[4] / 2), uvY - (layer[3] + layer[5] / 2)))
        layers[selectedLayer][6] = movingLayer[2] + rot
        if getKeyState("lshift") then
          layers[selectedLayer][6] = math.floor(layers[selectedLayer][6] / 5 + 0.5) * 5
        end
        layers[selectedLayer][6] = layers[selectedLayer][6] % 360
      else
        layers[selectedLayer][2] = math.floor(movingLayer[3] + uvX - movingLayer[1])
        layers[selectedLayer][3] = math.floor(movingLayer[4] + uvY - movingLayer[2])
      end
      rtToDraw = true
    else
      local layer = layers[selectedLayer]
      local x, y = layer[2], layer[3]
      local sx, sy = layer[4], layer[5]
      local rot = layer[6]
      local r = math.rad(-rot)
      local s = math.sin(r)
      local c = math.cos(r)
      local ix = (x + sx / 2 - uvX) * c - (y + sy / 2 - uvY) * s
      local iy = (x + sx / 2 - uvX) * s + (y + sy / 2 - uvY) * c
      local cs = math.min(math.floor(math.min(sx, sy) / 5 / 2) * 2, 16)
      local lw = cs / 4
      if ix <= sx / 2 + lw / 2 + 1 and ix >= -sx / 2 - lw / 2 - 1 and iy <= sy / 2 + lw / 2 + 1 and iy >= -sy / 2 - lw / 2 - 1 then
        if movingMode == "resize" then
          local hSide = false
          if ix < -sx / 2 + cs then
            if iy < -sy / 2 + cs then
              hSide = "c4"
            elseif iy > sy / 2 - cs then
              hSide = "c3"
            else
              hSide = "s4"
            end
          elseif ix > sx / 2 - cs then
            if iy < -sy / 2 + cs then
              hSide = "c2"
            elseif iy > sy / 2 - cs then
              hSide = "c1"
            else
              hSide = "s3"
            end
          elseif iy < -sy / 2 + cs then
            hSide = "s2"
          elseif iy > sy / 2 - cs then
            hSide = "s1"
          end
          if hSide then
            rtToDraw = true
            hoveringLayer = {
              uvX,
              uvY,
              layer[2],
              layer[3],
              layer[4],
              layer[5],
              hSide
            }
          end
        elseif movingMode == "rotate" then
          hoveringLayer = {
            math.atan2(uvX - (layer[2] + layer[4] / 2), uvY - (layer[3] + layer[5] / 2)),
            layer[6]
          }
        else
          hoveringLayer = {
            uvX,
            uvY,
            layer[2],
            layer[3]
          }
        end
      end
    end
  end
  if (hoveringLayer and true or false) ~= tmp then
    rtToDraw = true
  end
  if 0 < hoveringLayerSideCount then
    rtToDraw = true
  end
  if layerHighlight then
    rtToDraw = true
  end
  if prepareSaveNextFrame then
    drawLayers(true)
    saveNextFrame = true
    prepareSaveNextFrame = false
  elseif saveNextFrame then
    drawLayers()
    deleteEditorGui()
    local screen = dxCreateScreenSource(screenX, screenY)
    if isElement(screen) then
      if isElement(paintjobPreviewTexture) then
        destroyElement(paintjobPreviewTexture)
      end
      paintjobPreviewTexture = nil
      paintjobPreviewTexture = dxCreateRenderTarget(200, 200)
    end
    if isElement(paintjobPreviewTexture) then
      dxUpdateScreenSource(screen, false)
      dxSetRenderTarget(paintjobPreviewTexture)
      dxDrawImage(100 - 200 * (screenX / screenY) / 2, 0, 200 * (screenX / screenY), 200, screen)
      dxSetRenderTarget()
    end
    if isElement(screen) then
      destroyElement(screen)
    end
    createPaintjobSaver()
    saveNextFrame = false
    prepareSaveNextFrame = false
  elseif rtToDraw then
    drawLayers()
    rtToDraw = false
  end
  if saveFakeScreenSource then
    if isElement(saveFakeScreenSource) then
      dxDrawImage(0, 0, screenX, screenY, saveFakeScreenSource)
    end
    if not saveNextFrame and not prepareSaveNextFrame and (mirrorsReady and mirrorsPostReady or 8 <= mirrorTries) then
      if isElement(saveFakeScreenSource) then
        destroyElement(saveFakeScreenSource)
      end
      saveFakeScreenSource = false
    end
    mirrorsPostReady = mirrorsReady
  end
  local loadingState = (mirrorsReady or 8 <= mirrorTries) and 1 or 0.9
  if decalLoadQueue then
    if 0 < #decalLoadQueue then
      local p = 0
      if 0 < decalsToLoad then
        p = 1 - #decalLoadQueue / decalsToLoad
      end
      loadingState = p * 0.9
      for i = 1, 4 do
        if decalLoadQueue[1] then
          loadDecalFinal(decalLoadQueue[1][1], decalLoadQueue[1][2], decalLoadQueue[1][3])
          table.remove(decalLoadQueue, 1)
        end
      end
    else
      decalLoadQueue = false
      selectorCategory = decalCategoryList[1]
    end
  end
  if loadingState < 1 then
    dxDrawRectangle(screenX / 2 - 200, screenY / 2 - 4, 400, 8, grey2)
    dxDrawRectangle(screenX / 2 - 200, screenY / 2 - 4, 400 * loadingState, 8, green)
  end
end
local eventsHandled = false
function stopPaintjobEditor()
  showCursor(false)
  if eventsHandled then
    removeEventHandler("onClientRender", getRootElement(), renderPjEditor)
    removeEventHandler("onClientKey", getRootElement(), pjEditorKey)
    removeEventHandler("onClientClick", getRootElement(), pjEditorClick, true, "high+99999999999")
    removeEventHandler("onClientRestore", getRootElement(), restorePjEditor)
    removeEventHandler("onClientPreRender", getRootElement(), preRenderPjEditor)
  end
  eventsHandled = false
  if isElement(veh) then
    handleVehStreamIn(veh, true)
  end
  veh = false
  layers = {}
  if isElement(shader) then
    destroyElement(shader)
  end
  shader = false
  if isElement(renderTargetX) then
    destroyElement(renderTargetX)
  end
  renderTargetX = false
  if isElement(renderTargetY) then
    destroyElement(renderTargetY)
  end
  renderTargetY = false
  if isElement(renderTarget2) then
    destroyElement(renderTarget2)
  end
  renderTarget2 = false
  decalCategorys = {}
  if isElement(saveFakeScreenSource) then
    destroyElement(saveFakeScreenSource)
  end
  saveFakeScreenSource = false
  for k in pairs(decals) do
    if isElement(decals[k][1]) then
      destroyElement(decals[k][1])
    end
  end
  decals = {}
  layers = {}
  collectgarbage("collect")
  resetVariables1()
  resetVariables2()
  deleteEditorGui()
  resetTheColorList()
  exports.seal_tuning:reopen()
end
function resetVariables1()
  buyingPaintjob = false
  placingDecalColor = {
    255,
    255,
    255
  }
  selectedLayer = false
  layerClick = false
  paintjobDeleterPrompt = false
  paintjobToLoad = false
  currentPaintjobLoaderPage = 1
  decalSelectorCategoryScroll = 0
  currentDecalSelectorPage = 1
  decalToPlace = false
  sx, sy = 0, 0
  camX = 0.5
  camY = 0
  desiredCamZoom = 1.75
  camZoom = 1.75
  camCursor = false
  w = math.floor(screenX * 0.15)
end
function resetVariables2()
  layerScroll = 0
  inEditorMode = false
  placingDecal = false
  placingHeight = 128
  placingRot = 0
  uvX, uvY = false
  uvR = 0
  hoveringLayerSide = {}
  hoveringLayerSideCount = 0
  hoveringLayer = false
  movingLayer = false
  movingMode = "move"
  mirrorTries = 0
  mirrorSetStage = 1
  mirrorPositions = {}
  mirrorsReady = false
  mirrorsPostReady = false
  carBackgroundTexutre = "textures/0"
  carBackgroundColor = {
    255,
    255,
    255
  }
  carBackgroundSize = 256
  decalLoadQueue = false
end
function startPaintjobEditor(v, gratis)
  if v == getPedOccupiedVehicle(localPlayer) then
    gratisPJ = gratis
    local model = getElementModel(v)
    if not textureNames[model] then
      seexports.seal_gui:showInfobox("e", "Erre a járműre nem tudsz egyedi paintjobot vásárolni.")
      return false
    end
    stopPaintjobEditor()
    saveFakeScreenSource = dxCreateScreenSource(screenX, screenY)
    dxUpdateScreenSource(saveFakeScreenSource, true)
    dxDrawImage(0, 0, screenX, screenY, saveFakeScreenSource)
    showCursor(true)
    initColorsAndFonts()
    veh = v
    local col = {
      getVehicleColor(veh, true)
    }
    col[1], col[2], col[3] = 255, 255, 255
    setVehicleColor(veh, unpack(col))
    shader = dxCreateShader(mainShaderSource)
    engineApplyShaderToWorldTexture(shader, textureNames[model], veh)
    engineApplyShaderToWorldTexture(shader, "#" .. utf8.sub(textureNames[model], 2), veh)
    minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(veh)
    renderTargetX = dxCreateRenderTarget(screenX, screenY, true)
    renderTargetY = dxCreateRenderTarget(screenX, screenY, true)
    dxSetShaderValue(shader, "secondRTX", renderTargetX)
    dxSetShaderValue(shader, "secondRTY", renderTargetY)
    renderTarget2 = dxCreateRenderTarget(ts, ts, true)
    dxSetShaderValue(shader, "Tex0", renderTarget2)
    loadTheDecals()
    if not eventsHandled then
      addEventHandler("onClientRender", getRootElement(), renderPjEditor)
      addEventHandler("onClientKey", getRootElement(), pjEditorKey)
      addEventHandler("onClientClick", getRootElement(), pjEditorClick, true, "high+99999999999")
      addEventHandler("onClientRestore", getRootElement(), restorePjEditor)
      addEventHandler("onClientPreRender", getRootElement(), preRenderPjEditor)
    end
    eventsHandled = true
    return true
  end
end
