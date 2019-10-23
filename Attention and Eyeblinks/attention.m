function varargout = attention(varargin)
% ATTENTION MATLAB code for attention.fig
%      ATTENTION, by itself, creates a new ATTENTION or raises the existing
%      singleton*.
%
%      H = ATTENTION returns the handle to a new ATTENTION or the handle to
%      the existing singleton*.
%
%      ATTENTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ATTENTION.M with the given input arguments.
%
%      ATTENTION('Property','Value',...) creates a new ATTENTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before attention_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to attention_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help attention

% Last Modified by GUIDE v2.5 21-Oct-2019 00:15:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @attention_OpeningFcn, ...
                   'gui_OutputFcn',  @attention_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before attention is made visible.
function attention_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to attention (see VARARGIN)

% Choose default command line output for attention
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes attention wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = attention_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

TG_DATA_ATTENTION = 2;
%Preallocate buffer
data_att = zeros(1,256);
%Comport Selection
portnum1 = 20;
%COM Port #
comPortName1 = sprintf('\\\\.\\COM%d', portnum1);
% Baud rate for use with TG_Connect() and TG_SetBaudrate().
TG_BAUD_115200 = 115200;
% Data format for use with TG_Connect() and TG_SetDataFormat().
TG_STREAM_PACKETS = 0;
% Data type that can be requested from TG_GetValue().
TG_DATA_ATTENTION = 2;
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
% Attempt to connect the connection ID handle to serial port "COM3"
errCode = calllib('Thinkgear', 'TG_Connect', connectionId1,comPortName1,TG_BAUD_115200,TG_STREAM_PACKETS );
if ( errCode < 0 )
error( sprintf( 'ERROR: TG_Connect() returned %d.\n', errCode ) );
end
fprintf( 'Connected. Reading Packets...\n' );
i=0;
j=0;
%To display in Command Window
disp('Reading Brainwaves');
figure;
while i < 20
if (calllib('Thinkgear','TG_ReadPackets',connectionId1,1) == 1) %if a packet was read...
if (calllib('Thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_ATTENTION ) ~= 0)
j = j + 1;
i = i + 1;
%Read attention Valus from thinkgear packets
data_att(j) = calllib('Thinkgear','TG_GetValue',connectionId1,TG_DATA_ATTENTION );

str=num2str(data_att(j));
set(handles.edit1,str);
%To display in Command Window
disp(data_att(j));
%Plot Graph
axex(handles.axes1);
plot(data_att);
title('Attention');
%Delay to display graph
pause(1);
end
end
end
%To display in Command Window
disp('Loop Completed')
%Release the comm port
calllib('Thinkgear', 'TG_FreeConnection', connectionId1 );



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
