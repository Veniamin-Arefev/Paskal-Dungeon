program GameV12;
uses graphABC;
type massiv = array [1..40] of array [1..24] of integer;
label again;
var px,py,plx,ply,eN,dis,plhp:byte;
  plcontrol:char;
  enx,eny:integer;
  gameover:boolean;
  map : massiv;
	enemys:array[1..21,1..2]of byte;
	healht:array[1..21] of byte;
  roomxy:array[1..8,1..4]of byte;

function search_enemy ( x , y : byte): byte;
  begin
  var i : byte;
  i:=0;
    repeat
      i+=1;
      if (enemys[i,1]=x) and (enemys[i,2]=y) then
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
    setpencolor (cllime);
    setbrushcolor (clgreen);
  end;
  if healht[i]=1 then 
  begin
    setpencolor (clmagenta);
    setbrushcolor (clmagenta);
  end;
  if healht[i]=2 then 
  begin
    setpencolor (clmaroon);
    setbrushcolor (clred);
  end;
  rectangle(x-17,y-17,x-3,y-3);
end;

procedure enemyG1 (x:integer;y:integer);//рисует иконку противника
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

procedure wayG (x:integer;y:integer);//рисует путь
begin
  setpencolor (clyellow);
  setpenwidth (0);
  setbrushstyle (bssolid);
  setbrushcolor (clMediumSpringGreen);
  rectangle(x-20,y-20,x,y);
end;

procedure damage_enemy (x:integer;y:integer);//надо переделать
begin
  var i:byte;
  i:=search_enemy(x,y);
  if healht[i]<3 then
  begin
    healht[i]+=1;
    enemyG(x*20,y*20);
  end;
  if healht[i]= 3 then
  begin
    map[x,y]:=1;
    wayG(x*20,y*20);
  end;
end;

