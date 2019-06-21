program Gamev21;
uses graphABC,timers;
type massiv = array [1..40] of array [1..24] of integer;
label again, more, more2, restart;
var px,py,plx,ply,eN,dis,plhp,diff,wineN,control,i:byte;
  plcontrol:char;
  enx,eny:integer;
  gameover:boolean;
  map : massiv;
  color: color;
	enemys:array[1..21,1..2]of byte;
	healht:array[1..21] of byte;

procedure restarts;
var i:byte;
begin
  eN:=0;
  wineN:=0;
  for i:=1 to 21 do healht[i]:=0;
  for i:=1 to 21 do
  begin
    enemys[i,1]:=0;
    enemys[i,2]:=0;
  end;
  
end;


function search_enemy ( x , y : byte): byte;
  begin
  var i : byte;
  i:=0;
    repeat
      i+=1;
      if (enemys[i,1]=x) and (enemys[i,2]=y)  then
      begin
        Result:=i;
        i:=21;
      end;
    until(i=21);
  end;
  
  
procedure playerG (x:integer;y:integer);//рисует иконку игрока
begin
  setpencolor (clblue);
  setpenwidth (2);
  setbrushstyle (bssolid);
  setbrushcolor (clskyblue);
  rectangle(x-17,y-17,x-3,y-3);
end;

procedure enemyG (x:integer;y:integer);//рисует иконку противника
begin
  setpenwidth (2);
  setbrushstyle (bssolid);
  var i: byte;
  i:=search_enemy(x div 20,y div 20);
  if healht[i]=0 then 
  begin
    setpencolor (clred);
    setbrushcolor (cllime);
  end;
  if healht[i]=1 then 
  begin
    setpencolor (clred);
    setbrushcolor (clmagenta);
  end;
  if healht[i]=2 then 
  begin
    setpencolor (clmaroon);
    setbrushcolor (clred);
  end;
  rectangle(x-17,y-17,x-3,y-3);
end;

procedure enemyG1 (x:integer;y:integer);//рисует иконку противника(при первой прорисовке)
begin
  setpenwidth (2);
  setbrushstyle (bssolid);
  setpencolor (cllime);
  setbrushcolor (clgreen);
  rectangle(x-17,y-17,x-3,y-3);
end;


procedure wallG (x:integer;y:integer);//рисует стену
begin
  setpencolor (clbrown);
  setpenwidth (0);
  setbrushstyle (bssolid);
  setbrushcolor (clbrown);
  rectangle(x-20,y-20,x,y);
end;

procedure rainbowall;
begin
  SetFontSize(30);  
  if dis<13 then dis+=1
  else dis:=1;
  case dis of 
    1:color:=RGB(225,225,0);
    2:color:=RGB(225,180,0);
    3:color:=RGB(225,112,10);
    4:color:=RGB(225,74,10);
    5:color:=RGB(225,0,0);
    6:color:=RGB(158,0,68);
    7:color:=RGB(135,23,113);
    8:color:=RGB(90,45,113);
    9:color:=RGB(45,68,113);
    10:color:=RGB(45,90,90);
    11:color:=RGB(0,113,45);
    12:color:=RGB(135,180,45);
  end;
  SetFontColor(color);
  DrawTextCentered(0,0,1000,430,'You win this one, my dear friend');
  DrawTextCentered(0,40,1000,480,'My congratulations to you');
end;

procedure wayG (x:integer;y:integer);//рисует путь
begin
  setpencolor (clyellow);
  setpenwidth (0);
  setbrushstyle (bssolid);
  setbrushcolor (clyellow);
  rectangle(x-20,y-20,x,y);
end;

procedure damage_enemy (x:integer;y:integer);
begin
  var i:byte;
  i:=search_enemy(x,y);
  wayG(plx*20,ply*20);
  if healht[i]<3 then
  begin
    healht[i]+=1;
    enemyG(x*20,y*20);
  end;
  if healht[i]= 3 then
  begin
    wineN+=1;
    map[x,y]:=1;
    wayG(x*20,y*20);
    enemys[i,1]:=0;
    enemys[i,2]:=0;
  end;
  playerG(plx*20,ply*20);
end;

