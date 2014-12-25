%% Arduino Path Finding
%% James Taylor <jamestay@vt.edu>

sensorpin = 13;     % sensor control pin (all sensors)
leftsensorpin = 0;  % pin to read left sensor values from
centersensorpin = 2;% pin to read center sensor values from
rightsensorpin = 4; % pint to read right sensor values from
a.pinMode(sensorpin,'OUTPUT');  % preparing to turn sensors on and off

leftmotor = 5;      % set pin 5 as the pin to control the left motor
rightmotor = 6;     % set pin 6 as the pin to control the right motor

threshold = 400; % calculated threshold value
timeout = 0; % counts the seconds the robot is off the line 

while(timeout < 500)
    
    % read sensor variables
    a.digitalWrite(sensorpin,1) % output to turn sensors on
    left = a.analogRead(leftsensorpin);
    center = a.analogRead(centersensorpin);
    right = a.analogRead(rightsensorpin);
    a.digitalWrite(sensorpin,0) % output to turn off sensors

    
    if(center > threshold)
        % moves forward if the center sensor detects the line
        disp(['[' num2str(tick) ']: CENTER, ' num2str(left) ', ' num2str(center) ', ' num2str(right)]);
        a.analogWrite(leftmotor,255);
        a.analogWrite(rightmotor,255);
        timeout = 0;
        
    elseif(left > threshold)
        % if the black line is detected on the left, move right slightly
        disp(['[' num2str(tick) ']: LEFT, ' num2str(left) ', ' num2str(center) ', ' num2str(right)]);
        a.analogWrite(leftmotor,0);
        a.analogWrite(rightmotor,255);
        timeout = 0;
        
    elseif(right > threshold)
        % if the black line is detected on the right, move left slightly
        disp(['[' num2str(tick) ']: RIGHT, ' num2str(left) ', ' num2str(center) ', ' num2str(right)]);
        a.analogWrite(leftmotor,255);
        a.analogWrite(rightmotor,0);
        timeout = 0;

    else % all sensor readings are below the threshold
        if(timeout < 120)
            % turn left for a brief period of time
            a.analogWrite(leftmotor,0);
            a.analogWrite(rightmotor,255);
        else
            % turn right until the motors timeout
            a.analogWrite(leftmotor,255);
            a.analogWrite(rightmotor,0);
        end

        timeout = timeout + 1;
    
    end
        
end

% turns off the robot motors and sensors
a.analogWrite(leftmotor,off);
a.analogWrite(rightmotor,off);
a.digitalWrite(sensorpin,0);