[data,file_name] = PickDataSet('DataFiles');

[n_E,n1,n2]=size(data);

figure

for i=1:n_E
    imagesc(reshape(data(i,:,:),n1,n2))
    pause(0.5)
end