local createShader = dxCreateShader

local function decryptText(encodedText, keyByte, halfKeyByte)
  if encodedText and keyByte and halfKeyByte then
    encodedText = base64Decode(encodedText)
    keyByte = utf8.byte(keyByte)
    halfKeyByte = math.floor(utf8.byte(halfKeyByte) / 2)
    local decryptedText = ""
    local textLength = utf8.len(encodedText)
    local counter = 1

    for i = 1, textLength, 1 do
      if counter == halfKeyByte then
        keyByte = utf8.byte(utf8.sub(encodedText, i, i))
        counter = 1
      else
        counter = counter + 1
        decryptedText = decryptedText .. utf8.char(bitXor(utf8.byte(utf8.sub(encodedText, i, i)), keyByte))
      end
    end
    return decryptedText
  end
end

function processText(inputText, shaderParam1, shaderParam2, shaderParam3, shaderParam4)
  local processedText = ""
  local textLength = utf8.len(inputText)
  local temp1, temp2, temp3 = nil, nil, nil
  local combinedText = nil

  for i = 1, textLength, 1 do
    local currentChar = utf8.sub(inputText, i, i)

    if currentChar == "ö" or currentChar == "ü" or currentChar == "ó" or currentChar == "ő" or currentChar == "ú" or currentChar == "é" or currentChar == "á" or currentChar == "ű" or currentChar == "Ö" or currentChar == "Ü" or currentChar == "Ó" or currentChar == "Ő" or currentChar == "Ú" or currentChar == "Á" or currentChar == "Ű" or currentChar == "É" then
      if combinedText then
        processedText = processedText .. decryptText(combinedText, temp1, temp2)
        combinedText = nil
        temp1 = nil
        temp2 = nil
      else
        combinedText = ""
      end
    elseif combinedText then
      if not temp1 then
        temp1 = currentChar
      elseif not temp2 then
        temp2 = currentChar
      else
        combinedText = combinedText .. currentChar
      end
    else
      processedText = processedText .. currentChar
    end
  end
  
  local finalResult = createShader(processedText, shaderParam1, shaderParam2, shaderParam3, shaderParam4)
  processedText = nil
  collectgarbage("collect")
  return finalResult
end
