#| HarfBuzz integration for PDF::Font::Loader
unit class PDF::Font::Loader::HarfBuzz;

use HarfBuzz::Font;
use HarfBuzz::Font::FreeType;
use HarfBuzz::Feature;
use HarfBuzz::Buffer;
use HarfBuzz::Raw::Defs :hb-direction;
use HarfBuzz::Shaper;

method make-harfbuzz-font(:$face!, :$font-buf!, Bool :$kern --> HarfBuzz::Font) {
    my HarfBuzz::Feature() @features = $kern ?? <kern> !! <-kern>;
    $face.font-format ~~ 'TrueType'|'OpenType'
        ?? HarfBuzz::Font.COERCE: %( :blob($font-buf), :@features )
        !! HarfBuzz::Font::FreeType.COERCE: %( :ft-face($face), :@features);
}

method make-harfbuzz-shaper(Str:D :$text!, HarfBuzz::Font:D :$font!, Str :$script, Str :$lang --> HarfBuzz::Shaper:D) {
    my HarfBuzz::Buffer $buf .= new: :$text, :direction(HB_DIRECTION_LTR);
    $buf.script = $_ with $script;
    $buf.language = $_ with $lang;
    HarfBuzz::Shaper.new: :$buf, :$font;
}

=begin pod

=head1 NAME

PDF::Font::Loader::HarfBuzz - HarfBuzz integration for PDF::Font::Loader

=head1 DESCRIPTION

This module should be installed to provide optional shaping support for L<PDF::Font::Loader>

=head1 AUTHOR

 <david.warring@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2024 

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
