uses graphABC;
label again;
var plx,ply,plxn,plyn:integer;
  plcontrol:char;
  enx,eny:integer;
  gameover:boolean;
  map : array of  array of byte;

procedure playerG (x:integer;y:integer);//������ ������ ������
begin
  setpencolor (clblue);
  setpenwidth (2);
  setbrushstyle (bssolid);
  setbrushcolor (clskyblue);
  rectangle(x-10,y-10,x+10,y+10);
end;

procedure enemyG (x:integer;y:integer);//������ ������ ����������
begin
  setpencolor (clmaroon);
  setpenwidth (2);
  setbrushstyle (bssolid);
  setbrushcolor (clred);
  rectangle(x-10,y-10,x+10,y+10);
end;

procedure wallG (x:integer;y:integer);//������ �����
begin
  setpencolor (clbrown);
  setpenwidth (0);
  setbrushstyle (bssolid);
  setbrushcolor (clbrown);
  rectangle(x-10,y-10,x+10,y+10);
end;

procedure wayG (x:integer;y:integer);//������ ����
begin
  setpencolor (clyellow);
  setpenwidth (0);
  setbrushstyle (bssolid);
  setbrushcolor (clyellow);
  rectangle(x-10,y-10,x+10,y+10);
end;

procedure createmap (map:array of array of byte);//���������� �����
var r,i,j,rooms,px,py:byte;
  roomxy:array[1..5,1..4]of byte;
begin
  SetLength(map,40);
  for i := 0 to 39 do
    SetLength(map[i],24);
	for i:=0 to 39 do
  begin
  	for j:=0 to 23 do
    begin
    	map[i,j]:= 2;
    end;
  end;
  rooms:=random(3,5);
  for r:=1 to rooms do
  begin
    roomxy[r,1]:=random(3,7);//������
    roomxy[r,2]:=random(2,5);//������
    roomxy[r,3]:=random(39-roomxy[r,1]);//���������� �� �
    roomxy[r,4]:=random(23-roomxy[r,2]);//���������� �� �
    if r = 1 then 
    begin
    	px:=random(roomxy[1,1]);
      py:=random(roomxy[1,2]);
    end;
    //else ����������
    for i:=roomxy[r,3] to roomxy[r,3]+roomxy[r,1] do
    begin
      for j:=roomxy[r,4] to roomxy[r,4]+roomxy[r,2] do
      begin
        map[i,j]:=1;
        if ((px = i) and (py = j) and (r = 1)) then map[i,j]:=3;
      end;
    end;
  end;
  //�������
  for i:=0 to 39 do
  begin
  	for j:=0 to 23 do
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
  createmap(map);
  gameover:=false;
  setwindowsize (800,480);//������ ���� �������
  setwindowtitle ('Game');//�������� ���� �������
  setpencolor (clblack);//��� ���� ����
  setpenwidth (3);//��� ������ ����
  line(80,0,80,480);//����� ��� ��������� ���� (����� ��� ������)
  writeln ('log:');//���������� ��� ���
  
  //�������� ���� ����
  while not gameover do
  begin
    playerG (plx,ply);
    plxn:=plx;
    plyn:=ply;
    again:
    read (plcontrol);
    case plcontrol of
      'w','�': plyn:=ply-20;		//�����
      'a','�': plxn:=plx-20;		//�����
      's','�': plyn:=ply+20;		//����
      'd','�': plxn:=plx+20;		//������
      ' ': ;										//�������
      'z','�': halt;						//�����
      else goto again;					//��������� ����, ���� ���� ������
    end;
    writeln ('step'); //������ � ��� '��� �� ���?'
    //clearG (plx,ply);
    setpencolor (clblack);
    setpenwidth (3);
    line(80,0,80,480);
    plx:=plxn;
    ply:=plyn;
    if (plx > 800)or(plx < 0)or(plY > 480)or(ply < 0) then 
    begin
      //writeln ('GAMEOVER');//������������ � setbrush
      textout (100,100,'BORDER!!!');
    end;
  end;
end.