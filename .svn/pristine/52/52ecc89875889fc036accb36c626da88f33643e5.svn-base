{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
unit MaisProt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Registry;

type
  TMaisProt = class(TComponent)
  private
      DtExpira      :TDate;
   // sCNPJ         :String;
   // iVezes        :Integer;
      sNomeAplic    :String;
      IAplic        :Integer;

      Function  Ck_Copia:Boolean;
      Function  NumeroHd():String;
      Procedure GravarRegistro;
      Function  C(Action, Src: String;Hd:String): String;
      Function  C2(Action, Src: String): String;
      Function  Gera_Chave():String;


  protected

  public
    Property Valida:Boolean Read Ck_Copia;

  published
    Property DataExpiracao :TDate   Read DtExpira Write DtExpira;
 // Property CNPJAutorizado:String  Read sCNPJ Write sCNPJ;
 // Property NoVezes       :Integer Read iVezes Write iVezes;
    Property NomeAplic     :String  Read sNomeAplic Write sNomeAplic;
    Property IDAplic       :Integer Read IAplic    Write IAplic;
  end;

procedure Register;

implementation


Function TMaisProt.Ck_Copia:Boolean;
Var sChave,sChaveDesloqueio,sChaveDesloqueioOK,sParamNome,sAux:String;
    Registro : TRegistry;
Begin
    Try
     if sNomeAplic='' Then
     Begin
         Application.MessageBox('Aplicacao Nao Cadastrada!!'+#10+#13+'  Contate o Suporte!!','Mais Soluções', MB_OK + MB_ICONEXCLAMATION  );
         Result:=False;
         Exit;
     end;

     Registro := TRegistry.Create;
     sAux:=DatetoStr(DataExpiracao);
     if  sAux<>'30/12/1899' Then
       if (DataExpiracao<Date) Then
        Begin
            Registro.DeleteKey('Software\Hewlett Packard');
            Application.MessageBox('Chave de Validação Expirada - Contate o Suporte!!','Mais Soluções', MB_OK + MB_ICONEXCLAMATION );
            Result:=False;
            Exit;
        end;


     if Not(Registro.KeyExists('Software\Hewlett Packard')) Then
     Begin
          sChave:=Gera_Chave;
          sChaveDesloqueio:=InputBox('Chave não Cadastrada-'+sNomeAplic,'Informe esta Chave ao Suporte.: '+sChave,'');
          sChaveDesloqueioOk:=Copy(sChaveDesloqueio,13,length(sChaveDesloqueio));
          if (sChaveDesloqueioOK=C2('D',sChave)) Then
          Begin
              GravarRegistro;
              Result:=True;
              Exit;
          end
          else
          Begin
              Application.MessageBox('Chave de Desbloqueio Inválida!','Mais Soluções', MB_OK + MB_ICONEXCLAMATION );
              Result:=False;
              Exit;
          end;

     end
     else
     Begin
         Registro.OpenKey ('Software\Hewlett Packard', True);
         sParamNome:=(C('D',Registro.ReadString('P1_'+inttostr(iAplic)),NUMEROHD));
         if sParamNome<>sNomeAplic Then
         Begin
             sChave:=Gera_Chave;
             sChaveDesloqueio:=InputBox('Chave não Cadastrada-'+sNomeAplic,'Informe esta Chave ao Suporte.: '+sChave,'');
             sChaveDesloqueioOk:=Copy(sChaveDesloqueio,13,Length(sChaveDesloqueio));
             if (sChaveDesloqueioOk=C2('D',sChave)) Then
             Begin
                 GravarRegistro;
                 Result:=True;
                 Exit;
             end
             else
             Begin
                 Application.MessageBox('Chave de Desbloqueio Inválida!','Mais Soluções', MB_OK + MB_ICONEXCLAMATION );
                 Result:=False;
                 Exit;
            end;
          end
         else Result:=True ;

     end;

    except
         sChave:=Gera_Chave;
         sChaveDesloqueio:=InputBox('Chave não Cadastrada-'+sNomeAplic,'Informe esta Chave ao Suporte.: '+sChave,'');
         sChaveDesloqueioOk:=Copy(sChaveDesloqueio,13,Length(sChaveDesloqueio));
         if (sChaveDesloqueioOK=C2('D',sChave)) Then
         Begin
             GravarRegistro;
             Result:=True;
             Exit;
         end
         else
         Begin
             Application.MessageBox('Chave de Desbloqueio Inválida!','Mais Soluções', MB_OK + MB_ICONEXCLAMATION );
             Result:=False;
             Exit;
         end;
    end;
end;

Function TMaisProt.NumeroHd():String;
var Serial,DirLen,Flags:DWord;
    DLabel: Array[0..11] of Char;
Begin
    GetVolumeInformation(Pchar('C:\'),dLabel,12,@Serial,Dirlen,Flags,nil,0);
    Result:=IntToHex(Serial,8);
end;

procedure TMaisProt.GravarRegistro;
var   Registro : TRegistry;
begin
    Registro := TRegistry.Create;
    Registro.OpenKey ('Software\Hewlett Packard', True);
    Registro.WriteString('P1_'+inttostr(iAplic),C('C',sNomeAplic,NUMEROHD));
    Registro.CloseKey;
    Registro.Free;
end;

Function TMaisProt.C(Action, Src: String;Hd:String): String;
var KeyLen,KeyPos,OffSet,SrcPos,SrcAsc,TmpSrcAsc,Range  : Integer;
    Dest, Key : String;
    Label Fim;

Begin
    if (Src = '') Then
    Begin
        Result:= '';
        Goto Fim;
    end;
    Key :='YUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMM4A4VZYW9KHJUI2347EJHJKDF3424SKL K3LAKDJSL9RTIKJ';
    key:=Hd+Key;
    Dest := '';
    KeyLen := Length(Key);
    KeyPos := 0;
    Range := 256;
    if (Action = UpperCase('C')) then
    Begin
        Randomize;
        OffSet := Random(Range);
        Dest := Format('%1.2x',[OffSet]);
        for SrcPos := 1 to Length(Src) do
        Begin
            Application.ProcessMessages;
            SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
            if KeyPos < KeyLen then KeyPos := KeyPos + 1 else KeyPos := 1;
            SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
            Dest := Dest + Format('%1.2x',[SrcAsc]);
            OffSet := SrcAsc;
       end;
   end
   Else if (Action = UpperCase('D')) then
   Begin
       OffSet := StrToInt('$'+ copy(Src,1,2));
       SrcPos := 3;
       repeat
          SrcAsc := StrToInt('$'+ copy(Src,SrcPos,2));
          if (KeyPos < KeyLen) Then KeyPos := KeyPos + 1 else KeyPos := 1;
          TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
          if TmpSrcAsc <= OffSet then TmpSrcAsc := 255 + TmpSrcAsc - OffSet
          else TmpSrcAsc := TmpSrcAsc - OffSet;
          Dest := Dest + Chr(TmpSrcAsc);
          OffSet := SrcAsc;
          SrcPos := SrcPos + 2;
      until (SrcPos >= Length(Src));
  end;
  Result:= Dest;
  Fim:
end;


Function TMaisProt.C2(Action, Src: String): String;
var KeyLen,KeyPos,OffSet,SrcPos,SrcAsc,TmpSrcAsc,Range  : Integer;
    Dest, Key : String;
    Label Fim;

Begin
    if (Src = '') Then
    Begin
        Result:= '';
        Goto Fim;
    end;
    Key :='YUQL23KL23DF90WI5E1JAS467NMCXXL6JAOAUWWMCL0AOMM4A4VZYW9KHJUI2347EJHJKDF3424SKL K3LAKDJSL9RTIKJ';
    key:='842677E'+Key;
    Dest := '';
    KeyLen := Length(Key);
    KeyPos := 0;
    Range := 256;
    if (Action = UpperCase('C')) then
    Begin
        Randomize;
        OffSet := Random(Range);
        Dest := Format('%1.2x',[OffSet]);
        for SrcPos := 1 to Length(Src) do
        Begin
            Application.ProcessMessages;
            SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
            if KeyPos < KeyLen then KeyPos := KeyPos + 1 else KeyPos := 1;
            SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
            Dest := Dest + Format('%1.2x',[SrcAsc]);
            OffSet := SrcAsc;
       end;
   end
   Else if (Action = UpperCase('D')) then
   Begin
       OffSet := StrToInt('$'+ copy(Src,1,2));
       SrcPos := 3;
       repeat
          SrcAsc := StrToInt('$'+ copy(Src,SrcPos,2));
          if (KeyPos < KeyLen) Then KeyPos := KeyPos + 1 else KeyPos := 1;
          TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
          if TmpSrcAsc <= OffSet then TmpSrcAsc := 255 + TmpSrcAsc - OffSet
          else TmpSrcAsc := TmpSrcAsc - OffSet;
          Dest := Dest + Chr(TmpSrcAsc);
          OffSet := SrcAsc;
          SrcPos := SrcPos + 2;
      until (SrcPos >= Length(Src));
  end;
  Result:= Dest;
  Fim:
end;



Function TMaisProt.Gera_Chave():String;
Var iAux:Integer;
Begin
      Randomize;
      iAux:=Random(99999);
      Result:=C2('C',inttostr(iAux));
end;


procedure Register;
begin
  RegisterComponents('Mais Solucoes', [TMaisProt]);
end;


end.
