%% CubeSat Attitude Animation Script

% Reference frame: Orbital Frame (LHLV)
% Input: CubeSat State vector
% Author: Ameya Marakarkandy
% ameya.marakarkandy@gmail.com
% Last updated: 20/06/2024

function drawCubeSat(uu)

    % process inputs to function
    pn       = uu(1);       % inertial North position     
    pe       = uu(2);       % inertial East position
    pd       = uu(3);       % inertial Down position           
    u        = uu(4);       % velocity along xb
    v        = uu(5);       % velocity along yb       
    w        = uu(6);       % velocity along zb       
    phi      = uu(7);       % roll angle         
    theta    = uu(8);       % pitch angle     
    psi      = uu(9);       % yaw angle     
    p        = uu(10);      % roll rate
    q        = uu(11);      % pitch rate     
    r        = uu(12);      % yaw rate    
    t        = uu(13);      % time

    % define persistent variables 
    persistent spacecraft_handle;
    persistent Vertices
    persistent Faces
    persistent facecolors
    
    % first time function is called, initialize plot and persistent vars
    if t==0
        figure(1), clf
        [Vertices, Faces, facecolors] = defineSpacecraftBody;
        spacecraft_handle = drawSpacecraftBody(Vertices,Faces,facecolors,...
                                               pn,pe,pd,phi,theta,psi,...
                                               [],'normal');
        title('CubeSat Attitude')
        xlabel('East')
        ylabel('North')
        zlabel('-Down')
        view(32,47)  % set the view angle for figure
        axis([-0.5,0.5,-0.5,0.5,-0.5,0.5]);
        grid on
        hold on
        
    % at every other time step, redraw base and rod
    else 
        drawSpacecraftBody(Vertices,Faces,facecolors,...
                           pn,pe,pd,phi,theta,psi,...
                           spacecraft_handle);
    end
end

  
%=======================================================================
% drawSpacecraft
% return handle if 3rd argument is empty, otherwise use 3rd arg as handle
%=======================================================================
%
function handle = drawSpacecraftBody(V,F,patchcolors,...
                                     pn,pe,pd,phi,theta,psi,...
                                     handle,mode)
  V = rotate(V', phi, theta, psi)';  % rotate spacecraft
  V = translate(V', pn, pe, pd)';    % translate spacecraft
  %V = rotate(V', phi, theta, psi)';  % rotate spacecraft
  
  
  % transform vertices from NED to XYZ (for matlab rendering)
  R = [...
      0, 1, 0;...
      1, 0, 0;...
      0, 0, -1;...
      ];
  V = V*R;
  
  if isempty(handle)
  handle = patch('Vertices', V, 'Faces', F,...
                 'FaceVertexCData',patchcolors,...
                 'FaceColor','flat',...
                 'EraseMode', mode);
  else
    set(handle,'Vertices',V,'Faces',F);
    xlim(handle.Parent, [pe-0.5,pe+0.5]);
    ylim(handle.Parent, [pn-0.5,pn+0.5]);
    zlim(handle.Parent, [-pd-0.5,-pd+0.5]);
    drawnow
  end
end

%%%%%%%%%%%%%%%%%%%%%%%
function XYZ=rotate(XYZ,phi,theta,psi)
  % define rotation matrix
  R_roll = [...
          1, 0, 0;...
          0, cos(phi), -sin(phi);...
          0, sin(phi), cos(phi)];
  R_pitch = [...
          cos(theta), 0, sin(theta);...
          0, 1, 0;...
          -sin(theta), 0, cos(theta)];
  R_yaw = [...
          cos(psi), -sin(psi), 0;...
          sin(psi), cos(psi), 0;...
          0, 0, 1];
  R = R_roll*R_pitch*R_yaw;
  % rotate vertices
  XYZ = R*XYZ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by pn, pe, pd
function XYZ = translate(XYZ,pn,pe,pd)
  XYZ = XYZ + repmat([pn;pe;pd],1,size(XYZ,2));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define spacecraft vertices and faces
function [V,F,colors] = defineSpacecraftBody()
    % Define the vertices (physical location of vertices
    oneu = 0.10;
    threeu = 0.30;
    V = [...
        threeu/2 oneu/2 oneu/2;... % point 1
        threeu/2 oneu/2 -oneu/2;... % point 2
        threeu/2 -oneu/2 -oneu/2;... % point 3
        threeu/2 -oneu/2 oneu/2;... % point 4
        -threeu/2 oneu/2 oneu/2;... % point 5
        -threeu/2 oneu/2 -oneu/2;... % point 6
        -threeu/2 -oneu/2 -oneu/2;... % point 7
        -threeu/2 -oneu/2 oneu/2;... % point 8
    ];

    % define faces as a list of vertices numbered above
    F = [...
        1, 2,  3,  4;...  % ram (front)
        5, 6,  7,  8;...  % wake (back)
        1, 2,  6,  5;...  % starboard(right) 
        4, 3,  7,  8;...  % portboard(left)
        2, 3,  7,  6;...  % zenith(top)
        1, 4, 8, 5;... % nadir(bottom)
        ];

    % define colors for each face    
    myred = [1, 0, 0];
    mygreen = [0, 1, 0];
    myblue = [0, 0, 1];
    myyellow = [1, 1, 0];
    mycyan = [0, 1, 1];

    colors = [...
        myred;...    % front
        mygreen;...  % back
        myblue;...   % right
        myyellow;... % left
        mycyan;...   % top
        mycyan;...   % bottom
        ];
end
  