-- configuration
local encryptionKey = "a3bDHdmhrpEELPLycN7f4PWYkw3UuAmsXhF0xo7fr1fLRl2pwI"

-- actual code
local function notify(title, text)
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = title,
		Text = text
	})
end

local playergui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
if playergui:FindFirstChild("chatEncryptionGUI") ~= nil then
	playergui:FindFirstChild("chatEncryptionGUI"):Destroy()
end

local G2L = {};

-- StarterGui.chatEncryptionGUI
G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
G2L["1"]["Name"] = [[chatEncryptionGUI]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

-- StarterGui.chatEncryptionGUI.Frame
G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2"]["Size"] = UDim2.new(0, 164, 0, 144);
G2L["2"]["Position"] = UDim2.new(0, 0, 0.74032, 0);
G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);

-- StarterGui.chatEncryptionGUI.Frame.encryptButton
G2L["3"] = Instance.new("TextButton", G2L["2"]);
G2L["3"]["TextWrapped"] = true;
G2L["3"]["BorderSizePixel"] = 0;
G2L["3"]["TextSize"] = 14;
G2L["3"]["TextScaled"] = true;
G2L["3"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["3"]["BackgroundColor3"] = Color3.fromRGB(172, 255, 0);
G2L["3"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["3"]["Size"] = UDim2.new(0, 164, 0, 50);
G2L["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["3"]["Text"] = [[encrypt]];
G2L["3"]["Name"] = [[encryptButton]];
G2L["3"]["Position"] = UDim2.new(0, 0, 0.64931, 0);

-- StarterGui.chatEncryptionGUI.Frame.TextBox
G2L["4"] = Instance.new("TextBox", G2L["2"]);
G2L["4"]["BorderSizePixel"] = 0;
G2L["4"]["TextWrapped"] = true;
G2L["4"]["TextSize"] = 14;
G2L["4"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["4"]["TextScaled"] = true;
G2L["4"]["BackgroundColor3"] = Color3.fromRGB(0, 172, 255);
G2L["4"]["FontFace"] = Font.new([[rbxasset://fonts/families/FredokaOne.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["4"]["ClearTextOnFocus"] = false;
G2L["4"]["PlaceholderText"] = [[your text here..]];
G2L["4"]["Size"] = UDim2.new(0, 164, 0, 50);
G2L["4"]["Position"] = UDim2.new(0, 0, 0.29861, 0);
G2L["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["4"]["Text"] = [[]];

-- StarterGui.chatEncryptionGUI.Frame.title
G2L["5"] = Instance.new("TextLabel", G2L["2"]);
G2L["5"]["TextWrapped"] = true;
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["TextSize"] = 14;
G2L["5"]["TextScaled"] = true;
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["5"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["Size"] = UDim2.new(0, 164, 0, 35);
G2L["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["Text"] = [[encrypt gui]];
G2L["5"]["Name"] = [[title]];

-- StarterGui.chatEncryptionGUI.Frame.UIDragDetector
G2L["6"] = Instance.new("UIDragDetector", G2L["2"]);
G2L["6"]["MinDragTranslation"] = UDim2.new(0.05, 0, 0.05, 0);

local function buildKeyArray(keyStr)
	local key = {}
	for i = #keyStr, 1, -1 do
		table.insert(key, string.sub(keyStr, i, i))
	end
	return key
end

local numToSymbol = {["0"]="!", ["1"]="@", ["2"]="#", ["3"]="$", ["4"]="%", ["5"]="^", ["6"]="&", ["7"]="*", ["8"]="(", ["9"]=")"}
local symbolToNum = {}
for n,s in pairs(numToSymbol) do symbolToNum[s] = n end

local function encrypt(plaintext, key)
	local output = {}
	for i = 1, #plaintext do
		local c = string.sub(plaintext, i, i)
		local k = key[(i-1) % #key + 1]
		local character = utf8.char(string.byte(c) + string.byte(k))
		table.insert(output, character)
	end
	local out = table.concat(output)
	local b64 = crypt.base64encode(out)
	return b64:gsub("%d", function(d) return numToSymbol[d] end)
end

local function decrypt(ciphertext, key)
	local ok, result = pcall(function()
		-- restore symbols to digits first (reverse the post-base64 substitution)
		local restored = ciphertext:gsub(".", function(c)
			return symbolToNum[c] or c
		end)

		-- now base64 decode
		local decoded = crypt.base64decode(restored)

		-- XOR decrypt
		local output = {}
		local i = 0
		for _, codepoint in utf8.codes(decoded) do
			i = i + 1
			local k = key[(i - 1) % #key + 1]
			local newCodepoint = codepoint - string.byte(k)
			if newCodepoint <= 0 then
				return nil
			end
			table.insert(output, utf8.char(newCodepoint))
		end
		return table.concat(output)
	end)
	if not ok then return nil end
	return result
end

local frm = G2L["2"]
local text = ""
frm.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
	text = frm.TextBox.Text
end)

frm.encryptButton.Activated:Connect(function()
	if #text > 0 then
		local cipher = encrypt(text, buildKeyArray(encryptionKey))
		if cipher == nil then
			notify("uhhhh.", "could not encrypt")
			return
		end
		setclipboard(cipher)
		frm.encryptButton.Text = "copied to clipboard"
		task.wait(0.75)
		frm.encryptButton.Text = "encrypt"
	end
end)

local key = buildKeyArray(encryptionKey)

game:GetService("TextChatService").MessageReceived:Connect(function(msg)
	local dec = decrypt(msg.Text, key)
	if dec == nil then
		return
	else
		print(msg.TextSource.Name, ":", dec)
	end
end)

return G2L["1"], require;
