<?php require_once PUBLIC_PATH."public.php"; ?>
</head>
<body>
<table width="100%" cellspacing="0" cellpadding="0" border="0" align="left">
  <tbody>
    <tr>
      <td height="30"><table width="100%" cellspacing="0" cellpadding="0" border="0">
          <tbody>
            <tr>
              <td width="15" height="30"><img width="15" height="30" src="<?php  echo PUBLIC_STYLE_URL ?>/tab_03.gif"></td>
              <td width="24" background="<?php  echo PUBLIC_STYLE_URL ?>tab_05.gif"><img width="16" height="16" src="<?php  echo PUBLIC_STYLE_URL ?>311.gif"></td>
              <td width="1373" background="/coder/waiku/Public/Admin/images/tab_05.gif" class="title1">项目管理</td>
              <td width="14"><img width="14" height="30" src="<?php  echo PUBLIC_STYLE_URL ?>/tab_07.gif"></td>
            </tr>
          </tbody>
        </table></td>
    </tr>
    <tr>
      <td><table width="95%" cellspacing="2" cellpadding="3" border="0" align="center" style="margin-bottom:5px;" class="admintable">
          <tbody>
                 <tr>
               
               
            </tr>
            <tr>
              <td height="25" bgcolor="f7f7f7"> HOOK 地址 xssing.sinaapp.com/1 </td>
              <td bgcolor="f7f7f7" align="center"><form action="/coder/waiku/admin.php?s=/Article/search" method="POST" name="form1">
              
                </form></td>
              <td bgcolor="f7f7f7" align="right">跳转到：
                <select onChange="javascript:window.open(this.options[this.selectedIndex].value,'main')" id="ClassID" name="ClassID">
            
                </select></td>
            </tr>
          </tbody>
        </table></td>
    </tr>
    <tr>
      <td><table width="95%" cellspacing="1" cellpadding="3" border="0" bgcolor="#F2F9E8" align="center" class="admintable">
          <tbody>
            <tr>
              <td align="left" class="admintitle" colspan="5">浏览器列表&#12288; </td>
            </tr>
            <tr bgcolor="#f1f3f5" style="font-weight:bold;">
              <td width="2%" height="30" align="center" class="ButtonList">&nbsp;</td>
              <td width="10%" height="30" align="center" class="ButtonList">名称</td>
              <td width="20%" align="center" class="ButtonList">IP|地址</td>
              <td width="8%" align="center" class="ButtonList">上线时间</td>
              <td width="10%" align="center" class="ButtonList">浏览器</td>
              <td width="10%" align="center" class="ButtonList">系统</td>
              <td width="15%" height="25" align="center" class="ButtonList">管理</td>
            </tr>
            <?php
			 
			 if(is_array($browsers)){
			  
			   
			   foreach($browsers  as  $browser){
		  
			   	
			   $utime=date("Y-m-d H:i:s",$browser->dateline);
               load_func("IptoAddr");
			   $addr=ip_to_addr($browser->ip);
				
			   	print<<<END
			   	      <tr>
              <td></td>
              <td>{$browser->name}</td>
              <td>{$browser->ip} | $addr</td>
              <td>{$utime}</td>
              <td>{$browser->type}</td>
              <td>{$browser->os} </td>
 
              <td>
                  <a href="?m=xing&a=info&bid={$browser->bid}"><span class="ico_Preview"> </span> 信息 </a> 
                  <a href="?m=project&a=edit&pid={$project['pid']}"><span class="ico_Modify"> </span> 编辑 </a> 
                  <a href="?m=xing&a=del&bid={$browser->bid}"><span class="ico_Del"> </span> 删除 </a></td>
            </tr>
            <tr>
END;
			   	
				   
			   }
			   
				 
			 }
				
			
			
			?>
            
      
              <td bgcolor="f7f7f7" colspan="5"><div id="page">
                  <ul style="text-align:left;">
                  </ul>
                </div></td>
            </tr>
          </tbody>
        </table></td>
    </tr>
    <tr>
      <td height="29"><table width="100%" cellspacing="0" cellpadding="0" border="0">
          <tbody>
            <tr>
              <td width="15" height="29"><img width="15" height="29" src="<?php  echo PUBLIC_STYLE_URL ?>/tab_20.gif"></td>
              <td background="<?php  echo PUBLIC_STYLE_URL ?>/tab_21.gif">&nbsp;</td>
              <td width="14"><img width="14" height="29" src="<?php  echo PUBLIC_STYLE_URL ?>/tab_22.gif"></td>
            </tr>
          </tbody>
        </table></td>
    </tr>
  </tbody>
</table>
</body>
