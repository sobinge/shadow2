/*Yaeng*/

function  switchMenu(item){
	
	var child=$("#menu").children("li");
	var len=$("#menu").children("li").length;
	for(var i=0; i<len; i++)
	{
		  child[i].className='top_menu';   
	}
	item.className='on top_menu';
	
}