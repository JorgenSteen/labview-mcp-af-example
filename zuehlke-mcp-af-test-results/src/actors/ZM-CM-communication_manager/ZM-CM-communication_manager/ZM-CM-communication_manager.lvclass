<?xml version='1.0' encoding='UTF-8'?>
<LVClass LVVersion="26008000">
	<Property Name="NI.Lib.ContainingLib" Type="Str">ZM-CM-communication_manager.lvlib</Property>
	<Property Name="NI.Lib.ContainingLibPath" Type="Str">../../ZM-CM-communication_manager.lvlib</Property>
	<Property Name="NI.Lib.Description" Type="Str">Communication manager actor: owns a communication protocol object from its pre-launch settings, initialises it in Pre Launch Init (createResources), hands every package it receives to it (publish), and closes it in Stop Core. Error plan (D40, for now): evaluateError is a pass-through; an error stops the actor, and its Last Ack stops the root and through it the whole tree.</Property>
	<Property Name="NI.Lib.Icon" Type="Bin">*A#!!!!!!!)!"1!&amp;!!!-!%!!!@````]!!!!"!!%!!!*N!!!*Q(C=V:5^DB."%%9`)Q*3HQ$EV'&amp;&gt;Q6&gt;QP&amp;F&gt;Q;F$*SO26L4%PA&amp;SQA(K!A37/)'V'3);8P=5#%M\HB5`!LJ&gt;HJGPKKP?&gt;,@&lt;5G_PJ*=;ZNL^T8&lt;NF_Z&lt;H`+LB`SC`U&lt;_O@KT`$`DV]XW0`B\S%1=`K((4#1KXZ3\DRO'^&lt;J&gt;*PSYJ@6%BG@Y:`,0]4XD`@L.Z0C&lt;\?`\:RIR_^GA0^SER&lt;?64#QQRWS=`520^%20^%20^%!0^%!0^%!0&gt;%&gt;X&gt;%&gt;X&gt;%&gt;X&gt;%-X&gt;%-X&gt;%/XNL#NIQN&gt;[,+_W%HRJ&amp;#3.%G1")/CZ#PB38A3HI3(2S5]#5`#E`!E0)1IY5FY%J[%*_&amp;BG"+?B#@B38A3(F*VEOQ&gt;(:[%B`1+?!+?A#@A#8AIK9!H!!C+"9G$*'!I=!9X!5`!%`"QKY!HY!FY!J[!"\=#HI!HY!FY!B['^&amp;G*4N-[/DSEE=0D]$A]$I`$1WIZ0![0Q_0Q/$S5E]0D]$A14E%H/1BS"DE"TI0$Y`"QE=0D]$A]$I`$A[OPE0?:;43NI].D]"A]"I`"9`#11A;0Q70Q'$Q'$WFF]"A]"I`"9`"13A;0Q70Q'#"'5=L,3'9-.))-Q?$BUX?,^67+4G+^VU^TX+CK$;D;7+I.I^I)KA67,:RK1614L:J!V=3I8FDV)CJ!67&amp;61F7A,HS@M2.WR!\9$NNC'WS&amp;,&gt;P1XRRYO6RU0J^V/JVU0"ZV/"SUW_WUX7[VW7SU7KWU8#[`HV:P['.&lt;8*V,8_['Y@0LMLPR_9?W*`YJ?\P8YPU(,2[Y@HSHR?/HU&gt;L^1`F;T&amp;.DRX0J8TA&lt;^?,KXYEZ_ALKP&gt;N(!!!!!!</Property>
	<Property Name="NI.Lib.SourceVersion" Type="Int">637566976</Property>
	<Property Name="NI.Lib.Version" Type="Str">1.0.0.0</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Property Name="NI.LVClass.ClassNameVisibleInProbe" Type="Bool">true</Property>
	<Property Name="NI.LVClass.DataValRefToSelfLimitedLibFlag" Type="Bool">true</Property>
	<Property Name="NI.LVClass.FlattenedPrivateDataCTL" Type="Bin">*A#!!!!!!!)!"1!&amp;!!!-!%!!!@````]!!!!"!!%!!#)95F.31QU+!!.-6E.$4%*76Q!!(41!!!4E!!!!)!!!(21!!!"+!!!!!C&amp;;43V$43VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8WVB&lt;G&amp;H:8)O&lt;(:M;7)D7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,GRW9WRB=X-!!!!!!+!G!)!!!$!!!#A!"!!!!!!%!!-!0!#]!"^!A!)!!!!!!1!"!!&lt;`````!!!!!!!!!!!!!!!!F2O,9+Q1_5;1`$'1ZW0!&amp;Q!!!!Q!!!!1!!!!!$M6N8[;2E&gt;+MOY7#,EVXX85(9T:DQ#S"/G!#:DM_%*_!!!!!!!!!!#W*5CTJM0=1LU&gt;5L1&gt;@H9(!1!!!0`````5(9T:DQ#S"/G!#:DM_%*_!!!!%#%HLDO&amp;!2I0&lt;^\73,&gt;W&gt;GI!!!!%!!!!!!!!!8A!!5R71U-!!!!$!!*735R#!!!!!&amp;"53$!!!!!&amp;!!%!!1!!!!!#!!*735.$!!!!!!%=7EUN1UUN5&amp;*&amp;4%&amp;64E.)8V.&amp;6&amp;2*4E&gt;4,G.U&lt;!"16%AQ!!!!)Q!"!!-!!"R;43V$43V15E6-166/1UB@5U656%F/2V-O9X2M!!!!!A!"1A!!!!!!!F:*5%E!!!!!!!-C7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;GRJ9C2;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW9WRB=X-#"Q!!5&amp;2)-!!!!(%!!1!*!!!!!!!)=(*P&gt;'^D&lt;WQ=7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;"R;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M*&amp;J.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:D&lt;'&amp;T=Q!!!!!!!!!!!1!!!!!!!!!"!!!!!!)!!!!!!!!!!!!!!!!$!!!!!A!#!!!!!!!D!!!!'HC=9W"H9'ZAO-!!R)Q-4!V-'E$7"Q9'$A%'!%0V"/!!!!!!&amp;!!!!!RYH'.A9?"CY!"$"A!"#A!H!!!!31!!!2BYH'.AQ!4`A1")-4)Q-$U!UCRIYG!;RK9GQ'5O,LOAYMR1.\,#B)(OXA/EG5"S5$5]%#GG+U"]!NU=@CB^!%E-!*PT+1U!!!!!!!!-!!&amp;73524!!!!!!!$!!!"LA!!"'RYH%NA:'$).,9Q/Q#EG9&amp;9D;'")4E`*:78!=BHA)!X4!Q5AQ#I?6JIYNUO+CT..3I]4+6]`UN5/!*?A!3&lt;DX!=\P&lt;)/?ZI!V&lt;#E=71R2$Q0T#D_1D0Y41QU//8&lt;Q(LTW)!;B-"9;B/C!KY@,?0#IPBA9:+:9:3Y?/.*IQ17Q/BCFE/%^10&gt;"`1$)[$$VF[*Y)&amp;/E&amp;E:QCDR(%82BUR),O8BT%1Y7YU^Y6V!XW6R2A'E_^G/_[A!7)@&gt;R#"5"E1KA*#&amp;9#I(3!C\D!RY&lt;LW^&lt;V&gt;L%#;$5H-!9I&lt;A"A5LT#MR]$)!!I!*C!%7@@H````.E!2*KC9)&amp;1-R$Y*:4-SW-0V&gt;%0&amp;.*$-?1H8AV$H$26T1()0S![147O"N!;5P2H+&lt;I#[(S4W&amp;=I(M@]![11I'Z1W&amp;U$:8."9",%&amp;A?Q(5,99F(U!+I^//`O\O#+((3B&gt;Q^)YS&amp;X*O15'"HL6V=[V/MY[J4[VVE#G4:3PLH/!&lt;H*_&lt;GZJ8G:S9EFG@FZ]16&amp;_38ZS@IZ?4FF/:J)6!38*/9H&amp;R8:!-[FG&amp;MBR10?O!&lt;GZ),FMK$A:!(R&lt;!P%!!!!!!1M!!!)-?*RT9'"AS$3W-'.A:'"A"G)VBA;'Z0S56!9EY-$)A"/%BT7`%?CO56(I,F'2[3R2Y?GM5?%!UCS&gt;.CLB93^!3JK0=(1?.$T1?J*`SM%3FIY4LTW;D\'!F$9@:Q'JRK6-M&gt;N&amp;B;@8A[842Y7HWU?&amp;IT?1J4.%B;-\A-8QA(5A#`_5!]V("/,C$_.W("&amp;A\?N\OU$?1`;C!R"`"IIQ!7E1FA@C0````Q?RX;"M"[B;:X]86`3Q!JGV&amp;IC4=QM-$03KKZVL&gt;:RV3HVKL9&amp;-GSB@8?=!X?4]X.T3P-TER*,-`,TYAK,]EPTE`"S^H,+=T#1L!EK3=R+,C_W!:F,.,*$DA/Y&amp;!(+GA[5!!!!!^!!!!=BYH(.A9'$).,9Q/Q#EG2E:'.19'BC3]V.3':!")Q./%"\7`%;AOU:&amp;I&lt;N%2;;T2)7HMU;&amp;!UCT&gt;.KIB)?^!#FJ0M,2?K$5KPE9#UC__4A,3!G+H&amp;SXCQJ0LQ&gt;,JY]+4\?0#E&gt;P)%NHC!J(NQ.,JS/,Y9(G)Q*R]9?RW\`W^&lt;V&gt;D'B/&gt;!$CNU!2*C!.QP*!`/@```]AND75\1"6[_TPYILO6Z":;Y!YO3#Z4+_[WLF7RVGHV+@7'MCUC@,6&gt;1\14=\0T3X.SUR/,-H-TYMP+-IPS5`/T^(,+=P*4,)CI#1Z*\'YW!ZI*N8-!DE/!'Q!&gt;MQ!!!!4!!!!#8C=9W"A9'2E!!)!!"1!!Q!!!!!/*D'!!1!!"D)W,D-O-1!!!!!!!!QG!)!!!!!%-D9O-!!!!!!/*D'!!1!!"D)W,D-O-1!!!!!!!!QG!)!!!!!%-D9O-!!!!!!/*D'!!1!!"D)W,D-O-1!!!!!!!"1"!!!!^6=VAHEGIIQO=V*/"EEZH1!!!!U!!!!!!!!!!!!!!!!!!!!!!!!!A0````_!!!!"A!!!!9!!!!'!!!!"A!!!!9!!!!'!!!!"A!!!!9!!!!'!!!!"A!!!!9"A!!'"G!!"BA9!!:A"A!'A!%!"M!$!!;Q$1!'D$M!"I06!!;!KQ!'A.5!"I#L!!;!V1!'A+M!"I$6!!:ALA!''.A!"A&lt;A!!9"A!!(`````!!!%!0```````````````````````````````````````````Q!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!0``!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!``]!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$``Q!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!0``!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!``]!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$``Q!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!0``!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!``]!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$``Q!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!0``!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!``]!!!!!!!!!!!5&amp;!!!!!!!!!!!!!!!!!!!!!!!!!!$``Q!!!!!!!!7N79/N"1!!!!!!!!!!!!!!!!!!!!!!!0``!!!!!!7N73]P,S_$L15!!!!!!!!!!!!!!!!!!!!!``]!!!7N73]P,S]P,S]PA[U&amp;!!!!!!!!!!!!!!!!!!$``Q#$73]P,S]P,S]P,S]P,Y/N!!!!!!!!!!!!!!!!!0``!&amp;F:,S]P,S]P,S]P,S]P`I-!!!!!!!!!!!!!!!!!``]!79/$73]P,S]P,S]P`P\_71!!!!!!!!!!!!!!!!$``Q":AY/$AVEP,S]P`P\_`PZ:!!!!!!!!!!!!!!!!!0``!&amp;G$AY/$AY.:L@\_`P\_`FE!!!!!!!!!!!!!!!!!``]!79/$AY/$AY0_`P\_`P\_71!!!!!!!!!!!!!!!!$``Q":AY/$AY/$A`\_`P\_`PZ:!!!!!!!!!!!!!!!!!0``!&amp;G$AY/$AY/$`P\_`P\_`FE!!!!!!!!!!!!!!!!!``]!79/$AY/$AY0_`P\_`P\_71!!!!!!!!!!!!!!!!$``Q":AY/$AY/$A`\_`P\_`PZ:!!!!!!!!!!!!!!!!!0``!)/$AY/$AY/$`P\_`P\_AY-!!!!!!!!!!!!!!!!!``]!!&amp;F:AY/$AY0_`P\_A[V:!!!!!!!!!!!!!!!!!!$``Q!!!!":AY/$A`\_AY.:!!!!!!!!!!!!!!!!!!!!!0``!!!!!!!!79/$AY-P!!!!!!!!!!!!!!!!!!!!!!!!``]!!!!!!!!!!&amp;EP!!!!!!!!!!!!!!!!!!!!!!!!!!$```````````````````````````````````````````]!!!!#!!)!!!!!!HI!!5:13&amp;!!!!!$!!*'5&amp;"*!!!!!S*;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW&lt;'FC*&amp;J.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:D&lt;'&amp;T=Q)(!!"16%AQ!!!!=1!"!!E!!!!!!!BQ=G^U&lt;W.P&lt;"R;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M(&amp;J.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQE7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;G.M98.T!!!!!!!!!!!"!!!!!!!!!!%!!!!!!A!!!!!!!!!!!!!!!!!!!!!#!!!!7A!!!'9!!F2%1U-!!!!!!!%=7EUN1UUN5&amp;*&amp;4%&amp;64E.)8V.&amp;6&amp;2*4E&gt;4,G.U&lt;!"16%AQ!!!!)Q!"!!-!!"R;43V$43V15E6-166/1UB@5U656%F/2V-O9X2M!!!!!A!!1A!!!!!!!!!"!!!!1&amp;"53$!!!!!!!!!!!!!#2%2131!!!!!!!S*;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW&lt;'FC*&amp;J.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:D&lt;'&amp;T=Q)(!!"16%AQ!!!!=1!"!!E!!!!!!!BQ=G^U&lt;W.P&lt;"R;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M(&amp;J.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQE7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;G.M98.T!!!!!!!!!!!"!!!!!!!!!!%!!!!!!A!!!!!!!!!!!!!!!!!!!!!"!!!!"A!$!!!!!!!1!!!!!Q!!!!!!!!!!!!!!!!!!"2Y!!!V[?*SV6UNM'V55P=_?J/.]S$B.WBA3`.(96)A55R!%CUJ.-QEED5K&lt;.!AM3/NYH!_VYO"0[!+V1L)CMKC1'B%*KEIMIECMOIAK.FE!=NC-%,!*)E7YT9).#VB1N1I&gt;G`O?0:Y:/\7DK.DSU]B_Z^\\TDFT\RCA?6\IM/4AMAJ%O)=8QSIUS!I"S(4T5(TZ&amp;E!9)`]#;8-1&amp;4\CRY4&lt;FBTJ6+&amp;*6HS]8VK%PX&amp;X`E\_'HR'C(!8N^9,$AT7I%+,L"QG1W*7%'^WCINV7F1\&gt;!F83=\SNOC]TV^.RT!BJ)`1V&gt;Z.=E!E.]?F07&gt;#MZ'U3,_V&gt;@-/&amp;N+GAC!JT8%R_QR'R.4@M:"E(&amp;:)4!M*'0))L+WN[3"\!?2D:@21T!K'P58'KW";%:-1M]]R4!0$9*Z&lt;7B\*G6OCN6.1/@3AK#!39:?U%[^IK33H?I,"NL?X%9:L%4;N1JO90=E\_,PS6FXTW@481)"ETP0Z8`*@5&lt;T^."7"\7V&amp;(&lt;Q")ITC^;A+^7H&amp;=A%YKM*@G/M(7')K=*I+$KL#!&amp;0"*CU+I-OQ6%-'C=NYOPKCK51S%H@&amp;*FXB;#C2=-X&amp;:_:$S9B,$C6$F1)^+3GW&amp;_HJ;4,G$7A($L:ASEBW$&amp;:86Z%!8(8I5QA^,':,/$O'`BUOFAC8&gt;=*J6JWZ4G4/_QZYAS!^/$&gt;&amp;/@1',*JRL=SY*^A[S&gt;;9&lt;O*D;'+\5&amp;[IS=1P0XY4PY,?OFRG9AD$"C3L',+H!$+9?!.2GR#OAHE6-6&gt;-*N\!0*N;HGIG$F39?%.,64,R]P+S#9:3P&amp;;3IG"FDJ##F&gt;-`Z2`G([+B'=M@Q!6G;#P$H5&amp;.:+5?"GCK[]656)1$GABR+M,*=A]XIALBGCJE0%`-J3;C-YHJC.Q83]UGSQ3ZIU*#6DD&lt;-4(&lt;9(*N#`DAO(&lt;EP*U&gt;?7&gt;H"Y_-;S&amp;_WAW@=*;U3,_R&gt;;?4XK0_S7,9*B73;'C-;G&amp;2`;RI!4.X1B.'7F^@RUCYWJVY5IPA)$GL+_-M=.W%7VRMCZOOAK=I6ZDXU0#67[E5&lt;LK;N^K=?D7J1D671T60)`\:`6=TM@&gt;K*ET6.+IQD^5%R'R,1&gt;"P&gt;-&lt;&lt;M:J@NX\$;F),8\*K[GA+'O7"PZ#/84^PO$ZKO/\7L_``&lt;-C*HPY1=RYU.:B'0(ZP\1:TS&gt;"A2BKJMY5A`P+N#H0W$NK8/9?NAQ^[!V&lt;@AM8H!J]\\`-5]13JHZ15&amp;WB:ARD[/PD.48JG6Y04.O0@A](ZO8AM'1P(IJ7^ZHV*Y6]1MS'-7_R?88D`(1?R3NOY7/DB.KU*^WJ&amp;3-Z`XNCV93"(51.(T2]&lt;/:IS=]2B:S\#:'T-MM+$K"UX#"/-&amp;[P'3\`'CX44/71G:G)0R.DHYJ&amp;I+$5&lt;HB[.**-TMV/*-I:Q@A\)#IZ0+?M=UMY&lt;B"[T/I0[$.$59&lt;-7!^5M1P2!J3J$F6/3QX=`P&amp;2T3JYK-T&amp;^$7,".5U]8$%F.9&amp;?.QN5:X\G#_LD]EU[,NP++T;.S\/0@VS/\$9O`?D+XCI?(KU9F\W)'N&amp;PJVUQZSL'*4I@-&lt;WVR_69R&lt;AUX$30(J&gt;P08J=!J`@JM^`@_,=R)`_`%=&lt;3N$150*:/!1O'$"&lt;^NX`K[']NY_'-L[@BH+_IK&amp;Y!`7M&gt;^B/'X,RN\^0]@4:ALZV&gt;.C)0F6!(U$U(Z`OBN@_\@#DIJ3PNE(IR`"86'C8_FJ`&amp;!;2]3:_E/]8&lt;K!O?+]=YG`Q^T+&lt;J@^$G?%3%B8^H&amp;Q4PX$S(@]"+_4-(Q!!!!!!"!!!!&amp;!!!!!%!!!!!!!!!!Q!!5*%3&amp;!!!!!!!!-!!!!%!!!!!!!!!')!!!"S?*RD9'$)%Z"A_M&gt;1^Z?"3?!LE#(^FY&amp;:U)`R.Q-$JZ`!93$.+#!*&amp;*&lt;^S]!OK!U7VD[CS]%!";JMD"S3()=&amp;/=!S(#U;$0```_@Y?O1;8-52(TB4::9]BQ1!&amp;'):!!!!!!!!"!!!!!=!!!:&amp;!!!!#!!!!#&amp;@&lt;GF@4'&amp;T&gt;%NO&lt;X&gt;O4X&gt;O;7ZH4&amp;:$&lt;'&amp;T=U.M&gt;8.U:8)!!!&amp;/*A#!!!!!!!%!#!!Q`````Q!"!!!!!!%S!!!!"!"=1(!!(A!!33*;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW&lt;'FC*&amp;J.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:D&lt;'&amp;T=Q!)=(*P&gt;'^D&lt;WQ!!)E!]1!!!!!!!!!$)6J.,5..,7.P&lt;7VV&lt;GFD982J&lt;WZ@&lt;7&amp;O97&gt;F=CZM&gt;GRJ9C.;43V$43VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8WVB&lt;G&amp;H:8)O&lt;(:D&lt;'&amp;T=RR;43V$43V15E6-166/1UB@5U656%F/2V-O9X2M!"Z!5!!"!!!2=(*F&lt;'&amp;V&lt;G.I5W6U&gt;'FO:X-!&amp;5!(!!ZQ&gt;7*M;8.I:72$&lt;X6O&gt;!!!-%"1!!-!!1!!!!)D7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,GRW9WRB=X-!!1!$!!!!!!!!!"2/33Z-6CZ"&lt;'QO5W^V=G.F4WZM?1!!!"5G!)!!!!!!!1!%!#%!!1!!!1!!!!!!!!!;4&amp;:$&lt;'&amp;T=V"S;8:B&gt;'6%982B6'&amp;C4X*E:8)!!!!V*A#!!!!!!!)!"1!(!!!-!%!!!@````]!!!!"!!%!!!!%!!!!!!!!!!%!!!!#!!!!!Q!!!!!!!!!&lt;4&amp;:$&lt;'&amp;T=V"S;8:B&gt;'6%982B6'FN:8.U97VQ!!!!'39!A!!!!!!"!!5!"Q!!!1!!ZP)QT1!!!!!!!!!G4&amp;:$&lt;'&amp;T=V"S;8:B&gt;'6%982B4'&amp;T&gt;%&amp;Q='RJ:725;7VF=X2B&lt;8!!!!!:*A#!!!!!!!%!"1!(!!!"!!$G]D$.!!!!!!!!!"J-6E.M98.T5(*J&gt;G&amp;U:52B&gt;'&amp;5?8"F2'6T9Q!!!5YG!)!!!!!!!1!)!$$`````!!%!!!!!!4)!!!!%!&amp;R!=!!?!!"*)FJ.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:M;7)E7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;G.M98.T!!BQ=G^U&lt;W.P&lt;!!!C1$R!!!!!!!!!!-B7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,GRW&lt;'FC)VJ.,5..,7.P&lt;7VV&lt;GFD982J&lt;WZ@&lt;7&amp;O97&gt;F=CZM&gt;G.M98.T(&amp;J.,5..,6"325R"65Z$3&amp;^4262535Z(5SZD&gt;'Q!(E"1!!%!!"&amp;Q=G6M986O9WB4:82U;7ZH=Q!61!=!$H"V9GRJ=WBF:%.P&gt;7ZU!!!Q1&amp;!!!Q!"!!!!!C.;43V$43VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8WVB&lt;G&amp;H:8)O&lt;(:D&lt;'&amp;T=Q!"!!-!!!!!!!!!(ER71WRB=X.1=GFW982F2'&amp;U952G&lt;(2%982B5WF[:1!!!"EG!)!!!!!!!1!&amp;!!-!!!%!!!!!!!Q!!!!!!!!!'ER71WRB=X.1=GFW982F2'&amp;U952G&lt;(2%982B!!!"\C9!A!!!!!!%!&amp;R!=!!?!!"*)FJ.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:M;7)E7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;G.M98.T!!BQ=G^U&lt;W.P&lt;!!!C1$R!!!!!!!!!!-B7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,GRW&lt;'FC)VJ.,5..,7.P&lt;7VV&lt;GFD982J&lt;WZ@&lt;7&amp;O97&gt;F=CZM&gt;G.M98.T(&amp;J.,5..,6"325R"65Z$3&amp;^4262535Z(5SZD&gt;'Q!(E"1!!%!!"&amp;Q=G6M986O9WB4:82U;7ZH=Q!61!=!$H"V9GRJ=WBF:%.P&gt;7ZU!!!Q1&amp;!!!Q!"!!!!!C.;43V$43VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8WVB&lt;G&amp;H:8)O&lt;(:D&lt;'&amp;T=Q!"!!-!!!!"33*;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW&lt;'FC*&amp;J.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:D&lt;'&amp;T=Q!!!!!!!!!!!!!!!!!!!5EC7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;GRJ9C2;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW9WRB=X-!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"!!(!!Y!!!!%!!!!@!!!!#A!!!!#!!!%!!!!!!9!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"KA!!"16YH,V5SU\#5"!^N3+I_(Y$;HX%B1H%R"`!.$Z)B"$1D4(2UB:M=OFNWFNU[&gt;;F?X`*XX#N@I(4&amp;D8RA3S14N*U&lt;M`-H*ET,9"6H/=&gt;L!#&amp;^&lt;.C6CVH&gt;&gt;ZM_L;F;],C^I8D=M&amp;VTH+MR;T;ZB]1H7G?B]4\#8#0&amp;U38P"&lt;%&amp;L`%.D6&lt;;ZBOF(WD-S*-HIEQZ=L_]&gt;ZJ34W[K/[@H"2+B^7=,BCW]G6)Q/*P)/#OPY27)E*4DGMST&lt;@VK[IJB'5X0-TFYRBX`"KTP#P45,FP#_!",U_P/Y_^9\@;#2-1T"&amp;"'1."R776_:YQ8988F4"9=6SLJ1F4-43B)5;'%2C!^"Q[=NP&amp;,O)9JH&lt;E/GMAE&lt;_6?56%"S;P9T+M-%T95&gt;EX[KCAR_O'[`ZKGE3A[2B.))ZW&gt;_0E4MDCRK!OST4.*#;2_F8[\4"GOKO:ET)R$!5XSJ8!*15.YI#++*D&amp;8+B$$00%Z.VC&lt;@N_]PFG)&lt;2)0!G,&lt;5,&gt;,-%A9@\T@[&amp;_3#FV]W&amp;F@JBO)J1(."[*[![20Y5:,#'&amp;.*;2I5&lt;4^*Q+VD&gt;I!Q.PZ!B9"Q!!!!!!:1!"!!)!!Q!%!!!!3!!0"!!!!!!0!.E!V!!!!&amp;%!$Q1!!!!!$Q$:!.1!!!";!!]%!!!!!!]!W1$5!!!!9Y!!B!#!!!!0!.E!V!B4:7&gt;P:3"631B4:7&gt;P:3"631B4:7&gt;P:3"631%Q!!!!5F.31QU+!!.-6E.$4%*76Q!!(41!!!4E!!!!)!!!(21!!!!!!!!!!!!!!#!!!!!U!!!%R!!!!"^-35*/!!!!!!!!!92-6F.3!!!!!!!!!:B36&amp;.(!!!!!!!!!;R$1V.5!!!!!!!!!="-38:J!!!!!!!!!&gt;2$4UZ1!!!!!!!!!?B544AQ!!!!!1!!!@R%2E24!!!!!!!!!C2-372T!!!!!!!!!DB735.%!!!!!A!!!ER(1U2*!!!!!!!!!IBW:8*T!!!!"!!!!JR41V.3!!!!!!!!!Q"(1V"3!!!!!!!!!R2*1U^/!!!!!!!!!SBJ9WQY!!!!!!!!!TR$5%-S!!!!!!!!!V"-37:Q!!!!!!!!!W2'5%6Y!!!!!!!!!XB'5%BC!!!!!!!!!YR'5&amp;.&amp;!!!!!!!!!["75%21!!!!!!!!!\2-37*E!!!!!!!!!]B#2%6Y!!!!!!!!!^R#2%BC!!!!!!!!!`"#2&amp;.&amp;!!!!!!!!"!273624!!!!!!!!""B%6%B1!!!!!!!!"#R.65F%!!!!!!!!"%")36.5!!!!!!!!"&amp;271V21!!!!!!!!"'B'6%&amp;#!!!!!!!!"(Q!!!!!`````Q!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!&amp;!!!!!!!!!!!0````]!!!!!!!!!^!!!!!!!!!!!`````Q!!!!!!!!%)!!!!!!!!!!$`````!!!!!!!!!2!!!!!!!!!!!0````]!!!!!!!!#D!!!!!!!!!!!`````Q!!!!!!!!+5!!!!!!!!!!,`````!!!!!!!!!LQ!!!!!!!!!!0````]!!!!!!!!#V!!!!!!!!!!!`````Q!!!!!!!!-E!!!!!!!!!!$`````!!!!!!!!!T1!!!!!!!!!!@````]!!!!!!!!%[!!!!!!!!!!#`````Q!!!!!!!!8Y!!!!!!!!!!$`````!!!!!!!!"P!!!!!!!!!!"0````]!!!!!!!!(#!!!!!!!!!!(`````Q!!!!!!!!==!!!!!!!!!!D`````!!!!!!!!"SQ!!!!!!!!!#@````]!!!!!!!!(1!!!!!!!!!!+`````Q!!!!!!!!&gt;1!!!!!!!!!!$`````!!!!!!!!"W1!!!!!!!!!!0````]!!!!!!!!(@!!!!!!!!!!!`````Q!!!!!!!!?1!!!!!!!!!!$`````!!!!!!!!#"1!!!!!!!!!!0````]!!!!!!!!-'!!!!!!!!!!!`````Q!!!!!!!!QA!!!!!!!!!!$`````!!!!!!!!$K!!!!!!!!!!!0````]!!!!!!!!/N!!!!!!!!!!!`````Q!!!!!!!"09!!!!!!!!!!$`````!!!!!!!!%_!!!!!!!!!!!0````]!!!!!!!!4[!!!!!!!!!!!`````Q!!!!!!!"0Y!!!!!!!!!!$`````!!!!!!!!&amp;!!!!!!!!!!!!0````]!!!!!!!!5;!!!!!!!!!!!`````Q!!!!!!!"2Q!!!!!!!!!!$`````!!!!!!!!'LQ!!!!!!!!!!0````]!!!!!!!!;R!!!!!!!!!!!`````Q!!!!!!!"L-!!!!!!!!!!$`````!!!!!!!!'PA!!!!!!!!!A0````]!!!!!!!!=K!!!!!!@7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,G.U&lt;!!!!!!</Property>
	<Property Name="NI.LVClass.Geneology" Type="Xml"><String>
