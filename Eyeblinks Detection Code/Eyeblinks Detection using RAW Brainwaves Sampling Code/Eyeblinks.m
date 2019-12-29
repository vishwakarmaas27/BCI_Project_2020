%Reading Eyeblinks by sampling Raw brainwaves data from Brainsense
%connected to port no 6 and output a beep sound on eyeblink.
%(Change portnum1 variable to define the port no of the device).
%Author: Shivam Vishwakarma

%Clear Screen
clc;
%Clear Variables
clear all;
%Close figures
close all;

%Pre-requisite definitions to generate a beep sound
amp=5; 
fs=1000;
duration=1;
freq=100;
values=0:1/fs:duration;
a=amp*sin(2*pi* freq*values);

%Preallocate buffer
data_blink = zeros(1,256);
%Comport Selection
portnum1 = 6;
%COM Port #
comPortName1 = sprintf('\\\\.\\COM%d', portnum1);

% Baud rate for use with TG_Connect() and TG_SetBaudrate().
TG_BAUD_115200 = 9600;

% Data format for use with TG_Connect() and TG_SetDataFormat().
TG_STREAM_PACKETS = 0;
% Data type that can be requested from TG_GetValue().
TG_DATA_RAW = 4;

%load thinkgear dll
loadlibrary('Thinkgear.dll');
%To display in Command Window
fprintf('Thinkgear.dll loaded\n');
%get dll version
dllVersion = calllib('Thinkgear', 'TG_GetDriverVersion');
%To display in command window
fprintf('ThinkGear DLL version: %d\n', dllVersion );

% Get a connection ID handle to ThinkGear
connectionId1 = calllib('Thinkgear', 'TG_GetNewConnectionId');
if ( connectionId1 < 0 )
error( sprintf( 'ERROR: TG_GetNewConnectionId() returned %d.\n', connectionId1 ) );
end;

% Attempt to connect the connection ID handle to serial port "COM_"
errCode = calllib('Thinkgear', 'TG_Connect', connectionId1,comPortName1,TG_BAUD_115200,TG_STREAM_PACKETS );
if ( errCode < 0 )
error( sprintf( 'ERROR: TG_Connect() returned %d.\n', errCode ) );
end
fprintf( 'Connected.\n' );

%Enable Blinks Detection
if(calllib('Thinkgear','TG_EnableBlinkDetection',connectionId1,1)==0)
disp('Blink Detection Enabled.');
end

i=0;
j=0;
%To display in Command Window
disp('Reading Brainwaves (Brainwave Packets)');
while i < 10        %Read 10 eyeblinks before stopping
    %Collect 256 packets for sampling
    while j<256
        if (calllib('Thinkgear','TG_ReadPackets',connectionId1,1) == 1)   %if a packet was read..
         %  if (calllib('Thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_RAW) ~= 0)   %if RAW has been updated 
                j = j + 1;
                data_blink(j) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_RAW);
         %  end
        end
    end
    if (j == 256)       
       %Checking the 256 samples, if a peak was generated, 
       %If yes, it's a Eyeblink.
       out_max=max(data_blink);
       out_min=min(data_blink);
       
       if ( (out_max > 300)  && (out_min < -300) )  %Eyeblink peak range satisfied
           %Blink Detected, now generate a beep sound. 
           %Next line is for generating a beep sound.
           sound(a)
           
           %Plot Image and Write Blink detected in command window
           figure, imshow('blink.jpg');
           disp('Blink detected');
           i=i+1;       %Read 10 eyeblinks before stopping
           close all;
       end
    end
    j=0;
end
%To display in Command Window
disp('Loop Completed')
close all;
%Release the comm port
calllib('Thinkgear', 'TG_FreeConnection', connectionId1 );