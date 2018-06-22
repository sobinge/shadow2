<?php
class  CodeAction  extends  AppAction{
	
	
	function  code(){
		
			$pid=intval($_GET[pid]);
		
		$project=new ProjectModel();
		
		$pro=$project->getby_pid($pid);
		
        if($pro[uid]!=$_SESSION['uid']) {
        cpmsg("无权限",'error',"?m=xing");  exit();	
        }
		
        $xing=new XingModel();
        $browsers=$xing->get_browsers($pid);
          //  $info=$xing->get_infos($pid);
        
      
        
		include  view_file();
	}
  function  js(){
		
			$pid=intval($_GET[pid]);
		
		$project=new ProjectModel();
		
		$pro=$project->getby_pid($pid);
		
        if($pro[uid]!=$_SESSION['uid']) {
        cpmsg("无权限",'error',"?m=xing");  exit();	
        }
		
        $xing=new XingModel();
        $browsers=$xing->get_browsers($pid);
          //  $info=$xing->get_infos($pid);
        
      
        
		include  view_file();
	}
	
	
}