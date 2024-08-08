NAME
====

PDF::Font::Loader::HarfBuzz - HarfBuzz related glyph shaping

SYNOPSIS
========

```raku
use PDF::Font::Loader::HarfBuzz; # ensure module  installed
use PDF::Font::Loader;
use PDF::Lite;
use PDF::Content::FontObj;
use HarfBuzz::Raw::Defs :hb-script;

my PDF::Lite $pdf .= new;
$pdf.add-page.text: -> $gfx {
    $gfx.text-position = 50, 700;

    my %arabic = (
        :text("تسجّل يتكلّم"),
        :Lang<ar>,
        :script(HB_SCRIPT_ARABIC),
        :direction<rtl>,
        :font<amiri-regular.ttf>
    );

    my %russian = (
        :text("Дуо вёжи дёжжэнтиюнт ут"),
        :lang<ru>,
        :script(HB_SCRIPT_CYRILLIC),
        :direction<ltr>,
    );

    for %arabic, %russian {
        my $text = .<text>;
        my $direction = .<direction>;
        my $file = 't/fonts/' ~ (.<font> // 'DejaVuSans.ttf');

        my PDF::Content::FontObj $font = PDF::Font::Loader.load-font: :$file;
        $gfx.font = $font;
        $gfx.say: $text, :shape, :$direction, :align<left>;
        $gfx.say;
    }
}

# ensure consistant document ID generation
$pdf.id = $*PROGRAM-NAME.fmt('%-16.16s');
lives-ok {
    $pdf.save-as: "shaping-example.pdf";
}

```

DESCRIPTION
===========

PDF::Font::Loader::HarfBuzz provides glyph shaping support for the
[PDF-Font-Loader](https://pdf-raku.github.io/PDF-Font-Loader-raku/) module.

This module is optional, but required when font-shaping or the text direction
is right-to-left (rtl).

Font shaping can help with the selection and layout of glyphs from Unicode code-points, in areas such as combining characters and ligatures.

AUTHOR
======

<david.warring@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2024 

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