procedure enemy_turn ();//ход врагов
label down;
var i,i2,i3,i4:byte;
path : array[1..4] of byte;
begin
  for i:=1 to eN do
  begin
    if healht[i]=3 then goto down;
    for i2:=1 to 4 do path[i2]:=0;
    if enemys[i,1]<40 then
    begin
    if (map[enemys[i,1]+1,enemys[i,2]]=1) or (map[enemys[i,1]+1,enemys[i,2]]=3) then
    begin
      if px>=enemys[i,1]+1 then path[1]:= px-(enemys[i,1]+1)
      else path[1]:= (enemys[i,1]+1)-px;
      if py>=enemys[i,2] then path[1]:=path[1] + py-enemys[i,2]
      else path[1]:=path[1] + enemys[i,2]-py;
      if (map[enemys[i,1]+1,enemys[i,2]]=3) then path[1]:=0;
    end
    else path[1]:=200;    
    end
    else path[1]:=200;  
    if enemys[i,1]>1 then
    begin
    if (map[enemys[i,1]-1,enemys[i,2]]=1) or (map[enemys[i,1]-1,enemys[i,2]]=3) then
    begin
      if px>=enemys[i,1]-1 then path[2]:= px-(enemys[i,1]-1)
      else path[2]:= (enemys[i,1]-1)-px;
      if py>=enemys[i,2] then path[2]:=path[2] + py-enemys[i,2]
      else path[2]:=path[2] + enemys[i,2]-py;
      if (map[enemys[i,1]-1,enemys[i,2]]=3) then path[2]:=0;
    end
    else path[2]:=200;
    end
    else path[2]:=200;
     if enemys[i,2]<24 then
     begin
     if (map[enemys[i,1],enemys[i,2]+1]=1) or (map[enemys[i,1],enemys[i,2]+1]=3) then
    begin
      if px>=enemys[i,1] then path[3]:= px-enemys[i,1]
      else path[3]:= enemys[i,1]-px;
      if py>=enemys[i,2]+1 then path[3]:=path[3] + py-(enemys[i,2]+1)
      else path[3]:=path[3] + (enemys[i,2]+1)-py;
      if (map[enemys[i,1],enemys[i,2]+1]=3) then path[3]:=0;
    end
    else path[3]:=200;
    end
    else path[3]:=200;
    if enemys[i,2]>1 then
    begin
    if (map[enemys[i,1],enemys[i,2]-1]=1) or (map[enemys[i,1],enemys[i,2]-1]=3) then
    begin
      if px>=enemys[i,1] then path[4]:= px-enemys[i,1]
      else path[4]:= enemys[i,1]-px;
      if py>=enemys[i,2]-1 then path[4]:=path[4] + py-(enemys[i,2]-1)
      else path[4]:= path[4] + (enemys[i,2]-1)-py;
      if (map[enemys[i,1],enemys[i,2]-1]=3) then path[4]:=0;
    end
    else path[4]:=200;
    end
    else path[4]:=200;
    i2:=path.Min;
    if (path[4]=i2) and (map[enemys[i,1],enemys[i,2]-1]=1) then i3:=4;
    if (path[2]=i2) and (map[enemys[i,1]-1,enemys[i,2]]=1) then i3:=2;
    if (path[3]=i2) and (map[enemys[i,1],enemys[i,2]+1]=1) then i3:=3;
    if (path[1]=i2) and (map[enemys[i,1]+1,enemys[i,2]]=1) then i3:=1;
  {  if (path[1]=i3) and (path[1]=path[2]) and (map[enemys[i,1]+1,enemys[i,2]]=1) and (map[enemys[i,1]-1,enemys[i,2]]=1) then 
      if (random(1)=0) then i3:=1
      else i3:=2; 
    if (path[1]=i3) and (path[1]=path[3]) and (map[enemys[i,1]+1,enemys[i,2]]=1) and (map[enemys[i,1],enemys[i,2]+1]=1) then
      if (random(1)=0) then i3:=1
      else i3:=3;
    if (path[1]=i3) and (path[1]=path[4]) and (map[enemys[i,1]+1,enemys[i,2]]=1) and (map[enemys[i,1],enemys[i,2]-1]=1) then 
      if (random(1)=0) then i3:=1
      else i3:=4;
    if (path[2]=i3) and (path[2]=path[3]) and (map[enemys[i,1]-1,enemys[i,2]]=1) and (map[enemys[i,1],enemys[i,2]+1]=1) then 
      if (random(1)=0) then i3:=2
      else i3:=3;
    if (path[2]=i3) and (path[2]=path[4]) and (map[enemys[i,1]-1,enemys[i,2]]=1) and (map[enemys[i,1],enemys[i,2]-1]=1) then
      if (random(1)=0) then i3:=2
      else i3:=4;
    if (path[3]=i3) and (path[3]=path[4]) and (map[enemys[i,1],enemys[i,2]+1]=1) and (map[enemys[i,1],enemys[i,2]-1]=1) then
      if (random(1)=0) then i3:=3
      else i3:=4;}
    if (i2<dis) and (i2>0) then //передвижение врагов
    begin
    wayG(enemys[i,1]*20,enemys[i,2]*20);
    map[enemys[i,1],enemys[i,2]]:=1;
    case i3 of
    1:begin
        if (map[enemys[i,1]+1,enemys[i,2]]=4) then begin
          enemyG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=4;
          goto down;
        end;
        enemys[i,1]+=1;
      end;
    2:begin
        if (map[enemys[i,1]-1,enemys[i,2]]=4) then begin
          enemyG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=4;
          goto down;        
        end;
        map[enemys[i,1]-1,enemys[i,2]]:=4;
        enemys[i,1]-=1;
      end;
    3:begin
        if (map[enemys[i,1],enemys[i,2]+1]=4) then begin
          enemyG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=4;
          goto down;        
        end;
        enemys[i,2]+=1;
      end;
    4:begin
        if (map[enemys[i,1],enemys[i,2]-1]=4) then begin
          enemyG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=4;
          goto down;        
        end;
        enemys[i,2]-=1;
      end;
    end;
    map[enemys[i,1],enemys[i,2]]:=4;
    enemyG(enemys[i,1]*20,enemys[i,2]*20);
    end
    else if i2=0 then
    begin
    wayG(enemys[i,1]*20,enemys[i,2]*20);
    if plhp>0 then plhp-=1;
    enemyG(enemys[i,1]*20,enemys[i,2]*20);
    end;
    down:
  end;
