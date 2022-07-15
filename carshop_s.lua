
function setVehicleHeadlightColorServerEventFunc(thehlvehicle,vehhlr,vehhlg,vehhlb)
	setVehicleHeadLightColor(thehlvehicle,vehhlr,vehhlg,vehhlb)
end
addEvent("setVehicleHeadlightColorServerEvent",true)
addEventHandler("setVehicleHeadlightColorServerEvent",resourceRoot,setVehicleHeadlightColorServerEventFunc)

function setVehicleColorServerEventFunc(thevehicle,vehr,vehg,vehb,vehr2,vehg2,vehb2,vehr3,vehg3,vehb3)
	setVehicleColor(thevehicle,vehr,vehg,vehb,vehr2,vehg2,vehb2,vehr3,vehg3,vehb3)
end
addEvent("setVehicleColorServerEvent",true)
addEventHandler("setVehicleColorServerEvent",resourceRoot,setVehicleColorServerEventFunc)
