local screenX, screenY = guiGetScreenSize()
local barBackground = false

function guiRefreshColors()
    local resource = getResourceFromName("seal_gui")
    local resourceState = getResourceState(resource)

    if resource and resourceState == "running" then
        barBackground = exports.seal_gui:getColorCodeToColor("grey1")

        for drug in pairs(drugTypes) do
            drugTypes[drug].col1 = exports.seal_gui:getColorCodeToColor(drugTypes[drug].color1)
            drugTypes[drug].col2 = exports.seal_gui:getColorCodeToColor(drugTypes[drug].color2)
        end
    end
end
addEventHandler("onGuiRefreshColors", getRootElement(), guiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), guiRefreshColors)

local rampagePosX = screenX / 2 - 150
local rampagePosY = screenY - 100

local rampageSizeW = 300
local rampageSizeH = 32

local drugShaders = {}
drugShaders.lsd = " texture screenTexture; sampler screenSampler = sampler_state { Texture = <screenTexture>; }; texture screenTextureEx; sampler screenSamplerEx = sampler_state { Texture = <screenTextureEx>; }; float intensity = 0; float time = 0; const float3 lumCoeff = float3(0.2125, 0.7154, 0.0721); float3x3 QuaternionToMatrix(float4 quat) { float3 cross = quat.yzx * quat.zxy; float3 square= quat.xyz * quat.xyz; float3 wimag = quat.w * quat.xyz; square = square.xyz + square.yzx; float3 diag = 0.5 - square; float3 a = (cross + wimag); float3 b = (cross - wimag); return float3x3( 2.0 * float3(diag.x, b.z, a.y), 2.0 * float3(a.z, diag.y, b.x), 2.0 * float3(b.y, a.x, diag.z)); } float4 PixelShaderFunction(float4 Diffuse : COLOR0, float2 TexCoord : TEXCOORD0) : COLOR0 { TexCoord = (TexCoord - 0.5) * 2.0; TexCoord.x /= 1.0 + (abs(TexCoord.y) / (5+sin(time)*2))*intensity; TexCoord.y /= 1.0 + (abs(TexCoord.x) / (5+cos(time)*2))*intensity; TexCoord = (TexCoord / 2.0) + 0.5; TexCoord.x += sin(TexCoord.y*3.14*5+time*2.5)*0.0045*intensity; TexCoord.y += cos(TexCoord.x*3.14*5+time*2.5)*0.0045*intensity; float4 render = tex2D(screenSampler, TexCoord); float4 render2 = tex2D(screenSamplerEx, TexCoord); float3 root3 = float3(0.57735, 0.57735, 0.57735); float half_angle = 0.5 * sin(time/10); float4 rot_quat = float4( (root3 * sin(half_angle)), cos(half_angle)); float3x3 rot_Matrix = QuaternionToMatrix(rot_quat); render.rgb = lerp(render.rgb, mul(rot_Matrix, render.rgb), intensity); float ci = float(dot(render.rgb, lumCoeff)); render.rgb = lerp(ci, render.rgb, 1 + (1 + abs(cos(time)))*intensity); render = lerp(render, render2, sin(time*2)*0.25*intensity); return render; } technique Technique1 { pass Pass1 { PixelShader = compile ps_2_0 PixelShaderFunction(); } } "
drugShaders.shroom = " texture screenTexture; sampler screenSampler = sampler_state { Texture = <screenTexture>; }; texture screenTextureEx; sampler screenSamplerEx = sampler_state { Texture = <screenTextureEx>; }; float intensity = 0; float time = 0; const float3 lumCoeff = float3(0.2125, 0.7154, 0.0721); float3x3 QuaternionToMatrix(float4 quat) { float3 cross = quat.yzx * quat.zxy; float3 square= quat.xyz * quat.xyz; float3 wimag = quat.w * quat.xyz; square = square.xyz + square.yzx; float3 diag = 0.5 - square; float3 a = (cross + wimag); float3 b = (cross - wimag); return float3x3( 2.0 * float3(diag.x, b.z, a.y), 2.0 * float3(a.z, diag.y, b.x), 2.0 * float3(b.y, a.x, diag.z)); } float4 PixelShaderFunction(float4 Diffuse : COLOR0, float2 TexCoord : TEXCOORD0) : COLOR0 { TexCoord = (TexCoord - 0.5) * 2.0; TexCoord.x /= 1.0 + (abs(TexCoord.y) / (5+sin(time)*2))*intensity; TexCoord.y /= 1.0 + (abs(TexCoord.x) / (5+cos(time)*2))*intensity; TexCoord = (TexCoord / 2.0) + 0.5; TexCoord.x += sin(TexCoord.y*3.14*5+time*2.5)*0.0025*intensity; TexCoord.y += cos(TexCoord.x*3.14*5+time*2.5)*0.0025*intensity; float4 render = tex2D(screenSampler, TexCoord); float4 render2 = tex2D(screenSamplerEx, TexCoord); float3 root3 = float3(0.57735, 0.57735, 0.57735); float half_angle = 0.5 * sin(time/10); float4 rot_quat = float4( (root3 * sin(half_angle)), cos(half_angle)); float3x3 rot_Matrix = QuaternionToMatrix(rot_quat); render.rgb = lerp(render.rgb, mul(rot_Matrix, render.rgb), intensity); float ci = float(dot(render.rgb, lumCoeff)); render.rgb = lerp(ci, render.rgb, 1 + (1 + abs(cos(time)))*intensity); render = lerp(render, render2, cos(time)*0.5*intensity); return render; } technique Technique1 { pass Pass1 { PixelShader = compile ps_2_0 PixelShaderFunction(); } } "
drugShaders.coke = " float ScreenWidth; float ScreenHeight; texture screenTexture; sampler screenSampler = sampler_state { Texture = <screenTexture>; }; float intensity = 0; float time = 0; const float4 lumCoeff = float4(0.2125, 0.7154, 0.0721, 1); const float3 lumCoeffEx = float3(0.2125, 0.7154, 0.0521); float4 PixelShaderFunction(float2 TexCoord : TEXCOORD0) : COLOR0 { TexCoord = (TexCoord - 0.5) * 2.0; TexCoord.x *= 1 - pow((abs(TexCoord.y) / 3), 2)*intensity; TexCoord.y *= 1 - pow((abs(TexCoord.x) / 3), 2)*intensity; TexCoord = (TexCoord / 2.0) + 0.5; float4 render = tex2D(screenSampler, TexCoord); float4 orig = render; float s11 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, -1.0f / ScreenHeight)), lumCoeff); float s12 = dot(tex2D(screenSampler, TexCoord + float2(0, -1.0f / ScreenHeight)), lumCoeff); float s13 = dot(tex2D(screenSampler, TexCoord + float2(1.0f / ScreenWidth, -1.0f / ScreenHeight)), lumCoeff); float s21 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, 0)), lumCoeff); float s23 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, 0)), lumCoeff); float s31 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, 1.0f / ScreenHeight)), lumCoeff); float s32 = dot(tex2D(screenSampler, TexCoord + float2(0, 1.0f / ScreenHeight)), lumCoeff); float s33 = dot(tex2D(screenSampler, TexCoord + float2(1.0f / ScreenWidth, 1.0f / ScreenHeight)), lumCoeff); float t1 = s13 + s33 + (2 * s23) - s11 - (2 * s21) - s31; float t2 = s31 + (2 * s32) + s33 - s11 - (2 * s12) - s13; float OutLine; if (((t1 * t1) + (t2 * t2)) > 0.25/10) { OutLine = 0.5*intensity; } else { OutLine = 0; } render.rgb = (render.rgb - 0.5) *(OutLine + 1.0) + 0.5; render.rgb *= 1+0.25*intensity+OutLine*0.5; float ci = float(dot(render.rgb, lumCoeffEx)); render.rgb = lerp(ci, render.rgb, 1+intensity ); return render; } technique Technique1 { pass Pass1 { PixelShader = compile ps_2_0 PixelShaderFunction(); } } "
drugShaders.para = " float ScreenWidth; float ScreenHeight; texture screenTexture; sampler screenSampler = sampler_state { Texture = <screenTexture>; }; float intensity = 0; float time = 0; const float4 lumCoeff = float4(0.2125, 0.7154, 0.0721, 1); const float3 lumCoeffEx = float3(0.4125, 0.7154, 0.0721); const float3 purple = float3(0.65, 0.4, 0.75); float4 PixelShaderFunction(float2 TexCoord : TEXCOORD0) : COLOR0 { TexCoord = (TexCoord - 0.5) * 2.0; TexCoord.x *= 1 - pow((abs(TexCoord.y) / 3), 2)*intensity; TexCoord.y *= 1 - pow((abs(TexCoord.x) / 3), 2)*intensity; TexCoord = (TexCoord / 2.0) + 0.5; float4 render = tex2D(screenSampler, TexCoord); float4 orig = render; float s11 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, -1.0f / ScreenHeight)), lumCoeff); float s12 = dot(tex2D(screenSampler, TexCoord + float2(0, -1.0f / ScreenHeight)), lumCoeff); float s13 = dot(tex2D(screenSampler, TexCoord + float2(1.0f / ScreenWidth, -1.0f / ScreenHeight)), lumCoeff); float s21 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, 0)), lumCoeff); float s23 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, 0)), lumCoeff); float s31 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, 1.0f / ScreenHeight)), lumCoeff); float s32 = dot(tex2D(screenSampler, TexCoord + float2(0, 1.0f / ScreenHeight)), lumCoeff); float s33 = dot(tex2D(screenSampler, TexCoord + float2(1.0f / ScreenWidth, 1.0f / ScreenHeight)), lumCoeff); float t1 = s13 + s33 + (2 * s23) - s11 - (2 * s21) - s31; float t2 = s31 + (2 * s32) + s33 - s11 - (2 * s12) - s13; float OutLine; if (((t1 * t1) + (t2 * t2)) > 0.25/10) { OutLine = 0.5*intensity; } else { OutLine = 0; } render.rgb = (render.rgb - 0.5) *(OutLine + 1.0) + 0.5; render.rgb *= 1+purple*intensity+OutLine*0.5; float ci = float(dot(render.rgb, lumCoeffEx)); render.rgb = lerp(ci, render.rgb, 1+intensity ); return render; } technique Technique1 { pass Pass1 { PixelShader = compile ps_2_0 PixelShaderFunction(); } } "
drugShaders.speed = " float ScreenWidth; float ScreenHeight; texture screenTexture; sampler screenSampler = sampler_state { Texture = <screenTexture>; }; float intensity = 0; float time = 0; const float4 lumCoeff = float4(0.2125, 0.7154, 0.0721, 1); float4 PixelShaderFunction(float2 TexCoord : TEXCOORD0) : COLOR0 { TexCoord = (TexCoord - 0.5) * 2.0; TexCoord.x *= 1 - pow((abs(TexCoord.y) / 2.75), 2)*intensity; TexCoord.y *= 1 - pow((abs(TexCoord.x) / 2.75), 2)*intensity; TexCoord = (TexCoord / 2.0) + 0.5; float4 render = tex2D(screenSampler, TexCoord); float4 orig = render; float s11 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, -1.0f / ScreenHeight)), lumCoeff); float s12 = dot(tex2D(screenSampler, TexCoord + float2(0, -1.0f / ScreenHeight)), lumCoeff); float s13 = dot(tex2D(screenSampler, TexCoord + float2(1.0f / ScreenWidth, -1.0f / ScreenHeight)), lumCoeff); float s21 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, 0)), lumCoeff); float s23 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, 0)), lumCoeff); float s31 = dot(tex2D(screenSampler, TexCoord + float2(-1.0f / ScreenWidth, 1.0f / ScreenHeight)), lumCoeff); float s32 = dot(tex2D(screenSampler, TexCoord + float2(0, 1.0f / ScreenHeight)), lumCoeff); float s33 = dot(tex2D(screenSampler, TexCoord + float2(1.0f / ScreenWidth, 1.0f / ScreenHeight)), lumCoeff); float t1 = s13 + s33 + (2 * s23) - s11 - (2 * s21) - s31; float t2 = s31 + (2 * s32) + s33 - s11 - (2 * s12) - s13; float OutLine; if (((t1 * t1) + (t2 * t2)) > 0.1/10) { OutLine = 0.5*intensity; } else { OutLine = 0; } render.rgb = (render.rgb - 0.5) *(OutLine + 1.0) + 0.5; render.rgb *= 1+0.5*intensity+OutLine*0.5; float ci = float(dot(render.rgb, lumCoeff)); render.rgb = lerp(ci, render.rgb, 1-intensity*0.25 ); return render; } technique Technique1 { pass Pass1 { PixelShader = compile ps_2_0 PixelShaderFunction(); } } "
drugShaders.weed = " float ScreenWidth; float ScreenHeight; texture screenTexture; sampler screenSampler = sampler_state { Texture = <screenTexture>; }; texture screenTextureEx; sampler screenSamplerEx = sampler_state { Texture = <screenTextureEx>; }; float intensity = 0; float time = 0; float4 PixelShaderFunction(float2 TexCoord : TEXCOORD0) : COLOR0 { TexCoord = (TexCoord - 0.5) * 2.0; float d = 1-sqrt(TexCoord.x*TexCoord.x+TexCoord.y*TexCoord.y); TexCoord.x += sin(TexCoord.y*3.14*5+time*2.5)*0.00125*intensity; TexCoord.y += cos(TexCoord.x*3.14*5+time*2.5)*0.00125*intensity; TexCoord = (TexCoord / 2.0) + 0.5; float4 render = tex2D(screenSampler, TexCoord); float4 render2 = tex2D(screenSamplerEx, TexCoord); render = lerp(render, (render+render2)/2, intensity); render.rgb *= lerp(1, d, abs(cos(time/2))*0.5*intensity); render.r *= 1+0.15*abs(sin(time/2))*intensity; render.g *= 1+0.25*abs(sin(time/2))*intensity; return render; } technique Technique1 { pass Pass1 { PixelShader = compile ps_2_0 PixelShaderFunction(); } } "
drugShaders.ex = " float ScreenWidth; float ScreenHeight; texture screenTexture; sampler screenSampler = sampler_state { Texture = <screenTexture>; }; texture screenTextureEx; sampler screenSamplerEx = sampler_state { Texture = <screenTextureEx>; }; float intensity = 1; float time = 0; float4 PixelShaderFunction(float2 TexCoord : TEXCOORD0) : COLOR0 { TexCoord = (TexCoord - 0.5) * 2.0; float d = 1-sqrt(TexCoord.x*TexCoord.x+TexCoord.y*TexCoord.y); TexCoord.x += sin(TexCoord.y*3.14*5+time*2.5)*0.002*intensity; TexCoord.y += cos(TexCoord.x*3.14*5+time*2.5)*0.002*intensity; TexCoord = (TexCoord / 2.0) + 0.5; float4 render = tex2D(screenSampler, TexCoord); float4 render2 = tex2D(screenSamplerEx, TexCoord); render = lerp(render, (render+render2)/2, intensity); render.rgb /= lerp(1, d, abs(cos(time))*0.25*intensity); render.r *= 1+0.25*abs(sin(time/2))*intensity; render.b *= 1+0.15*abs(sin(time/2))*intensity; return render; } technique Technique1 { pass Pass1 { PixelShader = compile ps_2_0 PixelShaderFunction(); } } "