end;

procedure createmap ();//генерирует карту
var r,i,j,rooms,tx1,ty1,tx2,ty2,eP,i2:byte;
    roomxy:array[1..8,1..4]of byte;
begin
	eN:=0;
	for i:=1 to 40 do
  begin
  	for j:=1 to 24 do
    begin
    	map[i,j]:= 2;
    end;
  end;
  rooms:=random(5,8);
  for r:=1 to rooms do
  begin
    roomxy[r,1]:=random(4,7);//длинна
    roomxy[r,2]:=random(4,6);//ширина
    roomxy[r,3]:=1+random(40-roomxy[r,1]);//координата по х
    roomxy[r,4]:=1+random(24-roomxy[r,2]);//координата по у
    for i:=roomxy[r,3] to roomxy[r,3]+roomxy[r,1] do
    begin
      for j:=roomxy[r,4] to roomxy[r,4]+roomxy[r,2] do
      begin
        map[i,j]:=1;
      end;
    end;
    if r = 1 then 
    begin
    	px:=random(roomxy[1,1])+roomxy[1,3];
      py:=random(roomxy[1,2])+roomxy[1,4];
    end
    else
    begin
    	tx1:=random(roomxy[r-1,1])+roomxy[r-1,3];
      ty1:=random(roomxy[r-1,2])+roomxy[r-1,4];
      tx2:=random(roomxy[r,1])+roomxy[r,3];
      ty2:=random(roomxy[r,2])+roomxy[r,4];
      if (random(1)=0) then
      begin
      	while(tx1<>tx2) do
        begin
        	if(tx1>tx2) then tx1:=tx1-1
          else tx1:=tx1+1;
          map[tx1,ty1]:=1;
        end;
        while(ty1<>ty2) do
        begin
        	if(ty1>ty2) then ty1:=ty1-1
          else ty1:=ty1+1;
          map[tx1,ty1]:=1;
				end;
      end
      else
      begin
      	while(ty1<>ty2) do
        begin
        	if(ty1>ty2) then ty1:=ty1-1
          else ty1:=ty1+1;
          map[tx1,ty1]:=1;
				end;
      	while(tx1<>tx2) do
        begin
        	if(tx1>tx2) then tx1:=tx1-1
          else tx1:=tx1+1;
          map[tx1,ty1]:=1;
        end;
      end;
    	eP:=eN+1;
    	eN:=eN+random(1,3);
      for i:=eP to eN do
      begin
        j:=1;
        while j=1 do
        begin
          j:=1;
     	    enemys[i,1]:=1+random(roomxy[r,1])+roomxy[r,3];//x
          enemys[i,2]:=1+random(roomxy[r,2])+roomxy[r,4];//y
          if (enemys[i,1]=px) and (enemys[i,2]=py) then j:=2;
          if (enemys[i,1]=0) and (enemys[i,2]=0) then j:=2;
          if (enemys[i,1]=0) or (enemys[i,2]=0) then j:=2;
          i2:=0;
          repeat
            i2+=1;
            if (enemys[i2,1]=enemys[i,1]) and (enemys[i2,2]=enemys[i,2]) then j:=2;
          until(i2=21);
        end;
      end;
        map[px,py]:=3;
  for i:=1 to eN do map[enemys[i,1],enemys[i,2]]:=4;
    end;
  end;
end;
procedure drawmap ();//генерирует карту
var i,j:byte;
begin
  for i:=1 to 40 do
  begin
  	for j:=1 to 24 do
    begin
    	case map[i,j] of
      1: wayG (i*20,j*20);
      2: wallG (i*20,j*20);
      3: begin
      wayG(i*20,j*20);
      playerG (i*20,j*20);
      end;
      4: begin
      wayG(i*20,j*20);
      enemyG1 (i*20,j*20);
      end;
      end;
    end;
  end;
