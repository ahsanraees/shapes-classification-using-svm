function varargout = shapesclassificationsvm(varargin)
% SHAPESCLASSIFICATIONSVM MATLAB code for shapesclassificationsvm.fig
%      SHAPESCLASSIFICATIONSVM, by itself, creates a new SHAPESCLASSIFICATIONSVM or raises the existing
%      singleton*.
%
%      H = SHAPESCLASSIFICATIONSVM returns the handle to a new SHAPESCLASSIFICATIONSVM or the handle to
%      the existing singleton*.
%
%      SHAPESCLASSIFICATIONSVM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHAPESCLASSIFICATIONSVM.M with the given input arguments.
%
%      SHAPESCLASSIFICATIONSVM('Property','Value',...) creates a new SHAPESCLASSIFICATIONSVM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before shapesclassificationsvm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to shapesclassificationsvm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help shapesclassificationsvm

% Last Modified by GUIDE v2.5 25-Oct-2021 20:11:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @shapesclassificationsvm_OpeningFcn, ...
                   'gui_OutputFcn',  @shapesclassificationsvm_OutputFcn, ...
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


% --- Executes just before shapesclassificationsvm is made visible.
function shapesclassificationsvm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to shapesclassificationsvm (see VARARGIN)

% Choose default command line output for shapesclassificationsvm
handles.output = hObject;
axes(handles.axes3)
imshow('logo.png')
axes(handles.axes4)
imshow('logo.png')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes shapesclassificationsvm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = shapesclassificationsvm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Training.
function Training_Callback(hObject, eventdata, handles)
% hObject    handle to Training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% data_path='G:\Ayesha\data\training';
% data=imageDatastore(data_path,'IncludeSubFolders',true,'LabelSource','foldernames');
% [traindb, testdb]=splitEachLabel(data,0.7,'randomized');
Traindata_path='G:\Ayesha\data\training';
Testdata_path='G:\Ayesha\data\testing';
traindb=imageDatastore(Traindata_path,'IncludeSubFolders',true,'LabelSource','foldernames');
testdb=imageDatastore(Testdata_path,'IncludeSubFolders',true,'LabelSource','foldernames');
img=readimage(traindb,1);
CS=[16,16];
[hogfv,hogvis]=extractHOGFeatures(img,'CellSize',CS);
hogfeaturesize=length(hogfv);
totaltrainimages=numel(traindb.Files);
trainingfeatures=zeros(totaltrainimages,hogfeaturesize,'single');
for i=1:totaltrainimages
    img=readimage(traindb,i);
    trainingfeatures(i,:)=extractHOGFeatures(img,'CellSize',CS);
end
traininglabels=traindb.Labels;
classifier=fitcecoc(trainingfeatures,traininglabels);
setappdata(0,'testdb',testdb)
setappdata(0,'CS',CS)
setappdata(0,'hogvfv',hogfv)
setappdata(0,'hogvis',hogvis)
setappdata(0,'classifier',classifier)
setappdata(0,'hogfeaturesize',hogfeaturesize)
M='Training is Done';
set(handles.edit1,'string', sprintf(M))
% --- Executes on button press in Test_single_image.
function Test_single_image_Callback(hObject, eventdata, handles)
% hObject    handle to Test_single_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
testdb=getappdata(0,'testdb');
CS=getappdata(0,'CS');
hogfv=getappdata(0,'hogvfv');
hogvis=getappdata(0,'hogvis');
classifier=getappdata(0,'classifier');
hogfeaturesize=getappdata(0,'hogfeaturesize');
[filename, pathname]=uigetfile('*.*','select input image');
filewithpath=strcat(pathname,filename);
imgt=imread(filewithpath);
CS=[16,16];
[hogfvt,hogvist]=extractHOGFeatures(imgt,'CellSize',CS);
predictlabel=predict(classifier,hogfvt);
% set(handles.edit1 , 'String' , predictlabel);
axes(handles.axes2);
imshow(imgt);
% figure
% imshow(imgt)
title(['shape recognized is: ' char(predictlabel)])
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


% --- Executes on button press in Testing.
function Testing_Callback(hObject, eventdata, handles)
% hObject    handle to Testing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
testdb=getappdata(0,'testdb');
CS=getappdata(0,'CS');
hogfv=getappdata(0,'hogvfv');
hogvis=getappdata(0,'hogvis');
classifier=getappdata(0,'classifier');
hogfeaturesize=getappdata(0,'hogfeaturesize');
totaltestimages=numel(testdb.Files);
testfeatures=zeros(totaltestimages,hogfeaturesize,'single');
for i=1:totaltestimages
    imgt=readimage(testdb,i);
    testfeatures(i,:)=extractHOGFeatures(imgt,'CellSize',CS);
end
testlabels=testdb.Labels;
predictedlabel=predict(classifier, testfeatures);
accuracy=(sum(predictedlabel == testlabels) / numel(testlabels))*100;
String='Testing Accuracy Percentage is: ';
set(handles.edit1 , 'String' , String);
String = {String,accuracy};
set(handles.edit1 , 'Max' , 2)  % To accomodate multi line text
set(handles.edit1 , 'String' , String);
setappdata(0,'testlabels',testlabels)
setappdata(0,'Predictedlabel',predictedlabel)
% --- Executes on button press in Confusion_matrix.
function Confusion_matrix_Callback(hObject, eventdata, handles)
% hObject    handle to Confusion_matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
testlabels=getappdata(0,'testlabels');
predictedlabel=getappdata(0,'Predictedlabel');
figure
plotconfusion(testlabels,predictedlabel)
% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq();
close all


% --------------------------------------------------------------------
% function SVMclassifier_Callback(hObject, eventdata, handles)
% % hObject    handle to Untitled_1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
