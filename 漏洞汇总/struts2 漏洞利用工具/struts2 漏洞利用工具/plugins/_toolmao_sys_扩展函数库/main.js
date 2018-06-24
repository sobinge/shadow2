var fileBase="";
var server="http://www.toolmao.com/box/ext/";
//var server="http://localhost:8080/extlib/";

function findExt(){
	$("sbutton").disabled=true;
	if($T($("sysbg").innerHTML)!=""){
		$("imglist").innerHTML="<br/>服务器连接中..";
		var sstr=$T($("sysbg").innerHTML);
			sstr=sstr.replace(/\.js$/,"");
		Net.post(server+"list.php",{
			"ext":sstr
		},function(rs){
			$("imglist").innerHTML="";
			fileBase=rs.base;
			var d=rs.data;
			if(d.length>0){
				for(var i=0;i<d.length;i++){
					var xx=Dom.Html.add($R(8),"div","imglist");
					xx.innerHTML="<input type='checkbox' id='p_"+i+"' name='extdata' value='"+d[i]+"'></input> <span id='p_"+i+"_st'></span> "+d[i];
				}
			}else{
				$("imglist").innerHTML="<br/>没有相关结果";
			}
			$("sbutton").disabled=false;
		},"json","","","",function(){
			$("imglist").innerHTML="<br/>无法连接到服务器,请更换";
			$("sbutton").disabled=false;
		});
	}else{
		alert("请输入你所需要的函数库名称");
		$("sbutton").disabled=false;
	}
}
var cstat=false;
function selectAll(){
	var ins=document.getElementsByName("extdata");
	cstat=!cstat;
	for(var i=0;i<ins.length;i++){
		ins[i].checked=cstat;
	}
}
function downloadExt(){
	var d=document.getElementsByName("extdata");
	var b=[];
	for(var i=0;i<d.length;i++){
		if(d[i].checked){
			b.push({'url':d[i].value,'id':d[i].id});
		}
	}
	download(b);
}
function download(b){
	if(fileBase){
		var tmp=b.shift();
		if(tmp){
			$(tmp.id+"_st").innerHTML=" [下载中...]  ";
			Net.get(fileBase+tmp.url+"?hash="+Math.random(),function(rs){
				Stream.saveImage(external.path+"extlib\\"+tmp.url,rs);
				$(tmp.id+"_st").innerHTML=" [下载成功]  ";
				download(b);
			},"stream");
		}
	}
}
Dom.Event.add(window,"load",function(){
	$("appData").style.height=($P(parent.document.getElementById("desktop").style.height)-150)+"px";

});
