#!/usr/bin/env perl
use warnings;
no warnings 'experimental::smartmatch';
use feature 'switch';
use Tk;
my $config_filename = "config.txt";
my $win = MainWindow->new(-title=>"Wii U Toolbox");
$win->configure(-background => '#505050');
my $bg = '#505050';
my $fg = '#f0f0f0';

# my $CFG = (-background => $bg, -foreground => $fg);

sub menu_edit_config
{
	`gedit $config_filename || kwrite $config_filename || xterm -e "nano $config_filename || vim $config_filename || vi $config_filename"`;
}

my $left = $win->Frame->pack(-side=>'left', -fill=>'both');
my $list = $left->Listbox->pack(-fill=>'both', -expand=>1);
my @list = ("Wii VC Inject", "Wii U WUP Downloader");
$list->insert('end', @list);
$left->Button(-text=>"Exit", -command => sub{exit})->pack(-side=>'left');
$left->Button(
	-text=>"Edit config",
	-command => sub { menu_edit_config }
)->pack(-side=>'right');

my $right = $win->Frame->pack(-side=>'right', -fill=>'both', -expand=>1);
$right->Button(-text=>"Open")->pack(-side=>'left');
$right->Button(-text=>"Exit")->pack(-side=>'left');


sub menu_wiiu_vc_inject
{
	
}

sub root_menu
{
	$sel = $_d->menu( title => 'Select an option',
		list => [ 'Wii VC Inject', 'Inject a Retail Wii VC game',
		          'Wii U WUP Downloading', 'Inject a Wii VC game',
		          'Edit Config', 'Edit the config',
		          'Exit', 'Exactly what it says on the box' ]);
	given ($sel)
	{
		when ('Wii U VC Inject') {
			menu_wiiu_vc_inject;
		}
		when ('Edit Config') {
			menu_edit_config;
		}
		when ('Exit') { exit }
		when (0) { exit }
		default {}
	}
}


# while (1) { root_menu }

MainLoop
