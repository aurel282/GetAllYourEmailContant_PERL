use strict;
use warnings;
use Net::SMTP::TLS;
use Email::Simple;
use IO::Socket::SSL;
use Mail::POP3Client;
use List::MoreUtils qw(uniq);
use Data::Dumper qw(Dumper);
use 5.010;
use CGI qw(:standard);
my $cgi = new CGI;


print "Begin of the script \n";


################################################################## TEST SEND EMAIL

my $mailer = new Net::SMTP::TLS(   # PUT YOUR EMAIL INFO
    'smtp.gmail.com',
    Hello   =>      'smtp.gmail.com',
    Port    =>      587,
    User    =>      'YOUREMAIL@gmail.com',
    Password    =>      'YOURPASS'
    ); 
 
my $subject = 'Test Perl';   
 
$mailer->mail('YOUREMAIL@gmail.com');
$mailer->to('YOUREMAIL@gmail.com');
$mailer->data;
$mailer->datasend("Subject: " . $subject . "\n");
$mailer->datasend("Sent From Perl");
$mailer->dataend;
# $mailer->quit;

################################################################## Start Useful Script

my $username = 'YOUREMAIL@gmail.com';
my $password = 'YOURPASS';

my $mailhost = 'pop.gmail.com';
my $port = '995';

print $cgi->header();

my $pop = Mail::POP3Client->new(USER=> $username,
PASSWORD => $password,
HOST => $mailhost,
PORT => $port,
USESSL => 'true',
DEBUG => 0,) or die("ERROR: Unable to connect to mail server.\n");

my $count = $pop->Count();

if (($pop->Count()) < 1)
{
print "No messages...\n";
exit;
}
my @t = ();
my @lstMails = ();
my @lstUniqMails = ();

print "There are $count Messages in your inbox\n";
my $i;
for($i = 1; $i  < $count; $i++)
{
print "\n\n\nMail number $i\n";
foreach($pop->Head($i))
{
# /^(From|Subject|Email):\s+/i && print $_, "\n";
#/^(From|Subject):\s+/i && print $_, "\n";
/^(From):\s+/i && push(@lstMails,$_);
}
#print 'Message: '.$pop->Body($i);
}

$pop->Close();

foreach (@lstMails) {
   print "$_\n";
}

@lstUniqMails = uniq(@lstMails);
say Dumper  \@lstUniqMails;

print " \n \n \n";

my  $Tempmessage = '';
#foreach (@lstUniqMails) 
#{
  # print "$_\n";
   #$Tempmessage .=  "$_" ;
   #$Tempmessage .=  "\n";
#}
#print " \n \n \n";

 
 
#print " \n \n \n";

 $subject = 'Data From Perl';  

$mailer->mail('YOUREMAIL@gmail.com');
$mailer->to('YOUREMAIL@gmail.com');
$mailer->data();
$mailer->datasend("Subject: " . $subject . "\n");
foreach (@lstUniqMails) 
{
   print "$_\n";
   $Tempmessage .= Dumper("$_") ;
   $Tempmessage .= "\n" ;
   #$mailer->datasend(Dumper($_));
   #$mailer->datasend('\n');
   #$Tempmessage .=  "\n";
}
print " \n \n \n TempMessage \n \n";
print "$Tempmessage";
#$mailer->datasend("Cretinos \n \n \n Cretinos");
$mailer->datasend(Dumper($Tempmessage));
$mailer->dataend();
$mailer->quit;


print "End of the script";
