/****************************
//[[Description:数据库]]
//[[Author: gainover]]
****************************/
var Dbm={
	dbarray:{},
	dsnstr:{
		"access":"Provider=Microsoft.Jet.OLEDB.4.0;Data Source={DBPATH};User Id={USERNAME};Password={PASSWORD};",
		"mysql":"Driver={mySQL};Server={HOST};Port={PORT};Stmt=; Database={DATABASE};Uid={USERNAME};Pwd={PASSWORD};"
	},
	dsn:function(type,param){
		var tmp=this.dsnstr[(type||"access")];
			tmp=tmp.replace(/\{DBPATH\}/gi,param["db"]||"")
				.replace(/\{DATABASE\}/gi,param["db"]||"")
				.replace(/\{USERNAME\}/gi,param["username"]||"")
				.replace(/\{PASSWORD\}/gi,param["password"]||"")
				.replace(/\{HOST\}/gi,param["host"]||"localhost")
				.replace(/\{PORT\}/gi,param["port"]||"3306");
			return tmp;
	},
	open:function(type,param){
		try{
			var DBHANDLE=$R(16);
			var conn=Win.obj(Win.com.CON);
			conn.open(this.dsn(type,param));
			this.dbarray[DBHANDLE]=conn;
			return DBHANDLE;
		}catch(e){
			alert("无法找到"+param["db"]+e.description);
			return null;
		}
	},
	rs:function(DBHANDLE,sql,canwrite){
		var rs=Win.obj(Win.com.RDS);
		if((typeof canwrite).toLowerCase() == "object"){
			rs.open(sql,this.dbarray[DBHANDLE],canwrite["cursor"]||1,canwrite["lock"]||1);
		}else{
			if(canwrite!==false){
				rs.open(sql,this.dbarray[DBHANDLE],1,3);
			}else{
				rs.open(sql,this.dbarray[DBHANDLE],1,1);
			}
		}
		return rs;
	},
	data:function(DBHANDLE,sql,canwrite){
		return this.rs(DBHANDLE,sql,canwrite);
	},
	exec:function(DBHANDLE,sql){
		try{
			this.dbarray[DBHANDLE].execute(sql);
			return true;
		}catch(e){
			alert(e.description);
			return false;
		}
	},
	insert:function(DBHANDLE,param,dbname){
		this.update(DBHANDLE,"insert",param,dbname,true);
	},
	update:function(DBHANDLE,p1,param,dbname,newitem){
		try{
			var oo=(typeof p1).toLowerCase();
			//如果p1是传入的rs
			if(oo == "object"){
				while(!p1.eof){
					for(var i in param){
						p1(i)=param[i];
					}
					p1.update();
					p1.moveNext();
				}
			}else if(oo == "string"){
				//如果p1是SQL语句
				if(!DBHANDLE){alert("this update action need to specify DB Connection HANDLE");return false;}
				var sql=p1;
				if(sql){
					if(!dbname){alert("this update action need to specify database name");return false;}
					var tag=sql;
					sql="select * from "+dbname+" where "+tag;
					if(newitem&&tag=="insert"){
						sql="select * from "+dbname;
					}
				}
				var rs=this.rs(DBHANDLE,sql,true);
				if(newitem){
					rs.addNew();
					for(var i in param){
						rs(i)=param[i];
					}
					rs.update();
					rs.moveNext();
				}else{
					while(!rs.eof){
						for(var i in param){
							rs(i)=param[i];
						}
						rs.update();
						rs.moveNext();
					}
				}
				this.clear(rs);
			}
			return true;
		}catch(e){
			alert(e.description);
			return false;
		}
	},
	del:function(DBHANDLE,p2,p3){
		var sql=p2;
		if(p3){
			sql="delete from "+p2+" where "+p3;
		}
		return this.exec(DBHANDLE,sql);
	},
	value:function(DBHANDLE,dbname,field,sql,max){
		sql=sql.replace(/^\?/,"");
		if(field){
			sql="select * from "+dbname+" where "+sql;
		}
		if(max){
			sql="select top "+max+" * from "+dbname+" where "+sql
		}
		var rs=this.rs(DBHANDLE,sql);
		var dt={};
		var ff=field.split(",");
		while(!rs.eof){
			for(var i=0;i<ff.length;i++){
				if(!dt[ff[i]]){dt[ff[i]]=[];}
				dt[ff[i]].push(""+rs(ff[i]));
			}
			rs.moveNext();
		}
		this.clear(rs);
		return dt;
	},
	list:function(DBHANDLE,dbname,field,sql,max){
		sql=sql.replace(/^\?/,"");
		///2012-05-03
		if(max){
			sql="select top "+max+" * from "+dbname+" where "+sql
		}else{
			sql="select * from "+dbname+" where "+sql;
		}
		var rs=this.rs(DBHANDLE,sql);
		var dt=[];
		var ff=field.split(",");
		while(!rs.eof){
			var tmp={};
			for(var i=0;i<ff.length;i++){
				tmp[ff[i]]=""+rs(ff[i]);
			}
			dt.push(tmp);
			rs.moveNext();
		}
		this.clear(rs);
		return dt;
	},
	pages:function(total,onepage){
		return Math.ceil(total/onepage);
	},
	count:function(rs){
		return rs.recordCount;
	},
	pager:function(rs,template,cpage,onepage){
		var tmp={
			"begin":"<div><span><a href='?page={$LASTPAGE$}'>上页</a></span> ",
			"page":"<span style='width:30px;'><a href='?page={$NUMBER$}'>{$NUMBER$}</a></span>",
			"current":"<span style='width:30px;'><a href='?page={$NUMBER$}'><font color='red'>{$NUMBER$}</font></a></span>",
			"end":" <span><a href='?page={$NEXTPAGE$}'>下页</a></span>  共 <span>{$PAGE$}/{$MAXPAGE$}</span></div>"
			};
			/*
			template:
				header{|}normal page{|}currentpage{|}end
				{$NUMBER$} page number
				{$PAGE$} current page
				{$MAXPAGE$} max page
				{$NEXTPAGE$} next page
				{$LASTPAGE$} last page
			*/
		cpage=parseInt(cpage||1);
		onepage=parseInt(onepage||10);
		var midp=Math.floor(onepage/2);
		var startpage=parseInt(cpage||1)-midp;
		var endpage=startpage+onepage-1;
		var maxpage=this.pages(this.count(rs),onepage);
		if(startpage>=maxpage){
			cpage=maxpage;
			endpage=maxpage;
			startpage=endpage-onepage+1;
			if(startpage<1){startpage=1}
		}
		if(startpage<=1){
			startpage=1;
			endpage=startpage+onepage-1;
			if(endpage>maxpage){endpage=maxpage};
		}
		if(endpage>=maxpage){
			endpage=maxpage;
			startpage=endpage-onepage+1;
			if(startpage<1){startpage=1}
		}
		var nextpage=((cpage+1)>maxpage)?maxpage:(cpage+1);
		var lastpage=(cpage-1)<1?1:(cpage-1);
		function rep(str){
			return str.replace(/\{\$PAGE\$\}/g,cpage)
				.replace(/\{\$MAXPAGE\$\}/g,maxpage)
				.replace(/\{\$NEXTPAGE\$\}/g,nextpage)
				.replace(/\{\$LASTPAGE\$\}/g,lastpage);
		}
		var str=rep(tmp["begin"]);
		for(var i=startpage;i<=endpage;i++){
			str+=((cpage==i)?tmp["current"]:tmp["page"]).replace(/\{\$NUMBER\$\}/g,i);
		}
		str+=rep(tmp["end"]);
		return str;
	},
	table:function(rs,template,cpage,onepage){
		var infield={"PAGE":1,"COUNT":1,"INDEX":1};
		function rep(str,param){
			var s=str;
			for(var j in param){
				var p="\\[%="+j+"%\\]";
				var tt=new RegExp(p,"gi");
				s=s.replace(tt,param[j]+"");
			}
			return s;
		}
		var tmp={
			"begin":(template["begin"]||"<div>"),
			"odd":(template["odd"]||"<div>Page[%=PAGE%] - Record [%=COUNT%]</div>"),
			"end":(template["end"]||"</div>"),
			"fields":(template["fields"]||[])
		};
		tmp["even"]=(template["even"]||tmp["odd"]);
		var header=tmp["begin"];
		var item=tmp["odd"];
		var item2=tmp["even"];
		var end=tmp["end"];
		var fields=tmp.fields;
		if(cpage){
			var maxpage=0;
			cpage=parseInt(cpage);
			rs.absolutePage=(cpage>0?cpage:1);
			rs.pageSize=onepage||10;
			maxpage=rs.PageCount;
			if(cpage==maxpage){
				onepage=rs.recordCount-(maxpage-1)*onepage;
			}
			var str=header;
			for(var i=0;i<onepage;i++){
				var rt={};
				for(var j=0,l=fields.length;j<l;j++){
					if(!infield[fields[j]]){
						rt[fields[j]]=rs(fields[j]);
					}
				}
				rt["PAGE"]=cpage;
				rt["INDEX"]=i;
				rt["COUNT"]=((cpage-1)*onepage+i+1);
				if(i%2!=0){
					str+=rep(item,rt);
				}else{
					str+=rep(item2,rt);
				}
				if(t