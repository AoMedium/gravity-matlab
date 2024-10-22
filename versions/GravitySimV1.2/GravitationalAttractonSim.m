%Gravitational Attraction Simulator

clear
clf


%==== PARA ====

[gravityObjects, systemCentre] = GetSystem("sol_alpha");

targetIndex = 1;
isFollowingTarget = true;
scale = 1000;
origin = [0,0];

predictPath = true;



%==== MAIN ====

input("[Enter] Initialise Objects");
tic;
for i = 1:length(gravityObjects)
    if gravityObjects(i).orbitCentre == "undefined" && gravityObjects(i).orbitRadius ~= 0
        gravityObjects(i).orbitCentre = systemCentre;
    end
    for j = 1:length(gravityObjects)
        if i ~= j && gravityObjects(j).id == gravityObjects(i).orbitCentre && gravityObjects(i).orbitRadius ~= 0
            gravityObjects(i) = gravityObjects(i).CalcOrbitParameters(gravityObjects(j));
        end
    end
    
end
toc;
input("[Enter] Begin Simulation");

step = 1;
generationCount = 0;

while 1
    PlotObjects(gravityObjects, origin, scale, isFollowingTarget, targetIndex, predictPath);
    
    disp(newline + "Simulation Details:");
    disp("- Generation: " + generationCount);
    disp("- Objects: " + length(gravityObjects));
    cmdInput = input(">> Next: ", "s"); %"s" for string data type

    if cmdInput == "set scale"
        disp("[~] Current scale: " + scale);
        scale = input("[?] Input scale: ");
    elseif cmdInput == "set step"
        disp("[~] Current step: " + step);
        step = input("[?] Input step: ");
%     elseif cmdInput == "spawn"
%         newObjId = input("[?] Input obj id: ", "s");
%         newObjX = input("[?] Input obj X: ");
%         newObjY = input("[?] Input obj Y: ");
%         newObj = GravityObject(newObjId, [newObjX, newObjY]);
%         newObj.mass = input("[?] Input obj mass: ");
%         
%         gravityObjects = [gravityObjects, newObj];
    elseif cmdInput == "set origin"
        disp("[~] Current origin: " + origin(1) + ", " + origin(2));
        originX = input("[?] Input origin X: ");
        originY = input("[?] Input origin Y: ");
        origin = [originX, originY];
    elseif cmdInput == "toggle follow"
        isFollowingTarget = ~isFollowingTarget;
        disp("[!] Is following target now " + isFollowingTarget);
    elseif cmdInput == "set target"
        disp("[~] Current target: " + gravityObjects(targetIndex).id);
        targetIndex = input("[?] Input target index: ");
        disp("[!] Following target: " + gravityObjects(targetIndex).id);
    else
        disp("[!] Stepped " + step + " generation(s)");
        tic;
        for count = 1:step
            gravityObjects = TimeStep(gravityObjects);
            generationCount = generationCount + 1;
        end
        toc; %get execution time elapsed
    end
end



function gravityObjects = TimeStep(gravityObjects)
    for i = 1:length(gravityObjects)
        for j = 1:length(gravityObjects)
            if i ~= j
                %disp(gravityObjects(i).id + " test with " + gravityObjects(j).id);
                gravityObjects(i) = gravityObjects(i).ReceiveAttraction(gravityObjects(j)); % no need to pass obj as well
            end
        end
    end
    for i = 1:length(gravityObjects)
        gravityObjects(i) = gravityObjects(i).Update();
    end
end

function [] = PlotObjects(gravityObjects, origin, scale, isFollowingTarget, targetIndex, predictPath)
    clf
    for i = 1:length(gravityObjects)
        obj = gravityObjects(i);
        [x, y] = obj.GetPosition(obj);
        hold on
        plot(x, y, "o", "MarkerSize", 5, "MarkerFaceColor", obj.colour, "MarkerEdgeColor", [0,0,0]);
        obj.DrawPositions();
        text(x, y, "  " + obj.id);% + " : " + obj.mass + "µ");
    end
    if predictPath
        gravityObjects(targetIndex).DrawPredictPath(gravityObjects);
    end
    if isFollowingTarget
        origin = gravityObjects(targetIndex).pos;
    end
    axis([origin(1)-scale, origin(1)+scale, origin(2)-scale origin(2)+scale])
    hold off
end