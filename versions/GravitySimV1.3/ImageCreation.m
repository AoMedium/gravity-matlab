[gravityObjects, systemCentre] = GetSystem("sol_alpha");

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

tic
[img, imgArray] = CreateImage(200,200,gravityObjects,200,1500);
toc

image(img)


axis equal
userInput = input('Save image as a file? ','s');
if strcmpi(userInput,'yes')
    fileName = input('Enter file name: ','s');
    %imwrite(img, [fileName '.png']);
    MakeAnimatedGif(imgArray,[fileName '.gif']);
end



function [img, imgArray] = CreateImage(width, height, gravityObjects, iterations, scale)
    minDim = min(width,height);

    img = zeros(height,width, 3);
    imgArray = cell(1,iterations);
    
    for step = 1:iterations
        newImg = zeros(height,width, 3);
        for i = 1:length(gravityObjects)
            for j = 1:length(gravityObjects)
                if i ~= j
                    %disp(gravityObjects(i).id + " test with " + gravityObjects(j).id);
                    gravityObjects(i) = gravityObjects(i).ReceiveAttraction(gravityObjects(j)); % no need to pass obj as well
                end
            end
        end
        for i = 1:length(gravityObjects)
            gravityObjects(i) = gravityObjects(i).UpdateLight();
            
            [x,y] = gravityObjects(i).GetPosition(gravityObjects(i));
            
            pixelX = round(x/scale * minDim + width/2);
            pixelY = round(y/scale * minDim + height/2);
            
            if pixelX >= 0 && pixelX <= width && pixelY >= 0 && pixelY <= height
                img(pixelY,pixelX,:) = 255 * gravityObjects(i).colour;
                newImg(pixelY,pixelX,:) = 255 * gravityObjects(i).colour;
            end
        end
        scale = scale * 1.01;
        imgArray{1,step} = uint8(newImg);
    end
end