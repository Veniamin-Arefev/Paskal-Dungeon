uses graphABC;
type massiv = array [1..40] of array [1..24] of integer;
label again;
var px,py,plx,ply:byte;
  plcontrol:char;
  enx,eny:integer;
  gameover:boolean;
  map : massiv;
	enemys:array[1..21,1..2]of byte;
  roomxy:array[1..8,1..4]of byte;
  
  
procedure playerG (x:integer;y:integer);//������ ������ ������
begin
  setpencolor (clblue);
  setpenwidth (2);
  setbrushstyle (bssolid);
  setbrushcolor (clskyblue);
  rectangle(x-17,y-17,x-3,y-3);
end;

procedure enemyG (x:integer;y:integer);//������ ������ ����������
begin
  setpencolor (clmaroon);
  setpenwidth (2);
  setbrushstyle (bssolid);
  setbrushcolor (clred);
  rectangle(x-17,y-17,x-3,y-3);
end;

procedure wallG (x:integer;y:integer);//������ �����
begin
  setpencolor (clbrown);
  setpenwidth (0);
  setbrushstyle (bssolid);
  setbrushcolor (clbrown);
  rectangle(x-20,y-20,x,y);
end;

procedure wayG (x:integer;y:integer);//������ ����
begin
  setpencolor (clyellow);
  setpenwidth (0);
  setbrushstyle (bssolid);
  setbrushcolor (clyellow);
  rectangle(x-20,y-20,x,y);
end;

procedure createmap ();//���������� �����
var r,i,j,rooms,tx1,ty1,tx2,ty2,eN,eP:byte;
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
    roomxy[r,1]:=random(4,7);//������
    roomxy[r,2]:=random(4,6);//������
    roomxy[r,3]:=1+random(40-roomxy[r,1]);//���������� �� �
    roomxy[r,4]:=1+random(24-roomxy[r,2]);//���������� �� �
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
     	  enemys[i,1]:=random(roomxy[r,1])+roomxy[r,3];
        enemys[i,2]:=random(roomxy[r,2])+roomxy[r,4];
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
      4: enemyG (i*20,j*20);
      end;
    end;
  end;
end;

begin
  createmap();
  map[px,py]:=1;
  gameover:=false;
  setwindowsize (800,480);//������ ���� �������
  setwindowtitle ('Game');//�������� ���� �������
  
  //�������� ���� ����
  while not gameover do
  begin
    playerG (px*20,py*20);
    plx:=px;
    ply:=py;
    again:
    read (plcontrol);
    case plcontrol of
      'w','�':
      begin
      	if py-1>0 then if (map[px,py-1]=1) then ply:=py-1
        else goto again;
      end;
      'a','�':
      begin
      	if px-1>0 then if (map[px-1,py]=1) then plx:=px-1
      	else goto again;
      end;
      's','�':
      begin
      	if py+1<25 then if (map[px,py+1]=1) then ply:=py+1
      	else goto again;
      end;
      'd','�':
      begin
      	if px+1<41 then if (map[px+1,py]=1) then plx:=px+1
      	else goto again;
      end;
      ' ': ;										//�������
      'z','�': halt;						//�����
      else goto again;					//��������� ����, ���� ���� ������
    end;
    WayG (px*20,py*20);
    setpencolor (clblack);
    setpenwidth (3);
    px:=plx;
    py:=ply;
  end;
end.