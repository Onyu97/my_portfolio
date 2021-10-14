%name �ޱ�


KbName('UnifyKeyNames'); %kbname�� ���� ��ħ
FlushEvents;
Screen('Preference', 'SkipSyncTests', 1);
WaitSecs(.5);
keyIsDown = 0;


[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]); %������� screen �������.
bgColor = 255;

myText = 'Write down your name';

Screen('TextFont', wPtr, 'Times');
Screen('TextSize',wPtr, 48);
Screen('TextStyle', wPtr, 2);

DrawFormattedText(wPtr,myText,'center','center',0);%���� ���� center���밡 ǥ��, ���� ǥ�õ�(0�ǹ�). 
%Screen('Flip', wPtr);
%WaitSecs(1);
%Screen('Flip', wPtr);
newText = [];

preTime = GetSecs()

yesKeys = KbName('return'); %enter
bspace = KbName('backspace');
fspace = KbName('space');

while ~keyIsDown %keyisdown�� �׻� 0�̴�. 
    [secs, keyCode,deltaSecs] = KbWait(-1, 2); %release �� �� ������ ���̴�. (2)
    if secs - preTime > 0.02 %�ʹ� �ν��� ���ؼ�, �ѹ� �������� ������ �ν��ϴ� ���� ���� ���� ���� �ð� ���� �ν��ϱ�� �ߴ�. 
        if any(keyCode(yesKeys))
            break; %enter������ ����
        end
        if any(keyCode(bspace)) %backspace ��� �ֱ�
            newText = newText(1:end-1);
        elseif any(keyCode(fspace)) %space��� �ֱ�
            newText = [newText ' '];
        else
            nt = KbName(find(keyCode));
            newText = [newText nt]; %���ο� Ű ��ֱ�
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


