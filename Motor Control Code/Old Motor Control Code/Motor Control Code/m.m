%function PSEMB301
%run this function to connect and plot raw EEG data
%make sure to change portnum1 to the appropriate COM port

clear all
close all

data_BLINK = zeros(1,256);    %preallocate buffer
data_ATTENTION = zeros(1,256);
data_MEDITATION = zeros(1,256);
   X= zeros(1,256);
   
   
portnum1 = 24;   %COM Port #
comPortName1 = sprintf('\\\\.\\COM%d', portnum1);


% Baud rate for use with TG_Connect() and TG_SetBaudrate().
%TG_BAUD_57600 =      57600;

TG_BAUD_115200  =   115200;

% Data format for use with TG_Connect() and TG_SetDataFormat().
TG_STREAM_PACKETS =     0;


% Data type that can be requested from TG_GetValue().

TG_DATA_BATTERY            =    0 ;   
TG_DATA_POOR_SIGNAL        =    1 ;
TG_DATA_ATTENTION          =    2 ;
TG_DATA_MEDITATION         =    3 ;
TG_DATA_RAW                =    4 ;
TG_DATA_DELTA              =    5 ;
TG_DATA_THETA              =    6 ; 
TG_DATA_ALPHA1             =    7 ;
TG_DATA_ALPHA2             =    8 ;
TG_DATA_BETA1              =    9 ;
TG_DATA_BETA2              =    10 ;
TG_DATA_GAMMA1             =    11 ;
TG_DATA_GAMMA2             =    12 ;
TG_DATA_BLINK_STRENGTH     =    37 ;
TG_DATA_READYZONE          =    38 ;



%load thinkgear dll
loadlibrary('Thinkgear.dll');
fprintf('Thinkgear.dll loaded\n');

%get dll version
%dllVersion = calllib('Thinkgear', 'TG_GetDriverVersion');
% fprintf('ThinkGear DLL version: %d\n', dllVersion );


%%
% Get a connection ID handle to ThinkGear
connectionId1 = calllib('Thinkgear', 'TG_GetNewConnectionId');
if ( connectionId1 < 0 )
    error( sprintf( 'ERROR: TG_GetNewConnectionId() returned %d.\n', connectionId1 ) );
end;

% Set/open stream (raw bytes) log file for connection
errCode = calllib('Thinkgear', 'TG_SetStreamLog', connectionId1, 'streamLog.txt' );
if( errCode < 0 )
    error( sprintf( 'ERROR: TG_SetStreamLog() returned %d.\n', errCode ) );
end;

% Set/open data (ThinkGear values) log file for connection
errCode = calllib('Thinkgear', 'TG_SetDataLog', connectionId1, 'dataLog.txt' );
if( errCode < 0 )
    error( sprintf( 'ERROR: TG_SetDataLog() returned %d.\n', errCode ) );
end;

% Attempt to connect the connection ID handle to serial port "COM3"
errCode = calllib('Thinkgear', 'TG_Connect',  connectionId1,comPortName1,TG_BAUD_115200,TG_STREAM_PACKETS );
if ( errCode < 0 )
    error( sprintf( 'ERROR: TG_Connect() returned %d.\n', errCode ) );
    
else disp('conected!!');
end

% fprintf( 'Connect    
if(calllib('Thinkgear','TG_EnableBlinkDetection',connectionId1,1)==0)
    disp('blinkdetectenabled');
end

%record data
serialOne=serial('COM3', 'BaudRate', 9600);
  fopen(serialOne);
j = 0;
i = 0;
k = 0;
l = 0;
Blink=0;
Drive_mode = 0;

X = 0:1:255;

while (i < 100)   %loop for 20 seconds
%while(0)    
    if (calllib('Thinkgear','TG_ReadPackets',connectionId1,1) == 1)   %if a packet was read...
        
       if (calllib('Thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_BLINK_STRENGTH ) ~= 0)   %if RAW has been updated 
                j = j + 1;
                
                data_BLINK (j)=calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_BLINK_STRENGTH );
                disp('BLINK = ');
                disp(data_BLINK (j));
                
                if(data_BLINK(j) > 40 )
 %                   if(data_BLINK(j) < 95)
                        Blink = Blink+1;
%                    end
                end

                
                    
                    if (40 <data_BLINK (j) < 60)
     %                   if(Drive_mode == 1)
%                             fopen(serialOne);
                            disp('FORWARD')
                            fwrite(serialOne,'A');
                            pause(2)
%                             fclose(serialOne);
     %                   end
                    end

                    if(60<data_BLINK (j) < 80)
    %                    if(Drive_mode == 1)
%                             fopen(serialOne);
                            disp('BACKWARD')
                            fwrite(serialOne,'B');
                            pause(2)

    %                    end
                    end
                   if(80<data_BLINK (j) < 90)
    %                    if(Drive_mode == 1)
%                             fopen(serialOne);
                             disp('RIGHT SIDE')
                            fwrite(serialOne,'C');
                            pause(2)

    %                    end
                   end
                  if(90<data_BLINK (j) < 100)
    %                    if(Drive_mode == 1)
%                             fopen(serialOne);
                             disp('LEFT SIDE')
                            fwrite(serialOne,'D');
                            pause(2)

    %                    end
                 end
          end
                    
                
    end 
       
%    end 

%   if (calllib('Thinkgear','TG_ReadPackets',connectionId1,1) == 1)   %if a packet was read...
%         if(Drive_mode == 1)      
%         if (calllib('Thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_ATTENTION ) ~= 0)   %if RAW has been updated 
% %           l = l + 1;
%             k = k + 1;
%             i = i + 1;
%  %           X(i) = i;
%             data_ATTENTION(k) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_ATTENTION  );
%             disp('ATTENTION = ');
%             disp(data_ATTENTION(k));
% %            plot(data_ATTENTION)
% %            axis([0 100 0 100])
% %            drawnow;
%             
%    
%            Blink=0;
% %        if (calllib('Thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_MEDITATION ) ~= 0)   %if RAW has been updated 
% %            l = l + 1;
% %            data_MEDITATION(l) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_MEDITATION  );
% %            disp('MEDITATION = ');
% %            disp(data_MEDITATION(l));               
%            
% %            if(Drive_mode == 1)    
%                 if(data_ATTENTION(k) > 50)                
% %                     fopen(serialOne);
%                     fwrite(serialOne,'C');              %move forwrd
% %                     fclose(serialOne);
%                 elseif(data_ATTENTION(k) < 40)                
%   %                  fopen(serialOne);
%                    fwrite(serialOne,'D');
%   %                  fclose(serialOne);
%   %                  end
%                 end
%  %           end 
%             
%                         
%             
%             plot(X,data_ATTENTION,'-r',X,data_BLINK,'-*k');
%             axis([0 100 0 200])
%             drawnow;

%        end
        end  
                   
%         end 

           
%disconnect             
calllib('Thinkgear', 'TG_FreeConnection', connectionId1 );
%end






