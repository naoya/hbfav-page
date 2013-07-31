use strict;
use warnings;

use Cinnamon::DSL;

set application => 'hbfav2-page';
set repository  => 'git://github.com/naoya/hbfav-page.git';
set user        => 'ec2-user';
set password    => '';

role production => ['hbfav.bloghackers.net'], {
    deploy_to   => '/home/ec2-user/hbfav',
    branch      => 'master',
};

task deploy  => {
    setup => sub {
        my ($host, @args) = @_;
        my $repository = get('repository');
        my $deploy_to  = get('deploy_to');
        my $branch   = 'origin/' . get('branch');
        remote {
            run "git clone $repository $deploy_to && cd $deploy_to && git checkout -q $branch";
        } $host;
    },
    update => sub {
        my ($host, @args) = @_;
        my $deploy_to = get('deploy_to');
        my $branch   = 'origin/' . get('branch');
        remote {
            run "cd $deploy_to && git fetch origin && git checkout -q $branch && git submodule update --init";
        } $host;
    },
};
