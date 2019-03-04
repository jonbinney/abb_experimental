% Total robot mass taken from the IRB1200 datasheet
total_robot_mass = 54.0;

% Per link volume calculate using meshlab.
volume_base_link = 0.012603;
volume_link_1 = 0.010835;
volume_link_2 = 0.016048;
volume_link_3 = 0.006829;
volume_link_4 = 0.002511;
volume_link_5 = 0.000576;
% Link_6 is modeled as a cylinder.
volume_link_6 = pi*0.02^2*0.005;

total_robot_volume = volume_base_link + volume_link_1 + volume_link_2 + volume_link_3 + volume_link_4 + volume_link_5 + volume_link_6;
robot_density = total_robot_mass / total_robot_volume;

mass_base_link = robot_density * volume_base_link;
mass_link_1 = robot_density * volume_link_1;
mass_link_2 = robot_density * volume_link_2;
mass_link_3 = robot_density * volume_link_3;
mass_link_4 = robot_density * volume_link_4;
mass_link_5 = robot_density * volume_link_5;
mass_link_6 = robot_density * volume_link_6;

% Verify that the mass calculation was correct.
robot_mass_check = mass_base_link + mass_link_1  + mass_link_2 + mass_link_3 + mass_link_4 + mass_link_5 + mass_link_6;
if (abs(robot_mass_check - total_robot_mass) > 1e-10)
  printf ("Something is wrong with the per link mass calculatation:\n")
  total_robot_mass
  robot_mass_check
  exit
endif

function inertia = scale_inertia(inertia, mass, volumen, scale)
  inertia = inertia ./ scale^5;
  inertia = (inertia .* mass) ./ volumen;
endfunction


function print_inertial(meshlab_inertia, mass, volume, center_of_mass, scale)
  inertia = scale_inertia(meshlab_inertia, mass, volume, scale);
  printf("      <inertial>\n");
  printf("        <mass value=\"%g\"/>\n", mass);      
  printf("        <origin xyz=\"%g %g %g\"/>\n", center_of_mass(1), center_of_mass(2), center_of_mass(3));      
  printf("        <inertia ixx=\"%g\" ixy=\"%g\" ixz=\"%g\" iyy=\"%g\" iyz=\"%g\" izz=\"%g\"/>\n", inertia(1,1), inertia(1,2), inertia(1,3), inertia(2,2), inertia(2,3), inertia(3,3))
  printf("      </inertial>\n");
endfunction


printf("\n** base_link:\n")
inertia = [9.332476   0.045335   0.028470;
            0.045335  12.781226  -0.022451;
            0.028470  -0.022451  11.934223];
center_of_mass = [-0.028986 0.000596 0.112730];
print_inertial(inertia, mass_base_link, volume_base_link, center_of_mass, 10);

printf("\n** link_1:\n")
inertial = [10.242188  -0.004163   0.025707;
            -0.004163   8.373408  -0.010056;
            0.025707  -0.010056   8.019296];
center_of_mass = [0.000877 -0.000631 0.336217];
print_inertial(inertial, mass_link_1, volume_link_1, center_of_mass, 10);

printf("\n** link_2:\n")
inertial = [45.159019   0.001209   0.019125;
            0.001209  42.357410  -0.164604;
            0.019125  -0.164604   8.181775];
center_of_mass = [-0.000928 -0.000497 0.250051];
print_inertial(inertial, mass_link_2, volume_link_2, center_of_mass, 10);

printf("\n** link_3:\n")
inertial = [  2.309597   0.013060  -0.517453;
  0.013060   8.293624   0.013012;
 -0.517453   0.013012   7.549211];
center_of_mass = [0.099588 0.001143 0.032333];
print_inertial(inertial, mass_link_3, volume_link_3, center_of_mass, 10);

printf("\n** link_4:\n")
inertial = [  0.524367  -0.011997   0.034790;
 -0.011997   1.082882  -0.002073;
  0.034790  -0.002073   1.046977];
center_of_mass = [0.381678 0.001261 0.005168];
print_inertial(inertial, mass_link_4, volume_link_4, center_of_mass, 10);

printf("\n** link_5:\n")
inertial = [ 0.046006  -0.000944  -0.000008;
-0.000944   0.099600   0.000019;
-0.000008   0.000019   0.084074];
center_of_mass = [0.011197 -0.001056 0.000109];
print_inertial(inertial, mass_link_5, volume_link_5, center_of_mass, 10);

printf("\n** link_6:\n")
% Link 6 is so small that without the scaling meshlab could not calculate
% th volume and to get an inertia tensor I needed to scale it 100 times
% (instead of 10 like the rest).
inertial =  [ 12.367648  -0.000111   0.000084;
 -0.000111   6.311567  -0.001112;
  0.000084  -0.001112   6.314166];
center_of_mass = [-0.250976 -0.000189 0.010218]/100;
print_inertial(inertial, mass_link_6, volume_link_6, center_of_mass, 100);
