classdef GravityObject
    properties
        id;
        mass;
        x = 0;
        y = 0;
        nextX = 0;
        nextY = 0;
        dx = 0;
        dy = 0;
        a = 0;
        
        orbitRadius = 0;
        
        positionsX = [];
        positionsY = [];
        
        colour = [0,0,0];
        isFixed = 0;
    end
    
    methods
        function thisObj = GravityObject(id, posArray)
            thisObj.id = id;
            thisObj.x = posArray(1);
            thisObj.y = posArray(2);
        end
        
        function thisObj = Update(thisObj)
            thisObj.x = thisObj.x + thisObj.dx;
            thisObj.y = thisObj.y + thisObj.dy;
            
            thisObj = thisObj.AddPosition();
        end
        
        function thisObj = ReceiveAttraction(thisObj, otherObj) %must return obj after modifying
%             disp(thisObj.id + " comp " + otherObj.id);
%             disp(otherObj.mass);
            
            if thisObj.isFixed == 1
                return
            end
            
            distanceX = otherObj.x - thisObj.x;
            distanceY = otherObj.y - thisObj.y;
            distance = sqrt(distanceX^2 + distanceY^2);
            
            thisObj.a = 10 * otherObj.mass / distance^2;
            
            %--, +-, ++, -+
            
            %            xConst = 1;
            %            yConst = 1;
            %
            %            if distanceX < 0 && distanceY < 0 %1st quadrant case
            %                 xConst = -1;
            %                 yConst = -1;
            %            elseif distanceX > 0 && distanceY < 0 %2nd quadrant case
            %                 yConst = -1;
            %            elseif distanceX < 0 && distanceY > 0 %4th quadrant case
            %                 xConst = -1;
            %            end
            %
            %            absX = abs(distanceX);
            %            absY = abs(distanceY);
            %
            %            vecX = absX / (absX + absY) * xConst;
            %            vecY = absY / (absX + absY) * yConst;
            
            
            
            
            [vecX, vecY] = thisObj.CalculateComponents(distanceX, distanceY);
            
            
            
            thisObj.dx = thisObj.dx + thisObj.a * vecX;
            thisObj.dy = thisObj.dy + thisObj.a * vecY;
            
%             if thisObj.id == "Kas"
%                 disp(thisObj.id + " receives " + thisObj.a + " ms^-2 from " + otherObj.id);
%                 disp(thisObj.id + " v is now " + sqrt(thisObj.dx^2 + thisObj.dy^2));
%                 disp(thisObj.id + " pos is now " + thisObj.x + ", " + thisObj.y);
%             end
        end
        
        function thisObj = AddPosition(thisObj)
            if length(thisObj.positionsX) >= 2
                
%                 if thisObj.hasExceededDistance(thisObj.x, thisObj.positionsX(end), thisObj.y, thisObj.positionsY(end)) == 1
%                     return
%                 end
                if abs(thisObj.x - thisObj.positionsX(end)) < 50 && abs(thisObj.y - thisObj.positionsY(end)) < 50
                    return
                end
            end
            
            if length(thisObj.positionsX) >= 50
               thisObj.positionsX = thisObj.positionsX(2:end);
               thisObj.positionsY = thisObj.positionsY(2:end);
            end
            thisObj.positionsX = [thisObj.positionsX, thisObj.x];
            thisObj.positionsY = [thisObj.positionsY, thisObj.y];
        end
        function [] = DrawPositions(thisObj)
            plot([thisObj.positionsX, thisObj.x], [thisObj.positionsY, thisObj.y], "Color", thisObj.colour); %draw line to current pos for continuity
        end
    end
    methods (Static)
        function isTrue = hasExceededDistance(pos1X, pos1Y, pos2X, pos2Y)
            thresholdDistance = 20;
            if abs(pos1X - pos2X) < thresholdDistance && abs(pos1Y - pos2Y) < thresholdDistance
                isTrue = 0;
            else
                isTrue = 1;
            end
        end
        
        function [vecX, vecY] = CalculateComponents(distanceX, distanceY)
            if distanceX == 0
                distanceX = distanceX + 0.0001;
                theta = pi / 2;
            else
                theta = abs(atan(distanceY / distanceX));
            end
            if distanceY == 0
                distanceY = distanceY + 0.001;
            end
            
            vecX = cos(theta) * distanceX / abs(distanceX);
            vecY = sin(theta) * distanceY / abs(distanceY);
        end
        
        function [x, y] = GetPosition(thisObj) %must pass obj to access x and y
            x = thisObj.x;
            y = thisObj.y;
        end
    end
end