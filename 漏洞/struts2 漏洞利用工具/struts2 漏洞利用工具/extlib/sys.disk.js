/****************************
//[[Description:磁盘控件]]
//[[Author: gainover]]
****************************/
//需前置定义Sys
$Q("Sys"); 
/**
 * 磁盘信息
 * @namespace 磁盘
 */
Sys.Disk={
	obj:null,
	init:function(){
		try{
			this.obj=Win.obj(Win.com.FSO);
		}catch(e){
			alert("Create Scripting.FileSystemObject Object Error");
		}
	},
	open:function(){
		this.init();
	},
	close:function(){
		this.obj=null;
	},
	control:function(id,template){
		var temptag=template||"{name} ({id}:)";
		/*
			template:
				{name}		Drive Volume Name
				{id}			Drive Letter
				{type}		Drive Type
				{total:GB/MB/KB/B}		Drive Total Size
				{used:GB/MB/KB/B}		Drive used Size
				{remain:GB/MB/KB/B}		Drive remain Size
				{serial}	Drive SeriaNumber

			default: "{name} ({id}:)";
			exampe:
				"({id}:) {name}({remain:GB}/{total:GB})"
		*/
		var rs=this.list();
		var str="<select id=\""+(id||$R(3))+"\">";
		if(rs){
			var fold={":GB":1024*1024*1024,":MB":1024*1024,":KB":1024,":B":1};
			for(var i=0,l=rs.length;i<l;i++){
				var tmp=temptag
				.replace(/\{name\}/g,rs[i].Name)
				.replace(/\{id\}/g,rs[i].ID)
				.replace(/\{type\}/g,rs[i].Type)
				.replace(/\{serial\}/g,rs[i].Serial)
				.replace(/\{total([\:GMKB]{0,3})\}/g,function($1,$2){
					return $F(rs[i].Size.total/fold[$2],1)+$2.replace(":","");
				})
				.replace(/\{used([\:GMKB]{0,3})\}/g,function($1,$2){
					return $F(rs[i].Size.used/fold[$2],1)+$2.replace(":","");
				})
				.replace(/\{remain([\:GMKB]{0,3})\}/g,function($1,$2){
					return $F(rs[i].Size.remain/fold[$2],1)+$2.replace(":","");
				});
				str+="<option value=\""+rs[i].ID+"\">"+tmp+"</option>";
			}
		}else{
			str+="<option value=\"\">加载驱动器失败</option>";
		}
		str+="</select>";
		return str;
	},
	list:function(){
		if(this.obj){
			var drivelist=[];
			var e=new Enumerator(this.obj.Drives);
			for(;!e.atEnd();e.moveNext()){
				var i=e.item();
				var tt=i.DriveType;
				var name="";
				var size={
					total:0,
					used:0,
					remain:0
				};
				switch(tt){
					case 3:
						name=i.ShareName;break;
					default:
						switch(tt){
							case 0:
								name="未知设备";break;
							case 1:
								name="可移动设备";break;
							case 2:
								name="本地磁盘";break;
							case 3:
								name="网络驱动器";break;
							case 4:
								name="DVD/CD ROM";break;
							case 5:
								name="RAM 磁盘";break;
						}
						if(i.isReady){
							name=i.VolumeName?i.VolumeName:"本地磁盘";
							size={
								total:i.totalSize,
								used:(i.totalSize-i.availableSpace),
								remain:i.availableSpace
							};
						}else{
							name+="(未就绪)";
						}
				}
				drivelist.push({
					"ID":i.DriveLetter,
					"Type":tt,
					"Name":name,
					"Serial":(i.isReady?i.SerialNumber:0),
					"Size":size
				});
			}
			return drivelist;
		}else{
			return false;
		}
	}
}