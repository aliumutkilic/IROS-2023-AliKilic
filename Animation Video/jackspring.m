function [spr_b_x, spr_b_y, spr_g_x, spr_g_y, case_x, case_y, div_x, div_y] = jackspring(x_start, y_start, angle, k, dl, w)

%spring parameters
w_spring = w/2; %spring width
l0 = 0.53*1.96; %spring length uncompressed


        %total number of coils in spring
        N_coils = 10;

        %number of coils in active length
        k_nat = 21000;
        N_active = 40/(k/k_nat + 5);
        active_r = N_active/ N_coils;   %ratio of active to total coils

        if N_active > 9.5
            N_active = 9.5;
        end

        y_vec_grey = linspace(0, - l0*(1 - N_active/ N_coils), 300);

        omega = 2*pi/( l0/ N_coils);
        x_vec_grey =  w_spring*cos(omega*y_vec_grey);

        rot_mat = [ cos(-angle), -sin(-angle); sin(-angle), cos(-angle) ]; 

        %get phi
        phi = ( 1 - N_active - floor(1 - N_active))*2*pi;

        omega_black = 2*pi/( ( l0*N_active/ N_coils -  dl)/N_active);
        y_vec_black = linspace(0, - l0*N_active/ N_coils +  dl, 300);
        x_vec_black = w_spring * cos(omega_black * y_vec_black - phi);

        y_vec_black = y_vec_black +  y_vec_grey(length(y_vec_grey));


        %draw line division:
        y_div =  y_vec_grey(length(y_vec_grey));

        div_line_x = [- w_spring, -  w_spring,  w_spring, w_spring]*1.2;
        div_line_y = [ y_div + 0.2, y_div,  y_div, y_div + 0.2];

        points_divline = rot_mat*( [div_line_x; div_line_y]);
        div_x = points_divline(1,:) + x_start;
        div_y = points_divline(2,:) + y_start;


        points_grey = rot_mat* [x_vec_grey;  y_vec_grey ];
        spr_g_x = points_grey(1,:) + x_start;
        spr_g_y = points_grey(2,:) + y_start;

        points_black = rot_mat* [ x_vec_black;  y_vec_black ];
        spr_b_x = points_black(1,:) + x_start;
        spr_b_y = points_black(2,:) + y_start;
        
        
        %draw casing
        x_left = - 1.4*w_spring;
        x_right =  1.4*w_spring;
        x_case = [x_left, x_left, x_right, x_right];

        y_top = 0;
        y_bot = - 0.6*l0;
        y_case = [y_bot, y_top, y_top, y_bot];

        points_case = rot_mat*[x_case; y_case];
        case_x = points_case(1,:) + x_start;
        case_y = points_case(2,:) + y_start;

end