local screenSource = false
local screenSourceEx = false

local currentDoseIntensity = 0

local drugShader = false
local currentDrug = false

function processShader()
    if isElement(screenSource) then
        destroyElement(screenSource)
    end
    screenSource = false

    if isElement(screenSourceEx) then
        destroyElement(screenSourceEx)
    end
    screenSourceEx = false

    if isElement(drugShader) then
        destroyElement(drugShader)
    end
    drugShader = false

    if currentDrug then
        drugShader = dxCreateShader(drugShaders[currentDrug])
        screenSource = dxCreateScreenSource(screenX, screenY)

        dxSetShaderValue(drugShader, "screenTexture", screenSource)
        dxSetShaderValue(drugShader, "ScreenWidth", screenX)
        dxSetShaderValue(drugShader, "ScreenHeight", screenY)
        dxUpdateScreenSource(screenSource, true)

        if currentDrug ~= "coke" and currentDrug ~= "speed" and currentDrug ~= "para" then
            screenSourceEx = dxCreateScreenSource(screenX, screenY)
            dxSetShaderValue(drugShader, "screenTextureEx", screenSourceEx)
            dxUpdateScreenSource(screenSourceEx, true)
        end

        if alreadyHandeldEvents then
            return
        end
        alreadyHandeldEvents = true

        addEventHandler("onClientRender", getRootElement(), renderDrugs, true, "low-999999999999999999")
        addEventHandler("onClientPreRender", getRootElement(), preRenderDrugs)
    else
        removeEventHandler("onClientRender", getRootElement(), renderDrugs, true, "low-999999999999999999")
        removeEventHandler("onClientPreRender", getRootElement(), preRenderDrugs)
    end
