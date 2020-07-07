function objectTickValueArray = dialogForSelectingSomeObjectsAndUsersToEdit(userInputCellArray,varargin)
nObj = size(userInputCellArray,2);
if isempty(userInputCellArray)
    return
end
if nargin<2 || isempty(varargin{1})
    objectTickValueArray = ones(1,nObj);
else
    objectTickValueArray = varargin{1};
end
% Create figure
h.f = figure(423423);  clf;
set(h.f,'units','pixels','position',[300,700,750,80],'toolbar','none','menu','none');

for iObj = 1:nObj
    h.userCheck(iObj) = uicontrol('style','checkbox','value',objectTickValueArray(iObj),'units','pixels','position',[30*iObj+30,50,30,15],'string',num2str(iObj));
end

h.txt1 = uicontrol('Style','text','String','Obj:','position', [10,50,50,15]);
% h.txt2 = uicontrol('Style','text','String','user:','position',[30,350,50,15]);
% for iObj = 1:nObj
%     h.objCheck(iObj)  = uicontrol('style','checkbox','units','pixels','position',[10,50*(nObj-iObj)+200,30,15],'string',num2str(iObj));
% end
% for iUser= 1:nUser
%     for iObj = 1:nObj
%         h.objUserCheck(iObj,iUser)  = uicontrol('style','checkbox','units','pixels','position',[100*iUser,50*(nObj-iObj)+200,30,15],'string',num2str(iObj));
%
%     end
% end

% %
% % % % Create yes/no checkboxes
% % % h.c(1) = uicontrol('style','checkbox','units','pixels',...
% % %                 'position',[10,30,50,15],'string','yes');
% % % h.c(2) = uicontrol('style','checkbox','units','pixels',...
% % %                 'position',[90,30,50,15],'string','no');
% Create OK pushbutton

h.pAll = uicontrol('style','pushbutton','units','pixels','position',[ 40,5,70,20],'string','All' ,'callback',@p_callAll)
h.pSome = uicontrol('style','pushbutton','units','pixels','position',[140,5,70,20],'string','Some','callback',@p_callSome)



disp(1)
% Pushbutton callback
    function objectTickValueArray = p_callSome(src,varargin)
        vals = get(h.userCheck,'Value');
        objectTickValueArray = mat2vec([vals{:}])';

        disp(objectTickValueArray)
        close(h.f)
    end
    function objectTickValueArray = p_callAll(varargin)
        objectTickValueArray = ones(1,nObj);
        disp(objectTickValueArray)
        %close(h.f)
    end

end





