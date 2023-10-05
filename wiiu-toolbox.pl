#!/usr/bin/env perl
use warnings;
no warnings ('experimental::smartmatch');
use feature 'switch';
use Tk;
# use Tk::PNG;
use Tk::FileSelect;
use JSON;
# use LWP::UserAgent;
use HTTP::Async;
use HTTP::Request;
use Data::Dumper;
use Data::HexDump;
my $config_filename = "config.txt";
my $win = MainWindow->new(-title=>"Wii U Toolbox", -background=>"#505050");
my $popup;
my $popup_lb;

sub winfigure
{
	my $twin = shift;
	$twin->geometry( shift || "600x400" );
	$twin->optionAdd("*borderWidth", 4);
	$twin->optionAdd("*background", "#505050");
	$twin->optionAdd("*foreground", "#dadada");
	# $twin->optionAdd("*borderColour", "#303030");
	$twin->optionAdd("*relief", "flat");
	$twin->optionAdd("*padY", "0");
}
winfigure $win;

sub setup_popup
{
	return if $popup;
	$popup = MainWindow->new(-title=>"Progress - Wii U Toolbox", -background=>"#505050");
	winfigure $popup, "400x200";
	$popup_lb = $popup->Listbox->pack(-fill=>'both', -expand=>1);
	
}

# my $ua = LWP::UserAgent->new;
# $ua->agent("Wii U Console Legit '); DROP TABLE accounts; --");
my $async = HTTP::Async->new;
$async->slots(2);

my $NINWIFI = "http://ccs.cdn.c.shop.nintendowifi.net/ccs/download/";

my $results_box;
my $titledb = [];
my @titledb_filtered = ();

sub menu_edit_config
{
	`gedit $config_filename || kwrite $config_filename || xterm -e "nano $config_filename || vim $config_filename || vi $config_filename"`;
}

# ... heh
my $mainframe = $win->Frame(-background => "#505050");
my @tabs = (
	$mainframe->Frame,
	$mainframe->Frame,
	$mainframe->Frame,
);

my $status = $win->Label(-text => "Project by Nekobit cuz i cant go by without shameless plugging",
                         -foreground => 'purple');

sub status
{
	$status->configure(-text => shift);
}

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


sub gamedir
{
	my ($game, $fn) = @_;
	$game->{name} =~ s/[\r\n]+/ /g;
	$game->{name} . ' [' . $game->{titleID} . ']' . ($fn ? "/$fn" : "");
}

sub gamedir_writefile
{
	my ($game, $fn, $content) = @_;
	open $fh, '>', gamedir($game, $fn) or die $!;
	print $fh $content;
	close $fh;
}

sub slurp
{
	open my $fh, '<', shift or ((shift && shift->("Can't open file")) || die "Can't open file");
	do { local $/; <$fh> };
}


sub parse_titlekeys_db
{
	my ($filename, $input) = @_;
	my $cb = sub { $input->configure(-textvariable=>shift); };
	$titledb = decode_json(slurp($filename));
}

parse_titlekeys_db "titledb.json";

sub search_db
{
	my $input = shift;
	my $input_val = $input->get;

	$results_box->delete(0, 25565);
	my @sorted = ();
	foreach $data (@{$titledb})
	{
		push(@sorted, $data);
	}
	# my @matches = grep { $_ = $_->{name}; /$input_val/i } @sorted;
	@titledb_filtered = grep { $_->{name} =~ /$input_val/i if $_->{name}; } @sorted;
	status(scalar @titledb_filtered . " results");
	$results_box->insert('end', map { "$_->{name} [$_->{region}]" } @titledb_filtered);
}

sub create_fake_ticket
{
	my $game = shift;
	my $ticket_data = "\x00\x01\x00\x04\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\xd1\x5e\xa5\xed\x15\xab\xe1\x1a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x52\x6f\x6f\x74\x2d\x43\x41\x30\x30\x30\x30\x30\x30\x30\x33\x2d\x58\x53\x30\x30\x30\x30\x30\x30\x30\x63\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\xfe\xed\xfa\xce\x01\x00\x00\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x14\x00\x00\x00\xac\x00\x00\x00\x14\x00\x01\x00\x14\x00\x00\x00\x00\x00\x00\x00\x28\x00\x00\x00\x01\x00\x00\x00\x84\x00\x00\x00\x84\x00\x03\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";
	my $titleID_bytes = pack "H*", $game->{titleID};
	my $titleKey_bytes = pack "H*", $game->{titleKey};
	substr($ticket_data, 476, length($titleID_bytes), $titleID_bytes);
	substr($ticket_data, 447, length($titleKey_bytes), $titleKey_bytes);
			
	gamedir_writefile($game, "title.tik", $ticket_data);
}

