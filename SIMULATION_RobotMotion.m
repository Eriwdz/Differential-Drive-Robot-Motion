clc;
clear all;
close all;

% Robot parameters
robotPose = [0,0,0];
tireDiameter_m = 0.25;
trackWidth_m = 0.5;
model = 'icr'; % or 'linear'

% Populate wheel velocities vector
v_radps = 20;
% Wheel velocity vector
u = [abs(sin(0:0.01:2*pi)).*v_radps; abs(cos(0:0.01:2*pi)).*v_radps];
% time between iterations in seconds
dt_s = 0.01;

for ii = 1:length(u(1,:))
    % Get left and right wheel velocities in rad/s
    Vr_radps = u(1,ii); Vl_radps = u(2,ii);
    % Convert rad/s to m/s based on tire diameter
    Vr_mps = Vr_radps * tireDiameter_m / (2 * pi);
    Vl_mps = Vl_radps * tireDiameter_m / (2 * pi);
    % Get robot frame linear and rotational velocities
    v_mps = (Vr_mps + Vl_mps) / 2.0;
    w_radps = (Vr_mps - Vl_mps) / trackWidth_m;
    % Update robot pose using kinematic model
    robotPose = differentialDriveKinematics(robotPose, v_mps, w_radps, dt_s, model);
    
    % Render environment
    %======================================================================
    clf;
    hold on;
    xlim([-0.5 3.5]); ylim([-1.5 1.5]);
    xlabel('meters'); ylabel('meters');
    if(exist('robotPose'))
        drawRobot(robotPose(1), robotPose(2), rad2deg(robotPose(3)), 0.25);
    end
    pause(0.001);
    % End render environment
    %----------------------------------------------------------------------
end