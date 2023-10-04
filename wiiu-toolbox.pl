#!/usr/bin/env perl
use warnings;
no warnings ('experimental::smartmatch');
use feature 'switch';
use Tk;
#use Tk::PNG;
use Tk::FileSelect;
use JSON;
my $config_filename = "config.txt";
my $win = MainWindow->new(-title=>"Wii U Toolbox", -background=>"#505050");
$win->geometry( "600x400" );
$win->optionAdd("*borderWidth", 4);
$win->optionAdd("*background", "#303030");
$win->optionAdd("*foreground", "#dadada");
$win->optionAdd("*borderColor", "#303030");
$win->optionAdd("*relief", "flat");
$win->optionAdd("*padY", "0");

my $results_box;
my $titledb = [];

sub menu_edit_config
{
	`gedit $config_filename || kwrite $config_filename || xterm -e "nano $config_filename || vim $config_filename || vi $config_filename"`;
}

# ... heh
my $mainframe = $win->Frame(-background => "#303030");
my @tabs = (
	$mainframe->Frame,
	$mainframe->Frame,
	$mainframe->Frame,
);

sub show_tab {
	foreach my $tab (@tabs)
	{
		$tab->packForget;
	}
	$tabs[shift]->pack(-fill=>'both', -expand=>1);
}

sub init_headers
{
	my $top_frame = $win->Frame(-background=>"#505050")->pack;
	#$top_frame->grid();
	my @header_btns = (
		$top_frame->Button(
			-text => "Injector",
			-compound => 'top',
			#-image => $win->Photo(-file=>'data/wii.png'),
			-command => sub { show_tab 0; }
		)->pack,
		$top_frame->Button(
			-text => "Downloader",
			-compound => 'top',
			#-image => $win->Photo(-file=>'data/wii.png'),
			-command => sub { show_tab 1; }
		)->pack,
		$top_frame->Button(
			-text => "Fetcher",
			-command => sub { show_tab 2; }
		)->pack,
		$top_frame->Button(
			-text => "Edit config",
			-command => sub { menu_edit_config }
		)->pack
	);
	
	for (my $i = 0; $i < scalar @header_btns; ++$i)
	{
		$header_btns[$i]->grid(-row => 0, -column => $i);
	}
}
init_headers;

sub parse_titlekeys_db
{
	my ($filename, $input) = @_;
	my $cb = sub { $input->configure(-textvariable=>shift); };
	open my $fh, '<', $filename or $cb->("Can't open file");
	$titledb = decode_json(do { local $/; <$fh> });
}

sub search_db
{
	my $input = shift;
	my $input_val = $input->get;

	$results_box->delete(0, 25565);
	my @sorted = ();
	foreach $data (@{$titledb})
	{
		push(@sorted, $data->{name});
	}
	my @matches = grep { /$input_val/i } @sorted;
	$results_box->insert('end', @matches);
}

sub init_tab_injector
{
	my $tab = $tabs[shift];
	my $search = $tab->Frame->pack;
	my $search_input = $search->Entry->pack;
	my $search_btn = $search->Button(-text=>"Search", -command=>sub{ search_db $search_input })->pack;
	
	$search_input->grid(-row => 0, -column => 0);
	$search_btn->grid(-row=> 0, -column => 1);
	
	
	$results_box = $tab->Scrolled('Listbox', -scrollbars=>'oe')->pack(-fill=>'both', -expand=>1);
}

sub init_tab_download
{
	my $tab = $tabs[shift];
	$tab->Button(-text=>"lol")->pack;
}

sub init_tab_fetcher
{
	my $tab = $tabs[shift];
	my $input = $tab->Entry()->pack;
	my $selector = $tab->Button(
		-text=>"Select...",
		-command => sub {
			$FSref = $tab->FileSelect(-directory => "./");
			$file = $FSref->Show;
			$input->configure(-textvariable=>"$file") if $file;
			parse_titlekeys_db($file, $input) if $file;
		}
	)->pack;
	
	$input->grid(-row => 0, -column => 0);
	$selector->grid(-row => 0, -column => 1);
}

init_tab_injector(0);
init_tab_download(1);
init_tab_fetcher(2);

# Start!
$mainframe->pack(-fill=>'both', -expand=>1);
MainLoop
