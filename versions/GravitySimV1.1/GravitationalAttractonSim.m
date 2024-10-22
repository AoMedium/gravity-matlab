%Gravitational Attraction Simulator

clear
clf

scale = 2000;
origin = [0,0];

unitMass = 0.1;
AU = 300;

Sol = GravityObject("Sol",[0,0]);
Sol.mass = unitMass * 333000;
Sol.colour = [1,1,0];

Kas = GravityObject("Kas",[AU * 0.387,0]);
%Kas.orbitRadius = AU * 0.387;
Kas.mass = unitMass * 0.055;
Kas.dy = CalculateTangentialV(AU * 0.387, Sol.mass);
Kas.colour = [0.67,0.67,0.67];

Ayca = GravityObject("Ayca",[AU * 0.723,10]);
Ayca.mass = unitMass * 0.815;
Ayca.dy = CalculateTangentialV(AU * 0.723, Sol.mass);
Ayca.colour = [1,0.62,0];

Earth = GravityObject("Earth",[AU,10]);
Earth.mass = unitMass;
Earth.dy = CalculateTangentialV(AU, Sol.mass);
Earth.colour = [0,0.75,1];

Muna = GravityObject("Muna",[AU+0.01,0]);
Muna.mass = unitMass * 0.011;
Muna.dx = Earth.dx;
Muna.dy = CalculateTangentialV(0.01, Earth.mass) + Earth.dx;
Muna.colour = [0.5,0.5,0.5];

Jaen = GravityObject("Jaen",[AU * 1.524,0]);
Jaen.mass = unitMass * 0.110;
Jaen.dy = CalculateTangentialV(AU * 1.524, Sol.mass);
Jaen.colour = [0.8,0.27,0];

Muerin = GravityObject("Muerin",[AU * 5.203,0]);
Muerin.mass = unitMass * 317.8;
Muerin.dy = CalculateTangentialV(AU * 5.203, Sol.mass);
Muerin.colour = [1,0.8,0];

Sera = GravityObject("Sera",[AU * 5.5,0]);
Sera.mass = 200;
Sera.dy = 5;

gravityObjects = [Sol, Kas, Ayca, Earth, Jaen, Muerin, Sera];

%Hypothesis for why 3+ object system does not work:
%   Based on existence of object, not distance or dxdy calc
%   More objects increase inaccuracy
%Solution: was adding dx and dy every iteration rather than at the end of
%   all iterations

input("[Enter] Begin Simulation");
PlotObjects(gravityObjects, origin, scale);

step = 10;%input("Input number of steps");
generationCount = 0;

while 1
    disp(newline + "Simulation Details:");
    disp("- Generation: " + generationCount);
    disp("- Objects: " + length(gravityObjects));
    cmdInput = input(">> Next: ", "s"); %"s" for string data type

    if cmdInput == "scale"
        disp("[~] Current scale: " + scale);
        scale = input("[?] Input scale: ");
    elseif cmdInput == "step"
        disp("[~] Current step: " + step);
        step = input("[?] Input step: ");
    elseif cmdInput == "spawn"
        newObjId = input("[?] Input obj id: ", "s");
        newObjX = input("[?] Input obj X: ");
        newObjY = input("[?] Input obj Y: ");
        newObj = GravityObject(newObjId, [newObjX, newObjY]);
        newObj.mass = input("[?] Input obj mass: ");
        
        gravityObjects = [gravityObjects, newObj];
    elseif cmdInput == "origin"
        disp("[~] Current origin: " + origin(1) + ", " + origin(2));
        originX = input("[?] Input origin X: ");
        originY = input("[?] Input origin Y: ");
        origin = [originX, originY];
    else
        disp("[!] Stepped " + step + " increment(s)");
        for count = 1:step
            gravityObjects = TimeStep(gravityObjects);
            generationCount = generationCount + 1;
        end
    end
    PlotObjects(gravityObjects, origin, scale);
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

function [] = PlotObjects(gravityObjects, origin, scale)
    clf
    for i = 1:length(gravityObjects)
        obj = gravityObjects(i);
        [x, y] = obj.GetPosition(obj);
        hold on
        plot(x, y, "o", "MarkerSize", 5, "MarkerFaceColor", obj.colour, "MarkerEdgeColor", [0,0,0]);
        obj.DrawPositions();
        text(x, y, "  " + obj.id);% + " : " + obj.mass + "µ");
    end
    axis([origin(1)-scale, origin(1)+scale, origin(2)-scale origin(2)+scale])
    hold off
end




function ds = CalculateTangentialV(radius, parentMass)
    G = 10;
    ds = sqrt(G * parentMass / radius);
end