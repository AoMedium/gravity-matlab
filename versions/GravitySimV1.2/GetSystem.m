function [systemObjects, systemCentre] = GetSystem(systemName)

    switch systemName
        case "sol_alpha"
            
            systemCentre = "Sol";
            
            unitMass = 1;
            AU = 300;

            
            Sol = GravityObject("Sol",unitMass * 333000);
            Sol.pos = [0,0];
            Sol.colour = [1,1,0];

            Kas = GravityObject("Kas",unitMass * 0.055);
            Kas.orbitRadius = AU * 0.387;
            Kas.colour = [0.67,0.67,0.67];

            Ayca = GravityObject("Ayca",unitMass * 0.815);
            Ayca.orbitRadius = AU * 0.723;
            Ayca.colour = [1,0.62,0];

            Earth = GravityObject("Earth",unitMass);
            Earth.orbitRadius = AU;
            Earth.colour = [0,0.75,1];

            Muna = GravityObject("Muna", unitMass * 0.012);
            Muna.orbitCentre = "Earth";
            Muna.orbitRadius = AU * 0.002569;

            Jaen = GravityObject("Jaen",unitMass * 0.110);
            Jaen.orbitRadius = AU * 1.524;
            Jaen.colour = [0.8,0.27,0];

            Muerin = GravityObject("Muerin",unitMass * 317.8);
            Muerin.orbitRadius = AU * 5.203;
            Muerin.colour = [1,0.8,0];

            Leio = GravityObject("Leio",1);
            Leio.orbitCentre = "Muerin";
            Leio.orbitRadius = 10;
            
            Iomus = GravityObject("Iomus",unitMass * 95.2);
            Iomus.orbitRadius = AU * 9.529;
            %Iomus.colour = [1,0.8,0];

            Sera = GravityObject("Sera",1);
            Sera.pos = [AU * 5.5,0];
            Sera.vel = [0,5];
            
            systemObjects = [Sol, Kas, Ayca, Earth, Muna, Jaen, Muerin, Leio, Sera];
        case "sol_beta"
    end

    return
end