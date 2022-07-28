modes = 3

%%% Assume  2D Portal...
figure(1)
subplot(1,modes,1)
for mode=1:1:modes
    subplot(1,modes,mode)
    ev = readmatrix("modes\EigenVector"+num2str(mode)+".txt");
    elements = size(ev,1);
    sfac = 1600;

    hold on;
    for element=1:1:elements
        x_coord_i = ev(element,2);
        y_coord_i = ev(element,3);

        x_coord_j = ev(element,4);
        y_coord_j = ev(element,5);

        d = [ev(element,6) ev(element,7) ev(element,9) ev(element,10)];

        plot([x_coord_i  x_coord_j ],[y_coord_i  y_coord_j ],'--','Color','black');
        plot([x_coord_i + sfac*d(1) x_coord_j + sfac*d(3)],[y_coord_i + sfac*d(2) y_coord_j + sfac*d(4)],'Color','black');
        grid on; axis('equal');
        xlabel("Distance (m)"); ylabel("Distance (m)"); title("Mode Shape "+num2str(mode))
    end
end