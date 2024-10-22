classdef GravityObject
    properties (Constant)
        G = 0.1;
    end
    
    properties
        id;
        mass;
        pos = [0,0];
        vel = [0,0];
        a = 0;
        
        orbitCentre = "undefined";
        orbitRadius = 0;
        
        positionsX = [];
        positionsY = [];
        
        colour = [0.5,0.5,0.5];
        isFixed = 0;
    end
    
    methods
        function thisObj = GravityObject(id, mass)
            thisObj.id = id;
            thisObj.mass = mass;
        end
        
        
        
        
        function thisObj = UpdateLight(thisObj)
            thisObj.pos(1) = thisObj.pos(1) + thisObj.vel(1);
            thisObj.pos(2) = thisObj.pos(2) + thisObj.vel(2);
        end
        
        
        function thisObj = Update(thisObj)
            thisObj.pos(1) = thisObj.pos(1) + thisObj.vel(1);
            thisObj.pos(2) = thisObj.pos(2) + thisObj.vel(2);
            
            thisObj = thisObj.AddPosition();
        end
        
        
        function thisObj = CalcOrbitParameters(thisObj, targetObj)
            theta = rand() * 2 * pi;
            x = thisObj.orbitRadius * cos(theta);
            y = thisObj.orbitRadius * sin(theta);
            
            thisObj.pos = targetObj.pos + [x,y];
            
            v = sqrt(thisObj.G * targetObj.mass / thisObj.orbitRadius);
            dx = v * -sin(theta);
            dy = v * cos(theta);
            
            thisObj.vel = targetObj.vel + [dx,dy];
%             disp(thisObj.id);
%             disp(thisObj.pos);
%             disp(targetObj.pos);
        end
        
        
        function thisObj = ReceiveAttraction(thisObj, otherObj) %must return obj after modifying
%             disp(thisObj.id + " comp " + otherObj.id);
%             disp(otherObj.mass);
            
            if thisObj.isFixed == 1
                return
            end
            
            distanceX = otherObj.pos(1) - thisObj.pos(1);
            distanceY = otherObj.pos(2) - thisObj.pos(2);
            distance = sqrt(distanceX^2 + distanceY^2);
            
            thisObj.a = thisObj.G * otherObj.mass / distance^2;
            
            
            k = thisObj.a / distance;
            ax = k * distanceX;
            ay = k * distanceY;
            
            
            
            thisObj.vel(1) = thisObj.vel(1) + ax;
            thisObj.vel(2) = thisObj.vel(2) + ay;
        end
        
        function thisObj = AddPosition(thisObj)
            if length(thisObj.positionsX) >= 2
                
                if ~thisObj.ValidateForNewPos(thisObj.pos,[thisObj.positionsX(end-1),thisObj.positionsY(end-1)],[thisObj.positionsX(end),thisObj.positionsY(end)])
                    return
                end
                
                
%                 if abs(thisObj.pos(1) - thisObj.positionsX(end)) < 50 && abs(thisObj.pos(2) - thisObj.positionsY(end)) < 50
%                     return
%                 end
            end
            
            if length(thisObj.positionsX) >= 50
               thisObj.positionsX = thisObj.positionsX(2:end);
               thisObj.positionsY = thisObj.positionsY(2:end);
            end
            thisObj.positionsX = [thisObj.positionsX, thisObj.pos(1)];
            thisObj.positionsY = [thisObj.positionsY, thisObj.pos(2)];
        end
        
        function [] = DrawPositions(thisObj)
            %plot([thisObj.positionsX, thisObj.pos(1)], [thisObj.positionsY, thisObj.pos(2)], "Color", thisObj.colour); %draw line to current pos for continuity
            plot([thisObj.positionsX, thisObj.pos(1)], [thisObj.positionsY, thisObj.pos(2)],"-o","MarkerSize",2, "Color", thisObj.colour);
        end
        
        function [] = DrawPredictPath(thisObj, gravityObjects)
        end
    end
    methods (Static)
        function isTrue = ValidateForNewPos(pos1, pos2, pos3)
            
            vec1 = [pos2(1) - pos1(1), pos2(2) - pos1(2)];
            vec2 = [pos3(1) - pos2(1), pos3(2) - pos2(2)];
            
            dotResult = abs(dot(vec1,vec2) / (norm(vec1) * norm(vec2)));
            %disp(dotResult + " or " + acosd(dotResult));
            
            if dotResult < cosd(2) %2 degrees angle threshold
                isTrue = 1;
            else
                isTrue = 0;
            end
            
%             thresholdDistance = 20;
%             if abs(pos1X - pos2X) < thresholdDistance && abs(pos1Y - pos2Y) < thresholdDistance
%                 isTrue = 0;
%             else
%                 isTrue = 1;
%             end
        end
        
        function [x, y] = GetPosition(thisObj) %must pass obj to access x and y
            x = thisObj.pos(1);
            y = thisObj.pos(2);
        end
    end
end