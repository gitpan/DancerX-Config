
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "DancerX Config",
  "AUTHOR" => "Michael Vu <email\@michael.vu>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "DancerX-Config",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "DancerX::Config",
  "PREREQ_PM" => {
    "B" => 0,
    "Cwd" => 0,
    "Dancer" => "1.3110",
    "Data::Dumper" => 0,
    "FindBin" => 0,
    "Template::Simple" => "0.06"
  },
  "VERSION" => "0.03",
  "test" => {
    "TESTS" => "t/*.t t/foobar/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



