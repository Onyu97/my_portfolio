%name 받기


KbName('UnifyKeyNames'); %kbname에 영향 미침
FlushEvents;
Screen('Preference', 'SkipSyncTests', 1);
WaitSecs(.5);
keyIsDown = 0;


[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]); %흰색으로 screen 만들었다.
bgColor = 255;

myText = 'Write down your name';

Screen('TextFont', wPtr, 'Times');
Screen('TextSize',wPtr, 48);
Screen('TextStyle', wPtr, 2);

DrawFormattedText(wPtr,myText,'center','center',0);%앞의 것을 center에대가 표시, 색깔 표시됨(0의미). 
%Screen('Flip', wPtr);
%WaitSecs(1);
%Screen('Flip', wPtr);
newText = [];

preTime = GetSecs()

yesKeys = KbName('return'); %enter
bspace = KbName('backspace');
fspace = KbName('space');

while ~keyIsDown %keyisdown은 항상 0이다. 
    [secs, keyCode,deltaSecs] = KbWait(-1, 2); %release 할 때 가져온 것이다. (2)
    if secs - preTime > 0.02 %너무 인식을 잘해서, 한번 눌렀지만 여러번 인식하는 것을 막기 위해 일정 시간 이후 인식하기로 했다. 
        if any(keyCode(yesKeys))
            break; %enter나오면 끄기
        end
        if any(keyCode(bspace)) %backspace 기능 넣기
            newText = newText(1:end-1);
        elseif any(keyCode(fspace)) %space기능 넣기
            newText = [newText ' '];
        else
            nt = KbName(find(keyCode));
            newText = [newText nt]; %새로운 키 써넣기
        end
        DrawFormattedText(wPtr,newText,'center','center',0);
        Screen('Flip', wPtr);
        preTime = GetSecs();
    end
end
DrawFormattedText(wPtr,newText,'center','center',[255 0 0]);
Screen('Flip', wPtr);
WaitSecs(2)
sca;


