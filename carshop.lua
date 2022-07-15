
local carShopOpenFromCommand = false

carshopMarkerLocations = {
	{2163.3,2473.4,10.82}, --You can place a marker by typing a coordinate you want.
}

function updateLabelColor()
	r = tonumber(guiGetText(edit1))
	g = tonumber(guiGetText(edit2))
	b = tonumber(guiGetText(edit3))
	
	guiLabelSetColor(lblResult, r,g,b)
end

function colorToPercent(val)
	val = tonumber(val)
	if not val then val = 255 end
	if val < 0 then val = 0 end
	if val > 255 then val =  255 end
	val = (val/255)*100
	return val
end

function percentToColor(per)
	per = tonumber(per)
	if not per then per = 100 end
	if per < 0 then per = 0 end
	if per > 100 then per = 100 end
	per = math.floor(per*255 *.01)
	return per
end

function guiScrolled()
	if scrolled == false then
		scrolled = true
		return
	end
	
	p = guiScrollBarGetScrollPosition(source)
	v = percentToColor(p)
	if source == red then
		guiSetText(edit1, tostring(v))
	elseif source == green then
		guiSetText(edit2, tostring(v))
	elseif source == blue then
		guiSetText(edit3, tostring(v))
	end
end

function guiChanged()
	text = guiGetText(source)
	text = tonumber(text)
	if not text then text = 0 end
	if text < 0 then
		text = 0
		guiSetText(source, text)
	elseif text > 255 then
		text = 255
		guiSetText(source, text)
	end	

	v = colorToPercent(text)
	if source == edit1 then
		scrolled = false	
		guiScrollBarSetScrollPosition(red, v)
	elseif source == edit2 then
		scrolled = false
		guiScrollBarSetScrollPosition(green, v)
	elseif source == edit3 then
		scrolled = false
		guiScrollBarSetScrollPosition(blue, v)
	end

	updateLabelColor()
end

function CarShopGui(state)
	if state == true then -- open gui
		guiGridListSetSelectedItem(carshopGridlist,0,1)
		updateLabelColor()
		showCursor(true,true)
		guiSetVisible(carshopWindow,true)
		guiSetVisible(carshopButton,true)
		guiSetVisible(carshopCloseButton,true)
		guiSetVisible(carshopGridlist,true)
		guiSetVisible(red,true)
		guiSetVisible(green,true)
		guiSetVisible(blue,true)
		guiSetVisible(lbl1,true)
		guiSetVisible(lbl2,true)
		guiSetVisible(lbl3,true)
		guiSetVisible(edit1,true)
		guiSetVisible(edit2,true)
		guiSetVisible(edit3,true)
		guiSetVisible(lblResult,true)
		guiSetVisible(lblResultshadow,true)
	elseif state == false then -- close gui
		showCursor(false,false)
		guiSetVisible(carshopWindow,false)
		guiSetVisible(carshopButton,false)
		guiSetVisible(carshopCloseButton,false)
		guiSetVisible(carshopGridlist,false)
		guiSetVisible(red,false)
		guiSetVisible(green,false)
		guiSetVisible(blue,false)
		guiSetVisible(lbl1,false)
		guiSetVisible(lbl2,false)
		guiSetVisible(lbl3,false)
		guiSetVisible(edit1,false)
		guiSetVisible(edit2,false)
		guiSetVisible(edit3,false)
		guiSetVisible(lblResult,false)
		guiSetVisible(lblResultshadow,false)
	end
end

