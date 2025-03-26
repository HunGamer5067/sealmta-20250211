local seexports = {
  seal_gui = false,
  seal_models = false,
  seal_mdc = false,
  seal_hud = false,
  seal_groups = false,
  seal_controls = false,
  seal_markers = false
}
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
  if seelangStaticImageToc[0] and seelangStaticImageToc[1] and seelangStaticImageToc[2] then
    seelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
  end
end
processSeelangStaticImage[0] = function()
  if not isElement(seelangStaticImage[0]) then
    seelangStaticImageToc[0] = false
    seelangStaticImage[0] = dxCreateTexture("files/led.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[1] = function()
  if not isElement(seelangStaticImage[1]) then
    seelangStaticImageToc[1] = false
    seelangStaticImage[1] = dxCreateTexture("files/vign.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[2] = function()
  if not isElement(seelangStaticImage[2]) then
    seelangStaticImageToc[2] = false
    seelangStaticImage[2] = dxCreateTexture("files/nagypng.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
local seelangWaiterState0 = false
local function seelangProcessResWaiters()
  if not seelangWaiterState0 then
    local res0 = getResourceFromName("seal_markers")
    if res0 and getResourceState(res0) == "running" then
      createCCTVMarkers()
      seelangWaiterState0 = true
    end
  end
end
if triggerServerEvent then
  addEventHandler("onClientResourceStart", getRootElement(), seelangProcessResWaiters)
end
if triggerClientEvent then
  addEventHandler("onResourceStart", getRootElement(), seelangProcessResWaiters)
end
local font = false
local fontScale = false
local faTicks = false
local function seelangGuiRefreshColors()
  local res = getResourceFromName("seal_gui")
  if res and getResourceState(res) == "running" then
    font = seexports.seal_gui:getFont("11/W95FA.otf")
    fontScale = seexports.seal_gui:getFontScale("11/W95FA.otf")
    faTicks = seexports.seal_gui:getFaTicks()
    loadCatIcons()
  end
end
addEventHandler("onGuiRefreshColors", getRootElement(), seelangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), seelangGuiRefreshColors)
addEventHandler("refreshFaTicks", getRootElement(), function()
  faTicks = seexports.seal_gui:getFaTicks()
end)
loaded = false
local seelangModloaderLoaded = function()
  if not loaded then
      modelsLoaded()
      loaded = true
  end
end
addEventHandler("modloaderLoaded", getRootElement(), seelangModloaderLoaded)
if getElementData(localPlayer, "loggedIn") or seexports.seal_models and seexports.seal_models:isModloaderLoaded() then
  addEventHandler("onClientResourceStart", getResourceRootElement(), seelangModloaderLoaded)
end
local seelangCondHandlState0 = false
local function seelangCondHandl0(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState0 then
    seelangCondHandlState0 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderStreamed, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderStreamed)
    end
  end
end
local markerPoses = {
  {
      1168.5355224609, -1371.3842773438, 26.651515960693,
      0, 0,
  },
  {
    231.453125,
    80.134765625,
    1005.0390625,
    6,
    5555
  },
  {
    -1535.7822265625,
    403.529296875,
    9007.05859375,
    1,
    1
  },
  {
    231.4775390625,
    80.3427734375,
    1005.0390625,
    6,
    1
  },
  {
    -1589.333,
    691.39,
    9004.709,
    1,
    1
  },
  {
    1527.265625,
    -1463.2646484375,
    8032.9609375,
    1,
    1
  },
  {
    228.00259399414,
    114.20302581787,
    1003.21875,
    10,
    16027
  },
  {
    230.97248840332,
    113.86531829834,
    1003.21875,
    10,
    11
  },
  {
    230.97248840332,
    113.86531829834,
    1003.21875,
    10,
    8
  },
  {
    230.97248840332,
    113.86531829834,
    1003.21875,
    10,
    12
  },
  {
    323.4736328125,
    308.6611328125,
    999.1484375,
    5,
    25353
  },
  {
    230.97248840332,
    113.86531829834,
    1003.21875,
    10,
    14077
  }
}
local screenX, screenY = guiGetScreenSize()
local lastExitTick = 0
local shaderSource = " texture sBaseTexture; texture OverlayTexture; float iTime; float noiseLvl = 0.25; float noiseX = 12.9898; float noiseY = 78.2330; sampler Samp = sampler_state { Texture = (sBaseTexture); AddressU = MIRROR; AddressV = MIRROR; }; sampler Overlay = sampler_state { Texture = (OverlayTexture); AddressU = MIRROR; AddressV = MIRROR; }; float crtOverscan = 0.1; float crtBend = 4.8; float zoom = 1; float blur = 0.001; const float3 lumCoeff = float3(0.2125, 0.7154, 0.0721); float2 crt(float2 coord, float z) { coord = (coord - 0.5) * 2.0 / (crtOverscan + z); coord *= 1.1; coord.x *= 1.0 + pow((abs(coord.y) / (crtBend-z)), 2.0); coord.y *= 1.0 + pow((abs(coord.x) / (crtBend-z)), 2.0); coord = (coord / 2.0) + 0.5; return coord; } float rand_1_05(in float2 uv) { float2 noise = (frac(sin(dot(uv, float2(noiseX,noiseY)*2.0)) * 43758.5453)); return abs(noise.x + (noise.y)) * 0.5; } float4 interference(float2 uv, float4 screen) { screen.rgb *= 1+(sin((uv.y+iTime)*15)+1)*0.25; return screen; } float4 interference2(float2 uv, float4 screen) { screen.r *= 1+(cos((uv.x+(iTime/50))*50)+1)*0.05; screen.g *= 1+(cos((uv.x+(iTime/50))*50+50*3)+1)*0.05; screen.b *= 1+(cos((uv.x+(iTime/50))*50+50*6)+1)*0.05; return screen; } bool whiteNoise = false; bool menuOpen = false; float4 PixelShaderFunction(float2 uv : TEXCOORD) : COLOR { float4 outputColor; if(whiteNoise) { float c = rand_1_05(crt(uv, 1)); outputColor = float4(c, c, c, 1); } else { outputColor = tex2D(Samp, crt(uv, zoom)); for (float i = 1; i < 3; i++) { outputColor += tex2D(Samp, crt(float2(uv.x, uv.y + (i * blur)), zoom)); outputColor += tex2D(Samp, crt(float2(uv.x, uv.y - (i * blur)), zoom)); outputColor += tex2D(Samp, crt(float2(uv.x - (i * blur), uv.y), zoom)); outputColor += tex2D(Samp, crt(float2(uv.x + (i * blur), uv.y), zoom)); } outputColor /= 9; } float col = (outputColor.r+outputColor.g+outputColor.b)/3; float4 overlay = tex2D(Overlay, crt(uv, 1)); if(overlay.a > 0.5) { if(menuOpen || whiteNoise) col = overlay.r; else if(col > 0.5) col = 0; else col = 1; } outputColor.rgb = float3(col*0.75, col, col*0.75); outputColor.rgb *= 1+rand_1_05(uv)*noiseLvl; float3 intensity = float(dot(outputColor.rgb, lumCoeff)); outputColor.rgb = lerp(intensity, outputColor.rgb, 0.75 ); outputColor = interference(uv, outputColor); return interference2(uv, outputColor); } technique movie { pass P1 { PixelShader = compile ps_2_a PixelShaderFunction(); } } technique fallback { pass P0 { } } "
local sceneTarget, overlayRT, lookupRT, movieShader
local zoom = 1
local camerasPerCategory = {}
local categories = {}
local catIcons = {}
function loadCatIcons()
  for i = 1, #cameraList do
    local cat = cameraList[i][5]
    catIcons[cat] = seexports.seal_gui:getFaIconFilename(categoryIcons[cat] or "ellipsis-h", 32)
  end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  for i = 1, #cameraList do
    local cat = cameraList[i][5]
    if not camerasPerCategory[cat] then
      camerasPerCategory[cat] = {}
      table.insert(categories, cat)
    end
    table.insert(camerasPerCategory[cat], i)
  end
end)
local currentCategory = false
local currentPerCategory = 1
local lastExit = false
local currentMarker = false
local currentCamera = false
local start = getTickCount() + 1000
local rotationToSync = {}
local lastRotSync = 0
local camSound = {}
local currentMenuItem = 1
local menuScroll = 0
local menuOpen = false
local camState = false
local minPlayer = false
local minVehicle = false
local lastLookup = 0
local lookingUp = false
local lookingUpVehicle = false
local lookingUpVehiclePlate = false
local lookingUpResult
local gotVehicleData = false
local mdcImages = {}
local targetCameraRotation = {}
local processRotation = {}
local cameraElements = {}
local cameras = {}
local streamedCameras = {}
function streamInCamera()
  local id = cameraElements[source]
  for i = #streamedCameras, 1, -1 do
    if streamedCameras[i] == id then
      return
    end
  end
  table.insert(streamedCameras, id)
  if isElement(camSound[id]) then
    destroyElement(camSound[id])
  end
  camSound[id] = nil
  seelangCondHandl0(true)
end
function streamOutCamera()
  local id = cameraElements[source]
  for i = #streamedCameras, 1, -1 do
    if streamedCameras[i] == id then
      table.remove(streamedCameras, i)
    end
  end
  if isElement(camSound[id]) then
    destroyElement(camSound[id])
  end
  camSound[id] = nil
  seelangCondHandl0(0 < #streamedCameras)
end
function modelsLoaded()
  for i = 1, #cameraList do
    local obj = createObject(2921, cameraList[i][1], cameraList[i][2], cameraList[i][3], 0, 0, cameraList[i][4])
    cameras[i] = createObject(2921, cameraList[i][1], cameraList[i][2], cameraList[i][3] - 0.38, cameraRotation[i][1], 0, cameraList[i][4] + cameraRotation[i][2])
    targetCameraRotation[i] = {
      cameraRotation[i][1],
      cameraRotation[i][2],
      cameraRotation[i][3]
    }
    addEventHandler("onClientElementStreamIn", cameras[i], streamInCamera)
    addEventHandler("onClientElementStreamOut", cameras[i], streamOutCamera)
    setElementInterior(obj, cameraList[i][7])
    setElementInterior(cameras[i], cameraList[i][7])
    setElementDimension(obj, cameraList[i][8])
    setElementDimension(cameras[i], cameraList[i][8])
    cameraElements[cameras[i]] = i
  end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
  if 22 <= weapon and weapon <= 38 and cameraElements[hitElement] and not cameraDamaged[cameraElements[hitElement]] then
    cameraDamaged[cameraElements[hitElement]] = 0
    triggerServerEvent("syncCCTVDamage", localPlayer, cameraElements[hitElement])
  end
end)
addEvent("gotVehiclePlateSearchForTraffi", true)
addEventHandler("gotVehiclePlateSearchForTraffi", getRootElement(), function(veh, valid, warrant, warrantPlate)
  --iprint(veh, lookingUpVehicle)
  if veh == lookingUpVehicle then
    local mdcCol = false
    if tonumber(valid) then
      valid = valid .. " érvénytelen bejegyzés"
      mdcCol = "yellow"
    elseif valid then
      valid = "érvényes"
    else
      valid = "lejárt"
      mdcCol = "red"
    end
    if warrant or warrantPlate then
      warrant = "igen"
      mdcCol = "red"
    else
      warrant = "nem"
    end
    gotVehicleData = "Műszaki: " .. valid .. ", Körözött: " .. warrant
    local id = tonumber(getElementData(veh, "vehicle.dbID"))
    if id then
      local text = getVehiclePlateText(veh)
      text = split(text, "-")
      seexports.seal_mdc:addLastPlate(id, table.concat(text, "-"), mdcCol)
    end
  end
end)
function requestVehicle(veh)
  lookingUpVehicle = veh
  local plate = getVehiclePlateText(lookingUpVehicle)
  lookingUpVehiclePlate = table.concat(split(plate, "-"), "-")
  local id = tonumber(getElementData(veh, "vehicle.dbID"))
  if id then
    gotVehicleData = "Lekérdezés folyamatban..."
    triggerLatentServerEvent("requestVehiclePlateSearch", localPlayer, veh, true)
  else
    gotVehicleData = "Műszaki: érvényes, Körözött: nem"
  end
end
function enterCamMode(id)
  if not currentCamera and getTickCount() - lastExitTick > 5000 then
    currentMarker = id
    if isElement(sceneTarget) then
      destroyElement(sceneTarget)
    end
    if isElement(overlayRT) then
      destroyElement(overlayRT)
    end
    if isElement(lookupRT) then
      destroyElement(lookupRT)
    end
    if isElement(movieShader) then
      destroyElement(movieShader)
    end
    sceneTarget = dxCreateScreenSource(screenX, screenY)
    dxUpdateScreenSource(sceneTarget, true)
    overlayRT = dxCreateRenderTarget(screenX, screenY, true)
    lookupRT = dxCreateRenderTarget(math.ceil(screenY * 0.1) * 4, math.ceil(screenY * 0.1) * 2)
    movieShader = dxCreateShader(shaderSource)
    dxSetShaderValue(movieShader, "sBaseTexture", sceneTarget)
    dxSetShaderValue(movieShader, "OverlayTexture", overlayRT)
    if not currentCategory then
      currentCategory = categories[1]
      currentPerCategory = 1
      cctvHandleHit(currentCategory)
    end
    currentCamera = camerasPerCategory[currentCategory][currentPerCategory]
    dxSetShaderValue(movieShader, "whiteNoise", cameraDamaged[currentCamera] and true or false)
    triggerServerEvent("changeCurrentCCTV", localPlayer, currentCamera)
    triggerEvent("changeCurrentCCTV", localPlayer, currentCamera and cameraList[currentCamera][5] or false)
    triggerServerEvent("syncCameraDimension", localPlayer, id, true)
    setElementInterior(localPlayer, cameraList[currentCamera][7])
    setElementDimension(localPlayer, cameraList[currentCamera][8])
    setElementFrozen(localPlayer, true)
    showCursor(true)
    seexports.seal_gui:setCursorType("none")
    menuOpen = false
    zoom = cameraRotation[currentCamera][3]
    dxSetShaderValue(movieShader, "zoom", zoom)
    start = getTickCount() + 100
    addEventHandler("onClientPreRender", getRootElement(), preRenderCurrentCamera, true, "high+1")
    addEventHandler("onClientRender", getRootElement(), renderCCTVShader, true, "low-99999999")
    addEventHandler("onClientKey", getRootElement(), cctvKey, true, "high+99999999")
    addEventHandler("onClientPlayerSpawn", localPlayer, deleteCamera)
    showChat(false)
    seexports.seal_hud:hideHUD()
    minPlayer = false
    minVehicle = false
    lookingUp = false
    lookingUpVehicle = false
    lookingUpVehiclePlate = false
    lookingUpResult = nil
    gotVehicleData = nil
    mdcMode = false
    seexports.seal_gui:showInfobox("i", "Mozgatás: W A S D, Zoom: SHIFT és CTRL, Kategória váltás: E, Kilépés: Backspace")
    seexports.seal_gui:showInfobox("i", "A kamerák közötti léptetéshez használd az F és G gombot.")
    if seexports.seal_groups:isPlayerOfficer(localPlayer) then
      seexports.seal_gui:showInfobox("i", "MDC Mód ki/be: X.")
    end
  end
end
addEvent("syncCCTVDamage", true)
addEventHandler("syncCCTVDamage", getRootElement(), function(i, d)
  if isElement(cameras[i]) then
    cameraDamaged[i] = d and (isElementStreamedIn(cameras[i]) and (cameraDamaged[i] or 0) or 1) or nil
    if isElement(camSound[i]) then
      destroyElement(camSound[i])
    end
    camSound[i] = nil
    if not d then
      for j = 1, 3 do
        cameraRotation[i][j] = targetCameraRotation[i][j]
      end
      setElementRotation(cameras[i], cameraRotation[i][1], 0, cameraList[i][4] + cameraRotation[i][2])
    end
    if i == currentCamera then
      dxSetShaderValue(movieShader, "whiteNoise", cameraDamaged[currentCamera] and true or false)
    end
  end
end)
addEvent("syncCCTVRotation", true)
addEventHandler("syncCCTVRotation", getRootElement(), function(i, r1, r2, z)
  if source ~= localPlayer and targetCameraRotation[i] then
    if r1 then
      targetCameraRotation[i][1] = r1
    end
    if r2 then
      targetCameraRotation[i][2] = r2
    end
    if z then
      targetCameraRotation[i][3] = z
    end
    if isElementStreamedIn(cameras[i]) then
      processRotation[i] = true
      if not isElement(camSound[i]) then
        camSound[i] = playSound3D("files/cam.mp3", cameraList[i][1], cameraList[i][2], cameraList[i][3], true)
        setSoundVolume(camSound[i], 0.75)
      end
    else
      if isElement(camSound[i]) then
        destroyElement(camSound[i])
      end
      camSound[i] = nil
      cameraRotation[i][1] = targetCameraRotation[i][1]
      cameraRotation[i][2] = targetCameraRotation[i][2]
      cameraRotation[i][3] = targetCameraRotation[i][3]
      setElementRotation(cameras[i], cameraRotation[i][1], 0, cameraList[i][4] + cameraRotation[i][2])
    end
  end
end)
local rotating = false
local selfCamSound = false
local cx, cy, cz, tx, ty, tz = 0, 0, 0, 0, 0, 1
function preRenderCurrentCamera(delta)
  rotating = false
  if not menuOpen and not cameraDamaged[currentCamera] then
    if getKeyState("a") then
      if cameraRotation[currentCamera][2] < 90 then
        cameraRotation[currentCamera][2] = cameraRotation[currentCamera][2] + 20 * delta / 1000
        if cameraRotation[currentCamera][2] > 90 then
          cameraRotation[currentCamera][2] = 90
        end
        targetCameraRotation[currentCamera][2] = cameraRotation[currentCamera][2]
        rotating = true
        rotationToSync[2] = true
        setElementRotation(cameras[currentCamera], cameraRotation[currentCamera][1], 0, cameraList[currentCamera][4] + cameraRotation[currentCamera][2])
      end
    elseif getKeyState("d") and cameraRotation[currentCamera][2] > -90 then
      cameraRotation[currentCamera][2] = cameraRotation[currentCamera][2] - 20 * delta / 1000
      if cameraRotation[currentCamera][2] < -90 then
        cameraRotation[currentCamera][2] = -90
      end
      targetCameraRotation[currentCamera][2] = cameraRotation[currentCamera][2]
      rotating = true
      rotationToSync[2] = true
      setElementRotation(cameras[currentCamera], cameraRotation[currentCamera][1], 0, cameraList[currentCamera][4] + cameraRotation[currentCamera][2])
    end
    if getKeyState("s") then
      if cameraRotation[currentCamera][1] < 60 then
        cameraRotation[currentCamera][1] = cameraRotation[currentCamera][1] + 20 * delta / 1000
        if cameraRotation[currentCamera][1] > 60 then
          cameraRotation[currentCamera][1] = 60
        end
        targetCameraRotation[currentCamera][1] = cameraRotation[currentCamera][1]
        rotating = true
        rotationToSync[1] = true
        setElementRotation(cameras[currentCamera], cameraRotation[currentCamera][1], 0, cameraList[currentCamera][4] + cameraRotation[currentCamera][2])
      end
    elseif getKeyState("w") and cameraRotation[currentCamera][1] > 0 then
      cameraRotation[currentCamera][1] = cameraRotation[currentCamera][1] - 20 * delta / 1000
      if cameraRotation[currentCamera][1] < 0 then
        cameraRotation[currentCamera][1] = 0
      end
      targetCameraRotation[currentCamera][1] = cameraRotation[currentCamera][1]
      rotating = true
      rotationToSync[1] = true
      setElementRotation(cameras[currentCamera], cameraRotation[currentCamera][1], 0, cameraList[currentCamera][4] + cameraRotation[currentCamera][2])
    end
    if getKeyState("lshift") then
      if zoom < 3 then
        zoom = zoom + 1 * delta / 1000
        if 3 < zoom then
          zoom = 3
        end
        dxSetShaderValue(movieShader, "zoom", zoom)
        cameraRotation[currentCamera][3] = zoom
        targetCameraRotation[currentCamera][3] = cameraRotation[currentCamera][3]
        rotating = true
        rotationToSync[3] = true
      end
    elseif getKeyState("lctrl") and 1 < zoom then
      zoom = zoom - 1 * delta / 1000
      if zoom < 1 then
        zoom = 1
      end
      dxSetShaderValue(movieShader, "zoom", zoom)
      cameraRotation[currentCamera][3] = zoom
      targetCameraRotation[currentCamera][3] = cameraRotation[currentCamera][3]
      rotating = true
      rotationToSync[3] = true
    end
  end
  if rotationToSync[1] or rotationToSync[2] or rotationToSync[3] then
    lastRotSync = lastRotSync - delta
    if lastRotSync < 0 then
      lastRotSync = 1000
      triggerServerEvent("syncCCTVRotation", localPlayer, currentCamera, rotationToSync[1] and cameraRotation[currentCamera][1], rotationToSync[2] and cameraRotation[currentCamera][2], rotationToSync[3] and cameraRotation[currentCamera][3])
      rotationToSync[1] = false
      rotationToSync[2] = false
      rotationToSync[3] = false
    end
  end
  local m = getElementMatrix(cameras[currentCamera])
  if m then
    cx, cy, cz = m[4][1] - m[2][1] * 0.45, m[4][2] - m[2][2] * 0.45, m[4][3] - m[2][3] * 0.45
    tx, ty, tz = cx - m[2][1], cy - m[2][2], cz - m[2][3]
  else
    cx, cy, cz = getElementPosition(cameras[currentCamera])
    tx, ty, tz = cx, cy, cz - 1
  end
  setCameraMatrix(cx, cy, cz, tx, ty, tz)
  if rotating then
    if not isElement(selfCamSound) then
      selfCamSound = playSound("files/cam.mp3", true)
    end
  else
    if isElement(selfCamSound) then
      destroyElement(selfCamSound)
    end
    selfCamSound = nil
  end
end
function preRenderStreamed(delta)
  local blink = getTickCount() % 1000 > 500
  for k = 1, #streamedCameras do
    local i = streamedCameras[k]
    local onScreen = isElementOnScreen(cameras[i]) or i == currentCamera
    if onScreen then
      local m = getElementMatrix(cameras[i])
      if m then
        if blink and i ~= currentCamera and not cameraDamaged[i] then
          local zx, zy, zz = m[3][1], m[3][2], m[3][3]
          local fx, fy, fz = m[2][1], m[2][2], m[2][3]
          local lx, ly, lz = m[1][1], m[1][2], m[1][3]
          local x, y, z = m[4][1] - fx * 0.255 + lx * 0.075 - zx * 0.05, m[4][2] - fy * 0.255 + ly * 0.075 - zy * 0.05, m[4][3] - fz * 0.255 + lz * 0.075 - zz * 0.05
          seelangStaticImageUsed[0] = true
          if seelangStaticImageToc[0] then
            processSeelangStaticImage[0]()
          end
          dxDrawMaterialLine3D(x - zx * 0.015, y - zy * 0.015, z - zz * 0.015, x + zx * 0.015, y + zy * 0.015, z + zz * 0.015, seelangStaticImage[0], 0.03, tocolor(255, 0, 0), false, x + fx, y + fy, z + fz)
        end
        if cameraDamaged[i] and 1 > cameraDamaged[i] then
          local t = (1 - cameraRotation[i][1] / 90) * 1.25
          cameraDamaged[i] = cameraDamaged[i] + 1 / t * delta / 1000
          if 1 < cameraDamaged[i] then
            cameraDamaged[i] = 1
          end
          fxAddSparks(m[4][1], m[4][2], m[4][3], 0, 0, -1)
          setElementRotation(cameras[i], cameraRotation[i][1] + (90 - cameraRotation[i][1]) * getEasingValue(cameraDamaged[i], "OutBounce"), 0, cameraList[i][4] + cameraRotation[i][2])
        end
      end
    elseif cameraDamaged[i] and 1 > cameraDamaged[i] then
      local t = (1 - cameraRotation[i][1] / 90) * 1.25
      cameraDamaged[i] = cameraDamaged[i] + 1 / t * delta / 1000
      if 1 < cameraDamaged[i] then
        cameraDamaged[i] = 1
      end
      setElementRotation(cameras[i], cameraRotation[i][1] + (90 - cameraRotation[i][1]) * cameraDamaged[i], 0, cameraList[i][4] + cameraRotation[i][2])
    end
    if not cameraDamaged[i] then
      if not rotating and processRotation[i] then
        local rot = false
        if cameraRotation[i][1] > targetCameraRotation[i][1] then
          cameraRotation[i][1] = cameraRotation[i][1] - 15 * delta / 1000
          if cameraRotation[i][1] < targetCameraRotation[i][1] then
            cameraRotation[i][1] = targetCameraRotation[i][1]
          end
          rot = true
        elseif cameraRotation[i][1] < targetCameraRotation[i][1] then
          cameraRotation[i][1] = cameraRotation[i][1] + 15 * delta / 1000
          if cameraRotation[i][1] > targetCameraRotation[i][1] then
            cameraRotation[i][1] = targetCameraRotation[i][1]
          end
          rot = true
        end
        if cameraRotation[i][2] > targetCameraRotation[i][2] then
          cameraRotation[i][2] = cameraRotation[i][2] - 15 * delta / 1000
          if cameraRotation[i][2] < targetCameraRotation[i][2] then
            cameraRotation[i][2] = targetCameraRotation[i][2]
          end
          rot = true
        elseif cameraRotation[i][2] < targetCameraRotation[i][2] then
          cameraRotation[i][2] = cameraRotation[i][2] + 15 * delta / 1000
          if cameraRotation[i][2] > targetCameraRotation[i][2] then
            cameraRotation[i][2] = targetCameraRotation[i][2]
          end
          rot = true
        end
        if cameraRotation[i][3] > targetCameraRotation[i][3] then
          cameraRotation[i][3] = cameraRotation[i][3] - 0.75 * delta / 1000
          if cameraRotation[i][3] < targetCameraRotation[i][3] then
            cameraRotation[i][3] = targetCameraRotation[i][3]
          end
          rot = true
          if i == currentCamera then
            zoom = cameraRotation[i][3]
            dxSetShaderValue(movieShader, "zoom", zoom)
          end
        elseif cameraRotation[i][3] < targetCameraRotation[i][3] then
          cameraRotation[i][3] = cameraRotation[i][3] + 0.75 * delta / 1000
          if cameraRotation[i][3] > targetCameraRotation[i][3] then
            cameraRotation[i][3] = targetCameraRotation[i][3]
          end
          rot = true
          if i == currentCamera then
            zoom = cameraRotation[i][3]
            dxSetShaderValue(movieShader, "zoom", zoom)
          end
        end
        if rot then
          setElementRotation(cameras[i], cameraRotation[i][1], 0, cameraList[i][4] + cameraRotation[i][2])
        else
          processRotation[i] = nil
          if camSound[i] then
            if isElement(camSound[i]) then
              destroyElement(camSound[i])
            end
            camSound[i] = nil
          end
        end
      elseif camSound[i] then
        if isElement(camSound[i]) then
          destroyElement(camSound[i])
        end
        camSound[i] = nil
      end
    elseif camSound[i] then
      if isElement(camSound[i]) then
        destroyElement(camSound[i])
      end
      camSound[i] = nil
    end
  end
  rotating = false
end
addEvent("gotMDCPlayerQuery", true)
addEventHandler("gotMDCPlayerQuery", getRootElement(), function(data, image1, image2, image3)
  if data then
    for i = 1, #mdcImages do
      if isElement(mdcImages[i]) then
        destroyElement(mdcImages[i])
      end
    end
    mdcImages = {}
    if image1 then
      mdcImages[1] = dxCreateTexture(image1)
    end
    if image2 then
      mdcImages[2] = dxCreateTexture(image2)
    end
    if image3 then
      mdcImages[3] = dxCreateTexture(image3)
    end
    lookingUpResult = data
  else
    lookingUpResult = false
  end
end)
local damagedPerCategory = {}
function cctvKey(key, state)
  if state then
    local now = getTickCount()
    if menuOpen then
      if (key == "e" or key == "enter") and 250 < now - start then
        menuOpen = false
        if categories[currentMenuItem] then
          cctvHandleLeave(currentCategory)
          currentCategory = categories[currentMenuItem]
          currentPerCategory = 1
          cctvHandleHit(currentCategory)
          currentCamera = camerasPerCategory[currentCategory][currentPerCategory]
          dxSetShaderValue(movieShader, "whiteNoise", cameraDamaged[currentCamera] and true or false)
          triggerServerEvent("changeCurrentCCTV", localPlayer, currentCamera)
          triggerEvent("changeCurrentCCTV", localPlayer, currentCamera and cameraList[currentCamera][5] or false)
          triggerServerEvent("syncCameraDimension", localPlayer, currentCamera)
          setElementInterior(localPlayer, cameraList[currentCamera][7])
          setElementDimension(localPlayer, cameraList[currentCamera][8])
          zoom = cameraRotation[currentCamera][3]
          dxSetShaderValue(movieShader, "zoom", zoom)
          start = now
        end
      elseif key == "w" or key == "arrow_u" then
        if 1 < currentMenuItem then
          currentMenuItem = currentMenuItem - 1
          if currentMenuItem - menuScroll < 1 then
            menuScroll = menuScroll - (currentMenuItem - menuScroll + 1)
          end
        end
      elseif key == "s" or key == "arrow_d" then
        if currentMenuItem < #categories then
          currentMenuItem = currentMenuItem + 1
          if 15 < currentMenuItem - menuScroll then
            menuScroll = menuScroll + (currentMenuItem - menuScroll - 15)
          end
        end
      elseif key == "backspace" then
        menuOpen = false
      end
    elseif (key == "f" or key == "arrow_l") and 250 < now - start and 1 < #camerasPerCategory[currentCategory] then
      if 1 < currentPerCategory then
        currentPerCategory = currentPerCategory - 1
      else
        currentPerCategory = #camerasPerCategory[currentCategory]
      end
      currentCamera = camerasPerCategory[currentCategory][currentPerCategory]
      dxSetShaderValue(movieShader, "whiteNoise", cameraDamaged[currentCamera] and true or false)
      triggerServerEvent("changeCurrentCCTV", localPlayer, currentCamera)
      triggerEvent("changeCurrentCCTV", localPlayer, currentCamera and cameraList[currentCamera][5] or false)
      triggerServerEvent("syncCameraDimension", localPlayer, currentCamera)
      setElementInterior(localPlayer, cameraList[currentCamera][7])
      setElementDimension(localPlayer, cameraList[currentCamera][8])
      zoom = cameraRotation[currentCamera][3]
      dxSetShaderValue(movieShader, "zoom", zoom)
      start = now
    elseif (key == "g" or key == "arrow_r") and 250 < now - start and 1 < #camerasPerCategory[currentCategory] then
      if currentPerCategory < #camerasPerCategory[currentCategory] then
        currentPerCategory = currentPerCategory + 1
      else
        currentPerCategory = 1
      end
      currentCamera = camerasPerCategory[currentCategory][currentPerCategory]
      dxSetShaderValue(movieShader, "whiteNoise", cameraDamaged[currentCamera] and true or false)
      triggerServerEvent("changeCurrentCCTV", localPlayer, currentCamera)
      triggerEvent("changeCurrentCCTV", localPlayer, currentCamera and cameraList[currentCamera][5] or false)
      triggerServerEvent("syncCameraDimension", localPlayer, currentCamera)
      setElementInterior(localPlayer, cameraList[currentCamera][7])
      setElementDimension(localPlayer, cameraList[currentCamera][8])
      zoom = cameraRotation[currentCamera][3]
      dxSetShaderValue(movieShader, "zoom", zoom)
      start = now
    elseif key == "r" and not lookingUp and not lookingUpVehicle and 5000 < now - lastLookup then
      if minVehicle then
        lastLookup = now
        local s = playSound("files/trans.mp3")
        setSoundVolume(s, 2)
        requestVehicle(minVehicle)
      elseif minPlayer then
        lastLookup = now
        local s = playSound("files/trans.mp3")
        setSoundVolume(s, 2)
        lookingUp = getElementData(minPlayer, "char.ID")
        if lookingUp then
          lookingUpResult = nil
          triggerServerEvent("queryMdcPlayerByCharacterID", localPlayer, lookingUp)
        end
      end
    elseif key == "x" then
      if seexports.seal_groups:isPlayerOfficer(localPlayer) then
        mdcMode = not mdcMode
      end
    elseif key == "e" then
      damagedPerCategory = {}
      for i = 1, #cameraList do
        if cameraDamaged[i] then
          damagedPerCategory[cameraList[i][5]] = (damagedPerCategory[cameraList[i][5]] or 0) + 1
        end
      end
      menuOpen = true
    elseif key == "backspace" then
      if lookingUpVehicle then
        if 5000 < now - lastLookup then
          lookingUpVehicle = false
        end
      elseif lookingUp then
        if lookingUpResult ~= nil and 5000 < now - lastLookup then
          for i = 1, #mdcImages do
            if isElement(mdcImages[i]) then
              destroyElement(mdcImages[i])
            end
          end
          mdcImages = {}
          lookingUp = false
        end
      else
        deleteCamera()
      end
    end
  end
  cancelEvent()
end
addEvent("changeCurrentCCTV", true)
function deleteCamera()
  lastExitTick = getTickCount()
  seexports.seal_controls:toggleAllControls(true)
  cctvHandleLeave(currentCategory)
  currentCamera = false
  lastExit = currentMarker
  triggerServerEvent("changeCurrentCCTV", localPlayer, currentCamera)
  triggerEvent("changeCurrentCCTV", localPlayer, currentCamera and cameraList[currentCamera][5] or false)
  showCursor(false)
  seexports.seal_gui:setCursorType("normal")
  setElementFrozen(localPlayer, false)
  triggerServerEvent("syncCameraDimension", localPlayer)
  setElementInterior(localPlayer, markerPoses[currentMarker][4])
  setElementDimension(localPlayer, markerPoses[currentMarker][5])
  if isElement(sceneTarget) then
    destroyElement(sceneTarget)
  end
  sceneTarget = nil
  if isElement(overlayRT) then
    destroyElement(overlayRT)
  end
  overlayRT = nil
  if isElement(lookupRT) then
    destroyElement(lookupRT)
  end
  lookupRT = nil
  if isElement(movieShader) then
    destroyElement(movieShader)
  end
  movieShader = nil
  removeEventHandler("onClientPreRender", getRootElement(), preRenderCurrentCamera, true, "high+1")
  removeEventHandler("onClientRender", getRootElement(), renderCCTVShader, true, "low-99999999")
  removeEventHandler("onClientKey", getRootElement(), cctvKey, true, "high+99999999")
  removeEventHandler("onClientPlayerSpawn", localPlayer, deleteCamera)
  setCameraTarget(localPlayer)
  showChat(true)
  seexports.seal_hud:showHUD()
end
function renderCCTVShader()
  local now = getTickCount()
  local time = getRealTime()
  dxSetRenderTarget(overlayRT, true)
  dxSetBlendMode("modulate_add")
  minPlayer = false
  minVehicle = false
  if menuOpen then
    dxSetShaderValue(movieShader, "menuOpen", true)
    local y = math.floor(screenY * 0.25)
    local w = screenX * 0.35
    local h = (screenY - y * 2) / 15
    dxDrawRectangle(screenX / 2 - w / 2, y, w, h * 15, tocolor(0, 0, 0))
    local sh = h * 15 / (math.max(#categories - 15, 0) + 1)
    dxDrawRectangle(screenX / 2 + w / 2 - 6, y + sh * menuScroll, 6, sh, tocolor(255, 255, 255))
    for i = 1, 15 do
      local cat = categories[i + menuScroll]
      if cat then
        local c = 255
        if i + menuScroll == currentMenuItem then
          dxDrawRectangle(screenX / 2 - w / 2, y, w - 6, h, tocolor(255, 255, 255))
          c = 0
        end
        dxDrawImage(screenX / 2 - w / 2 + 4, y + 4, h - 8, h - 8, ":seal_gui/" .. catIcons[cat] .. faTicks[catIcons[cat]], 0, 0, 0, tocolor(c, c, c))
        dxDrawText(cat, screenX / 2 - w / 2 + h, y, 0, y + h, tocolor(c, c, c), fontScale * 1.5, font, "left", "center")
        if damagedPerCategory[cat] then
          dxDrawText(damagedPerCategory[cat] .. " OFFLINE", 0, y, screenX / 2 + w / 2 - 6 - 4, y + h, tocolor(c, c, c), fontScale * 1.5, font, "right", "center")
        end
      end
      y = y + h
    end
    dxDrawText("Navigálás: W és S, Kiválasztás: E, Kilépés: Backspace", 0, y + 8, screenX, 0, tocolor(255, 255, 255), fontScale * 2.25, font, "center", "top")
  elseif lookingUpVehicle then
    dxSetShaderValue(movieShader, "menuOpen", true)
    local s2 = math.ceil(screenY * 0.1)
    dxDrawRectangle(screenX / 2 - s2 * 2 - 4, screenY / 2 - s2 - 4, s2 * 4 + 8, s2 * 2 + s2 / 5 * 2 + 8, tocolor(0, 0, 0))
    dxDrawImageSection(screenX / 2 - s2 * 2, screenY / 2 - s2, s2 * 4, s2 * 2, 0, 0, s2 * 4, s2 * 2, lookupRT)
    if gotVehicleData then
      dxDrawText("Rendszám: " .. lookingUpVehiclePlate, 0, screenY / 2 + s2, screenX, screenY / 2 + s2 + s2 / 5 + 8, tocolor(255, 255, 255), fontScale * 1.5, font, "center", "center")
      dxDrawText(5000 < now - lastLookup and gotVehicleData or "Lekérdezés folyamatban...", 0, screenY / 2 + s2 + s2 / 5, screenX, screenY / 2 + s2 + s2 / 5 * 2 + 8, tocolor(255, 255, 255), fontScale * 1.25, font, "center", "center")
    else
      dxDrawText("Rendszám: " .. lookingUpVehiclePlate, 0, screenY / 2 + s2, screenX, screenY / 2 + s2 + s2 / 5 * 2 + 8, tocolor(255, 255, 255), fontScale * 1.5, font, "center", "center")
    end
    dxDrawText("Kilépés: Backspace", 2, 0, screenX + 2, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "center", "bottom")
    dxDrawText("Kilépés: Backspace", 0, 0, screenX, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "center", "bottom")
    dxDrawText(currentCategory .. " " .. currentPerCategory .. "/" .. #camerasPerCategory[currentCategory], 0, 0, screenX * 0.9 + 2, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "right", "bottom")
    dxDrawText(currentCategory .. " " .. currentPerCategory .. "/" .. #camerasPerCategory[currentCategory], 0, 0, screenX * 0.9, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "right", "bottom")
    dxDrawText(string.format("%04d. %02d. %02d. %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second), screenX * 0.1 + 2, 0, 0, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "left", "bottom")
    dxDrawText(string.format("%04d. %02d. %02d. %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second), screenX * 0.1, 0, 0, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "left", "bottom")
  elseif lookingUp then
    dxSetShaderValue(movieShader, "menuOpen", true)
    local s2 = math.ceil(screenY * 0.1)
    local s3 = s2 * 2 / 5
    local w = s2 * 2 + 24 + s3 * 3 * 3 + 4
    dxDrawRectangle(screenX / 2 - w / 2 - 4, screenY / 2 - s2 - 4, w + 8, s2 * 2 + 8, tocolor(0, 0, 0))
    local x, y = screenX / 2 - w / 2, screenY / 2 - s2
    dxDrawImageSection(x, y, s2 * 2, s2 * 2, 0, 0, s2 * 2, s2 * 2, lookupRT)
    x = x + s2 * 2 + 12
    if lookingUpResult == nil or now - lastLookup < 5000 then
      dxDrawText("Lekérdezés folyamatban...", x, y, 0, y + s3, tocolor(255, 255, 255), fontScale * 1.75, font, "left", "center")
    else
      if lookingUpResult then
        dxDrawText(lookingUpResult.name, x, y, 0, y + s3, tocolor(255, 255, 255), fontScale * 1.75, font, "left", "center")
        local weaponText = "nincs"
        if lookingUpResult.licenses.wp then
          if lookingUpResult.licenses.wp[5] then
            weaponText = "bevont"
          elseif lookingUpResult.licenses.wp[4] then
            weaponText = "lejárt"
          end
        end
        dxDrawText("Körözések: " .. lookingUpResult.warrants .. ", Fegy. eng.: " .. weaponText, x, y + s3 * 4, 0, y + s3 * 5, tocolor(255, 255, 255), fontScale * 1.5, font, "left", "center")
        for i = 1, #mdcImages do
          if mdcImages[i] then
            dxDrawImage(x, y + s3, s3 * 3, s3 * 3, mdcImages[i])
            dxDrawRectangle(x, y + s3 * 4 - s3 / 2, s3 * 3, s3 / 2, tocolor(0, 0, 0))
            dxDrawText(lookingUpResult.imageId[i], x, y + s3 * 4 - s3 / 2, x + s3 * 3, y + s3 * 4, tocolor(255, 255, 255), fontScale * 1, font, "center", "center")
            x = x + s3 * 3 + 4
          end
        end
      else
        dxDrawText("Nincs találat!", x, y, 0, y + s3, tocolor(255, 255, 255), fontScale * 1.75, font, "left", "center")
      end
      dxDrawText("Kilépés: Backspace", 2, 0, screenX + 2, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "center", "bottom")
      dxDrawText("Kilépés: Backspace", 0, 0, screenX, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "center", "bottom")
    end
    dxDrawText(currentCategory .. " " .. currentPerCategory .. "/" .. #camerasPerCategory[currentCategory], 0, 0, screenX * 0.9 + 2, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "right", "bottom")
    dxDrawText(currentCategory .. " " .. currentPerCategory .. "/" .. #camerasPerCategory[currentCategory], 0, 0, screenX * 0.9, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "right", "bottom")
    dxDrawText(string.format("%04d. %02d. %02d. %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second), screenX * 0.1 + 2, 0, 0, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "left", "bottom")
    dxDrawText(string.format("%04d. %02d. %02d. %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second), screenX * 0.1, 0, 0, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "left", "bottom")
  else
    if mdcMode and not cameraDamaged[currentCamera] then
      local players = getElementsByType("player", getRootElement(), true)
      local minD = screenY * 0.075
      dxDrawText("O", screenX / 2, screenY / 2, screenX / 2, screenY / 2, tocolor(255, 255, 255), fontScale * 2.25, font, "center", "center")
      for i = 1, #players do
        if isElementOnScreen(players[i]) and not isPedInVehicle(players[i]) then
          local wx, wy, wz = getPedBonePosition(players[i], 8)
          if isLineOfSightClear(wx, wy, wz, cx, cy, cz, true, true, true, true, true, true, false, players[i]) then
            local x, y = getScreenFromWorldPosition(wx, wy, wz, 16)
            if x then
              x = x - screenX / 2
              y = y - screenY / 2
              local d = math.sqrt(x * x + y * y)
              if minD > d then
                local rx, ry, rz = getElementRotation(players[i])
                local rot = rz - (cameraList[currentCamera][4] + cameraRotation[currentCamera][2])
                rot = (rot + 180) % 360 - 180
                local rot2 = math.deg(math.atan2(cy - wy, cx - wx)) - (cameraList[currentCamera][4] + cameraRotation[currentCamera][2]) - 90
                rot2 = (rot2 + 180) % 360 - 180
                if 90 > math.abs(rot + rot2) then
                  minD = d
                  minPlayer = players[i]
                end
              end
            end
          end
        end
      end
      if not minPlayer then
        local x2, y2, z2 = cx + (tx - cx) * 500, cy + (ty - cy) * 500, cz + (tz - cz) * 500
        local hit, hx, hy, hz, he = processLineOfSight(cx, cy, cz, x2, y2, z2, true, true, true, false, false, true, false)
        if isElement(he) and getElementType(he) == "vehicle" then
          minVehicle = he
        end
      end
    end
    if minVehicle then
      local vm = getElementMatrix(minVehicle)
      local minx, miny, minz, maxx, maxy, maxz = getElementBoundingBox(minVehicle)
      local x1, y1 = getScreenFromWorldPosition(vm[4][1] + vm[1][1] * minx + vm[2][1] * miny, vm[4][2] + vm[1][2] * minx + vm[2][2] * miny, vm[4][3] + vm[1][3] * minx + vm[2][3] * miny, 16)
      local x2, y2 = getScreenFromWorldPosition(vm[4][1] + vm[1][1] * minx + vm[2][1] * maxy, vm[4][2] + vm[1][2] * minx + vm[2][2] * maxy, vm[4][3] + vm[1][3] * minx + vm[2][3] * maxy, 16)
      local x3, y3 = getScreenFromWorldPosition(vm[4][1] + vm[1][1] * maxx + vm[2][1] * miny, vm[4][2] + vm[1][2] * maxx + vm[2][2] * miny, vm[4][3] + vm[1][3] * maxx + vm[2][3] * miny, 16)
      local x4, y4 = getScreenFromWorldPosition(vm[4][1] + vm[1][1] * maxx + vm[2][1] * maxy, vm[4][2] + vm[1][2] * maxx + vm[2][2] * maxy, vm[4][3] + vm[1][3] * maxx + vm[2][3] * maxy, 16)
      if x1 and x2 and x3 and x4 then
        dxSetShaderValue(movieShader, "menuOpen", true)
        local minx = math.min(x1, x2, x3, x4)
        local miny = math.min(y1, y2, y3, y4)
        local maxx = math.max(x1, x2, x3, x4)
        local maxy = math.max(y1, y2, y3, y4)
        local cx, cy = (minx + maxx) / 2, (miny + maxy) / 2
        local sx = (maxx - minx) / 2
        local sy = (maxy - miny) / 2
        if sx > sy then
          sy = sx / 2
        else
          sx = sy * 2
        end
        local s2 = math.ceil(screenY * 0.1)
        dxDrawRectangle(screenX / 2 - s2 * 2 - 4, screenY / 2 - s2 - 4, s2 * 4 + 8, s2 * 2 + s2 / 5 + 8, tocolor(0, 0, 0))
        dxSetRenderTarget(lookupRT)
        dxDrawImageSection(0, 0, s2 * 4, s2 * 2, cx - sx, cy - sy, sx * 2, sy * 2, sceneTarget)
        dxSetRenderTarget(overlayRT)
        dxDrawImageSection(screenX / 2 - s2 * 2, screenY / 2 - s2, s2 * 4, s2 * 2, 0, 0, s2 * 4, s2 * 2, lookupRT)
        local plate = getVehiclePlateText(minVehicle)
        plate = table.concat(split(plate, "-"), "-")
        dxDrawText("Rendszám: " .. plate, 0, screenY / 2 + s2, screenX, screenY / 2 + s2 + s2 / 5 + 8, tocolor(255, 255, 255), fontScale * 1.5, font, "center", "center")
      else
        dxSetShaderValue(movieShader, "menuOpen", false)
        dxDrawText("O", screenX / 2, screenY / 2, screenX / 2, screenY / 2, tocolor(255, 255, 255), fontScale * 2.25, font, "center", "center")
        minVehicle = false
      end
      dxDrawText(currentCategory .. " " .. currentPerCategory .. "/" .. #camerasPerCategory[currentCategory], 0, 0, screenX * 0.9 + 2, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "right", "bottom")
      dxDrawText(currentCategory .. " " .. currentPerCategory .. "/" .. #camerasPerCategory[currentCategory], 0, 0, screenX * 0.9, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "right", "bottom")
      if minVehicle then
        dxDrawText("Lekérdezés: R", 2, 0, screenX + 2, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "center", "bottom")
        dxDrawText("Lekérdezés: R", 0, 0, screenX, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "center", "bottom")
      end
      dxDrawText(string.format("%04d. %02d. %02d. %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second), screenX * 0.1 + 2, 0, 0, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "left", "bottom")
      dxDrawText(string.format("%04d. %02d. %02d. %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second), screenX * 0.1, 0, 0, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "left", "bottom")
    elseif minPlayer then
      local x, y, z = getWorldFromScreenPosition(screenX / 2, screenY / 2, 1)
      local x2, y2, z2 = getWorldFromScreenPosition(screenX, screenY / 2, 1)
      local vx, vy, vz = x2 - x, y2 - y, z2 - z
      local len = math.sqrt(vx * vx + vy * vy + vz * vz)
      vx = vx / len
      vy = vy / len
      vz = vz / len
      local x, y, z = getPedBonePosition(minPlayer, 8)
      local sx, sy = getScreenFromWorldPosition(x + vx * 0.2, y + vy * 0.2, z + vz * 0.2, 16)
      local x, y = getScreenFromWorldPosition(x, y, z, 16)
      if x and sx then
        dxSetShaderValue(movieShader, "menuOpen", true)
        local rx = screenX / 2
        local ry = screenY / 2
        local s2 = math.ceil(screenY * 0.1)
        local s = getDistanceBetweenPoints2D(x, y, sx, sy)
        dxDrawRectangle(rx - s2 - 4, ry - s2 - 4, s2 * 2 + 8, s2 * 2 + 8, tocolor(0, 0, 0))
        dxSetRenderTarget(lookupRT)
        dxDrawImageSection(0, 0, s2 * 2, s2 * 2, x - s, y - s, s * 2, s * 2, sceneTarget)
        dxSetRenderTarget(overlayRT)
        dxDrawImageSection(rx - s2, ry - s2, s2 * 2, s2 * 2, 0, 0, s2 * 2, s2 * 2, lookupRT)
      else
        dxSetShaderValue(movieShader, "menuOpen", false)
        dxDrawText("O", screenX / 2, screenY / 2, screenX / 2, screenY / 2, tocolor(255, 255, 255), fontScale * 2.25, font, "center", "center")
        minPlayer = false
      end
      dxDrawText(currentCategory .. " " .. currentPerCategory .. "/" .. #camerasPerCategory[currentCategory], 0, 0, screenX * 0.9 + 2, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "right", "bottom")
      dxDrawText(currentCategory .. " " .. currentPerCategory .. "/" .. #camerasPerCategory[currentCategory], 0, 0, screenX * 0.9, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "right", "bottom")
      if minPlayer then
        dxDrawText("Arcfelismerés: R", 2, 0, screenX + 2, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "center", "bottom")
        dxDrawText("Arcfelismerés: R", 0, 0, screenX, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "center", "bottom")
      end
      dxDrawText(string.format("%04d. %02d. %02d. %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second), screenX * 0.1 + 2, 0, 0, screenY * 0.9 + 2, tocolor(0, 0, 0), fontScale * 2.25, font, "left", "bottom")
      dxDrawText(string.format("%04d. %02d. %02d. %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second), screenX * 0.1, 0, 0, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "left", "bottom")
    else
      dxSetShaderValue(movieShader, "menuOpen", false)
      dxDrawText(currentCategory .. " " .. currentPerCategory .. "/" .. #camerasPerCategory[currentCategory], 0, 0, screenX * 0.9, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "right", "bottom")
      dxDrawText(string.format("%04d. %02d. %02d. %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second), screenX * 0.1, 0, 0, screenY * 0.9, tocolor(255, 255, 255), fontScale * 2.25, font, "left", "bottom")
    end
  end
  dxSetBlendMode("blend")
  dxSetRenderTarget()
  dxUpdateScreenSource(sceneTarget, false)
  dxSetShaderValue(movieShader, "noiseX", math.random(119898, 139898) / 10000)
  dxSetShaderValue(movieShader, "noiseY", math.random(772330, 792330) / 10000)
  dxSetShaderValue(movieShader, "iTime", now / 2000)
  local p = (now - start) / 250
  if 0 < p then
    if p < 1 then
      dxDrawRectangle(0, 0, screenX, screenY, tocolor(25, 25, 25))
      local sx = screenX * 0.97 * (0.5 + p * 0.5)
      local sy = screenY * 0.97 * p
      dxDrawImage(screenX / 2 - sx / 2, screenY / 2 - sy / 2, sx, sy, movieShader)
      p2 = p * 3 - 2
      if 0 > p2 then
        p2 = 0
      end
      seelangStaticImageUsed[1] = true
      if seelangStaticImageToc[1] then
        processSeelangStaticImage[1]()
      end
      dxDrawImage(screenX / 2 - sx / 2, screenY / 2 - sy / 2, sx, sy, seelangStaticImage[1], 0, 0, 0, tocolor(25, 25, 25, 255 * (1 - p2)))
    else
      dxDrawImage(screenX * 0.015, screenY * 0.015, screenX * 0.97, screenY * 0.97, movieShader)
    end
  else
    dxDrawRectangle(0, 0, screenX, screenY, tocolor(25, 25, 25))
  end
  seelangStaticImageUsed[2] = true
  if seelangStaticImageToc[2] then
    processSeelangStaticImage[2]()
  end
  dxDrawImage(0, 0, screenX, screenY, seelangStaticImage[2])
  seelangStaticImageUsed[2] = true
  if seelangStaticImageToc[2] then
    processSeelangStaticImage[2]()
  end
end
addEvent("changeEnteredCustomMarker", false)
addEventHandler("changeEnteredCustomMarker", getRootElement(), function(theType, id)
  if theType == "cctv" and not currentCamera then
    if lastExit == id then
      lastExit = false
      return
    end
    lastExit = false
    enterCamMode(id)
  end
end)
local markers = {}
function createCCTVMarkers()
  for i = 1, #markerPoses do
    markers[i] = seexports.seal_markers:createCustomMarker(markerPoses[i][1], markerPoses[i][2], markerPoses[i][3], markerPoses[i][4], markerPoses[i][5], "v4yellow", "cctv")
    seexports.seal_markers:setCustomMarkerInterior(markers[i], "cctv", i, 1)
  end
end
addEventHandler("onClientResourceStop", getResourceRootElement(), function()
  for k = 1, #markers do
    if markers[k] then
      seexports.seal_markers:deleteCustomMarker(markers[k])
    end
    markers[k] = nil
  end
end)
local syncZones = {}
local syncCols = {}
addEvent("onLocalPlayerCCTVColShapeHit", false)
addEvent("onLocalPlayerCCTVColShapeLeave", false)
function cctvNormalHit(he, md)
  if he == localPlayer and md then
    triggerEvent("onLocalPlayerCCTVColShapeHit", source)
  end
end
function cctvNormalLeave(he, md)
  if he == localPlayer then
    triggerEvent("onLocalPlayerCCTVColShapeLeave", source)
  end
end
function cctvHandleHit(name)
  if syncZones[name] then
    for i = 1, #syncZones[name] do
      triggerEvent("onLocalPlayerCCTVColShapeHit", syncZones[name][i])
    end
  end
end
function cctvHandleLeave(name)
  if syncZones[name] then
    for i = 1, #syncZones[name] do
      triggerEvent("onLocalPlayerCCTVColShapeLeave", syncZones[name][i])
    end
  end
end
local iewcs = isElementWithinColShape
function isPlayerWithinColShape(col)
  if isElementWithinColShape(localPlayer, col) then
    return true
  end
  local name = syncCols[col]
  if name and currentCamera then
    return currentCategory == name
  end
end
function registerSyncZone(name, col)
  if not syncZones[name] then
    syncZones[name] = {}
  end
  if not syncCols[col] then
    addEventHandler("onClientColShapeHit", col, cctvNormalHit)
    addEventHandler("onClientColShapeLeave", col, cctvNormalLeave)
  end
  if syncCols[col] ~= name then
    local old = syncCols[col]
    if old then
      for i = #syncZones[old], 1, -1 do
        if syncZones[old][i] == col then
          table.remove(syncZones[old], i)
        end
      end
      if #syncZones[old] <= 0 then
        syncZones[old] = nil
      end
    end
    table.insert(syncZones[name], col)
  end
  syncCols[col] = name
end
addEventHandler("onClientElementDestroy", getRootElement(), function()
  local name = syncCols[source]
  if name and syncZones[name] then
    for i = #syncZones[name], 1, -1 do
      table.remove(syncZones[name], i)
    end
    if #syncZones[name] <= 0 then
      syncZones[name] = nil
    end
  end
  syncCols[source] = nil
end)
addEvent("requestCCTVSyncZonesClient", false)
addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  setTimer(triggerEvent, 10, 1, "requestCCTVSyncZonesClient", getRootElement())
end, true, "low-9999999")
