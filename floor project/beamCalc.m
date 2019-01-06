%Daniel Loza
%Civil 311 Strengths of materials
%Floor Design Project
%Determine the optimum spacing and beams for a floor.
%The goal is to use the least steel.


clear
clc
%this program will find the maximum spacing between beams and calculate the
%steel's weight. 
%calculate allowed stress
stressU = 50000;
FS = 1.67;
stressA = stressU/FS;
%imports the s beam data
%Designation † A, in 2 d, in. b f , in. t f , in. t w , in. I x , in 4 S x , in 3 r x , in. I y , in 4 S y , in 3 r y , in.
%(n,1) height, (n,2) lb/ft, (n,9) S
Sbeam = xlsread('SBeam.xlsx');
beamsTested = size(Sbeam, 1);
%Loads on the floor
LB = 30;
Liveload= 50;
Deadload = 130;
Load = Liveload + Deadload;
ResultA = zeros(beamsTested,5);

%loop to calculate each spacing and weight
for n=1:beamsTested
    ResultA(n,1)=Sbeam(n,1);%beam depth
    ResultA(n,2) = Sbeam(n,2); %beam lb/ft
    %max distance between beams
    ResultA(n,3) = stressA * 8 * 12 * Sbeam(n,9) /( Load * (12*LB)^2);
    %if statements to round to factor of 30 and weight
    if ResultA(n,3) >= 15
        ResultA(n,4) =15;%spacing
        ResultA(n,5) = LB*LB*ResultA(n,2)/15;%weight
    elseif ResultA(n,3) >= 10
        ResultA(n,4) =10;
        ResultA(n,5) = LB*LB*ResultA(n,2)/10;
    elseif ResultA(n,3) >= 6
        ResultA(n,4) =6;
        ResultA(n,5) = LB*LB*ResultA(n,2)/6;
    elseif ResultA(n,3) >= 5
        ResultA(n,4) =5;%spacing
        ResultA(n,5) = LB*LB*ResultA(n,2)/5;%weight
    elseif ResultA(n,3) >= 3
        ResultA(n,4) =3;%spacing
        ResultA(n,5) = LB*LB*ResultA(n,2)/3;%weight
    elseif ResultA(n,3) >= 2
        ResultA(n,4) =2;%spacing
        ResultA(n,5) = LB*LB*ResultA(n,2)/2;%weight
    elseif ResultA(n,3) >= 1
        ResultA(n,4) =1;%spacing
        ResultA(n,5) = LB*LB*ResultA(n,2)/1;%weight
    else %spacing smaller than a foot is useless.
        ResultA(n,4) =NaN;%spacing
        ResultA(n,5) = NaN;%weight
    end
end
%disp(ResultA)
%search data for lowest weight and display result.
low =1;
for n=1:15
    if ResultA(n,5) < ResultA(low,5)
        low=n;
    end
end

%prints out the results.
fprintf('The least steel used is %g lbs\n', ResultA(low,5))
fprintf('S beams used: S%g x %g \n', ResultA(low,1), ResultA(low,2))
fprintf('At a spacing of %g feet.\n', ResultA(low,4))

%the program will now calculate the lightest girder possible
LG = 30;
WG = ResultA(low,5)/LG + Load*LG
%smallest S allowed
SG = (WG/12) * (12*LG)^2 /(stressA * 8)
%import girder properties
Wgirder = xlsread('girder.xlsx');
%counts the girders to be tested
Gcount = size(Wgirder, 1);
lowG =1;%sets the lowest weight as the first girder
for i=1:Gcount
    if SG <= Wgirder(i,9)
        if Wgirder(i, 9) < Wgirder(lowG, 9)
            lowG = i;
        end
    end
end
%displays the lightested girder strong enough
fprintf('Girder used: W%g x %g \n', Wgirder(lowG,1), Wgirder(lowG,2))

    