function carshopClicked ()
	theVehicle = getPedOccupiedVehicle(localPlayer)
	if not isElement(theVehicle) then return end
	hlr,hlg,hlb = getVehicleHeadLightColor(theVehicle)
	r,g,b,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(theVehicle,true)
	carshopType = guiGridListGetItemText(carshopGridlist,guiGridListGetSelectedItem(carshopGridlist),1)
	guiText1 = guiGetText(edit1)
	guiText2 = guiGetText(edit2)
	guiText3 = guiGetText(edit3)
	if source == carshopCloseButton then
		CarShopGui(false)
		carShopOpenFromCommand = false
	elseif source == carshopButton then
		if carshopType == "Headlight Color" then
			triggerServerEvent("setVehicleHeadlightColorServerEvent",resourceRoot,theVehicle,guiText1,guiText2,guiText3)
		elseif carshopType == "Vehicle Color 1" then
			triggerServerEvent("setVehicleColorServerEvent",resourceRoot,theVehicle,guiText1,guiText2,guiText3,r2,g2,b2,r3,g3,b3)
		elseif carshopType == "Vehicle Color 2" then
			triggerServerEvent("setVehicleColorServerEvent",resourceRoot,theVehicle,r,g,b,guiText1,guiText2,guiText3,r3,g3,b3)
		elseif carshopType == "Vehicle Color 3" then
			triggerServerEvent("setVehicleColorServerEvent",resourceRoot,theVehicle,r,g,b,r2,g2,b2,guiText1,guiText2,guiText3)
		end
	elseif source == carshopGridlist then
		if carshopType == "Headlight Color" then
			guiSetText(edit1,hlr)
			guiSetText(edit2,hlg)
			guiSetText(edit3,hlb)
		elseif carshopType == "Vehicle Color 1" then
			guiSetText(edit1,r)
			guiSetText(edit2,g)
			guiSetText(edit3,b)
		elseif carshopType == "Vehicle Color 2" then
			guiSetText(edit1,r2)
			guiSetText(edit2,g2)
			guiSetText(edit3,b2)
		elseif carshopType == "Vehicle Color 3" then
			guiSetText(edit1,r3)
			guiSetText(edit2,g3)
			guiSetText(edit3,b3)
		end
	end
end

function carshopMarkerLeave(hitSource,matchingDimension)
	if carShopOpenFromCommand then return end
	if (hitSource == localPlayer) and isPedInVehicle(localPlayer) and (getPedOccupiedVehicleSeat(localPlayer) == 0) then
		CarShopGui(false)
	end
end
addEventHandler("onClientMarkerLeave",resourceRoot,carshopMarkerLeave)

function carshopMarkerHit(hitSource,matchingDimension)
	if carShopOpenFromCommand then return end
	if (hitSource == localPlayer) and isPedInVehicle(localPlayer) and (getPedOccupiedVehicleSeat(localPlayer) == 0) then
		CarShopGui(true)
	end
end
addEventHandler("onClientMarkerHit",resourceRoot,carshopMarkerHit)

carshopWindow = guiCreateWindow(0.26, 0.22, 0.49, 0.59, "Car Shop", true)
guiWindowSetSizable(carshopWindow, false)
guiSetAlpha(carshopWindow, 1.00)
carshopButton = guiCreateButton(0.52, 0.89, 0.43, 0.08, "Set Color", true, carshopWindow)
guiSetProperty(carshopButton, "AlwaysOnTop", "True")
carshopCloseButton = guiCreateButton(0.95, 0.89, 0.05, 0.08, "X", true, carshopWindow)
guiSetProperty(carshopCloseButton, "AlwaysOnTop", "True")
carshopGridlist = guiCreateGridList(0.02, 0.06, 0.49, 0.92, true, carshopWindow)
guiSetProperty(carshopGridlist, "AlwaysOnTop", "True")
guiGridListAddColumn(carshopGridlist, "Customize", 0.9)

for i = 1, 4 do
	guiGridListAddRow(carshopGridlist)
end

