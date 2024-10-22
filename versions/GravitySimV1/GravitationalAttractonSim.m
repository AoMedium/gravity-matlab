%Gravitational Attraction Simulator

clear
clf

AU = 300;

Sol = GravityObject("Sol",[0,0]);
Sol.mass = 100000;
Sol.colour = [1,1,0];

Kas = GravityObject("Kas",[AU * 0.387,0]);
%Kas.orbitRadius = AU * 0.387;
Kas.mass = 1;
Kas.dy = sqrt(Sol.mass / (AU * 0.387));
Kas.colour = [0.5,0.5,0.5];

Earth = GravityObject("Earth",[AU,10]);
Earth.mass = 1;
Earth.dy = sqrt(Sol.mass / AU);
Earth.colour = [0,0,1];

Jaen = GravityObject("Jaen",[AU * -1.524,0]);
Jaen.mass = 0.001;
Jaen.dy = -sqrt(Sol.mass / (AU * 1.524));
Jaen.colour = [0.6,0,0];

gravityObjects = [Sol, Kas, Jaen];

%Hypothesis for why 3+ object system does not work:
%   Based on existence of object, not distance or dxdy calc
%   More objects increase inaccuracy

disp(gravityObjects(2));
input("[Enter] Begin Simulation");
PlotObjects(gravityObjects);

step = 1;%input("Input number of steps");
while 1
    loopCondition = input("Step Next Gen?");
    if loopCondition ~= 0
        break
    end
    
    for count = 1:step
        gravityObjects = TimeStep(gravityObjects);
    end
    PlotObjects(gravityObjects);
end

function gravityObjects = TimeStep(gravityObjects)
    for i = 1:length(gravityObjects)
        for j = 1:length(gravityObjects)
            if i ~= j
                %disp(gravityObjects(i).id + " test with " + gravityObjects(j).id);
                gravityObjects(i) = gravityObjects(i).Update(gravityObjects(j)); % no need to pass obj as well
                if gravityObjects(i).id == "Kas"
                    disp(gravityObjects(i).dx + ", " + gravityObjects(i).dy);
                end
            end
        end
    end
end

function [] = PlotObjects(gravityObjects)
    clf
    for i = 1:length(gravityObjects)
        obj = gravityObjects(i);
        [x, y] = obj.GetPosition(obj);
        hold on
        plot(x, y, "o", "MarkerSize", 5, "MarkerFaceColor", obj.colour, "MarkerEdgeColor", [0,0,0]);
        obj.DrawPositions();
        text(x, y, "  " + obj.id);% + " : " + obj.mass + "µ");
    end
    axis([-500 500 -500 500])
    hold off
end
