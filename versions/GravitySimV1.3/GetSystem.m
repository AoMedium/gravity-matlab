function [systemObjects, systemCentre] = GetSystem(systemName)

    switch systemName
        case "sol_alpha"
            
            systemCentre = "Sol";
            
            unitMass = 1;
            AU = 300;

            
            Sol = GravityObject("Sol",unitMass * 333000);
            Sol.pos = [0,0];
            Sol.colour = [1,1,0];
            Sol.isFixed = true;

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
            Iomus.colour = [1,0.984,0.687];
            
            Hera = GravityObject("Hera",unitMass * 14.6);
            Hera.orbitRadius = AU * 19.19;
            Hera.colour = [0,1,0.85];
            
            Mei = GravityObject("Mei",unitMass * 17.2);
            Mei.orbitRadius = AU * 30.06;
            Mei.colour = [0.02,0,1];

            Veida = GravityObject("Veida",10);
            Veida.pos = [AU * 5.5,0];
            Veida.vel = [0,5];
            
            Sera = GravityObject("Sera",10);
            Sera.pos = [0,AU * 20];
            Sera.vel = [1,0];
            
            systemObjects = [Sol, Kas, Ayca, Earth, Jaen, Muerin, Iomus, Hera, Mei, Veida, Sera];
        case "sol_beta"
        case "test"
            systemCentre = "Star";
            
            Star = GravityObject("Star", 10000);
            Star.pos = [0,0];
            Star.colour = [0,0.2,1];
            
            Planet1 = GravityObject("Planet1", 10000);
            Planet1.orbitRadius = 100;
            Planet1.colour = [0.5,0,1];
            
            Planet2 = GravityObject("Planet2", 10000);
            Planet2.orbitRadius = 200;
            Planet2.colour = [1,0,0.8];
            
            systemObjects = [Star, Planet1, Planet2];
    end

    return
end