end;

procedure KeyPress(key:char); 
begin 
plcontrol:=key; 
end; 

var rainbow:=new timer(100,rainbowall);

begin                                                    //начало кода
  restart:
  setwindowsize (400,200);
  setwindowtitle ('Select difficult');
  SetFontSize(10);
  SetFontColor(clblack);
  setbrushcolor (clwhite);  
  writeln('Select your difficult');
  writeln('Easy(1),    Normal(2),    Hard(3)');
  writeln('Choose one of this and write number');
  more:
  read(plcontrol);
  case plcontrol of
   '1': diff:=1;
   '2': diff:=2;
   '3': diff:=3;
  else goto more;
  end;
  clearWindow;
  for i:=1 to 10 do writeln;
  writeln('Select type of control');
  writeln('If you want to press Enter after every turn, press 0');
  writeln('If you don ',#39,'t want to press Enter after every turn, press 1');
  for i:=1 to 10 do writeln;
  more2:
  read(plcontrol);
  case plcontrol of
  '1': control:=1;
  '0': control:=0;
  else goto more2;
  end;
  createmap();
  drawmap();
  dis:=5;
  case diff of
  1: plhp:=255; //eN*4;
  2: plhp:=eN*3+10;
  3: plhp:=eN*3+1;
  end;
  writeln(eN);
  gameover:=false;
  setwindowsize (1000,480);//размер окна графики
  setwindowtitle ('Game');//название окна графики
  DrawTextCentered(800,0,1000,100,'Player Health');
  
  //основной цикл игры
  while (not gameover) and (wineN<>eN) do
  begin
    SetFontSize(10);
    SetFontColor(clblack);
    setbrushcolor (clwhite);  
    FillRectangle(800,100,1000,200); 
    DrawTextCentered(800,100,1000,200,plhp);
    playerG (px*20,py*20);
    map[px,py]:=1;
    plx:=px;
    ply:=py;
    plcontrol:='0';
    again:
    if control=0 then read(plcontrol)
    else OnKeyPress:=KeyPress;
    case plcontrol of
      '1' : begin
      drawmap;
      goto again;
      end;
      '2': begin
        for i:=1 to eN do if healht[i]<>3 then enemyG(enemys[i,1]*20,enemys[i,2]*20);
        goto again;
      end;
      'w','ц','W','÷':
      begin
      	if py-1>0 then case map[px,py-1] of 
             4: begin      	
                  enx:=px;
                  eny:=py-1;
                 	damage_enemy(enx,eny);
            	  end;
          	 1: ply:=py-1
                    	 end
        else goto again; 
      end;
      'a','ф','A','‘':
      begin
      	if px-1>0 then case map[px-1,py] of 
             4: begin      	
                  enx:=px-1;
                  eny:=py;
                 	damage_enemy(enx,eny);
            	  end;
          	 1: plx:=px-1
                    	 end
        else goto again; 
      end;
      's','ы','S','џ':
      begin
      	if py+1<25 then case map[px,py+1] of 
             4: begin      	
                  enx:=px;
                  eny:=py+1;
                 	damage_enemy(enx,eny);
            	  end;
          	 1: ply:=py+1
                    	 end
        else goto again; 
      end;
      'd','в','D','¬':
      begin
      	if px+1<41 then case map[px+1,py] of 
             4: begin      	
                  enx:=px+1;
                  eny:=py;
                 	damage_enemy(enx,eny);
            	  end;
          	 1: plx:=px+1
                    	 end
        else goto again; 
      end;
      ' ': ;										//пропуск
      'z','€','Z','я': halt;						//выход
      else goto again;					//повторить ввод, если иной символ
    end;
    WayG (px*20,py*20);
    px:=plx;
    py:=ply;
    map[px,py]:=3;
    enemy_turn();
    if plhp=0 then gameover :=true;
    end;
    ClearWindow;
    if gameover=true then
    begin
      SetFontSize(30);
      SetFontColor(clred);
      DrawTextCentered(0,0,1000,480,'WASTED');
      SetFontSize(10);
      DrawTextCentered(0,380,1000,480,'Or Gameover');
      for i:=0 to 100 do
      begin
        OnKeyPress:=KeyPress;
        if plcontrol in['r','R','к',' ' ]then
        begin
          restarts;        
          goto restart;
        end;
        sleep(50);
      end;
      halt;
    end
    else
    begin
      dis:=1;
      rainbow.start;
      for i:=0 to 100 do
      begin
        OnKeyPress:=KeyPress;
        if plcontrol in['r','R','к',' ' ]then
        begin
          restarts;
          rainbow.stop;
          goto restart;
        end;
        sleep(50);
      end;
      halt;
    end;
end.