guiGridListSetItemText(carshopGridlist, 0, 1, "Headlight Color", false, false)
guiGridListSetItemText(carshopGridlist, 1, 1, "Vehicle Color 1", false, false)
guiGridListSetItemText(carshopGridlist, 2, 1, "Vehicle Color 2", false, false)
guiGridListSetItemText(carshopGridlist, 3, 1, "Vehicle Color 3", false, false)
r,g,b = 255,255,255
red = guiCreateScrollBar(.515,.157, .41,.0601, true, true, carshopWindow)
green = guiCreateScrollBar(.515,.307, .41,.061, true, true, carshopWindow)
blue = guiCreateScrollBar(.515,.457, .41,.062, true, true, carshopWindow)
guiScrollBarSetScrollPosition(red, colorToPercent(r))
guiScrollBarSetScrollPosition(green, colorToPercent(g))
guiScrollBarSetScrollPosition(blue, colorToPercent(b))
lbl1 = guiCreateLabel(.05,.15, .1,.075, "RED", true, carshopWindow)
lbl2 = guiCreateLabel(.05,.3, .1,.075, "GREEN", true, carshopWindow)
lbl3 = guiCreateLabel(.05,.45, .1,.075, "BLUE", true, carshopWindow)
guiLabelSetVerticalAlign(lbl1, "center")
guiLabelSetVerticalAlign(lbl2, "center")
guiLabelSetVerticalAlign(lbl3, "center")
guiLabelSetColor(lbl1, 255, 0, 0)
guiLabelSetColor(lbl2, 0, 255, 0)
guiLabelSetColor(lbl3, 0, 0, 255)
edit1 = guiCreateEdit(.93,.15, 0.07,.075, tostring(r), true, carshopWindow)
edit2 = guiCreateEdit(.93,.3, 0.07,.075, tostring(g), true, carshopWindow)
edit3 = guiCreateEdit(.93,.45, 0.07,.075, tostring(b), true, carshopWindow)	
guiEditSetMaxLength(edit1, 3)
guiEditSetMaxLength(edit2, 3)
guiEditSetMaxLength(edit3, 3)
lblResult = guiCreateLabel(.625,.720, .45,.2, "COLOR", true, carshopWindow)
guiSetFont(lblResult, "sa-header")
guiLabelSetColor(lblResult, r,g,b)
guiSetProperty(lblResult, "AlwaysOnTop", "True")
lblResultshadow = guiCreateLabel(.626,.721, .45,.2, "COLOR", true, carshopWindow)
guiSetFont(lblResultshadow, "sa-header")
guiLabelSetColor(lblResultshadow, 100,100,100)
guiSetVisible(carshopWindow,false)
guiSetVisible(carshopButton,false)
guiSetVisible(carshopCloseButton,false)
guiSetVisible(carshopGridlist,false)
guiSetVisible(red,false)
guiSetVisible(green,false)
guiSetVisible(blue,false)
guiSetVisible(lbl1,false)
guiSetVisible(lbl2,false)
guiSetVisible(lbl3,false)
guiSetVisible(edit1,false)
guiSetVisible(edit2,false)
guiSetVisible(edit3,false)
guiSetVisible(lblResult,false)
guiSetVisible(lblResultshadow,false)

addEventHandler("onClientGUIClick",carshopButton,carshopClicked)
addEventHandler("onClientGUIClick",carshopCloseButton,carshopClicked)
addEventHandler("onClientGUIClick",carshopGridlist,carshopClicked)
addEventHandler("onClientGUIScroll",carshopWindow,guiScrolled)
addEventHandler("onClientGUIChanged",carshopWindow,guiChanged)

for i = 1,#carshopMarkerLocations do
	x,y,z = carshopMarkerLocations[i][1],carshopMarkerLocations[i][2],carshopMarkerLocations[i][3]
	carshopMarker = createMarker(x,y,z,"cylinder",3,255,255,255,100)
end

function UpdateColorsVehicle(theVehicle,Seat)
	if (Seat == 0) then
		hlr,hlg,hlb = getVehicleHeadLightColor(theVehicle)
		if hlr ~= nil and hlg ~= nil and hlb ~= nil and edit1 ~= nil and edit2 ~= nil and edit3 ~= nil then
			guiSetText(edit1,hlr)
			guiSetText(edit2,hlg)
			guiSetText(edit3,hlb)
		end
	end
end
addEventHandler("onClientPlayerVehicleEnter",localPlayer,UpdateColorsVehicle)

function onWasted(killer, weapon, bodypart)
	CarShopGui(false)
	carShopOpenFromCommand = false
end
addEventHandler("onClientPlayerWasted",localPlayer,onWasted)

function carShopCommand()
	if not getElementData(localPlayer,"VIP") and not getElementData(localPlayer,"ADMIN") then
		outputChatBox("This command only works for vip players!")
		return
	end
	if not (getPedOccupiedVehicleSeat(localPlayer) == 0) then
		outputChatBox("This command only works if you're driving a vehicle!")
		return
	end
	CarShopGui(true)
	carShopOpenFromCommand = true
end
addCommandHandler("carshop",carShopCommand,false) --If you are admin you can check car colors using this code

fileDelete("carshop.lua")
