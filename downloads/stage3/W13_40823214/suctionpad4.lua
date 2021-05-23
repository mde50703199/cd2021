function sysCall_init() 
    modelBase6=sim.getObjectHandle(sim.handle_self)
    robotBase6=modelBase6
    while true do
        robotBase6=sim.getObjectParent(robotBase6)
        if robotBase6==-1 then
            robotName6='Base'
            break
        end
        robotName6=sim.getObjectName(robotBase6)
        suffix,suffixlessName=sim.getNameSuffix(robotName6)
        if suffixlessName=='Base' then
            break
        end
    end
    sa=sim.getObjectHandle('suctionPadSensor#4')
    la=sim.getObjectHandle('suctionPadLoopClosureDummy1#4')
    l2a=sim.getObjectHandle('suctionPadLoopClosureDummy2#4')
    ba=sim.getObjectHandle('suctionPad#4')
    suctionPadLink=sim.getObjectHandle('suctionPadLink#4')
    local gripperBase=sim.getObjectHandle(sim.handle_self)

    infiniteStrength=sim.getScriptSimulationParameter(sim.handle_self,'infiniteStrength')
    maxPullForce=sim.getScriptSimulationParameter(sim.handle_self,'maxPullForce')
    maxShearForce=sim.getScriptSimulationParameter(sim.handle_self,'maxShearForce')
    maxPeelTorque=sim.getScriptSimulationParameter(sim.handle_self,'maxPeelTorque')

    sim.setLinkDummy(la,-1)
    sim.setObjectParent(la,ba,true)
    ma=sim.getObjectMatrix(l2a,-1)
    sim.setObjectMatrix(la,-1,ma)
end


function sysCall_cleanup() 
    sim.setLinkDummy(la,-1)
    sim.setObjectParent(la,ba,true)
    ma=sim.getObjectMatrix(l2a,-1)
    sim.setObjectMatrix(la,-1,ma)
end 

function sysCall_sensing() 
    parent=sim.getObjectParent(la)
    local sig=sim.getIntegerSignal(robotName6 .."call_6")
    if (not sig) or (sig==0) then
        if (parent~=ba) then
            sim.setLinkDummy(la,-1)
            sim.setObjectParent(la,ba,true)
            ma=sim.getObjectMatrix(l2a,-1)
            sim.setObjectMatrix(la,-1,ma)
        end
    else
        if (parent==ba) then
            -- Here we want to detect a respondable shape, and then connect to it with a force sensor (via a loop closure dummy dummy link)
            -- However most respondable shapes are set to "non-detectable", so "sim.readProximitySensor" or similar will not work.
            -- But "sim.checkProximitySensor" or similar will work (they don't check the "detectable" flags), but we have to go through all shape objects!
            index=0
            while true do
                shape=sim.getObjects(index,sim.object_shape_type)
                if (shape==-1) then
                    break
                end
                if (shape~=ba) and (sim.getObjectInt32Parameter(shape,sim.shapeintparam_respondable)~=0) and (sim.checkProximitySensor(sa,shape)==1) then
                    -- Ok, we found a respondable shape that was detected
                    -- We connect to that shape:
                    -- Make sure the two dummies are initially coincident:
                    sim.setObjectParent(la,ba,true)
                    ma=sim.getObjectMatrix(l2a,-1)
                    sim.setObjectMatrix(la,-1,ma)
                    -- Do the connection:
                    sim.setObjectParent(la,shape,true)
                    sim.setLinkDummy(la,l2a)
                    break
                end
                index=index+1
            end
        else
            -- Here we have an object attached
            if (infiniteStrength==false) then
                -- We might have to conditionally beak it apart!
                result,force,torque=sim.readForceSensor(suctionPadLink) -- Here we read the median value out of 5 values (check the force sensor prop. dialog)
                if (result>0) then
                    breakIt=false
                    if (force[3]>maxPullForce) then breakIt=true end
                    sf=math.sqrt(force[1]*force[1]+force[2]*force[2])
                    if (sf>maxShearForce) then breakIt=true end
                    if (torque[1]>maxPeelTorque) then breakIt=true end
                    if (torque[2]>maxPeelTorque) then breakIt=true end
                    if (breakIt) then
                        -- We break the link:
                        sim.setLinkDummy(la,-1)
                        sim.setObjectParent(la,ba,true)
                        ma=sim.getObjectMatrix(l2a,-1)
                        sim.setObjectMatrix(la,-1,ma)
                    end
                    
                end
            end
        end
    end
end 