procedure enemy_turn ();//рисует путь
label  down;
var i:byte;
begin
    for i:=1 to eN do
    begin
      if healht[i]=3 then goto down;
      if enemys[i,1]=px then if (enemys[i,2]+dis>py) and (enemys[i,2]<py) and (map[enemys[i,1],enemys[i,2]+1]=1) then//👉
        begin
          wayG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=1;
          enemys[i,2]+=1;
          enemyG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=4;
        end
        else if (enemys[i,2]-dis<py) and (enemys[i,2]>py)  and (map[enemys[i,1],enemys[i,2]-1]=1) then//👈
        begin
          wayG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=1;
          enemys[i,2]-=1;
          enemyG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=4;
        end;
      if enemys[i,2]=py then if (enemys[i,1]+dis>px) and (enemys[i,1]<px) and (map[enemys[i,1]+1,enemys[i,2]]=1) then //👇
        begin
          wayG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=1;
          enemys[i,1]+=1;
          enemyG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=4;
        end
        else if (enemys[i,1]-dis<px) and (enemys[i,1]>px) and (map[enemys[i,1]-1,enemys[i,2]]=1) then //👆
        begin
          wayG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=1;
          enemys[i,1]-=1;
          enemyG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=4;
        end;
      
      if enemys[i,1]<px then if enemys[i,1]+dis>px then
      if enemys[i,2]<py then if enemys[i,2]+dis>py then
      begin//x1,y1
      if random(1)=0 then if map[enemys[i,1],enemys[i,2]+1]=1 then begin
          wayG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=1;
          enemys[i,2]+=1;
          enemyG(enemys[i,1]*20,enemys[i,2]*20);
          map[enemys[i,1],enemys[i,2]]:=4;
        end
      else if map[enemys[i,1]+1,enemys[i,2]]=1 then begin
           wayG(enemys[i,1]*20,enemys[i,2]*20);
           map[enemys[i,1],enemys[i,2]]:=1;
           enemys[i,1]+=1;
           enemyG(enemys[i,1]*20,enemys[i,2]*20);
           map[enemys[i,1],enemys[i,2]]:=4;
         end;
       end;
      if enemys[i,1]<px then if enemys[i,1]+dis>px then
      if enemys[i,2]>py then if enemys[i,2]-dis<py then
      begin//x1,y2
      if random(1)=0 then if map[enemys[i,1],enemys[i,2]-1]=1 then begin
        wayG(enemys[i,1]*20,enemys[i,2]*20);
        map[enemys[i,1],enemys[i,2]]:=1;
        enemys[i,2]-=1;
        enemyG(enemys[i,1]*20,enemys[i,2]*20);
        map[enemys[i,1],enemys[i,2]]:=4;
      end
      else if map[enemys[i,1]-1,enemys[i,2]]=1 then begin
      wayG(enemys[i,1]*20,enemys[i,2]*20);
      map[enemys[i,1],enemys[i,2]]:=1;
      enemys[i,1]-=1;
      enemyG(enemys[i,1]*20,enemys[i,2]*20);
      map[enemys[i,1],enemys[i,2]]:=4;
      end;
     end;
                                                       
      if enemys[i,1]>px then if enemys[i,1]-dis<px then
      if enemys[i,2]<py then if enemys[i,2]+dis>py then
      begin//x2,y1
      if random(1)=0 then if map[enemys[i,1],enemys[i,2]+1]=1 then begin
      wayG(enemys[i,1]*20,enemys[i,2]*20);
      map[enemys[i,1],enemys[i,2]]:=1;
      enemys[i,2]+=1;
      enemyG(enemys[i,1]*20,enemys[i,2]*20);
      map[enemys[i,1],enemys[i,2]]:=4;
      end
      else if map[enemys[i,1]-1,enemys[i,2]]=1 then begin
       wayG(enemys[i,1]*20,enemys[i,2]*20);
       map[enemys[i,1],enemys[i,2]]:=1;
       enemys[i,1]-=1;
       enemyG(enemys[i,1]*20,enemys[i,2]*20);
       map[enemys[i,1],enemys[i,2]]:=4;
      end;
                                                       end;
      if enemys[i,1]>px then if enemys[i,1]-dis<px then
      if enemys[i,2]>py then if enemys[i,2]-dis<py then
      begin//x2,y2
       if random(1)=0 then if map[enemys[i,1],enemys[i,2]-1]=1 then begin
       wayG(enemys[i,1]*20,enemys[i,2]*20);
       map[enemys[i,1],enemys[i,2]]:=1;
       enemys[i,2]-=1;
       enemyG(enemys[i,1]*20,enemys[i,2]*20);
       map[enemys[i,1],enemys[i,2]]:=4;
      end
      else if map[enemys[i,1]-1,enemys[i,2]]=1 then begin
        wayG(enemys[i,1]*20,enemys[i,2]*20);
                                                           map[enemys[i,1],enemys[i,2]]:=1;
                                                           enemys[i,1]-=1;
                                                           enemyG(enemys[i,1]*20,enemys[i,2]*20);
                                                           map[enemys[i,1],enemys[i,2]]:=4;
                                                         end;
                                                       end;
    down:

    end;
end;

procedure createmap ();//генерирует карту
var r,i,j,rooms,tx1,ty1,tx2,ty2,eP:byte;
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
     	  enemys[i,1]:=random(roomxy[r,1])+roomxy[r,3];//x
        enemys[i,2]:=random(roomxy[r,2])+roomxy[r,4];//y
        map[enemys[i,1],enemys[i,2]]:=4;
      end;
    end;
    map[px,py]:=3;
  end;
  
  for i:=1 to 40 do
  begin
  	for j:=1 to 24 do
    begin
    	case map[i,j] of
      1: wayG (i*20,j*20);
      2: wallG (i*20,j*20);
      3: playerG (i*20,j*20);
      4: enemyG1 (i*20,j*20);
      end;
    end;
  end;
end;

begin
  createmap();
  gameover:=false;
  setwindowsize (800,480);//размер окна графики
  setwindowtitle ('Game');//название окна графики
  
  //основной цикл игры
  while not gameover do
  begin
    dis:=5;
    playerG (px*20,py*20);
    map[px,py]:=1;
    plx:=px;
    ply:=py;
    again:
    read (plcontrol);
    case plcontrol of
      'w','ц':
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
      'a','ф':
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
      's','ы':
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
      'd','в':
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
      'z','я': halt;						//выход
      else goto again;					//повторить ввод, если иной символ
    end;
    WayG (px*20,py*20);
//    setpencolor (clblack);
//    setpenwidth (3);
    px:=plx;
    py:=ply;
    map[px,py]:=3;
    enemy_turn();
    end;
end.