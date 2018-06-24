/****************************
//[[Description:ÑÕÉ«Ãæ°å¿â]]
//[[Author: gainover]]
****************************/
$Q("Util");

$D("util.colortable");

Util.colortable=__Gcolortable;

function Gcolortable_click(panel,color){
	$(Dom.Html.attr(panel,"colortext")).value=color;
	Dom.Html.hid(panel);
	var pk=$(Dom.Html.attr("TOOLMAO_colorPanel","colorpicker"));
	pk.style.background=color;
	pk.setAttribute("title",color);
}
function Gcolortable_over(panel,color){
	$(Dom.Html.attr(panel,"colortext")).value=color;
}
function __Gcolortable(){
     var colorW=21,colorH=12;
     var carr=["00","33","66","99","CC","FF"];
     var leftColor=["000000","333333","666666","999999","cccccc","FFFFFF","FF0000","00FF00","0000FF","FFFF00","00FFFF","FF00FF"];
     var colorTab=[];
     var tmpcolor="";
     this.colortext="";
     this.colorpanel="";
     this.colorpicker="";
     this.create=function(type){
		 var that=this;
         function createTable(){
			 var tbstr=[];
             tbstr.push("<table cellspacing='0' cellpadding='0' style='font-size:0pt;border:0px none #fff;background:#000'>");
             for(var i=0;i<colorH;i++){
				tbstr.push("<tr height='12'>");
				for(var j=0;j<colorW;j++){
					 var tdcolor="#"+colorTab[j+i*colorW];
					 tbstr.push("<td onclick='Gcolortable_click(\""+that.colorpanel+"\",\""+tdcolor+"\")' onmouseover='Gcolortable_over(\""+that.colorpanel+"\",\""+tdcolor+"\")' title='"+tdcolor+"' style='background:"+tdcolor+";"+((i==0)?"":"border-top:none;")+((j==0)?"":"border-left:none;")+"' class='colortable'></td>");
                 }
                 tbstr.push("</tr>");
             }
             tbstr.push("</table>");
             return tbstr.join("");
         }
         function createColorCube(){
             colorTab=["000000","000000","000000","000000","003300","006600","009900","00CC00","00FF00","330000","333300","336600","339900","33CC00","33FF00","660000","663300","666600","669900","66CC00","66FF00","000000","333333","000000","000033","003333","006633","009933","00CC33","00FF33","330033","333333","336633","339933","33CC33","33FF33","660033","663333","666633","669933","66CC33","66FF33","000000","666666","000000","000066","003366","006666","009966","00CC66","00FF66","330066","333366","336666","339966","33CC66","33FF66","660066","663366","666666","669966","66CC66","66FF66","000000","999999","000000","000099","003399","006699","009999","00CC99","00FF99","330099","333399","336699","339999","33CC99","33FF99","660099","663399","666699","669999","66CC99","66FF99","000000","cccccc","000000","0000CC","0033CC","0066CC","0099CC","00CCCC","00FFCC","3300CC","3333CC","3366CC","3399CC","33CCCC","33FFCC","6600CC","6633CC","6666CC","6699CC","66CCCC","66FFCC","000000","FFFFFF","000000","0000FF","0033FF","0066FF","0099FF","00CCFF","00FFFF","3300FF","3333FF","3366FF","3399FF","33CCFF","33FFFF","6600FF","6633FF","6666FF","6699FF","66CCFF","66FFFF","000000","FF0000","000000","990000","993300","996600","999900","99CC00","99FF00","CC0000","CC3300","CC6600","CC9900","CCCC00","CCFF00","FF0000","FF3300","FF6600","FF9900","FFCC00","FFFF00","000000","00FF00","000000","990033","993333","996633","999933","99CC33","99FF33","CC0033","CC3333","CC6633","CC9933","CCCC33","CCFF33","FF0033","FF3333","FF6633","FF9933","FFCC33","FFFF33","000000","0000FF","000000","990066","993366","996666","999966","99CC66","99FF66","CC0066","CC3366","CC6666","CC9966","CCCC66","CCFF66","FF0066","FF3366","FF6666","FF9966","FFCC66","FFFF66","000000","FFFF00","000000","990099","993399","996699","999999","99CC99","99FF99","CC0099","CC3399","CC6699","CC9999","CCCC99","CCFF99","FF0099","FF3399","FF6699","FF9999","FFCC99","FFFF99","000000","00FFFF","000000","9900CC","9933CC","9966CC","9999CC","99CCCC","99FFCC","CC00CC","CC33CC","CC66CC","CC99CC","CCCCCC","CCFFCC","FF00CC","FF33CC","FF66CC","FF99CC","FFCCCC","FFFFCC","000000","FF00FF","000000","9900FF","9933FF","9966FF","9999FF","99CCFF","99FFFF","CC00FF","CC33FF","CC66FF","CC99FF","CCCCFF","CCFFFF","FF00FF","FF33FF","FF66FF","FF99FF","FFCCFF","FFFFFF"];
             return createTable();
         }
         function createSeqCube(){
             colorW=21;colorH=12;
             var cCube=0,cCol=0;cRow=0;
             for(var i=0;i<colorW*colorH;i++){
                 if(i%21==0||i%21==2) colorTab[i]="000000";
                 else if(i%21==1) colorTab[i]=leftColor[(i-1)/21];
                 else{
                     cRow=Math.floor(i/21);cCol=(i-3)%21;
                     if(cCol<6) cCube=cRow>5?5:4;
                     else if(cCol>=6&&cCol<12) cCube=cRow>5?3:2;
                     else cCube=cRow>5?1:0;
                     cCol=(cCube==2||cCube==3)?cCol%6:(5-cCol%6);
                     cRow=(cCube==5||cCube==3||cCube==1)?cRow%6:(5-cRow%6);
                     colorTab[i]=carr[cCube]+carr[cRow]+carr[cCol];
                 }
             }
             return createTable();
         }
         function createBwCube(){
             colorW=21;colorH=13;
             for(var i=0;i<colorW*colorH;i++){
                 if(255-i>=0){
                     var sc=(255-i).toString(16);
                     if(sc.length==1) sc="0"+sc;
                     colorTab[i]=sc+sc+sc;
                 }
             else colorTab[i]="ffffff";
             }
             return createTable();
         }
         if(!type) type="";
         switch(type){
             case "":
				 var colors=createColorCube();
                 return colors;break;
             case "bw":
             case 2:
                 return createBwCube();break;
             case 1:
             case "seq":
                 return createSeqCube();break;
         }
     }
}