end

function renderDrugs()
    dxUpdateScreenSource(screenSource, true)
    dxDrawImage(0, 0, screenX, screenY, drugShader)

    if screenSourceEx then
        dxUpdateScreenSource(screenSourceEx, true)
    end

    dxDrawRectangle(rampagePosX, rampagePosY + rampageSizeH / 2 - 5, rampageSizeW, 10, barBackground)
    dxDrawRectangle(rampagePosX, rampagePosY + rampageSizeH / 2 - 5, rampageSizeW * currentDoseIntensity, 10, drugTypes[currentDrug].col1)
    dxDrawImageSection(rampagePosX, rampagePosY + rampageSizeH / 2 - 5, rampageSizeW * currentDoseIntensity, 10, 350 * getTickCount() / 2000, 0, 350 * currentDoseIntensity, 10, barTexture, 0, 0, 0, drugTypes[currentDrug].col2)
end

function preRenderDrugs(delta)
    local time = getTickCount() / 10
    dxSetShaderValue(drugShader, "time", time)

    if currentDoseIntensity < doseIntensity then
        currentDoseIntensity = currentDoseIntensity + doseSpeed * delta / 1000

        if currentDoseIntensity > doseIntensity then
            currentDoseIntensity = doseIntensity
        end
      elseif currentDoseIntensity > doseIntensity then
        currentDoseIntensity = currentDoseIntensity + doseSpeed * delta / 1000

        if currentDoseIntensity < doseIntensity then
            currentDoseIntensity = doseIntensity
        end
    end

    dxSetShaderValue(drugShader, "intensity", currentDoseIntensity)
end

addEvent("refreshDrugDose", true)
addEventHandler("refreshDrugDose", getRootElement(), function(drug, dose, time)
    if currentDrug ~= drug then
        if isElement(barTexture) then
            destroyElement(barTexture)
        end
        barTexture = dxCreateTexture("files/bar.dds", "argb", true)

        currentDrug = drug
        currentDoseIntensity = 0

        processShader()
    end

    doseIntensity = dose
    --seexports.v4_hud:staminaDrug(drug, dose)
    doseSpeed = (dose - currentDoseIntensity) / time
end)