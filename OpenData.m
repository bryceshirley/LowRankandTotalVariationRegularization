f = fopen('Simulation_data.dat', 'rb');
D = fread(f, inf, '*float');  % Try '*double' too
fclose(f);
size(D)