sub gen_cert
{
	my ($tmd, $num_contents) = @_;
	my $cert;

	if (length($tmd) == (0x0B04+(0x30*$num_contents)+0xA00)-0x300)
	{
		$cert = substr($tmd, 0x0B04+0x30*$num_contents, 0xA00-0x300);
	}
	else {
		$cert = substr($tmd, 0x0B04+0x30*$num_contents, 0xA00);
	}
	
	my $cetkdt = slurp('cetk');
	my @certchain = (
		substr($cert, 0, 0x400),
		substr($cert, 0x400, 0x300),
		substr($cetkdt, 0x350, 0x300),
	);
	
	join '', @certchain
}

sub download_game
{
	my ($game, $i) = @_;
	
	
	my $req = HTTP::Request->new(GET => 
		$NINWIFI . $game->{titleID} . '/tmd'
	);
	# Add some data as a little hack
	{
		$req->{data_game} = $game;
		$req->{data_idx} = $$i;
		$req->{type} = 'tmd';
	}
	$async->add($req);
	
	create_fake_ticket $game;
	setup_popup;
	
}

sub download_vidyas
{
	my @x = @_;
	foreach $i (@x)
	{
		my $game = $titledb_filtered[$i];
		#print Dumper $game;
		
		download_game $game, $i;
	}
	
}

sub create_progressbar
{
	my ($prog, $total, $size) = @_;
	my $val = (($prog || 0) / ($total || 1));
	my $p_str = "#" x (($val > $size ? 0 : $val) * $size);
	$p_str .= "_" x ($size - length($p_str));
	
	return "[$p_str]";
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
	$results_box->configure(-selectmode => 'multiple');
	$tab->Button(-text=>"Legally download",
		-command=>sub{
			download_vidyas $results_box->curselection;
		})->pack(-fill=>'both');
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

my $lid = $win->repeat(250, sub {
	$async->poke;
	if (my $res = $async->next_response) {{
		last unless ($res->is_success);
		
		my $game = $res->{_request}->{data_game};
		
		given ($res->{_request}->{type})
		{
		when('tmd') {
			$game->{name} =~ s/[\r\n]+/ /g;
			my $dir = gamedir($game);
			
			mkdir $dir;
			gamedir_writefile($game, 'title.tmd', $res->content);
			
			my $title_ver = unpack 'n', substr($res->content, 477, 2);
			my $content_count = unpack 'v', substr($res->content, 479, 2);
			
			gamedir_writefile($game, 'title.cert', gen_cert($res->content, $content_count));
			# exit 0;
			
			# progress info
			$game->{total} = 0;
			$game->{progress} = 0;
			
			print Dumper $game;
			for (my $i = 0; $i < $content_count; ++$i)
			{
				my $offset = 2820 + (48 * $i);
				my $id = unpack 'N', substr($res->content, $offset, 4);
				print "That's unusual, ($id != $i)... all good though (maybe)\n" if $id != $i;
				
				my $filename = sprintf("%08X", $id);
				my $url = $NINWIFI . $game->{titleID} . "/$filename";
				my $url_hash = $NINWIFI . $game->{titleID} . "/$filename.h3";
				my $is_hash = (ord(substr($res->content, $offset + 7, 1)) & 0x2) == 2;
				$game->{total} += $is_hash ? 2 : 1;
				
				my @dl = ([$url, 0],
				          [$is_hash ? $url_hash : undef, 1]);
				
				foreach my $url_dl (@dl)
				{
					next unless $url_dl->[0];
					print "Fetching: $url_dl->[0]\n";
					my $req = HTTP::Request->new(GET => $url_dl->[0]);
					{
						$req->{data_game} = $game;
						$req->{filename} = $url_dl->[1] ? "$filename.h3" : "$filename.app";
						$req->{type} = 'appdata';
					}
					$async->add($req);
				}
			}
		}
		when ('appdata') {
			my $filename = $res->{_request}->{filename};
			gamedir_writefile($game, $filename, $res->content);
			
			$game->{progress}++;
			
			status("Downloaded $filename for $game->{name} (size: " . length($res->content) . " bytes)");
			
		}
		default { die "Unknown request \"". $res->{_request}->{type} ."\". Programmer error.\n"; };
		}
    }}
	else {{
		last unless $popup_lb;
		$popup_lb->delete(0, 25565);
		# Dedupe for main items
		my @items = ();
		foreach my $data (@{$async->{to_send}})
		{ push(@items, $data->[0]->{data_game}); }
		my %seen;
		@items = grep { ! $seen{$_->{name}}++ } @items;
		@items = map {
			my $game = $_;
			$_ = create_progressbar($game->{progress}, $game->{total}, 20) . " $game->{name}";
		} @items;
		$popup_lb->insert('end', @items);
	}}
});

init_tab_injector(0);
init_tab_download(1);
init_tab_fetcher(2);

# Start!
$mainframe->pack(-fill=>'both', -expand=>1);
$status->pack(-fill=>'x', -side=>'left', -expand=>0);
MainLoop
