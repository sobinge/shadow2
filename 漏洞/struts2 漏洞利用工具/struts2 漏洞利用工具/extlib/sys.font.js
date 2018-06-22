/****************************
//[[Description:字体控件]]
//[[Author: gainover]]
****************************/
//需前置定义Sys
$Q("Sys");
/**
 * 系统字体
 * @namespace 系统字体
 */
Sys.Font={
	obj:null,
	inited:false,
	init:function(){
		if(!this.inited){
			var tmp=Dom.Html.add("dlgHelperdiv","div",null,"width:0px;height:0px;");
			Dom.Html.value(tmp,'<OBJECT id=dlgHelper CLASSID="clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b" width="0px" height="0px"></OBJECT> ');
		}
		this.inited=true;
		this.obj=$("dlgHelper").fonts;
	},
	open:function(){
		this.init();
	},
	close:function(){
	},
	list:function(type){
		if(!type){type="all";}
		/*type=[all,cn,en,other]*/
		this.init();
		var em=new Enumerator(this.obj);
		var rs=[];
		for(;!em.atEnd();em.moveNext()){
			var tmp=em.item()+"";
			if(type=="cn"){
				if(/[\u4E00-\u9FA5]+/.test(tmp)){
					rs.push(tmp);
				}
			}else if(type=="en"){
				if(/^[^\u4E00-\u9FA5]+$/.test(tmp)){
					rs.push(tmp);
				}
			}else{
				rs.push(tmp);
			}
		}
		return rs;
	},
	check:function(fontname){
		this.init();
		var em=new Enumerator(this.obj);
		var rs=[];
		for(;!em.atEnd();em.moveNext()){
			if(fontname == (em.item()+"")){
				return true;
			}
		}
		return false;
	},
	add:function(path,abs){
		path=abs?path:(external.path+path);
		external.addFont(path);
	},
	del:function(path,abs){
		path=abs?path:(external.path+path);
		external.delFont(path);
	},
	control:function(id,type,select){
		/*type from list*/
		if(!id){id=$R(16);}
		if(!select){select="";}
		var arr=this.list(type);
		var str="<select id='"+id+"'>";
		for(var i=0,l=arr.length;i<l;i++){
			str+="<option value='"+arr[i]+"'"+(select==arr[i]?" selected":"")+">"+arr[i]+"</option>";
		}
		str+="</select>";
		return str;
	}
};