<Name></Name>
<Val>!!!!!C&amp;;43V$43VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8WVB&lt;G&amp;H:8)O&lt;(:M;7)D7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,GRW9WRB=X.16%AQ!!!!!!!!!!!!!!!!!!9!!1!!!!!!!!%!!!!"!#*!5!!!'VJ.,5..,7.P&lt;7VV&lt;GFD982J&lt;WZ@&lt;7&amp;O97&gt;F=A!"!!!!!!!!!!!!!!%/4'&amp;C6EF&amp;6S"09GJF9X1!5&amp;2)-!!!!!!!!!!!!#9!A!!!!!!!!!!"``]!!!!"!!!!!!!"!1!!!!%!)E"1!!!&lt;7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S!!%!!!!!!!(````_!!!!!!)617.U&lt;X)A2H*B&lt;76X&lt;X*L,GRW&lt;'FC$5&amp;D&gt;'^S,GRW9WRB=X.16%AQ!!!!!!!!!!!!*A#!!!!!!!!!!!!!!!!!!!%!!!!!!!)"!!!!"!!71#%2=(*F&lt;'&amp;V&lt;G.I5W6U&gt;'FO:X-!%E!Q`````QBQ=G^U&lt;W.P&lt;!!!&amp;5!(!!ZQ&gt;7*M;8.I:72$&lt;X6O&gt;!!!?A$RZP%#%!!!!!)D7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,GRW9WRB=X-@7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,G.U&lt;!!O1&amp;!!!Q!!!!%!!BV$&lt;(6T&gt;'6S)'^G)'.M98.T)("S;8:B&gt;'5A:'&amp;U91!"!!-!!!!$````````````````!!!!!!!!!!!!!!!!!!!!!B6"9X2P=C"'=G&amp;N:8&gt;P=GMO&lt;(:M;7).17.U&lt;X)O&lt;(:D&lt;'&amp;T=V"53$!!!!!!!!!!!!!G!)!!!!!!!!!!!!!!!!!!!1!!!!!!!Q%!!!!&amp;!&amp;R!=!!?!!&amp;*)FJ.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:M;7)E7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;G.M98.T!!BQ=G^U&lt;W.P&lt;!!!1Q$R!!!!!!!!!!%=7EUN1UUN5&amp;*&amp;4%&amp;64E.)8V.&amp;6&amp;2*4E&gt;4,G.U&lt;!!?1&amp;!!!1!!%8"S:7RB&gt;7ZD;&amp;.F&gt;(2J&lt;G&gt;T!"*!-0````])=(*P&gt;'^D&lt;WQ!!"6!"Q!/=(6C&lt;'FT;'6E1W^V&lt;H1!!(I!]?&lt;R!F!!!!!#)VJ.,5..,7.P&lt;7VV&lt;GFD982J&lt;WZ@&lt;7&amp;O97&gt;F=CZM&gt;G.M98.T(VJ.,5..,7.P&lt;7VV&lt;GFD982J&lt;WZ@&lt;7&amp;O97&gt;F=CZD&gt;'Q!,E"1!!-!!1!#!!-&gt;1WRV=X2F=C"P:C"D&lt;'&amp;T=S"Q=GFW982F)'2B&gt;'%!!1!%!!!!"!!!!!$```````````````]!!!!"33*;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW&lt;'FC*&amp;J.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:D&lt;'&amp;T=Q!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#&amp;5&amp;D&gt;'^S)%:S97VF&gt;W^S;SZM&gt;GRJ9AV"9X2P=CZM&gt;G.M98.T5&amp;2)-!!!!!!!!!!!!#9!A!!!!!!!!!!!!!!!!!!"!!!!!!!%!1!!!!1!8%"Q!"Y!!%EC7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;GRJ9C2;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW9WRB=X-!#("S&lt;X2P9W^M!!"$!0%!!!!!!!!!!2R;43V$43V15E6-166/1UB@5U656%F/2V-O9X2M!"Z!5!!"!!!2=(*F&lt;'&amp;V&lt;G.I5W6U&gt;'FO:X-!&amp;5!(!!ZQ&gt;7*M;8.I:72$&lt;X6O&gt;!!!?A$RZP%#BQ!!!!)D7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,GRW9WRB=X-@7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,G.U&lt;!!O1&amp;!!!Q!"!!!!!BV$&lt;(6T&gt;'6S)'^G)'.M98.T)("S;8:B&gt;'5A:'&amp;U91!"!!-!!!!$````````````````!!!!!5EC7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;GRJ9C2;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW9WRB=X-!!!!!!!!!!!!!!!!!!!&amp;*)FJ.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:M;7)E7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;G.M98.T!!!!!!!!!!!!!!!!!!!!!!!!!!)617.U&lt;X)A2H*B&lt;76X&lt;X*L,GRW&lt;'FC$5&amp;D&gt;'^S,GRW9WRB=X.16%AQ!!!!!!!!!!!!*A#!!!!!!!!!!!!!!!!!!!%!!!!!!!!!!!!!"!"=1(!!(A!!33*;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW&lt;'FC*&amp;J.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:D&lt;'&amp;T=Q!)=(*P&gt;'^D&lt;WQ!!)E!]1!!!!!!!!!$)6J.,5..,7.P&lt;7VV&lt;GFD982J&lt;WZ@&lt;7&amp;O97&gt;F=CZM&gt;GRJ9C.;43V$43VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8WVB&lt;G&amp;H:8)O&lt;(:D&lt;'&amp;T=RR;43V$43V15E6-166/1UB@5U656%F/2V-O9X2M!"Z!5!!"!!!2=(*F&lt;'&amp;V&lt;G.I5W6U&gt;'FO:X-!&amp;5!(!!ZQ&gt;7*M;8.I:72$&lt;X6O&gt;!!!H!$RZP)QT1!!!!-B7EUN1UUN9W^N&lt;86O;7.B&gt;'FP&lt;F^N97ZB:W6S,GRW&lt;'FC)VJ.,5..,7.P&lt;7VV&lt;GFD982J&lt;WZ@&lt;7&amp;O97&gt;F=CZM&gt;G.M98.T(VJ.,5..,7.P&lt;7VV&lt;GFD982J&lt;WZ@&lt;7&amp;O97&gt;F=CZD&gt;'Q!,E"1!!-!!1!!!!)&gt;1WRV=X2F=C"P:C"D&lt;'&amp;T=S"Q=GFW982F)'2B&gt;'%!!1!$!!!!!@````Y!!!!"33*;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW&lt;'FC*&amp;J.,5.1,7.P&lt;7VV&lt;GFD982J&lt;WZ@=(*P&gt;'^D&lt;WQO&lt;(:D&lt;'&amp;T=Q!!!!!!!!!!!!!!!!!!!5EC7EUN1V!N9W^N&lt;86O;7.B&gt;'FP&lt;F^Q=G^U&lt;W.P&lt;#ZM&gt;GRJ9C2;43V$5#VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8X"S&lt;X2P9W^M,GRW9WRB=X-!!!!!!!!!!!!!!!!!!!!!!!!!!B6"9X2P=C"'=G&amp;N:8&gt;P=GMO&lt;(:M;7).17.U&lt;X)O&lt;(:D&lt;'&amp;T=V"53$!!!!!!!!!!!!!G!)!!!!!!!!!!!!!!!1!!!#.;43V$43VD&lt;WVN&gt;7ZJ9W&amp;U;7^O8WVB&lt;G&amp;H:8)O&lt;(:D&lt;'&amp;T=Q</Val>
</String>
</Property>
	<Property Name="NI.LVClass.IsTransferClass" Type="Bool">false</Property>
	<Property Name="NI.LVClass.LowestCompatibleVersion" Type="Str">1.0.0.0</Property>
	<Item Name="Parent Libraries" Type="Parent Libraries">
		<Item Name="Actor Framework.lvlib:Actor.lvclass" Type="Parent" URL="/&lt;vilib&gt;/ActorFramework/Actor/Actor.lvclass"/>
		<Item Name="ZM-CI-common_interfaces.lvlib:ZM-CI-package_handler.lvclass" Type="Parent" URL="../../../../common/ZM-CI-common_interfaces/ZM-CI-package_handler/ZM-CI-package_handler.lvclass"/>
	</Item>
	<Item Name="ZM-CM-communication_manager.ctl" Type="Class Private Data" URL="ZM-CM-communication_manager.ctl">
		<Property Name="NI.LibItem.Scope" Type="Int">2</Property>
	</Item>
	<Item Name="Accessors" Type="Folder">
		<Item Name="Read prelaunchSettings.vi" Type="VI" URL="../Read prelaunchSettings.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">16777216</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">276832256</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">2</Property>
		</Item>
		<Item Name="Read protocol.vi" Type="VI" URL="../Read protocol.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">16777216</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">8396800</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">2</Property>
		</Item>
		<Item Name="Read publishedCount.vi" Type="VI" URL="../Read publishedCount.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">16777216</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">8396800</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">2</Property>
		</Item>
		<Item Name="Write protocol.vi" Type="VI" URL="../Write protocol.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">16777216</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">3</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">8396800</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">2</Property>
		</Item>
		<Item Name="Write publishedCount.vi" Type="VI" URL="../Write publishedCount.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">16777216</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">3</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">8396800</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">2</Property>
		</Item>
		<Item Name="ZM-CM-writePrelaunchSettings.vi" Type="VI" URL="../ZM-CM-writePrelaunchSettings.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">0</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">0</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">1</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">1350574592</Property>
		</Item>
	</Item>
	<Item Name="AF Overrides" Type="Folder">
		<Item Name="Handle Error.vi" Type="VI" URL="../Handle Error.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">0</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">4</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">3</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">1107821072</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">3</Property>
		</Item>
		<Item Name="Pre Launch Init.vi" Type="VI" URL="../Pre Launch Init.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">16777344</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">1</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">3</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">277356560</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">3</Property>
		</Item>
		<Item Name="Stop Core.vi" Type="VI" URL="../Stop Core.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">16777344</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">1</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">3</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">1351098896</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">3</Property>
		</Item>
	</Item>
	<Item Name="Methods" Type="Folder">
		<Item Name="ZM-CI-handlePackage.vi" Type="VI" URL="../ZM-CI-handlePackage.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">0</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">5</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">1</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">1350574608</Property>
		</Item>
		<Item Name="ZM-CM-createResources.vi" Type="VI" URL="../ZM-CM-createResources.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">0</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">0</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">1350574608</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">2</Property>
		</Item>
		<Item Name="ZM-CM-evaluateError.vi" Type="VI" URL="../ZM-CM-evaluateError.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">0</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">0</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">1082143232</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">2</Property>
		</Item>
		<Item Name="ZM-CM-releaseProtocol.vi" Type="VI" URL="../ZM-CM-releaseProtocol.vi">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">0</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">0</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">2</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">1350574608</Property>
			<Property Name="NI.LibItem.Scope" Type="Int">2</Property>
		</Item>
	</Item>
	<Item Name="TypeDefs" Type="Folder">
		<Item Name="ZM-CM-PRELAUNCH_SETTINGS.ctl" Type="VI" URL="../ZM-CM-PRELAUNCH_SETTINGS.ctl">
			<Property Name="NI.ClassItem.ExecutionSystem" Type="Int">-1</Property>
			<Property Name="NI.ClassItem.Flags" Type="Int">1048576</Property>
			<Property Name="NI.ClassItem.InvokeUsage" Type="UInt">9</Property>
			<Property Name="NI.ClassItem.MethodScope" Type="UInt">1</Property>
			<Property Name="NI.ClassItem.Priority" Type="Int">1</Property>
			<Property Name="NI.ClassItem.State" Type="Int">1082139136</Property>
		</Item>
	</Item>
</LVClass>
