
function varargout = guiFigure_ADSB_projekt(varargin)
% Last Modified by GUIDE v2.5 29-Sep-2021 12:57:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiFigure_ADSB_projekt_OpeningFcn, ...
                   'gui_OutputFcn',  @guiFigure_ADSB_projekt_OutputFcn, ...
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


% --- Executes just before guiFigure_ADSB_projekt is made visible.
function guiFigure_ADSB_projekt_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
imaqreset
handles.cam = webcam(1);
guidata(hObject, handles);
%%%%%to open gui editor: 
%guide 

% --- Outputs from this function are returned to the command line.
function varargout = guiFigure_ADSB_projekt_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_knap1.
function start_knap1_Callback(hObject, ~, handles)
global KeepRunning;
KeepRunning=1;
while KeepRunning
    cam = handles.cam;
    data = snapshot(cam);
    imChange1 = rgb2gray(data);
    %imChange2 = medfilt2(imChange1, [1 1]);
    imChange3 = imbinarize(imChange1,0.75); %0.18 normalt (0.07 ved grøn)  (im2bw)
    imChange4 = bwareaopen(imChange3,100); %300
    bw = bwlabel(imChange4, 8);
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    
    imshow(bw, 'Parent', handles.axes1);
    imshow(data, 'Parent', handles.axes2);
    
    hold on
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','g','LineWidth',0.8)
        plot(bc(1),bc(2), '-black+')
        textX=text(bc(1)-20,bc(2)+5, strcat('X:', num2str(round(bc(1)))));
        textY=text(bc(1)-20,bc(2)+50, strcat('Y:', num2str(round(bc(2)))));
        set(textX, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'red');
        set(textY, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'red');
    end
    hold off
    drawnow;
    guidata(hObject, handles);
end



% --- Executes on button press in stop_knap2.
function stop_knap2_Callback(hObject, ~, handles)

global KeepRunning;
KeepRunning=0;
guidata(hObject, handles);


% --- Executes on button press in slet_knap3.
function slet_knap3_Callback(hObject, ~, handles)

cam = handles.cam;
delete (cam);
clear cam;
close all;
guidata(hObject, handles);
